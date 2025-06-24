// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get press_msg => 'You have pushed the button this many times:';

  @override
  String counter_msg(Object count) {
    return ' $count times';
  }

  @override
  String get f_name => 'firstname';

  @override
  String get confirm => 'Confirm';

  @override
  String get register => 'Register';

  @override
  String get leave => 'Leave';

  @override
  String get hn => 'HN';

  @override
  String get no_hn => 'No HN';

  @override
  String get vn => 'VN';

  @override
  String get no_vn => 'No VN';

  @override
  String get health_check => 'Health Check';

  @override
  String get enter_exam => 'Enter Medical';

  @override
  String get no_treatment_rights =>
      'No treatment rights, self-payment required';

  @override
  String get check_data => 'Check data';

  @override
  String get id_card_number => 'ID Card Number';

  @override
  String get full_name => 'Full Name';

  @override
  String get birth_date => 'Date of Birth';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get home_promptIdOrScanHN =>
      'Please insert your ID card or scan the HN to proceed.';

  @override
  String get home_CardSettingEnabled =>
      'The card enforcement settings are enabled.';

  @override
  String get regis_register => 'Register';

  @override
  String get regis_prefix => 'Prefix';

  @override
  String get regis_firstname => 'First Name';

  @override
  String get regis_lastname => 'Last Name';

  @override
  String get regis_birthday => 'Date of Birth (Year Month Day)';

  @override
  String get regis_IdCard => 'ID Card Number';

  @override
  String get regis_phone => 'Phone Number :';

  @override
  String get regis_enterphone => 'Please enter your phone number';

  @override
  String get regis_codeHN => 'HN Code';

  @override
  String get regis_enterHN => 'Please enter your HN';

  @override
  String get regis_backButton => '< Back';

  @override
  String get regis_tenDigitNumberPrompt =>
      'Please enter a complete 10-digit number.';

  @override
  String get health_send => 'Send';

  @override
  String get health_sys_too_low => 'The SYS is too low.';

  @override
  String get health_sys_too_high => 'The SYS is too high.';

  @override
  String get health_dia_too_low => 'The DIA is too low.';

  @override
  String get health_dia_too_high => 'The DIA is too high.';

  @override
  String get health_spo2_too_low => 'The Spo2 is too low.';

  @override
  String get health_spo2_too_high => 'The Spo2 is too high.';

  @override
  String get health_temp_too_low => 'The temperature is too low.';

  @override
  String get health_temp_too_high => 'The temperature is too high.';

  @override
  String get health_bmi_too_low => 'The BMI is too low.';

  @override
  String get health_bmi_too_high => 'The BMI is too high.';

  @override
  String get health_backButton => '< Back';

  @override
  String get summary_analyze => 'Analyze';

  @override
  String get summary_dispMed => 'Dispense medicine';

  @override
  String get summary_detail => 'Detail';

  @override
  String get summary_testResult => 'Result';

  @override
  String get summary_dx => 'DX :';

  @override
  String get summary_dc_note => 'Doctor Note :';

  @override
  String get summary_healthMeasurement => 'HEALTH MEASUREMENT';

  @override
  String get summary_bmi => 'BMI :';

  @override
  String get summary_weight => 'Weight :';

  @override
  String get summary_height => 'Height :';

  @override
  String get summary_printTestResults => 'Print Result';

  @override
  String get summary_backButton => '< BACK';

  @override
  String get summary_history => 'History';

  @override
  String get userinformation_OK => 'OK';

  @override
  String get userinformation_no_treatment_rights =>
      'No treatment rights, self-payment required';

  @override
  String get userinformation_check_data => 'Check data';

  @override
  String get userinformation_id_card_number => 'ID Card Number';

  @override
  String get userinformation_full_name => 'Full Name';

  @override
  String get userinformation_birth_date => 'Date of Birth';

  @override
  String get userinformation_age => 'Age';

  @override
  String get userinformation_phone_number => 'Phone Number';

  @override
  String get userinformation_hn => 'HN';

  @override
  String get userinformation_no_hn => 'No HN';

  @override
  String get userinformation_vn => 'VN';

  @override
  String get userinformation_no_vn => 'No VN';

  @override
  String get userinformation_pleaseCheckHealthFirst =>
      '(PLEASE CHECK HEALTH FIRST)';

  @override
  String get userinformation_back => 'BACK';

  @override
  String get userinformation_cancle => 'Cancle';

  @override
  String get waitting_cancle => 'Cancle';

  @override
  String get waitting_ok => 'OK';

  @override
  String get waitting_loading => 'Loading...';

  @override
  String get waitting_pleaseCheckHealthFirst => '(PLEASE CHECK HEALTH FIRST)';

  @override
  String get waitting_waitting_doctor => 'Waiting doctor.';

  @override
  String get waitting_results => 'Waiting test results.';

  @override
  String get waitting_review => 'Reviewing test results.';

  @override
  String get waitting_under_exam => 'Undergoing a re-examination.';

  @override
  String get waitting_backButton => '< BACK';

  @override
  String get patient_appointment => 'Apppointment';
}
