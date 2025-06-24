 
 
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class DeviceManager extends StatefulWidget {
  const DeviceManager({Key? key}) : super(key: key);

  @override
  _DeviceManagerState createState() => _DeviceManagerState();
}

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

class _DeviceManagerState extends State<DeviceManager> {
  var availablePorts = [];

  @override
  void initState() {
    super.initState();
    initPorts();
  }

  void initPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);

  

  }



String intArrayToString(List<int> intArray) {
  // Filter out values greater than 127
  List<int> filteredIntArray = intArray.where((value) => value <= 127).toList();

  return String.fromCharCodes(filteredIntArray);
}
 void startBP() async {
    bool connect = false;

    // while (true) {
      try {
      
        // final name = SerialPort.availablePorts.first;
        for (var name in SerialPort.availablePorts) {
          debugPrint('scan $name');
          final port = SerialPort(name);
          if (port.vendorId == 8137) {
            debugPrint("found BP");
            int status = 0;
            if (!port.openReadWrite()) {
              print(SerialPort.lastError);
            
            }

            debugPrint("open BP");

            SerialPortConfig config = port.config;
            config.baudRate = 9600;
            port.config = config;

            List<int> buffer = [];
            final reader = SerialPortReader(port);

                        debugPrint("reader BP");

            reader.stream.listen((data) {

                  debugPrint('$data');

              if (data[0] == 50) {
                status = 1;
              }

              if (status == 1) {
              
                buffer.addAll(data);

                if (true) {
                  debugPrint('Buffer: $buffer');
                 

                    String txt = intArrayToString(buffer);
                    debugPrint('$txt');


                    List<String> splitList = txt.split(";");

          
                    int sys = int.parse(splitList[3].split(":")[1].split(" ")[0]);

                    int dia = int.parse(splitList[5].split(":")[1].split(" ")[0]);



                    debugPrint('Sys: $sys, Dia:$dia');
                    // context.read<DataProvider>().spo2Healthrecord.text =
                    //     spo2.toString();
                    //  context.read<DataProvider>().pulseHealthrecord.text =
                    //     pulse.toString();
                  

                  buffer = [];

                  status = 0;
                }
              }
            });
          }
        }
      } on Exception catch (_) {
        print("throwing new error");
        // throw Exception("Error on server");
      }
    // }
  }
 void start() async {
    bool connect = false;

    // while (true) {
      try {
      
        // final name = SerialPort.availablePorts.first;
        for (var name in SerialPort.availablePorts) {
          debugPrint('scan $name');
          final port = SerialPort(name);
          if (port.vendorId == 1659) {
            debugPrint("found SPO2");
            int status = 0;
            if (!port.openReadWrite()) {
              print(SerialPort.lastError);
              exit(-1);
            }

                        debugPrint("open SPO2");

            SerialPortConfig config = port.config;
            config.baudRate = 38400;
            port.config = config;

            List<int> buffer = [];
            final reader = SerialPortReader(port);

                        debugPrint("reader SPO2");

            reader.stream.listen((data) {
              if (data[0] == 42) {
                status = 1;
              }

              if (status == 1) {
                buffer.addAll(data);

                if (buffer.length == 11) {
                  debugPrint('Buffer: $buffer');
                  if (buffer[2] == 83) {
                    int spo2 = buffer[5];
                    int pulse = buffer[6];
                    debugPrint('SpO2: $spo2, Pulse:$pulse');
                    // context.read<DataProvider>().spo2Healthrecord.text =
                    //     spo2.toString();
                    // context.read<DataProvider>().pulseHealthrecord.text =
                    //     pulse.toString();
                  }

                  buffer = [];

                  status = 0;
                }
              }
            });
          }
        }
      } on Exception catch (_) {
        print("throwing new error");
        // throw Exception("Error on server");
      }
    // }
  }


  void start2(){

final name = SerialPort.availablePorts.first;
final port = SerialPort(name);
int status = 0;
if (!port.openReadWrite()) {
  print(SerialPort.lastError);
  exit(-1);
}

SerialPortConfig config = port.config; 
config.baudRate = 38400;   
port.config = config;    

  List<int> buffer = [];
     final reader = SerialPortReader(port);
      reader.stream.listen((data) {
     
    
      
       if (data[0] == 42) {
          status = 1;
          
        }

        if(status==1){
          buffer.addAll(data);

          if(buffer.length==11){
               debugPrint('Buffer: $buffer');
          if(buffer[2]==83){
            int spo2 = buffer[5];
            int pulse = buffer[6];
            debugPrint('SpO2: $spo2, Pulse:$pulse');
          
          }
          
          buffer = [];
      


            status = 0 ;
          }
        
        }




    }); 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Serial Port example'),
        ),
        body: Scrollbar(
          child: ListView(
            children: [
              for (final address in availablePorts)
                Builder(builder: (context) {
                  final port = SerialPort(address);
                  return ExpansionTile(
                    title: Text(address),
                    children: [
                      CardListTile('Description', port.description),
                      CardListTile('Transport', port.transport.toTransport()),
                      CardListTile('USB Bus', port.busNumber?.toPadded()),
                      CardListTile('USB Device', port.deviceNumber?.toPadded()),
                      CardListTile('Vendor ID', port.vendorId?.toHex()),
                      CardListTile('Product ID', port.productId?.toHex()),
                      CardListTile('Manufacturer', port.manufacturer),
                      CardListTile('Product Name', port.productName),
                      CardListTile('Serial Number', port.serialNumber),
                      CardListTile('MAC Address', port.macAddress),
                    ],
                  );
                }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: startBP,
        ),
      
      ),
    );
  }
}

class CardListTile extends StatelessWidget {
  final String name;
  final String? value;

  CardListTile(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(value ?? 'N/A'),
        subtitle: Text(name),
      ),
    );
  }
}