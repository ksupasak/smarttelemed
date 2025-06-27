import 'package:smarttelemed/shared/med_devices/hl7/abstract_hl7.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AquarisHl7 extends AbstractHl7 {
  AquarisHl7({
    required String name,
    required String id,
    required String status,
    required String type,
    required bool autoStart,
  }) : super(
         name: name,
         id: id,
         status: status,
         type: type,
         autoStart: autoStart,
       );

  factory AquarisHl7.fromJson(Map<String, dynamic> json) {
    return AquarisHl7(
      name: json['name'],
      id: json['id'],
      status: json['status'],
      type: json['type'],
      autoStart: json['autoStart'] ?? false,
    );
  }

  @override
  void connect() {
    print('AquarisHl7 is connecting');
    startHL7Server();
  }

  void disconnect() {
    print('AquarisHl7 is disconnecting');
  }

  void startHL7Server() async {
    // DataProvider provider = context.read<DataProvider>();
    // provider.debugPrintV("start HL7 Server");

    final port = 1901; // Example port for HL7
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print('HL7 Server listening on port $port');

    server.listen((Socket socket) {
      print('Client connected: ${socket.remoteAddress.address}');
      socket.listen((List<int> data) {
        final message = String.fromCharCodes(data);
        print('Received HL7 message: $message');
        Map<String, dynamic> params = {
          'deviceId': this.id,
          'name': this.name,
          'type': 'hl7',
          'status': 'connected',
        };
        List<String> lines = message.split('\r');
        for (var line in lines) {
          print('Line: $line');
          List<String> tags = line.split('|');
          print('Tags: $tags');

          if (tags[0] == 'OBX') {
            print('OBX: $tags');
            List<String> labels = tags[3].split("^");
            if (labels[0] == "150344" && double.parse(tags[5]) > 0) {
              double temp = double.parse(tags[5]) / 10;
              params['temp'] = temp.toStringAsFixed(1).toString();
            }

            if (labels[0] == "150031" && int.parse(tags[5]) > 0) {
              params['sys'] = tags[5];
            }

            if (labels[0] == "150302" && int.parse(tags[5]) > 0) {
              params['dia'] = tags[5];
            }

            if (labels[0] == "149530" && int.parse(tags[5]) > 0) {
              params['pr'] = tags[5];
            }
            if (labels[0] == "150456" && int.parse(tags[5]) > 0) {
              params['spo2'] = tags[5];
            }
          }
        }

        callback?.call(params);

        //       // MSH|^~\&|northern|patient monitor^|||20250612090838||ORU^R01^ORU_R01|1362|P|2.6|
        //       // PID|||0001||expert^vs||00000000|M|
        //       // PV1||I|^^
        //       // OBR|1||||||20250612090838|
        //       // OBX|1|NM|150456^MDC_PULS_OXIM_SAT_O2^MDC|1.3.1.150456|-100|262688^MDC_DIM_PERCENT^MDC|||||F||||
        //       // OBX|2|NM|149530^MDC_PULS_OXIM_PULS_RATE^MDC|1.3.1.149530|-100|264864^MDC_DIM_BEAT_PER_MIN^MDC|||||F||||
        //       // OBX|3|NM|150344^MDC_TEMP^MDC|1.2.1.150344|38.5|268192^MDC_DIM_DEGC^MDC|||||F||||
        //       // OBX|4|NM|150344^MDC_TEMP^MDC|1.2.2.150344|384.5|268192^MDC_DIM_DEGC^MDC|||||F||||
        //       // OBX|3|NM|150031^MDC_PRESS_CUFF_SYS^MDC|1.1.9.150301|142|266016^MDC_DIM_MMHG^MDC|||||F||APERIODIC|20250612093319|
        //       // OBX|4|NM|150303^MDC_PRESS_CUFF_MEAN^MDC|1.1.9.150303|114|266016^MDC_DIM_MMHG^MDC|||||F||APERIODIC|20250612093319|
        //       // OBX|5|NM|150302^MDC_PRESS_CUFF_DIA^MDC|1.1.9.150302|100|266016^MDC_DIM_MMHG^MDC|||||F||APERIODIC|20250612093319|
        //       // Process the HL7 message here

        //       // You can write response back if needed
        //       // socket.write('ACK message here');
      });
    });
  }

  @override
  void onTick() {
    print('AquarisHl7 is ticking');
  }
}
