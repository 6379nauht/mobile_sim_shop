import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile_sim_shop/core/errors/failures.dart';

abstract class ImgurDataSource {
  String get clientId;
  Future<Map<String, String>> uploadImage(File imageFile);
  Future<bool> deleteImage(String deleteHash);
}

class ImgurDataSourceImpl implements ImgurDataSource {
  final http.Client client;
  final String _clientId;

  ImgurDataSourceImpl({
    required this.client,
    required String clientId,
  }) : _clientId = clientId;

  @override
  String get clientId => _clientId;

  @override
  Future<Map<String, String>> uploadImage(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.imgur.com/3/image'),
      );
      request.headers['Authorization'] = 'Client-ID $_clientId';
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send().timeout(
        const Duration(seconds: 15), // Timeout cho upload
        onTimeout: () => throw TimeoutException('Hết thời gian tải ảnh lên Imgur'),
      );
      final responseData = await http.Response.fromStream(response).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Hết thời gian nhận phản hồi từ Imgur'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        if (data['success'] == true) {
          return {
            'link': data['data']['link'] as String,
            'deleteHash': data['data']['deletehash'] as String,
          };
        } else {
          throw ServerFailure('Upload thất bại: ${data['data']['error']}');
        }
      } else {
        throw ServerFailure('Lỗi upload ảnh lên Imgur: ${response.statusCode}');
      }
    } on SocketException {
      throw ServerFailure('Không có kết nối mạng');
    } on TimeoutException catch (e) {
      throw ServerFailure(e.message ?? 'Hết thời gian xử lý ảnh');
    } catch (e) {
      print('Lỗi upload ảnh: $e');
      throw ServerFailure('Lỗi upload ảnh: $e');
    }
  }

  @override
  Future<bool> deleteImage(String deleteHash) async {
    try {
      final response = await client.delete(
        Uri.parse('https://api.imgur.com/3/image/$deleteHash'),
        headers: {'Authorization': 'Client-ID $_clientId'},
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('Hết thời gian xóa ảnh'),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerFailure('Lỗi xóa ảnh: ${response.statusCode}');
      }
    } on SocketException {
      throw ServerFailure('Không có kết nối mạng');
    } on TimeoutException catch (e) {
      throw ServerFailure(e.message ?? 'Hết thời gian xử lý');
    } catch (e) {
      print('Lỗi xóa ảnh: $e');
      throw ServerFailure('Lỗi xóa ảnh: $e');
    }
  }
}