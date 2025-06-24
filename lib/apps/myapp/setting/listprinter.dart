// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/apps/myapp/provider/provider.dart';
import 'package:smarttelemed/apps/myapp/setting/local.dart';

class SettingListPrinter extends StatefulWidget {
  const SettingListPrinter({super.key});

  @override
  State<SettingListPrinter> createState() => _SettingListPrinterState();
}

class _SettingListPrinterState extends State<SettingListPrinter> {
  List<String> listNamePrinters = [];
  bool statusSafe = false;
  String namePrinters = "";

  @override
  void initState() {
    super.initState();
    getprinter();
    scanprinter();
  }

  void getprinter() async {
    List<RecordSnapshot<int, Map<String, Object?>>> datas = await getPrinter();
    if (datas.length != 0) {
      for (RecordSnapshot<int, Map<String, Object?>> data in datas) {
        debugPrint("namePrinters  :${data["namePrinters"]}");
        context.read<DataProvider>().printername = data["namePrinters"]
            .toString();
      }
    }
  }

  Future<void> scanprinter() async {
    namePrinters = context.read<DataProvider>().printername;
    setState(() {
      statusSafe = true;
      listNamePrinters = [];
    });

    Future.delayed(const Duration(milliseconds: 500), () async {
      try {
        final printers = await Printing.listPrinters();
        setState(() {
          listNamePrinters = printers.map((printer) => printer.name).toList();
        });
      } catch (e) {
        print("Error listing printers: $e");
      } finally {
        setState(() {
          statusSafe = false;
        });
      }
    });
  }

  void selectPrinter(String printerName) async {
    setState(() {
      namePrinters = printerName;
      debugPrint('namePrinters=> $namePrinters');

      context.read<DataProvider>().printername = printerName;
      savenameprinter();
    });
  }

  void savenameprinter() {
    Map<String, dynamic> data = {'namePrinters': namePrinters};
    addDataPrinter(data);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: savenameprinter,
              child: statusSafe
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.save, color: Colors.black),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.1,
            child: Center(
              child: Text(
                "Selected Printer: $namePrinters",
                style: TextStyle(fontSize: width * 0.03),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.9,
            child: ListView.builder(
              itemCount: listNamePrinters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => selectPrinter(listNamePrinters[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      listNamePrinters[index],
                      style: TextStyle(fontSize: width * 0.03),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
