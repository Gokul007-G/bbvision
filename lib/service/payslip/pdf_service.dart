import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  static Future<Uint8List> generatePayslipPdf({
    required double width,
    required Map<String, dynamic> details,
  }) async {
    final pdf = pw.Document();

    //load fonts
    final regularFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );

    final ByteData imageData = await rootBundle.load('assets/icons/logo.png');
    final Uint8List imageBytes = imageData.buffer.asUint8List();

    final pw.ImageProvider pdfImage = pw.MemoryImage(imageBytes);

    final now = DateTime.now().toString();
    final date = now.split(' ');
    final time = date[1].split(':');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            children: [
              pw.Align(
                alignment: pw.Alignment.centerLeft,

                child: pw.Text(
                  '${date[0]}, ${time[0]}:${time[1]}',
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),

              pw.SizedBox(height: 16),

              //Logo
              pw.Image(pdfImage, width: width * 0.4),
              pw.Divider(),

              //company name
              pw.Text(
                textAlign: pw.TextAlign.center,
                'Quadsel Tower Old No 80, New No 118 Anna Salai, Manickam Ln, Guindy,\nChennai, Tamil Nadu 600032',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Payroll for the Month of ${details['pay_period']}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              pw.SizedBox(height: 16),

              infoRow(
                'Employee Name',
                '${details['emp_name']}',
                'Date of joined',
                '${details['doj']}',
                regularFont,
                boldFont,
              ),

              infoRow(
                'Employee Id',
                '${details['emp_id']}',
                'PAN Number',
                '${details['pan_no']}',
                regularFont,
                boldFont,
              ),

              infoRow(
                'Designation',
                '${details['designation_name']}',
                'UAN Number',
                '${details['uan_no']}',
                regularFont,
                boldFont,
              ),

              infoRow(
                'Department',
                '${details['dep_name']}',
                'ESIC  Number',
                '${details['esi_no']}',
                regularFont,
                boldFont,
              ),

              infoRow(
                'Bank',
                '${details['bank']}',
                'Bank Account No',
                '${details['acc_number']}',
                regularFont,
                boldFont,
              ),

              infoRow(
                'PF Number',
                '${details['pf_no']}',
                'Location',
                '${details['loc']}',
                regularFont,
                boldFont,
              ),

              infoRow(
                'Days Worked',
                '${details['month_days']}',
                'Total Number of Days',
                '${details['work_days']}',
                regularFont,
                boldFont,
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 16.0),
                child: pw.Column(
                  children: [
                    pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey400),

                      columnWidths: const {
                        0: pw.FlexColumnWidth(1),
                        1: pw.FlexColumnWidth(1),
                        2: pw.FlexColumnWidth(1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            _headerCell('Earnings'),
                            _headerCell('Deductions'),
                            _headerCell('Arrear_pay'),
                          ],
                        ),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder(
                        left: pw.BorderSide(color: PdfColors.grey400),
                        right: pw.BorderSide(color: PdfColors.grey400),
                        bottom: pw.BorderSide(color: PdfColors.grey400),
                        horizontalInside: pw.BorderSide(
                          color: PdfColors.grey400,
                        ),
                        verticalInside: pw.BorderSide(color: PdfColors.grey400),
                      ),
                      columnWidths: const {
                        0: pw.FlexColumnWidth(2),
                        1: pw.FlexColumnWidth(1),
                        2: pw.FlexColumnWidth(2),
                        3: pw.FlexColumnWidth(1),
                        4: pw.FlexColumnWidth(2),
                        5: pw.FlexColumnWidth(1),
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

              //table
              // pw.Padding(
              //   padding: pw.EdgeInsets.symmetric(vertical: 16),
              //   child: pw.Table(
              //     border: pw.TableBorder.all(width: 1),
              //     columnWidths: {
              //       0: pw.FlexColumnWidth(2),
              //       1: pw.FlexColumnWidth(1.5),
              //       2: pw.FlexColumnWidth(2.5),
              //       3: pw.FlexColumnWidth(1.5),
              //       4: pw.FlexColumnWidth(1.5),
              //       5: pw.FlexColumnWidth(1),
              //     },
              //     children: [
              //       /// HEADER ROW
              //       pw.TableRow(
              //         // decoration: BoxDecoration(color: Colors.grey.shade200),
              //         children: [
              //           tableHeader('Earnings', boldFont),
              //           pw.SizedBox(),
              //           tableHeader('Deductions', boldFont),
              //           pw.SizedBox(),
              //           tableHeader('Arrear Pay', boldFont),
              //           pw.SizedBox(),
              //         ],
              //       ),

              //       /// DATA ROWS
              //       salaryRow(
              //         'Basic & DA',
              //         details['basicDA'].toString(),
              //         'PF Employee',
              //         details['pfamount'].toString(),
              //         'NULL',
              //         regularFont,
              //         boldFont,
              //         details['gross_salary'].toString(),
              //       ),
              //       salaryRow(
              //         'HRA',
              //         details['hra'].toString(),
              //         'ESIC Employee',
              //         details['esicamount'].toString(),
              //         '',
              //         regularFont,
              //         boldFont,
              //         '',
              //       ),
              //       salaryRow(
              //         'Other Allowance',
              //         details['otherallowanceRoundOff'].toString(),
              //         'Professional Tax',
              //         details['professionaltax_permonth'].toString(),
              //         '',
              //         regularFont,
              //         boldFont,
              //         '',
              //       ),
              //       salaryRow(
              //         'Total Earning',
              //         details['salary'].toString(),
              //         'Total Deduction',
              //         details['deduction_total'].toString(),
              //         'Arrear Total',
              //         regularFont,
              //         boldFont,
              //         details['deduction_total'].toString(),
              //         isBold: true,
              //       ),

              //       /// NET SALARY ROW
              //       pw.TableRow(
              //         // decoration: BoxDecoration(color: Colors.green.shade50),
              //         children: [
              //           tableCell('NET Salary', boldFont, regularFont),
              //           tableCell(
              //             details['net_salary'].toString(),
              //             boldFont,
              //             regularFont,
              //           ),
              //           pw.SizedBox(),
              //           pw.SizedBox(),
              //           pw.SizedBox(),
              //           pw.SizedBox(),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              pw.SizedBox(height: 16),

              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      details['string_number'],
                      style: pw.TextStyle(font: boldFont, fontSize: 16),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      'This is a computer generated statement and does not require any signature.',
                      style: pw.TextStyle(font: boldFont, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  static pw.TableRow salaryRow(
    String eTitle,
    String eAmount,
    String dTitle,
    String dAmount,
    String aTitle,
    pw.Font regular,
    pw.Font bold,
    String aAmount, {
    bool isBold = false,
  }) {
    return pw.TableRow(
      children: [
        tableCell(eTitle, regular, bold, isBold: isBold),
        tableCell(eAmount, regular, bold, isBold: isBold),
        tableCell(dTitle, regular, bold, isBold: isBold),
        tableCell(dAmount, regular, bold, isBold: isBold),
        tableCell(aTitle, regular, bold, isBold: isBold),
        tableCell(aAmount, regular, bold, isBold: isBold),
      ],
    );
  }

  static pw.Widget tableHeader(String text, pw.Font bold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Center(
        child: pw.Text(text, style: pw.TextStyle(font: bold, fontSize: 14)),
      ),
    );
  }

  static pw.Widget tableCell(
    String text,
    pw.Font bold,
    pw.Font regular, {
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 9),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: isBold ? regular : bold, fontSize: 10),
      ),
    );
  }

  static pw.Widget infoRow(
    String text1,
    String text1Value,
    String text2,
    String text2Value,
    pw.Font regular,
    pw.Font bold,
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
                  style: pw.TextStyle(font: bold, fontSize: 12),
                  maxLines: 2,
                ),
                pw.Text(
                  text1Value,
                  style: const pw.TextStyle(fontSize: 10),
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
                pw.Text(text2, style: pw.TextStyle(font: bold, fontSize: 12)),
                pw.Text(text2Value, style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //new table
  static pw.Widget _headerCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.TableRow _dataRow(
    String a,
    String b,
    String c,
    String d,
    String e,
    String f, {
    bool isBold = false,
  }) {
    return pw.TableRow(
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

  static pw.Widget _cell(String text, isBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: 10,
        ),
      ),
    );
  }
}
