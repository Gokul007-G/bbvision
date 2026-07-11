import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bbvision/controller/payslip/payslip_controller.dart';
import 'package:bbvision/service/payslip/pdf_service.dart';
import 'package:bbvision/widget/appColors.dart';
import 'package:pdf/widgets.dart' as pw;

class PayslipDetailsScreen extends StatelessWidget {
  PayslipDetailsScreen({super.key});

  final controller = Get.put(PayslipController());
  @override
  Widget build(BuildContext context) {
    final details = controller.payslipDetails;

    final now = DateTime.now().toString();
    final date = now.split(' ');
    final time = date[1].split(':');

    final width = MediaQuery.sizeOf(context).width;
    return WillPopScope(
      onWillPop: () async {
        controller.payrollId.value = null;
        controller.departmentId.value = null;
        controller.staffId.value = null;
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                //currect date & time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${date[0]}, ${time[0]}:${time[1]}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.buttonDisabled,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.payrollId.value = null;
                          controller.departmentId.value = null;
                          controller.staffId.value = null;
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),

                //Logo
                Image.asset('assets/icons/logo.png', width: width * 0.4),
                Divider(),

                //company name
                const Text(
                  textAlign: TextAlign.center,
                  'Quadsel Tower Old No 80, \nNew No 118 Anna Salai, Manickam Ln, \nGuindy, Chennai, Tamil Nadu 600032',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Payroll for the Month of ${details['pay_period']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
                const SizedBox(height: 16),

                //employe name
                infoRow(
                  'Employee Name',
                  '${details['emp_name']}',
                  'Date of joined',
                  '${details['doj']}',
                ),

                //employee id
                infoRow(
                  'Employee Id',
                  '${details['emp_id']}',
                  'PAN Number',
                  '${details['pan_no']}',
                ),

                //designation
                infoRow(
                  'Designation',
                  '${details['designation_name']}',
                  'UAN Number',
                  '${details['uan_no']}',
                ),

                //department
                infoRow(
                  'Department',
                  '${details['dep_name']}',
                  'ESIC  Number',
                  '${details['esi_no']}',
                ),

                //bank
                infoRow(
                  'Bank',
                  '${details['bank']}',
                  'Bank Account No',
                  '${details['acc_number']}',
                ),

                //pf number
                infoRow(
                  'PF Number',
                  '${details['pf_no']}',
                  'Location',
                  '${details['loc']}',
                ),

                //day work
                infoRow(
                  'Days Worked',
                  '${details['month_days']}',
                  'Total Number of Days',
                  '${details['work_days']}',
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Table(
                        border: TableBorder.all(color: Colors.grey.shade400),
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            children: [
                              _headerCell('Earnings'),
                              _headerCell('Deductions'),
                              _headerCell('Arrear_pay'),
                            ],
                          ),
                        ],
                      ),
                      Table(
                        border: TableBorder(
                          left: BorderSide(color: Colors.grey.shade400),
                          right: BorderSide(color: Colors.grey.shade400),
                          bottom: BorderSide(color: Colors.grey.shade400),
                          horizontalInside: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(2),
                          5: FlexColumnWidth(1),
                        },
                        children: [
                          _dataRow(
                            'Basic & DA',
                            details['basicDA'].toString(),
                            'PF Employee',
                            details['pfamount'].toString(),
                            'NULL',
                            details['gross_salary'].toString(),
                          ),
                          _dataRow(
                            'HRA',
                            details['hra'].toString(),
                            'ESIC Employee',
                            details['esicamount'].toString(),
                            '',
                            '',
                          ),
                          _dataRow(
                            'Other Allowance',
                            details['otherallowanceRoundOff'].toString(),
                            'Professional Tax',
                            details['professionaltax_permonth'].toString(),
                            '',
                            '',
                          ),
                          _dataRow(
                            'Total Earning',
                            details['salary'].toString(),
                            'Total Deduction',
                            details['deduction_total'].toString(),
                            'Arrear Total',
                            details['deduction_total'].toString(),
                            isBold: true,
                          ),
                          _dataRow(
                            'NET Salary',

                            details['net_salary'].toString(),
                            isBold: true,

                            '',
                            '',
                            '',
                            '',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details['string_number'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This is a computer generated statement and does not require any signature.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isDownloading.value
                            ? null
                            : () async {
                                try {
                                  controller.isDownloading.value = true;
                                  final pdfBytes =
                                      await PdfService.generatePayslipPdf(
                                        width: width,
                                        details: Map<String, dynamic>.from(
                                          details,
                                        ),
                                      );

                                  final Directory dir = Directory(
                                    '/storage/emulated/0/Download',
                                  );

                                  final File file = File(
                                    '${dir.path}/salary_payslip_${DateTime.now().millisecondsSinceEpoch}.pdf',
                                  );

                                  await file.writeAsBytes(
                                    pdfBytes,
                                    flush: true,
                                  );

                                  // ✅ Success Snackbar
                                  Get.dialog(
                                    AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: const Text(
                                        'Download Complete',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: const Text(
                                        'Salary payslip has been successfully saved to your Downloads folder.',
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            controller.payrollId.value = null;
                                            controller.departmentId.value =
                                                null;
                                            controller.staffId.value = null;
                                            Get.back();
                                            Get.back();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                    barrierDismissible: false,
                                  );

                                  // ✅ Delay for UX
                                  // await Future.delayed(
                                  //   const Duration(seconds: 2),
                                  // );
                                  controller.isDownloading.value = false;
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'Failed to download file',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  debugPrint('PDF ERROR: $e');
                                } finally {
                                  controller.isDownloading.value = false;
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: controller.isDownloading.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Downloading...'),
                                ],
                              )
                            : const Text('Download'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ),
    );
  }

  TableRow salaryRow(
    String eTitle,
    String eAmount,
    String dTitle,
    String dAmount,
    String aTitle,
    String aAmount, {
    bool isBold = false,
  }) {
    return TableRow(
      children: [
        tableCell(eTitle, isBold: isBold),
        tableCell(eAmount, isBold: isBold),
        tableCell(dTitle, isBold: isBold),
        tableCell(dAmount, isBold: isBold),
        tableCell(aTitle, isBold: isBold),
        tableCell(aAmount, isBold: isBold),
      ],
    );
  }

  Widget tableCell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 9,
        ),
      ),
    );
  }

  pw.Widget infoRowPDF(
    String text1,
    String text1Value,
    String text2,
    String text2Value,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  text1,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                ),
                pw.Text(
                  text1Value,
                  style: const pw.TextStyle(fontSize: 9),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  text2,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                pw.Text(text2Value, style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(
    String text1,
    dynamic text1Value,
    String text2,
    dynamic text2Value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                Text(
                  text1Value,
                  style: TextStyle(
                    fontSize: 9,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text2,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                Text(text2Value, style: TextStyle(fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //new table
  Widget _headerCell(String text) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  TableRow _dataRow(
    String a,
    String b,
    String c,
    String d,
    String e,
    String f, {
    bool isBold = false,
  }) {
    return TableRow(
      children: [
        _cell(a, isBold),
        _cell(b, isBold),
        _cell(c, isBold),
        _cell(d, isBold),
        _cell(e, isBold),
        _cell(f, isBold),
      ],
    );
  }

  Widget _cell(String text, isBold) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 10,
        ),
      ),
    );
  }
}
