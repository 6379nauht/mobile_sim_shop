import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:typesense/typesense.dart';
import 'dart:async'; // Thêm import này cho StreamSubscription

class TypesenseSync {
  static final typesenseClient = Client(
    Configuration(
      'xyz123', // Sửa từ apiKey thành masterApiKey theo phiên bản mới
      nodes: {Node.withUri(Uri.parse('http://192.168.2.1:8108'))},
      connectionTimeout: const Duration(seconds: 2),
    ),
  );

  static Future<void> syncToTypesense(String productId, Map<String, dynamic> data) async {
    try {
      final document = {
        'id': productId,
        'title': data['title'] as String? ?? '',
        'stock': (data['stock'] as num?)?.toInt() ?? 0,
        'price': (data['price'] as num?)?.toDouble() ?? 0.0,
        'thumbnail': data['thumbnail'] as String? ?? '',
        'productType': data['productType'] as String? ?? '',
        'sku': data['sku'] as String? ?? '',
        'brandId': data['brandId'] as String? ?? '',
        'date': _parseDate(data['date']),
        'salePrice': (data['salePrice'] as num?)?.toDouble() ?? 0.0,
        'isFeatured': data['isFeatured'] as bool? ?? false,
        'categoryId': data['categoryId'] as String? ?? '',
        'description': data['description'] as String? ?? '',
        'images': (data['images'] as List?)?.cast<String>() ?? [],
        'productAttributes': _parseAttributes(data['productAttributes']),
      };

      await typesenseClient.collection('products').documents.upsert(document);
      debugPrint('Synced product $productId to Typesense');
    } catch (e) {
      debugPrint('Error syncing product $productId: $e');
      rethrow;
    }
  }

  static int? _parseDate(dynamic date) {
    if (date == null) return null;
    try {
      if (date is String) {
        return DateTime.parse(date).millisecondsSinceEpoch;
      } else if (date is Timestamp) {
        return date.toDate().millisecondsSinceEpoch;
      }
      return null;
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return null;
    }
  }

  static List<Map<String, dynamic>> _parseAttributes(dynamic attributes) {
    if (attributes == null || attributes is! List) return [];
    try {
      return attributes.map((attr) {
        return {
          'name': attr['name'] as String? ?? '',
          'values': (attr['values'] as List?)?.cast<String>() ?? [],
        };
      }).toList();
    } catch (e) {
      debugPrint('Error parsing attributes: $e');
      return [];
    }
  }

  static Future<void> deleteFromTypesense(String productId) async {
    try {
      // Sửa cú pháp từ documents()[productId] thành document(productId)
      await typesenseClient.collection('products').document(productId).delete();
      debugPrint('Deleted product $productId from Typesense');
    } catch (e) {
      debugPrint('Error deleting product $productId: $e');
      rethrow;
    }
  }

  static StreamSubscription<QuerySnapshot>? _subscription;

  static void startSync() {
    stopSync();

    _subscription = FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) async {
      final changes = snapshot.docChanges;
      for (var change in changes) {
        final productId = change.doc.id;
        final data = change.doc.data();
        try {
          switch (change.type) {
            case DocumentChangeType.added:
            case DocumentChangeType.modified:
              if (data != null) {
                await syncToTypesense(productId, data);
              }
              break;
            case DocumentChangeType.removed:
              await deleteFromTypesense(productId);
              break;
          }
        } catch (e) {
          debugPrint('Error processing change for $productId: $e');
        }
      }
    }, onError: (error) {
      debugPrint('Sync error: $error');
    });
  }

  static void stopSync() {
    _subscription?.cancel();
    _subscription = null;
  }

  // Phương thức mới để reload toàn bộ dữ liệu từ Firestore
  static Future<void> reloadAllData() async {
    try {
      // Lấy tất cả documents từ Firestore
      final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('products').get();

      // Đồng bộ từng document sang Typesense
      for (var doc in snapshot.docs) {
        final productId = doc.id;
        final data = doc.data() as Map<String, dynamic>;
        await syncToTypesense(productId, data);
      }

      debugPrint('Reloaded ${snapshot.docs.length} products to Typesense');
    } catch (e) {
      debugPrint('Error reloading data to Typesense: $e');
      rethrow;
    }
  }
}