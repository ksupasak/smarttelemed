import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';
import 'package:smarttelemed/apps/telemed/views/station/stage.dart';
import 'package:smarttelemed/apps/telemed/views/station/home.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_home.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_register.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_health_record.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_health_entry.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_appointment.dart';
import 'package:smarttelemed/apps/telemed/views/station/session_waiting.dart';
import 'package:smarttelemed/apps/telemed/views/station/session_summary.dart';
import 'package:smarttelemed/apps/telemed/views/setting/setting.dart';

/// Navigation helper class that provides convenient methods for navigating
/// using the new setPageWithNavigation pattern
class NavigationHelper {
  /// Navigate to home screen
  static void navigateToHome(BuildContext context) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      Stage.HOME_SCREEN,
      const HomeTelemed(),
    );
  }

  /// Navigate to patient home screen
  static void navigateToPatientHome(BuildContext context) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      Stage.PATIENT_HOME_SCREEN,
      const PatientHome(),
    );
  }

  /// Navigate to patient register screen
  static void navigateToPatientRegister(BuildContext context) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      Stage.PATIENT_REGISTER_SCREEN,
      const PatientRegister(),
    );
  }

  /// Navigate to patient health record screen
  static void navigateToPatientHealthRecord(BuildContext context) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      Stage.PATIENT_HEALTH_RECORD_SCREEN,
      const PatientHealthRecord(),
    );
  }

  /// Navigate to patient health entry screen
  static void navigateToPatientHealthEntry(BuildContext context) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      Stage.PATIENT_HEALTH_ENTRY_SCREEN,
      const PatientHealthEntry(),
    );
  }

  /// Navigate to patient appointment screen
  static void navigateToPatientAppointment(BuildContext context) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      Stage.PATIENT_APPOINTMENT_SCREEN,
      const PatientAppointment(),
    );
  }

  /// Navigate to session waiting screen
  static void navigateToSessionWaiting(BuildContext context) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      Stage.SESSION_WAITING_SCREEN,
      const SessionWaiting(),
    );
  }

  /// Navigate to session summary screen
  static void navigateToSessionSummary(BuildContext context) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      Stage.SESSION_SUMMARY_SCREEN,
      const SessionSummary(),
    );
  }

  /// Navigate to settings screen
  static void navigateToSettings(BuildContext context) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      Stage.SETTING_SCREEN,
      const Setting(),
    );
  }

  /// Generic navigation method for any screen
  static void navigateTo(BuildContext context, int stage, Widget destination) {
    context.read<DataProvider>().setPageWithNavigation(
      context,
      stage,
      destination,
    );
  }

  /// Navigate with delay (useful for showing loading states)
  static void navigateToWithDelay(
    BuildContext context,
    int stage,
    Widget destination,
    Duration delay,
  ) {
    Future.delayed(delay, () {
      if (context.mounted) {
        context.read<DataProvider>().setPageWithNavigation(
          context,
          stage,
          destination,
        );
      }
    });
  }

  /// Navigate with custom transition
  static void navigateToWithTransition(
    BuildContext context,
    int stage,
    Widget destination,
    PageRouteBuilder routeBuilder,
  ) {
    final provider = context.read<DataProvider>();
    provider.currentIndex = stage;
    provider.notifyListeners();

    Navigator.pushReplacement(context, routeBuilder);
  }

  /// Example of custom transition
  static PageRouteBuilder slideTransition(Widget destination) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

/// Usage examples:
/// 
/// // Simple navigation
/// NavigationHelper.navigateToPatientHome(context);
/// 
/// // Navigation with delay
/// NavigationHelper.navigateToWithDelay(
///   context, 
///   Stage.PATIENT_HOME_SCREEN, 
///   const PatientHome(), 
///   const Duration(seconds: 2)
/// );
/// 
/// // Navigation with custom transition
/// NavigationHelper.navigateToWithTransition(
///   context,
///   Stage.PATIENT_HOME_SCREEN,
///   const PatientHome(),
///   NavigationHelper.slideTransition(const PatientHome()),
/// );
/// 
/// // Direct provider usage
/// context.read<DataProvider>().setPageWithNavigation(
///   context,
///   Stage.PATIENT_HOME_SCREEN,
///   const PatientHome(),
/// ); 