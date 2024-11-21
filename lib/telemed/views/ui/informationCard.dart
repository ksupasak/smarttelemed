import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';

class InformationCard extends StatefulWidget {
  const InformationCard({
    super.key,
  });

  @override
  State<InformationCard> createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  @override
  Widget build(BuildContext context) {
    DataProvider provider = context.read<DataProvider>();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: MediaQuery.of(context).size.height * 0.1,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 2,
                      color: Color.fromARGB(255, 188, 188, 188),
                      offset: Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: provider.imgae == ''
                      ? Container(
                          color: const Color.fromARGB(255, 240, 240, 240),
                          child: Image.asset('assets/user (1).png'))
                      : Image.network(
                          "", // '${widget.dataidcard['personal']['picture_url']}',
                          fit: BoxFit.fill,
                        ))),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.fname + "  " + provider.lname,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    color: const Color(0xff48B5AA),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Text(
                  provider.id,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: const Color(0xff1B6286),
                  ),
                ),
                Text(
                  provider.hn,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: const Color(0xff1B6286),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
