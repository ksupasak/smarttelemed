import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:openvidu_client/openvidu_client.dart';
import 'package:provider/provider.dart';
import 'package:smart_health/station/provider/provider.dart';

import 'drop_down.dart';
import 'media_stream_view.dart';
import 'text_field.dart';

class ConfigView extends StatefulWidget {
  final LocalParticipant participant;
  final String userName;
  final VoidCallback onConnect;
  const ConfigView({
    super.key,
    required this.onConnect,
    required this.participant,
    this.userName = '',
  });

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  final TextEditingController _textUserNameController = TextEditingController();

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;
  MediaDevice? selectedAudioInput;
  MediaDevice? selectedVideoInput;

  StreamSubscription? _subscription;

  @override
  void initState() {
    _textUserNameController.text = widget.userName;
    super.initState();
    _subscription = Hardware.instance.onDeviceChange.stream
        .listen((List<MediaDevice> devices) {
      _loadDevices(devices);
    });
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    selectedAudioInput = _audioInputs?.first;
    selectedVideoInput = _videoInputs?.last;
    setState(() {
      debugPrint(selectedVideoInput.toString());
    });
  }

  void _selectAudioInput(MediaDevice? device) async {
    if (device == null) return;
    if (kIsWeb) {
      widget.participant.setAudioInput(device.deviceId);
    } else {
      await Hardware.instance.selectAudioInput(device);
    }
    selectedAudioInput = device;
    setState(() {});
  }

  void _selectVideoInput(MediaDevice? device) async {
    if (device == null) return;
    if (selectedVideoInput?.deviceId != device.deviceId) {
      widget.participant.setVideoInput(device.deviceId);
      selectedVideoInput = device;
      setState(() {
        debugPrint(device.toString());
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Widget _controlsWidget() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: OVDropDown(
              label: 'Input',
              devices: _audioInputs ?? [],
              selectDevice: selectedAudioInput,
              onChanged: _selectAudioInput,
            ),
          ),
          Container(
            child: OVDropDown(
              label: 'Video',
              devices: _videoInputs ?? [],
              selectDevice: selectedVideoInput,
              onChanged: _selectVideoInput,
            ),
          ),
        ],
      ),
    );
  }

  Widget _streamWidget() {
    return MediaStreamView(
      borderRadius: BorderRadius.circular(15),
      participant: widget.participant,
    );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff48B5AA),
                        offset: Offset(0, 2),
                        spreadRadius: 1,
                        blurRadius: 2)
                  ]),
              height: _height * 0.3,
              width: _width * 0.6,
              child: _streamWidget()),
          Container(
              color: Color.fromARGB(0, 7, 255, 139),
              //  height: _height * 0.15,
              width: _width * 0.6,
              child: _controlsWidget()),
          GestureDetector(
            onTap: widget.onConnect,
            child: Container(
              width: _width * 0.8,
              height: _height * 0.05,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 2,
                        spreadRadius: 1)
                  ],
                  color: Color(0xff31D6AA),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                  child: Text(
                'ยืนยันการวีดีโอคอล',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: _width * 0.04,
                    fontFamily: context.read<DataProvider>().fontFamily),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
