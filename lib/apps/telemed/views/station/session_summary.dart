import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smarttelemed/apps/telemed/core/services/background.dart/background.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smarttelemed/apps/telemed/views/ui/informationCard.dart';
import 'package:smarttelemed/apps/telemed/views/ui/stylebutton.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:smarttelemed/l10n/app_localizations.dart';
import 'package:smarttelemed/apps/telemed/views/station/stage.dart';

class SessionSummary extends StatefulWidget {
  const SessionSummary({super.key});

  @override
  State<SessionSummary> createState() => _SessionSummaryState();
}

class _SessionSummaryState extends State<SessionSummary> {
  String doctor_note = '--';
  String cc = '--';

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
    var url = Uri.parse(
      '${context.read<DataProvider>().platfromURL}/check_quick',
    );
    var res = await http.post(
      url,
      body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      },
    );

    resTojson2 = json.decode(res.body);
    setState(() {});
  }

  Future<void> exam() async {
    var url = Uri.parse(
      '${context.read<DataProvider>().platfromURL}/get_doctor_exam',
    );
    var res = await http.post(
      url,
      body: {'public_id': context.read<DataProvider>().id},
    );
    setState(() {
      var resTojson = json.decode(res.body);
      debugPrint('+++++++$resTojson');
      doctor_note = resTojson['data']['doctor_note'];
      cc = resTojson['data']['cc'];
      if (resTojson != null) {
        debugPrint(cc);
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

  void sendHealthrecordGateway() async {
    DataProvider provider = context.read<DataProvider>();
    var body = jsonEncode({
      // "vn": provider.vn,
      // "hn": provider.hn,
      // "cid": provider.id,
      // "cc":
      "vn": provider.vn,
      "hn": provider.hn,
      "cid": provider.id,
      "bmi": "",
      "bpd": "",
      "bps": "",
      "fbs": "0",
      "rr": "0",
      "pulse": "",
      "spo2": "",
      "temp": "",
      "height": "",
      "weight": "",
      "cc": cc,
    });
    try {
      provider.debugPrintV(
        "senvisitGatewayCC :${provider.platfromURLGateway}/api/vitalsign - ${cc}",
      );
      // "bmi": provider.bmiHealthrecord.text,
      // "bpd": provider.diaHealthrecord.text,
      // "bps": provider.sysHealthrecord.text,
      // "fbs": "0",
      // "rr": "0",
      // "pulse": provider.pulseHealthrecord.text,
      // "spo2": provider.spo2Healthrecord.text,
      // "temp": provider.tempHealthrecord.text,
      // "height": provider.heightHealthrecord.text,
      // "weight": provider.weightHealthrecord.text,
      // "cc": cc
      // }catch (e) {
      //   provider.debugPrintV("senvisitGatewayCC $e");
      // };
      // try {
      provider.debugPrintV(
        "senvisitGateway+CC :${provider.platfromURLGateway}/api/vitalsign",
      );

      var url = Uri.parse('${provider.platfromURLGateway}/api/vitalsign');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      provider.debugPrintV("response Gateway$response");
      var resTojsonGateway = json.decode(response.body);
      provider.debugPrintV("resTojsonGateway $resTojsonGateway");
    } catch (e) {
      provider.debugPrintV("error Gateway $e");
    }
  }

  void printexam() async {
    sendHealthrecordGateway();
    String msgHead = "";
    String msgDetail = "";
    //double sizeHeader = 20;
    sendHealthrecordGateway();
    pw.TextStyle font_sizeBody = pw.TextStyle(
      font: thaiFont, // Make sure thaiFont is a valid pw.Font
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );
    DataProvider provider = context.read<DataProvider>();
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
    msgDetail += "${AppLocalizations.of(context)!.summary_history} \n";

    dataBarcode = resTojson2["personal"]["hn"];
    dataQrcode =
        "https://expert.emr-life.com/telemed/App/login?cid=${provider.id}";

    pw.Widget _buildLogo(Uint8List logoBytes) {
      return pw.Center(
        child: pw.Image(pw.MemoryImage(logoBytes), width: 70, height: 70),
      );
    }

    pw.Widget _buildHeader() {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            AppLocalizations.of(context)!.summary_testResult, // 'ผลการตรวจ',
            style: font_sizeBody,
          ),
          pw.Text(msgHead, style: font_sizeBody),
        ],
      );
    }

    pw.Widget _buildText(String mText) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [pw.Text(mText, style: font_sizeBody)],
      );
    }

    pw.Widget _buildDocnote() {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            AppLocalizations.of(context)!.summary_analyze,
            style: font_sizeBody,
          ),
          pw.Text(cc, style: font_sizeBody),
          pw.Text(
            AppLocalizations.of(context)!.summary_dispMed,
            style: font_sizeBody,
          ),
          pw.Text(doctor_note, style: font_sizeBody),
          pw.Text(
            AppLocalizations.of(context)!.summary_detail,
            style: font_sizeBody,
          ),
          pw.Text(msgDetail, style: font_sizeBody),
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
              _buildQRCode(dataQrcode),
              pw.SizedBox(height: 5),
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
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomeTelemed()),
      // );
      // context.read<DataProvider>().setPage(Stage.HOME_SCREEN);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Stage().getPage(Stage.HOME_SCREEN),
        ),
      );
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
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(child: InformationCard()),
                    ),
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
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView(
                        children: [
                          SizedBox(height: height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.summary_testResult,
                                style: TextStyle(fontSize: width * 0.04),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.25,
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.summary_dx, // dx
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  cc,
                                  style: TextStyle(fontSize: width * 0.03),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.25,
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.summary_dc_note, // doctor note
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  doctor_note,
                                  style: TextStyle(fontSize: width * 0.03),
                                ),
                              ),
                            ],
                          ),
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
                              AppLocalizations.of(
                                context,
                              )!.summary_healthMeasurement, // วัดค่าสุขภาพ
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          resTojson2 != null
                              ? resTojson2["health_records"].length != 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            // BMI :
                                            resTojson2["health_records"][0]["bmi"] !=
                                                    null
                                                ? "${AppLocalizations.of(context)!.summary_bmi} ${resTojson2["health_records"][0]["bmi"]}"
                                                : "",
                                            style: TextStyle(
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                          Text(
                                            // Weight :
                                            resTojson2["health_records"][0]["weight"] !=
                                                    null
                                                ? "${AppLocalizations.of(context)!.summary_weight} ${resTojson2["health_records"][0]["weight"]}"
                                                : "",
                                            style: TextStyle(
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                          Text(
                                            // Height :
                                            resTojson2["health_records"][0]["height"] !=
                                                    null
                                                ? "${AppLocalizations.of(context)!.summary_height} ${resTojson2["health_records"][0]["height"]}"
                                                : "",
                                            style: TextStyle(
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox()
                              : const SizedBox(),
                          resTojson2 != null
                              ? resTojson2["health_records"].length != 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            resTojson2["health_records"][0]["bp"] !=
                                                    null
                                                ? "BP :${resTojson2["health_records"][0]["bp"]}"
                                                : "",
                                            style: TextStyle(
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                          Text(
                                            resTojson2["health_records"][0]["spo2"] !=
                                                    null
                                                ? "Spo2 :${resTojson2["health_records"][0]["spo2"]}"
                                                : "",
                                            style: TextStyle(
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                          Text(
                                            resTojson2["health_records"][0]["temp"] !=
                                                    null
                                                ? "Temp :${resTojson2["health_records"][0]["temp"]}"
                                                : "",
                                            style: TextStyle(
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                          Text(
                                            resTojson2["health_records"][0]["pr"] !=
                                                    null
                                                ? "Pulse :${resTojson2["health_records"][0]["pr"]}"
                                                : "",
                                            style: TextStyle(
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                          Text(
                                            resTojson2["health_records"][0]["dtx "] !=
                                                    null
                                                ? "RR :${resTojson2["health_records"][0]["dtx"]}"
                                                : "",
                                            style: TextStyle(
                                              fontSize: width * 0.03,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox()
                              : const SizedBox(),
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.summary_history,
                              style: TextStyle(fontSize: width * 0.03),
                            ),
                          ),
                          Center(
                            child: QrImageView(
                              data:
                                  'https://expert.emr-life.com/telemed/App/login?cid=${provider.id}',
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                          ),
                        ],
                      ),
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
                                height * provider.buttonSized_h,
                              ),
                              onPressed: () {
                                printexam();
                              },
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.summary_printTestResults, //"ปริ้นผลตรวจ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.06,
                                ),
                              ),
                            )
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
                  //             AppLocalizations.of(context)!.leave,
                  //             style: TextStyle(
                  //                 color: Colors.red, fontSize: width * 0.03),
                  //           ),
                  //         ),
                  //       )),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const PatientHome(),
                  //   ),
                  // );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Stage().getPage(Stage.PATIENT_HOME_SCREEN),
                    ),
                  );
                },
                child: Container(
                  height: height * 0.025,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 201, 201, 201),
                      width: width * 0.002,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.summary_backButton, //'< ย้อนกลับ',
                      style: TextStyle(
                        fontSize: width * 0.03,
                        color: const Color.fromARGB(255, 201, 201, 201),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
