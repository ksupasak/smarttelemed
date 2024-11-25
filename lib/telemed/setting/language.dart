import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smarttelemed/telemed/views/ui/stylebutton.dart';

class LanguageApp extends StatefulWidget {
  const LanguageApp({super.key});

  @override
  State<LanguageApp> createState() => _LanguageAppState();
}

class _LanguageAppState extends State<LanguageApp> {
  @override
  Widget build(BuildContext context) {
    DataProvider provider = context.read<DataProvider>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text(
            S.of(context)!.confirm,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ElevatedButton(
                    style:
                        stylebutter(Colors.black, width * 0.4, height * 0.08),
                    onPressed: () {
                      provider.setlanguageApp(const Locale("en"));
                      setState(() {});
                    },
                    child: Text(
                      "EN",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.035),
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ElevatedButton(
                    style:
                        stylebutter(Colors.black, width * 0.4, height * 0.08),
                    onPressed: () {
                      provider.setlanguageApp(const Locale("th"));
                      setState(() {});
                    },
                    child: Text("TH",
                        style: TextStyle(
                            color: Colors.white, fontSize: width * 0.035)))),
          ),
        ],
      ),
    );
  }
}
