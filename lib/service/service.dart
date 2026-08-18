import 'package:dio/dio.dart';

class Service {
  //BaseURl

  static const baseUrl = 'http://10.0.2.2/bbvision/mobile_services/';
  static const imageUrl = 'http://10.0.2.2/bbvision/Qvision/CRM/calls/uploads/';
  static const leaveImageUrl =
      'http://10.0.2.2/bbvision/Qvision/Leave_Management/leave_request/files/';
  static const claimImageUrl =
      'http://10.0.2.2/bbvision/Qvision/claim/Uploads/';

  // static const baseUrl =
  //     'https://software.bluebase.in/bbvision/mobile_services/';
  // static const imageUrl =
  //     'https://software.bluebase.in/bbvision/Qvision/CRM/calls/uploads/';
  // static const leaveImageUrl =
  //     'https://software.bluebase.in/bbvision/Qvision/Leave_Management/leave_request/files/';
  // static const claimImageUrl =
  //     'https://software.bluebase.in/bbvision/Qvision/claim/Uploads/';

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
    ),
  );
}
