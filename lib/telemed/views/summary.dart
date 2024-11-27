import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/background.dart/background.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smarttelemed/telemed/views/home.dart';
import 'package:smarttelemed/telemed/views/ui/informationCard.dart';
import 'package:smarttelemed/telemed/views/ui/stylebutton.dart';
import 'package:smarttelemed/telemed/views/userInformation.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  String doctor_note = '--';
  String dx = '--';
  Printer? selectedPrinter; // Stores the selected printer
  var resTojson2;
  late pw.Font thaiFont;
  @override
  void initState() {
    exam();
    get_queue();
    _loadThaiFont();

    super.initState();
  }

  Future<void> get_queue() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/check_quick');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });

    resTojson2 = json.decode(res.body);
    setState(() {});
  }

  Future<void> exam() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/get_doctor_exam');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      var resTojson = json.decode(res.body);
      debugPrint('+++++++$resTojson');
      doctor_note = resTojson['data']['doctor_note'];
      dx = resTojson['data']['dx'];
      if (resTojson != null) {
        debugPrint(dx);
        debugPrint(doctor_note);
        setState(() {});
      }
    });
  }

  Future<void> _selectPrinter() async {
    final printers = await Printing.listPrinters();

    print('lists_printer....');
    if (printers.isNotEmpty) {
      print('Total printers found: ${printers.length}');
      for (var i = 0; i < printers.length; i++) {
        print('Printer $i: ${printers[i].name}');
      }

      final kposPrinter = printers.firstWhere(
        (printer) => printer.name == context.read<DataProvider>().printername,
        orElse: () => printers.first,
      );
      debugPrint('selected :=> ${kposPrinter}');

      setState(() {
        selectedPrinter = kposPrinter;
      });
    }
  }

  void printexam() async {
    String msgHead = "";
    String msgDetail = "";
    //double sizeHeader = 20;

    pw.TextStyle font_sizeBody = pw.TextStyle(
      font: thaiFont, // Make sure thaiFont is a valid pw.Font
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );

    String dataBarcode = "";
    String dataQrcode = "";
    String databarcodeHN = resTojson2["personal"]["hn"];
    String databarcodeVN = ""; //resTojson2[""][""];
    //  img Logo
    Uint8List? logoBytes;
    try {
      final logoData = await rootBundle.load('assets/icon/ic_launcher.png');
      logoBytes = logoData.buffer.asUint8List();
    } catch (e) {
      debugPrint("Logo not found: $e");
    }
    //  img Logo

    if (selectedPrinter == null) {
      await _selectPrinter();

      // selectedPrinter = selected_printer;
    }

    final pdf = pw.Document();

    // Define 80mm width and auto height for a thermal printer
    final pageFormat = PdfPageFormat(80 * PdfPageFormat.mm, double.infinity);

    msgHead = 'HN : ${resTojson2['personal']['hn']} \n';
    msgHead +=
        'คุณ : ${resTojson2['personal']['first_name']} ${resTojson2['personal']['last_name']} \n';

    msgDetail =
        'น้ำหนัก : ${resTojson2['health_records'][0]['weight']} | ส่วนสูง: ${resTojson2['health_records'][0]['height']} \n';
    msgDetail +=
        'อุณภูมิ : ${resTojson2['health_records'][0]['temp']}  | BP: ${resTojson2['health_records'][0]['bp']} \n';
    msgDetail += 'PULSE : ${resTojson2['health_records'][0]['pulse_rate']} \n';

    dataBarcode = resTojson2["personal"]["hn"];
    dataQrcode = resTojson2["personal"]["hn"];

    pw.Widget _buildLogo(Uint8List logoBytes) {
      return pw.Center(
        child: pw.Image(
          pw.MemoryImage(logoBytes),
          width: 70,
          height: 70,
        ),
      );
    }

    pw.Widget _buildHeader() {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ผลการตรวจ',
            style: font_sizeBody,
          ),
          pw.Text(
            msgHead,
            style: font_sizeBody,
          ),
        ],
      );
    }

    pw.Widget _buildText(String mText) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(mText, style: font_sizeBody),
        ],
      );
    }

    pw.Widget _buildDocnote() {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(S.of(context)!.summary_analyze, style: font_sizeBody),
          pw.Text(dx, style: font_sizeBody),
          pw.Text(
            S.of(context)!.summary_dispMed,
            style: font_sizeBody,
          ),
          pw.Text(
            doctor_note,
            style: font_sizeBody,
          ),
          pw.Text(
            S.of(context)!.summary_detail,
            style: font_sizeBody,
          ),
          pw.Text(
            msgDetail,
            style: font_sizeBody,
          ),
        ],
      );
    }

    pw.Widget _buildBarcode(String dataBarcode) {
      return pw.Center(
        child: pw.BarcodeWidget(
          data: dataBarcode.toString(), // Sample barcode data
          barcode: pw.Barcode.code128(),
          width: 80,
          height: 40,
        ),
      );
    }

    pw.Widget _buildQRCode(String dataQrcode) {
      return pw.Center(
        child: pw.BarcodeWidget(
          data: dataQrcode.toString(), // Sample QR code data
          barcode: pw.Barcode.qrCode(),
          width: 80,
          height: 80,
        ),
      );
    }

    pw.Widget _buildFooter() {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            '--',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: thaiFont, fontSize: 12),
          ),
          pw.Text(
            '-',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: thaiFont, fontSize: 10),
          ),
        ],
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(80 * PdfPageFormat.mm, double.infinity),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logoBytes != null) _buildLogo(logoBytes),
              pw.SizedBox(height: 5),
              _buildHeader(),
              pw.SizedBox(height: 5),
              _buildDocnote(),
              pw.Divider(),
              _buildText("HN"),
              pw.SizedBox(height: 5),
              _buildBarcode(databarcodeHN),
              pw.Divider(),
              _buildText("VN"),
              pw.SizedBox(height: 5),
              _buildBarcode(databarcodeVN),
              pw.SizedBox(height: 5),
              // _buildQRCode(dataQrcode),
              // pw.SizedBox(height: 5),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    // Convert the PDF to bytes
    final pdfBytes = await pdf.save();

    if (selectedPrinter != null) {
      await Printing.directPrintPdf(
        printer: selectedPrinter!,
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const HomeTelemed()));
    } else {
      print("No printer selected.");
    }
  }

  Future<void> _loadThaiFont() async {
    final fontData = await rootBundle.load('assets/fonts/THSarabunNew.ttf');
    print('_loadThaiFont');
    print(fontData);
    setState(() {
      thaiFont = pw.Font.ttf(fontData);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DataProvider provider = context.read<DataProvider>();
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Positioned(
            child: SizedBox(
              width: width,
              height: height,
              child: ListView(
                children: [
                  SizedBox(height: height * 0.13),
                  Center(
                    child: Container(
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 0.5,
                                color: Color(0xff48B5AA),
                                offset: Offset(0, 3)),
                          ],
                        ),
                        child: const Center(
                          child: InformationCard(),
                        )),
                  ),
                  SizedBox(height: height * 0.02),
                  Center(
                    child: Container(
                      height: height * 0.5,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Color.fromARGB(255, 188, 188, 188),
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: ListView(children: [
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(S.of(context)!.summary_testResult,
                                style: TextStyle(fontSize: width * 0.04)),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.25,
                                child: Text(S.of(context)!.summary_dx, // dx
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: width * 0.03)),
                              ),
                              SizedBox(
                                width: width * 0.5,
                                child: Text(dx,
                                    style: TextStyle(fontSize: width * 0.03)),
                              ),
                            ]),
                        SizedBox(height: height * 0.01),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.25,
                                child: Text(
                                    S
                                        .of(context)!
                                        .summary_dc_note, // doctor note
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: width * 0.03)),
                              ),
                              SizedBox(
                                width: width * 0.5,
                                child: Text(doctor_note,
                                    style: TextStyle(fontSize: width * 0.03)),
                              ),
                            ]),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: width * 0.8,
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Center(
                            child: Text(
                                S
                                    .of(context)!
                                    .summary_healthMeasurement, // วัดค่าสุขภาพ
                                style: TextStyle(fontSize: width * 0.04))),
                        SizedBox(height: height * 0.01),
                        resTojson2 != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    // BMI :
                                    resTojson2["health_records"][0]["bmi"] !=
                                            null
                                        ? "${S.of(context)!.summary_bmi} ${resTojson2["health_records"][0]["bmi"]}"
                                        : "",
                                    style: TextStyle(fontSize: width * 0.03),
                                  ),
                                  Text(
                                    // Weight :
                                    resTojson2["health_records"][0]["weight"] !=
                                            null
                                        ? "${S.of(context)!.summary_weight} ${resTojson2["health_records"][0]["weight"]}"
                                        : "",
                                    style: TextStyle(fontSize: width * 0.03),
                                  ),
                                  Text(
                                    // Height :
                                    resTojson2["health_records"][0]["height"] !=
                                            null
                                        ? "${S.of(context)!.summary_height} ${resTojson2["health_records"][0]["height"]}"
                                        : "",
                                    style: TextStyle(fontSize: width * 0.03),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        resTojson2 != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    resTojson2["health_records"][0]["bp"] !=
                                            null
                                        ? "BP :${resTojson2["health_records"][0]["bp"]}"
                                        : "",
                                    style: TextStyle(fontSize: width * 0.03),
                                  ),
                                  Text(
                                    resTojson2["health_records"][0]["spo2"] !=
                                            null
                                        ? "ออกซิเจนในเลือด :${resTojson2["health_records"][0]["spo2"]}"
                                        : "",
                                    style: TextStyle(fontSize: width * 0.03),
                                  ),
                                  Text(
                                    resTojson2["health_records"][0]["temp"] !=
                                            null
                                        ? "Temp :${resTojson2["health_records"][0]["temp"]}"
                                        : "",
                                    style: TextStyle(fontSize: width * 0.03),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ]),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: resTojson2 != null
                          ? ElevatedButton(
                              style: stylebutter(
                                  Colors.green,
                                  width * provider.buttonSized_w,
                                  height * provider.buttonSized_h),
                              onPressed: () {
                                printexam();
                              },
                              child: Text("ปริ้นผลตรวจ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width * 0.06)))
                          : SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                              height: MediaQuery.of(context).size.width * 0.05,
                              child: const CircularProgressIndicator(),
                            ),
                    ),
                  ),
                  // Center(
                  //   child: GestureDetector(
                  //       onTap: () {
                  //         Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => const Userinformation()));
                  //       },
                  //       child: Container(
                  //         width: width * 0.1,
                  //         decoration:
                  //             BoxDecoration(border: Border.all(color: Colors.grey)),
                  //         child: Center(
                  //           child: Text(
                  //             S.of(context)!.leave,
                  //             style: TextStyle(
                  //                 color: Colors.red, fontSize: width * 0.03),
                  //           ),
                  //         ),
                  //       )),
                  // )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Userinformation()));
                },
                child: Container(
                  height: height * 0.025,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromARGB(255, 201, 201, 201),
                          width: width * 0.002)),
                  child: Center(
                      child: Text(
                    '< ย้อนกลับ',
                    style: TextStyle(
                        fontSize: width * 0.03,
                        color: const Color.fromARGB(255, 201, 201, 201)),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
