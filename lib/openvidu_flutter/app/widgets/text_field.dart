import 'package:flutter/material.dart'; 

class OVTextField extends StatelessWidget {
  final String label;
  final TextEditingController? ctrl;
  final bool enabled;
  const OVTextField({
    required this.label,
    this.ctrl,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              label,
              style:const TextStyle(
                
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.white.withOpacity(.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: ctrl,
              enabled: enabled,
              decoration: const InputDecoration.collapsed(
                hintText: '',
              ),
              keyboardType: TextInputType.url,
              autocorrect: false,
            ),
          ),
        ],
      );
}
