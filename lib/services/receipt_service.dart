import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class ReceiptService {
  /// Generates and Prints a PDF Receipt
  static Future<void> printReceipt({
    required String facultyName,
    required String department,
    required String month,
    required int totalLectures,
    required double ratePerLecture,
    required double totalAmount,
    required String paymentDate,
    required String receiptId,
  }) async {
    final doc = pw.Document();

    // 1. LOAD BOTH REGULAR AND BOLD FONTS
    final ttfRegular = await PdfGoogleFonts.robotoRegular();
    final ttfBold = await PdfGoogleFonts.robotoBold(); // ✅ Required for Bold Text

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          // 2. APPLY BOTH FONTS TO THE THEME
          return pw.Theme(
            data: pw.ThemeData.withFont(
              base: ttfRegular,
              bold: ttfBold, // ✅ Tells PDF to use Roboto for bold text too
            ),
            child: buildReceiptLayout(
                facultyName, department, month, totalLectures,
                ratePerLecture, totalAmount, paymentDate, receiptId
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Receipt_$receiptId.pdf',
    );
  }

  static pw.Widget buildReceiptLayout(
      String name, String dept, String month, int lectures,
      double rate, double total, String date, String id) {

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // HEADER
        pw.Header(
          level: 0,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("College SMS", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text("OFFICIAL SALARY SLIP", style: pw.TextStyle(fontSize: 18, color: PdfColors.grey)),
            ],
          ),
        ),
        pw.SizedBox(height: 20),

        // DETAILS
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("To:", style: pw.TextStyle(color: PdfColors.grey)),
                pw.Text(name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                pw.Text("Dept: $dept"),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text("Receipt #: $id"),
                pw.Text("Date: $date"),
                pw.Text("Status: PAID", style: pw.TextStyle(color: PdfColors.green, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 40),

        // TABLE
        pw.Table.fromTextArray(
          headers: ["Description", "Quantity", "Rate", "Total"],
          data: [
            ["Teaching Services - $month", "$lectures Lectures", "₹ ${rate.toStringAsFixed(2)}", "₹ ${total.toStringAsFixed(2)}"],
          ],
          border: null,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xff45a182)),
          cellHeight: 30,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
          },
        ),
        pw.Divider(),

        // TOTAL
        pw.Container(
          alignment: pw.Alignment.centerRight,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text("NET TOTAL: ", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              // ✅ This will now work because 'bold: ttfBold' is set
              pw.Text("₹ ${total.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
            ],
          ),
        ),

        pw.Spacer(),

        // FOOTER
        pw.Divider(),
        pw.Center(
          child: pw.Text("This is a computer-generated receipt. No signature required.",
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
        ),
      ],
    );
  }
}