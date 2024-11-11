import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/station/provider/provider.dart'; 
import 'package:smarttelemed/station/views/pages/healthrecord/sum.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart';

class HealthRecord2 extends StatefulWidget {
  const HealthRecord2({super.key});

  @override
  State<HealthRecord2> createState() => _HealthRecord2State();
}

class _HealthRecord2State extends State<HealthRecord2> {
  void setsHealthrecord() {
    context.read<DataProvider>().sysHealthrecord.text = "";
    context.read<DataProvider>().diaHealthrecord.text = "";
    context.read<DataProvider>().heightHealthrecord.text = "";
    context.read<DataProvider>().weightHealthrecord.text = "";
    context.read<DataProvider>().tempHealthrecord.text = "";
    context.read<DataProvider>().pulseHealthrecord.text = "";
    context.read<DataProvider>().spo2Healthrecord.text = "";
    context.read<DataProvider>().updateviewhealthrecord("");
  }

  @override
  void initState() {
    setsHealthrecord();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = context.watch<DataProvider>();
    return Scaffold(
      body: Stack(
        children: [
          const backgrund(),
          SizedBox(
            child: Column(
              children: [
                BoxTime(),
                BoxDecorate(
                    child: InformationCard(
                        dataidcard: context.read<DataProvider>().dataidcard)),
                const SizedBox(child: SumHealthrecord()

                    //  dataProvider.viewhealthrecord == "pulseAndSysAndDia"
                    //     ? const PulseAndSysAndDia()
                    //     : dataProvider.viewhealthrecord == "spo2"
                    //         ? const Spo2Healthrecord()
                    //         : dataProvider.viewhealthrecord == "sum"
                    //             ? const SumHealthrecord()
                    //             : const HeightAndWidth(),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
