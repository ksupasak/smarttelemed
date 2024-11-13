import 'package:flutter/material.dart';

class SettingListPrinter extends StatefulWidget {
  const SettingListPrinter({super.key});

  @override
  State<SettingListPrinter> createState() => _SettingListPrinterState();
}

class _SettingListPrinterState extends State<SettingListPrinter> {
  List listNamePrinters = [];
  bool statusSafe = false;
  String namePrinters = "";
  @override
  void initState() {
    getprinter();
    super.initState();
  }

  void getprinter() {
    namePrinters = "Test1234";
  }

  void scanprinter() {
    setState(() {
      statusSafe = true;
    });

    listNamePrinters = [];

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        statusSafe = false;
      });
    });
  }

  void savenameprinter() {}
  @override
  Widget build(BuildContext context) {
     
    double height = MediaQuery.of(context).size.height;
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                scanprinter();
              },
              child: statusSafe == false
                  ? const Icon(
                      Icons.save,
                      color: Colors.black,
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height*0.1,
            child: Center(child: Text("namePrinters :$namePrinters")),
          ),
          SizedBox(
               height: height *0.9,
            child: ListView.builder(
              itemCount: listNamePrinters.length,
              itemBuilder: (context, index) {
                return const Padding(
                  padding:   EdgeInsets.all(8.0),
                  child: Text("listNamePrinters[index].toString()"),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
