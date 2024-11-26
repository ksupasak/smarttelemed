import 'package:flutter/material.dart';
import 'package:smarttelemed/myapp/provider/provider.dart';

ButtonStyle stylebutter(
  Color color,
  double w,
  double h,
) {
  DataProvider provider = DataProvider();
  return ElevatedButton.styleFrom(
    fixedSize: Size(w, h),
    backgroundColor: color,
    //  disabledBackgroundColor: Colors.red,
    // disabledForegroundColor: Colors.red,
    shadowColor: Colors.grey,
    elevation: 5,
    // overlayColor: Colors.red,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}
