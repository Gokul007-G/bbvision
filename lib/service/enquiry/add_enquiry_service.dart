import 'dart:convert';
import 'package:bbvision/model/enquiry/call_type_model.dart';
import 'package:bbvision/model/enquiry/company_details_model.dart';
import 'package:bbvision/model/enquiry/company_model.dart';
import 'package:bbvision/model/enquiry/product_service_model.dart';
import 'package:bbvision/service/service.dart';

class AddEnquiryService {
  final api = Service();

  //call master
  Future<List<CallSource>?> callSource() async {
    try {
      final response = await api.dio.get(
        'add_enquiry.php',
        queryParameters: {'type': 'callSource'},
      );

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        if (data['status'] == 'success') {
          return (data['data'] as List)
              .map((e) => CallSource.fromJson(e))
              .toList();
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      print('error $e');
    }
    return null;
  }

  //get the exiting company names
  Future<List<CompanyModel>?> companyName() async {
    try {
      final response = await api.dio.get(
        'add_enquiry.php',
        queryParameters: {'type': 'companyName'},
      );

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        if (data['status'] == 'success') {
          return (data['data'] as List)
              .map((e) => CompanyModel.fromJson(e))
              .toList();
        } else {
          return null;
        }
      }
    } catch (e) {
      print('Error $e');
    }
    return null;
  }

  //get the exiting company details
  Future<List<CompanyDetails>?> companyDetails(int orgID) async {
    try {
      final response = await api.dio.get(
        'add_enquiry.php',
        queryParameters: {'type': 'companyDetails', 'org_id': orgID},
      );

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        if (data['status'] == 'success') {
          return (data['data'] as List)
              .map((e) => CompanyDetails.fromJson(e))
              .toList();
        } else {
          return null;
        }
      }
    } catch (e) {
      print('Error $e');
    }
    return null;
  }

  //get the exiting company details
  Future<List<ProductServiceModel>?> productServiceDetails(int id) async {
    try {
      final response = await api.dio.get(
        'add_enquiry.php',
        queryParameters: {'type': 'service', 'serviceId': id},
      );

      if (response.statusCode == 200) {
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        if (data['status'] == 'success') {
          return (data['data'] as List)
              .map((e) => ProductServiceModel.fromJson(e))
              .toList();
        } else {
          return null;
        }
      }
    } catch (e) {
      print('Error $e');
    }
    return null;
  }

}
