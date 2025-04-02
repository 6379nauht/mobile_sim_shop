import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_sim_shop/core/utils/constants/sizes.dart';
import 'package:mobile_sim_shop/core/widgets/appbar/appbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/address_model.dart';
import 'package:mobile_sim_shop/features/personalization/data/models/update_address_params.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_bloc.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_event.dart';
import 'package:mobile_sim_shop/features/personalization/presentation/blocs/address/address_state.dart';
import 'package:mobile_sim_shop/core/router/routes.dart';

class AddressFormPage extends StatefulWidget {
  final String userId;
  final AddressModel? address;
  final bool isEditMode;

  const AddressFormPage({
    super.key,
    required this.userId,
    this.address,
    this.isEditMode = false,
  });

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  int _currentStep = 0;
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  GoogleMapController? mapController;
  LatLng? _selectedLocation;
  String _fullAddress = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _hamletController = TextEditingController();

  String? _selectedProvinceCode;
  String? _selectedDistrictCode;
  String? _selectedCommuneCode;
  List<dynamic> _provinces = [];
  List<dynamic> _districts = [];
  List<dynamic> _communes = [];

  bool get isEmulator => Platform.isAndroid && !Platform.environment.containsKey('ANDROID_STORAGE');

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _fetchProvinces();
    if (widget.isEditMode && widget.address != null) {
      await _initializeEditMode();
    }
  }

  Future<void> _initializeEditMode() async {
    final address = widget.address!;
    _nameController.text = address.name;
    _phoneController.text = address.phoneNumber;
    _hamletController.text = address.hamlet;
    _fullAddress = address.fullAddress;
    _selectedLocation = address.latitude != null && address.longitude != null
        ? LatLng(address.latitude!, address.longitude!)
        : null;

    _selectedProvinceCode = _provinces.firstWhere(
          (p) => p['name'] == address.province,
      orElse: () => null,
    )?['code']?.toString();

    if (_selectedProvinceCode != null) {
      await _fetchDistricts(_selectedProvinceCode!);
      _selectedDistrictCode = _districts.firstWhere(
            (d) => d['name'] == address.district,
        orElse: () => null,
      )?['code']?.toString();

      if (_selectedDistrictCode != null) {
        await _fetchCommunes(_selectedDistrictCode!);
        _selectedCommuneCode = _communes.firstWhere(
              (c) => c['name'] == address.commune,
          orElse: () => null,
        )?['code']?.toString();
      }
    }

    final addressParts = address.fullAddress.split(', ');
    if (addressParts.length > 1) {
      _streetController.text = addressParts[1];
    }

    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _hamletController.dispose();
    mapController?.dispose();
    super.dispose();
  }

  Future<bool> _checkNetwork() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có kết nối Internet')),
      );
      return false;
    }
    return true;
  }

  Future<void> _fetchProvinces() async {
    if (!await _checkNetwork()) return;
    final response = await http.get(Uri.parse('https://provinces.open-api.vn/api/p/'));
    if (response.statusCode == 200) {
      setState(() {
        _provinces = jsonDecode(utf8.decode(response.bodyBytes));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh sách tỉnh/thành phố')),
      );
    }
  }

  Future<void> _fetchDistricts(String provinceCode) async {
    if (!await _checkNetwork()) return;
    final response = await http.get(Uri.parse('https://provinces.open-api.vn/api/p/$provinceCode?depth=2'));
    if (response.statusCode == 200) {
      setState(() {
        _districts = jsonDecode(utf8.decode(response.bodyBytes))['districts'];
        _communes = [];
        _selectedDistrictCode = null;
        _selectedCommuneCode = null;
        _streetController.clear(); // Reset số nhà
        _hamletController.clear(); // Reset ấp
        _fullAddress = '';
        _selectedLocation = null; // Reset vị trí bản đồ
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh sách quận/huyện')),
      );
    }
  }

  Future<void> _fetchCommunes(String districtCode) async {
    if (!await _checkNetwork()) return;
    final response = await http.get(Uri.parse('https://provinces.open-api.vn/api/d/$districtCode?depth=2'));
    if (response.statusCode == 200) {
      setState(() {
        _communes = jsonDecode(utf8.decode(response.bodyBytes))['wards'];
        _selectedCommuneCode = null;
        _streetController.clear(); // Reset số nhà
        _hamletController.clear(); // Reset ấp
        _fullAddress = '';
        _selectedLocation = null; // Reset vị trí bản đồ
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh sách phường/xã')),
      );
    }
  }

  Future<void> _initializeMapLocation() async {
    if (_selectedProvinceCode != null && _selectedDistrictCode != null && _selectedCommuneCode != null) {
      final provinceName = _provinces.firstWhere((p) => p['code'].toString() == _selectedProvinceCode)['name'];
      final districtName = _districts.firstWhere((d) => d['code'].toString() == _selectedDistrictCode)['name'];
      final communeName = _communes.firstWhere((c) => c['code'].toString() == _selectedCommuneCode)['name'];
      String address = '$communeName, $districtName, $provinceName';
      try {
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          setState(() {
            _selectedLocation = LatLng(locations.first.latitude, locations.first.longitude);
          });
          if (mapController != null) {
            mapController!.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
          }
        }
      } catch (e) {
        print("Error initializing map: $e");
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (widget.isEditMode && _selectedLocation != null) {
      mapController?.animateCamera(CameraUpdate.newLatLng(_selectedLocation!));
    } else if (_selectedProvinceCode != null && _selectedDistrictCode != null && _selectedCommuneCode != null) {
      _initializeMapLocation();
    }
  }

  Future<void> _updateAddressFromLocation(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _streetController.text = place.street ?? place.thoroughfare ?? '';
          _hamletController.text = place.subLocality ?? '';
          _fullAddress =
          '${_hamletController.text.isNotEmpty ? "${_hamletController.text}, " : ""}${_streetController.text}, ${_communes.firstWhere((c) => c['code'].toString() == _selectedCommuneCode)['name']}, ${_districts.firstWhere((d) => d['code'].toString() == _selectedDistrictCode)['name']}, ${_provinces.firstWhere((p) => p['code'].toString() == _selectedProvinceCode)['name']}';
        });
      }
    } catch (e) {
      print("Error updating address: $e");
    }
  }

  void _saveOrUpdateAddress() {
    if (_formKeyStep2.currentState!.validate()) {
      if (_selectedProvinceCode == null || _selectedDistrictCode == null || _selectedCommuneCode == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn đầy đủ tỉnh, quận, xã')),
        );
        return;
      }

      final provinceName = _provinces.firstWhere((p) => p['code'].toString() == _selectedProvinceCode)['name'];
      final districtName = _districts.firstWhere((d) => d['code'].toString() == _selectedDistrictCode)['name'];
      final communeName = _communes.firstWhere((c) => c['code'].toString() == _selectedCommuneCode)['name'];

      final address = AddressModel(
        id: widget.isEditMode ? widget.address!.id : '',
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        hamlet: _hamletController.text,
        commune: communeName,
        district: districtName,
        province: provinceName,
        country: 'Việt Nam',
        latitude: _selectedLocation?.latitude,
        longitude: _selectedLocation?.longitude,
        fullAddress: _fullAddress,
        dateTime: DateTime.now(),
        selectedAddress: widget.isEditMode ? widget.address!.selectedAddress : false,
      );

      if (widget.isEditMode) {
        final updateParams = UpdateAddressParams(
          userId: widget.userId,
          address: address,
          addressId: address.id,
        );
        context.read<AddressBloc>().add(UpdateAddressEvent(updateParams));
      } else {
        context.read<AddressBloc>().add(SaveAddressEvent(widget.userId, address));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        showBackArrow: true,
        title: Text(widget.isEditMode ? 'Chỉnh sửa địa chỉ' : 'Thêm địa chỉ mới'),
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state.status == AddressStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.isEditMode ? 'Địa chỉ đã được cập nhật' : 'Địa chỉ đã được lưu')),
            );
            context.pop(); // Sử dụng pop từ GoRouter để quay lại
          } else if (state.status == AddressStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Có lỗi xảy ra')),
            );
          }
        },
        child: _currentStep == 0 ? _buildStep1() : _buildStep2(),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.defaultSpace.r),
      child: Form(
        key: _formKeyStep1,
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedProvinceCode,
              hint: const Text('Tỉnh/Thành phố'),
              items: _provinces.map((province) => DropdownMenuItem(
                value: province['code'].toString(),
                child: Text(province['name']),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProvinceCode = value;
                });
                _fetchDistricts(value!);
              },
              validator: (value) => value == null ? 'Vui lòng chọn tỉnh/thành phố' : null,
            ),
            SizedBox(height: AppSizes.spaceBtwInputFields.h),
            DropdownButtonFormField<String>(
              value: _selectedDistrictCode,
              hint: const Text('Quận/Huyện'),
              items: _districts.map((district) => DropdownMenuItem(
                value: district['code'].toString(),
                child: Text(district['name']),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDistrictCode = value;
                });
                _fetchCommunes(value!);
              },
              validator: (value) => value == null ? 'Vui lòng chọn quận/huyện' : null,
            ),
            SizedBox(height: AppSizes.spaceBtwInputFields.h),
            DropdownButtonFormField<String>(
              value: _selectedCommuneCode,
              hint: const Text('Phường/Xã'),
              items: _communes.map((commune) => DropdownMenuItem(
                value: commune['code'].toString(),
                child: Text(commune['name']),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCommuneCode = value;
                  _streetController.clear(); // Reset số nhà
                  _hamletController.clear(); // Reset ấp
                  _fullAddress = '';
                  _selectedLocation = null; // Reset vị trí bản đồ
                });
                _initializeMapLocation(); // Cập nhật bản đồ khi chọn xã
              },
              validator: (value) => value == null ? 'Vui lòng chọn phường/xã' : null,
            ),
            SizedBox(height: AppSizes.spaceBtwInputFields.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKeyStep1.currentState!.validate()) {
                    setState(() => _currentStep = 1);
                  }
                },
                child: const Text('Tiếp theo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        SizedBox(
          height: 300.h,
          width: double.infinity,
          child: isEmulator
              ? const Center(child: Text('Bản đồ không hỗ trợ trên emulator'))
              : GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? const LatLng(10.7769, 106.7009), // Vị trí mặc định (TP.HCM)
              zoom: 15,
            ),
            onTap: (position) {
              setState(() {
                _selectedLocation = position;
              });
              _updateAddressFromLocation(position);
            },
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: const MarkerId('selected-location'),
                position: _selectedLocation!,
                draggable: true,
                onDragEnd: (newPosition) {
                  setState(() {
                    _selectedLocation = newPosition;
                  });
                  _updateAddressFromLocation(newPosition);
                },
              ),
            }
                : {},
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.defaultSpace.r),
            child: Form(
              key: _formKeyStep2,
              child: Column(
                children: [
                  Text(_fullAddress.isEmpty ? 'Di chuyển marker để chọn vị trí' : _fullAddress),
                  SizedBox(height: AppSizes.spaceBtwInputFields.h),
                  TextFormField(
                    controller: _hamletController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.location),
                      labelText: 'Khóm/Ấp',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _fullAddress =
                        '${value.isNotEmpty ? "$value, " : ""}${_streetController.text}, ${_communes.firstWhere((c) => c['code'].toString() == _selectedCommuneCode)['name']}, ${_districts.firstWhere((d) => d['code'].toString() == _selectedDistrictCode)['name']}, ${_provinces.firstWhere((p) => p['code'].toString() == _selectedProvinceCode)['name']}';
                      });
                    },
                  ),
                  SizedBox(height: AppSizes.spaceBtwInputFields.h),
                  TextFormField(
                    controller: _streetController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.building_31),
                      labelText: 'Số nhà, tên đường',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _fullAddress =
                        '${_hamletController.text.isNotEmpty ? "${_hamletController.text}, " : ""}$value, ${_communes.firstWhere((c) => c['code'].toString() == _selectedCommuneCode)['name']}, ${_districts.firstWhere((d) => d['code'].toString() == _selectedDistrictCode)['name']}, ${_provinces.firstWhere((p) => p['code'].toString() == _selectedProvinceCode)['name']}';
                      });
                    },
                    validator: (value) => value!.isEmpty ? 'Vui lòng nhập số nhà, tên đường' : null,
                  ),
                  SizedBox(height: AppSizes.spaceBtwInputFields.h),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user),
                      labelText: 'Tên',
                    ),
                    validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
                  ),
                  SizedBox(height: AppSizes.spaceBtwInputFields.h),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.mobile),
                      labelText: 'Số điện thoại',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';
                      final phoneRegExp = RegExp(r'^(03|05|07|08|09)[0-9]{8}$');
                      if (!phoneRegExp.hasMatch(value)) return 'Số điện thoại không đúng định dạng';
                      return null;
                    },
                  ),
                  SizedBox(height: AppSizes.spaceBtwInputFields.h),
                  BlocBuilder<AddressBloc, AddressState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.status == AddressStatus.loading ? null : _saveOrUpdateAddress,
                          child: state.status == AddressStatus.loading
                              ? const CircularProgressIndicator()
                              : Text(widget.isEditMode ? 'Cập nhật' : 'Lưu'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}