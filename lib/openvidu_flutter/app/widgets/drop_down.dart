import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 

class OVDropDown extends StatelessWidget {
  final String label;
  final MediaDevice? selectDevice;
  final List<MediaDevice> devices;
  final ValueChanged<MediaDevice?>? onChanged;
  const OVDropDown(
      {super.key,
      required this.label,
      this.devices = const [],
      this.selectDevice,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              
              fontSize: _width * 0.03,
              fontWeight: FontWeight.w400,
              color: Color(0xff48B5AA),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xff48B5AA), width: 2),
              ),
              child: DropdownButtonFormField<MediaDevice>(
                isExpanded: true,
                items: devices
                    .map(
                      (device) => DropdownMenuItem(
                        value: device,
                        child: ListTile(
                          leading: (selectDevice?.deviceId == device.deviceId)
                              ? const Icon(
                                  EvaIcons.checkmarkSquare,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  EvaIcons.square,
                                  color: Colors.grey,
                                ),
                          title: Text(
                            device.label,
                            style: TextStyle(
                                color: Color(0xff1B6286),
                                fontWeight: FontWeight.w500,
                                fontSize: _width * 0.02),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                value: selectDevice,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.videocam,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
