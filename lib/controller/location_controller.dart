import 'package:bbvision/model/location_result_model.dart';
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
        employeeId: login!.data!.assEmpId, // Your logged-in employee ID
        latitude: position.latitude,
        longitude: position.longitude,
        name: place.name ?? '',
        area: place.subLocality ?? '',
        city: place.locality ?? '',
        district: place.subAdministrativeArea ?? '',
        state: place.administrativeArea ?? '',
        postalCode: place.postalCode ?? '',
        country: place.country ?? '',
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
    isLoading.value = true;
    final result = await service.locationDetails();
    print("result $result");
    if (result != null) {
      locationDetails.assignAll(result);
    }
    isLoading.value = false;
  }
}
