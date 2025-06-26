import 'package:flutter/material.dart';
import 'package:smarttelemed/apps/telemed/views/station/home.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_appointment.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_health_entry.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_health_record.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_home.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_register.dart';
import 'package:smarttelemed/apps/telemed/views/station/session_summary.dart';
import 'package:smarttelemed/apps/telemed/views/station/session_waiting.dart';
import 'package:smarttelemed/apps/telemed/views/setting/setting.dart';
import 'package:smarttelemed/apps/telemed/views/splash_screen/splash_screen.dart';

class Stage {
  static const int SPLASH_SCREEN = 0;
  static const int HOME_SCREEN = 1; // read id card home page
  static const int PATIENT_REGISTER_SCREEN = 2; // patient register page
  static const int PATIENT_HOME_SCREEN = 3; // patient home page
  static const int PATIENT_HEALTH_RECORD_SCREEN =
      4; // patient health record page
  static const int PATIENT_HEALTH_ENTRY_SCREEN = 5; // patient health entry page
  static const int PATIENT_APPOINTMENT_SCREEN = 6;
  static const int SESSION_WAITING_SCREEN = 7;
  static const int SESSION_SUMMARY_SCREEN = 9;
  static const int SETTING_SCREEN = 10;

  Widget getPage(int index) {
    if (index == 0) {
      return const SplashScreen();
    } else if (index == Stage.HOME_SCREEN) {
      return const HomeTelemed();
    } else if (index == Stage.PATIENT_REGISTER_SCREEN) {
      return const PatientRegister();
    } else if (index == Stage.PATIENT_HOME_SCREEN) {
      return const PatientHome();
    } else if (index == Stage.PATIENT_HEALTH_RECORD_SCREEN) {
      return const PatientHealthRecord();
    } else if (index == Stage.PATIENT_HEALTH_ENTRY_SCREEN) {
      return const PatientHealthEntry();
    } else if (index == Stage.PATIENT_APPOINTMENT_SCREEN) {
      return const PatientAppointment();
    } else if (index == Stage.SESSION_WAITING_SCREEN) {
      return const SessionWaiting();
    } else if (index == Stage.SESSION_SUMMARY_SCREEN) {
      return const SessionSummary();
    } else if (index == Stage.SETTING_SCREEN) {
      return const Setting();
    }
    return const Placeholder();
  }
}
