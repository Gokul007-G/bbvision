import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';

class PdfPayslipController {
  Future<void> savePdfToDownloads(Uint8List bytes) async {
    final Directory dir = Directory('/storage/emulated/0/Download');

    final File file = File(
      '${dir.path}/salary_payslip_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );

    await file.writeAsBytes(bytes, flush: true);

    Get.snackbar(
      'Downloaded',
      'Saved to Downloads folder',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
