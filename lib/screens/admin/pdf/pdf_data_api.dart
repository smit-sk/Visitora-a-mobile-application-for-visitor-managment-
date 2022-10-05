import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:visitor_tracker/screens/admin/pdf/pdf_api.dart';

class PdfDataApi {
  static Future<File> generate(List item) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      theme: ThemeData.withFont(
        base: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        bold: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        italic: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        boldItalic: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
      ),
      build: (context) => [

        buildHeader(),
     
        // SizedBox(height: 3 * PdfPageFormat.cm),
        buildInvoiceInfo(),
        
        SizedBox(height: PdfPageFormat.cm),
        // buildTitle(invoice),
        buildInvoice(item),
        // Divider(),
        // buildTotal(invoice),
      ],
      // footer: (context) => buildFooter(invoice),
    ));
    final date = DateTime.now();
    String s = "Record of " + date.toString();
    return PdfApi.saveDocument(name: '${s}.pdf', pdf: pdf);
  }

  static Widget buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child:  Text("Visitor Info",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)))
            
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
        
        ],
      );

  // static Widget buildCustomerAddress(Customer customer) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
  //         Text(customer.address),
  //       ],
  //     );

  static Widget buildInvoiceInfo() {
  //  DateTime date = DateTime.now();
    // String formatDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String formatDate =DateTime.now().toString();
    final titles = <String>[
      
      'Date:'
    ];
    final data = <String>[
     formatDate
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  // static Widget buildSupplierAddress(Supplier supplier) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         Text(supplier.address),
  //       ],
  //     );

  // static Widget buildTitle(Invoice invoice) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'INVOICE',
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 0.8 * PdfPageFormat.cm),
  //         Text(invoice.info.description),
  //         SizedBox(height: 0.8 * PdfPageFormat.cm),
  //       ],
  //     );

  static Widget buildInvoice(List item) {
    final headers = [
      'Name',
      'Vaccinated',
      'Mobile No.',
      'Address',
      'Time',
    ];
    final data = item.map((item) {
      return [
        item['name'],
        item['vaccinated'],
        item['number'],
        item['address'],
        (item['uploaded_time'] as Timestamp).toDate(),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: TableBorder(bottom: BorderSide(),top: BorderSide(),left: BorderSide(),right: BorderSide(), horizontalInside: BorderSide(), verticalInside: BorderSide()),
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  // static Widget buildTotal(Invoice invoice) {
  //   final netTotal = invoice.items
  //       .map((item) => item.unitPrice * item.quantity)
  //       .reduce((item1, item2) => item1 + item2);
  //   final vatPercent = invoice.items.first.vat;
  //   final vat = netTotal * vatPercent;
  //   final total = netTotal + vat;

  //   return Container(
  //     alignment: Alignment.centerRight,
  //     child: Row(
  //       children: [
  //         Spacer(flex: 6),
  //         Expanded(
  //           flex: 4,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               buildText(
  //                 title: 'Net total',
  //                 value: Utils.formatPrice(netTotal),
  //                 unite: true,
  //               ),
  //               buildText(
  //                 title: 'Vat ${vatPercent * 100} %',
  //                 value: Utils.formatPrice(vat),
  //                 unite: true,
  //               ),
  //               Divider(),
  //               buildText(
  //                 title: 'Total amount due',
  //                 titleStyle: TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 value: Utils.formatPrice(total),
  //                 unite: true,
  //               ),
  //               SizedBox(height: 2 * PdfPageFormat.mm),
  //               Container(height: 1, color: PdfColors.grey400),
  //               SizedBox(height: 0.5 * PdfPageFormat.mm),
  //               Container(height: 1, color: PdfColors.grey400),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // static Widget buildFooter(Invoice invoice) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Divider(),
  //         SizedBox(height: 2 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Address', value: invoice.supplier.address),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
  //       ],
  //     );

  // static buildSimpleText({
  //   required String title,
  //   required String value,
  // }) {
  //   final style = TextStyle(fontWeight: FontWeight.bold);

  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: pw.CrossAxisAlignment.end,
  //     children: [
  //       Text(title, style: style),
  //       SizedBox(width: 2 * PdfPageFormat.mm),
  //       Text(value),
  //     ],
  //   );
  // }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Text(title, style: style),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
