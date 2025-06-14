import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/telemed/local/local.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/l10n/app_localizations.dart';
import 'package:smarttelemed/telemed/views/myapp.dart';
import 'package:smarttelemed/telemed/views/ui/stylebutton.dart';
import 'dart:io';
import 'package:process/process.dart';

class LanguageApp extends StatefulWidget {
  const LanguageApp({super.key});

  @override
  State<LanguageApp> createState() => _LanguageAppState();
}

class _LanguageAppState extends State<LanguageApp> {
  String? s;
  bool status_safe = false;
  void getS() async {
    List<RecordSnapshot<int, Map<String, Object?>>>? language =
        await getLanguageApp();
    if (language.length != 0) {
      for (RecordSnapshot<int, Map<String, Object?>> data in language) {
        s = data["s"].toString();
        setState(() {});
      }
    }
  }

  void restartApp() async {
    // Get the current executable path
    final executable = Platform.executable;

    // Start the process again
    await Process.start(executable, ['run']);

    // Exit the current app
    exit(0);
  }

  void saveLanguageApp(String s) async {
    setState(() {
      status_safe = true;
    });
    await addLanguageApp({"s": s});
    setState(() {
      status_safe = false;
    });
    restartApp();

    ///รีสตาส
    ///
  }

  @override
  void initState() {
    getS();
    super.initState();
  }

  List language = ['en', 'th'];
  List languageName = ['English', 'ไทย'];
  @override
  Widget build(BuildContext context) {
    DataProvider provider = context.read<DataProvider>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(s ?? ''),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                saveLanguageApp(s!);
              },
              child: status_safe == false
                  ? const Icon(Icons.save, color: Colors.black)
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: language.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                s = language[index];
                setState(() {});
              },
              child: Container(
                height: height * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: s == language[index]
                      ? Colors.green
                      : const Color.fromARGB(255, 226, 226, 226),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5.0,
                      color: s == language[index]
                          ? Colors.green
                          : const Color.fromARGB(255, 226, 226, 226),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      languageName[index],
                      style: TextStyle(fontSize: width * 0.03),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      // ListView(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Center(
      //           child: ElevatedButton(
      //               style: stylebutter(
      //                   Colors.black,
      //                   width * provider.buttonSized_w,
      //                   height * provider.buttonSized_h),
      //               onPressed: () {
      //                 saveLanguageApp("en");
      //               },
      //               child: Text(
      //                 "EN",
      //                 style: TextStyle(
      //                     color: Colors.white, fontSize: width * 0.035),
      //               ))),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Center(
      //           child: ElevatedButton(
      //               style: stylebutter(
      //                   Colors.black,
      //                   width * provider.buttonSized_w,
      //                   height * provider.buttonSized_h),
      //               onPressed: () {
      //                 saveLanguageApp("th");
      //               },
      //               child: Text("TH",
      //                   style: TextStyle(
      //                       color: Colors.white, fontSize: width * 0.035)))),
      //     ),
      //   ],
      // ),
    );
  }
}
