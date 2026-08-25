import 'package:bbvision/model/location_result_model.dart';
import 'package:bbvision/model/login_model.dart';
import 'package:bbvision/service/auth_local_storage.dart';
import 'package:bbvision/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final service = Get.put(LocationService());

  final locationDetails = <LocationResultModel?>[].obs;
  final isLoading = false.obs;

  final fromDate = "".obs;
  final toDate = "".obs;

  Future<LoginData?> _loadUser() async {
    final login = await AuthLocalStorage.getLoginDetails();
    return login?.data;
  }

  @override
  void onInit() {
    super.onInit();

    debugPrint("LocationController initialized");

    getLocation();
  }

  //Employee to get the current lcation
  Future<LocationResultModel?> getCurrentLocation(BuildContext context) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location service.")),
        );
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        return null;
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Location permission permanently denied. "
              "Please enable it from Settings.",
            ),
          ),
        );
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      debugPrint("Latitude: ${position.latitude}");
      debugPrint("Longitude: ${position.longitude}");

      // Reverse geocoding
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        return null;
      }
      final login = await AuthLocalStorage.getLoginDetails();

      final place = placemarks.first;

      final location = LocationResultModel(
        id: 0,
        employeeId: login!.data!.userName,
        latitude: position.latitude,
        longitude: position.longitude,
        area: place.subLocality ?? '',
        city: place.locality ?? '',
        status: 0,
        inTime: DateTime.now(),
        outTime: null,
        createdAt: DateTime.now(),
      );
      final success = await service.locationInsert(location);

      if (success) {
        debugPrint("Location inserted successfully");
      } else {
        debugPrint("Location insertion failed");
      }

      return location;
    } catch (e) {
      debugPrint("Location Error: $e");
      return null;
    }
  }

  //get the list of location in employee_locations
  Future<void> getLocation() async {
    final user = await _loadUser();

    final userId = user != null ? user.userName : "";
    final userGroupCode = user != null ? user.userGroupCode : "";

    //Assign the date for UI Update
    fromDate.value = "";
    toDate.value = "";

    isLoading.value = true;
    final result = await service.locationDetails(
      userId: userId,
      userGroupCode: userGroupCode,
    );
    print("result $result");
    if (result != null) {
      locationDetails.assignAll(result);
    }
    isLoading.value = false;
  }

  // Get location list filtered by date
  Future<void> getLocationByDate({
    required String fromDate,
    required String toDate,
  }) async {
    final user = await _loadUser();

    final userId = user?.userName ?? "";
    final userGroupCode = user?.userGroupCode ?? "";

    // Update dates for UI
    this.fromDate.value = fromDate;
    this.toDate.value = toDate;

    try {
      isLoading.value = true;

      final result = await service.locationDetails(
        userId: userId,
        userGroupCode: userGroupCode,
        fromDate: fromDate,
        toDate: toDate,
      );

      debugPrint("From Date: $fromDate");
      debugPrint("To Date: $toDate");
      debugPrint("Location result: $result");

      if (result != null) {
        locationDetails.assignAll(result);
      } else {
        locationDetails.clear();
      }
    } catch (e) {
      debugPrint("Location filter error: $e");
      locationDetails.clear();
    } finally {
      isLoading.value = false;
    }
  }

  //update logout
  Future<bool> updateLogoutCnt(int tableId) async {
    isLoading.value = true;
    final result = await service.updateLogout(tableId);
    print("result $result");

    isLoading.value = false;
    return result;
  }

  //get logs
  Future<Map<String, dynamic>?> getAttendancesCnt(String empId) async {
    isLoading.value = true;
    final result = await service.getAttendances(empId);
    print("result $result");
    if (result != null) {
      return result;
    }
    isLoading.value = false;
    return null;
  }
}
