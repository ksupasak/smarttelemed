import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageApp extends StatefulWidget {
  const LanguageApp({super.key});

  @override
  State<LanguageApp> createState() => _LanguageAppState();
}

class _LanguageAppState extends State<LanguageApp> {
  @override
  Widget build(BuildContext context) {
    DataProvider provider = context.read<DataProvider>();
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text(
            S.of(context)!.confirm,
          ),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    provider.setlanguageApp(const Locale("en"));
                    setState(() {});
                  },
                  child: const Text("EN"))),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    provider.setlanguageApp(const Locale("th"));
                    setState(() {});
                  },
                  child: const Text("TH"))),
        ],
      ),
    );
  }
}
