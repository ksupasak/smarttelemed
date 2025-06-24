import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// press message
  ///
  /// In en, this message translates to:
  /// **'You have pushed the button this many times:'**
  String get press_msg;

  /// No description provided for @counter_msg.
  ///
  /// In en, this message translates to:
  /// **' {count} times'**
  String counter_msg(Object count);

  /// No description provided for @f_name.
  ///
  /// In en, this message translates to:
  /// **'firstname'**
  String get f_name;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @hn.
  ///
  /// In en, this message translates to:
  /// **'HN'**
  String get hn;

  /// No description provided for @no_hn.
  ///
  /// In en, this message translates to:
  /// **'No HN'**
  String get no_hn;

  /// No description provided for @vn.
  ///
  /// In en, this message translates to:
  /// **'VN'**
  String get vn;

  /// No description provided for @no_vn.
  ///
  /// In en, this message translates to:
  /// **'No VN'**
  String get no_vn;

  /// No description provided for @health_check.
  ///
  /// In en, this message translates to:
  /// **'Health Check'**
  String get health_check;

  /// No description provided for @enter_exam.
  ///
  /// In en, this message translates to:
  /// **'Enter Medical'**
  String get enter_exam;

  /// No description provided for @no_treatment_rights.
  ///
  /// In en, this message translates to:
  /// **'No treatment rights, self-payment required'**
  String get no_treatment_rights;

  /// No description provided for @check_data.
  ///
  /// In en, this message translates to:
  /// **'Check data'**
  String get check_data;

  /// No description provided for @id_card_number.
  ///
  /// In en, this message translates to:
  /// **'ID Card Number'**
  String get id_card_number;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @birth_date.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get birth_date;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @home_promptIdOrScanHN.
  ///
  /// In en, this message translates to:
  /// **'Please insert your ID card or scan the HN to proceed.'**
  String get home_promptIdOrScanHN;

  /// No description provided for @home_CardSettingEnabled.
  ///
  /// In en, this message translates to:
  /// **'The card enforcement settings are enabled.'**
  String get home_CardSettingEnabled;

  /// No description provided for @regis_register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get regis_register;

  /// No description provided for @regis_prefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get regis_prefix;

  /// No description provided for @regis_firstname.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get regis_firstname;

  /// No description provided for @regis_lastname.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get regis_lastname;

  /// No description provided for @regis_birthday.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth (Year Month Day)'**
  String get regis_birthday;

  /// No description provided for @regis_IdCard.
  ///
  /// In en, this message translates to:
  /// **'ID Card Number'**
  String get regis_IdCard;

  /// No description provided for @regis_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number :'**
  String get regis_phone;

  /// No description provided for @regis_enterphone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get regis_enterphone;

  /// No description provided for @regis_codeHN.
  ///
  /// In en, this message translates to:
  /// **'HN Code'**
  String get regis_codeHN;

  /// No description provided for @regis_enterHN.
  ///
  /// In en, this message translates to:
  /// **'Please enter your HN'**
  String get regis_enterHN;

  /// No description provided for @regis_backButton.
  ///
  /// In en, this message translates to:
  /// **'< Back'**
  String get regis_backButton;

  /// No description provided for @regis_tenDigitNumberPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enter a complete 10-digit number.'**
  String get regis_tenDigitNumberPrompt;

  /// No description provided for @health_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get health_send;

  /// No description provided for @health_sys_too_low.
  ///
  /// In en, this message translates to:
  /// **'The SYS is too low.'**
  String get health_sys_too_low;

  /// No description provided for @health_sys_too_high.
  ///
  /// In en, this message translates to:
  /// **'The SYS is too high.'**
  String get health_sys_too_high;

  /// No description provided for @health_dia_too_low.
  ///
  /// In en, this message translates to:
  /// **'The DIA is too low.'**
  String get health_dia_too_low;

  /// No description provided for @health_dia_too_high.
  ///
  /// In en, this message translates to:
  /// **'The DIA is too high.'**
  String get health_dia_too_high;

  /// No description provided for @health_spo2_too_low.
  ///
  /// In en, this message translates to:
  /// **'The Spo2 is too low.'**
  String get health_spo2_too_low;

  /// No description provided for @health_spo2_too_high.
  ///
  /// In en, this message translates to:
  /// **'The Spo2 is too high.'**
  String get health_spo2_too_high;

  /// No description provided for @health_temp_too_low.
  ///
  /// In en, this message translates to:
  /// **'The temperature is too low.'**
  String get health_temp_too_low;

  /// No description provided for @health_temp_too_high.
  ///
  /// In en, this message translates to:
  /// **'The temperature is too high.'**
  String get health_temp_too_high;

  /// No description provided for @health_bmi_too_low.
  ///
  /// In en, this message translates to:
  /// **'The BMI is too low.'**
  String get health_bmi_too_low;

  /// No description provided for @health_bmi_too_high.
  ///
  /// In en, this message translates to:
  /// **'The BMI is too high.'**
  String get health_bmi_too_high;

  /// No description provided for @health_backButton.
  ///
  /// In en, this message translates to:
  /// **'< Back'**
  String get health_backButton;

  /// No description provided for @summary_analyze.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get summary_analyze;

  /// No description provided for @summary_dispMed.
  ///
  /// In en, this message translates to:
  /// **'Dispense medicine'**
  String get summary_dispMed;

  /// No description provided for @summary_detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get summary_detail;

  /// No description provided for @summary_testResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get summary_testResult;

  /// No description provided for @summary_dx.
  ///
  /// In en, this message translates to:
  /// **'DX :'**
  String get summary_dx;

  /// No description provided for @summary_dc_note.
  ///
  /// In en, this message translates to:
  /// **'Doctor Note :'**
  String get summary_dc_note;

  /// No description provided for @summary_healthMeasurement.
  ///
  /// In en, this message translates to:
  /// **'HEALTH MEASUREMENT'**
  String get summary_healthMeasurement;

  /// No description provided for @summary_bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI :'**
  String get summary_bmi;

  /// No description provided for @summary_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight :'**
  String get summary_weight;

  /// No description provided for @summary_height.
  ///
  /// In en, this message translates to:
  /// **'Height :'**
  String get summary_height;

  /// No description provided for @summary_printTestResults.
  ///
  /// In en, this message translates to:
  /// **'Print Result'**
  String get summary_printTestResults;

  /// No description provided for @summary_backButton.
  ///
  /// In en, this message translates to:
  /// **'< BACK'**
  String get summary_backButton;

  /// No description provided for @summary_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get summary_history;

  /// No description provided for @userinformation_OK.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get userinformation_OK;

  /// No description provided for @userinformation_no_treatment_rights.
  ///
  /// In en, this message translates to:
  /// **'No treatment rights, self-payment required'**
  String get userinformation_no_treatment_rights;

  /// No description provided for @userinformation_check_data.
  ///
  /// In en, this message translates to:
  /// **'Check data'**
  String get userinformation_check_data;

  /// No description provided for @userinformation_id_card_number.
  ///
  /// In en, this message translates to:
  /// **'ID Card Number'**
  String get userinformation_id_card_number;

  /// No description provided for @userinformation_full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get userinformation_full_name;

  /// No description provided for @userinformation_birth_date.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get userinformation_birth_date;

  /// No description provided for @userinformation_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get userinformation_age;

  /// No description provided for @userinformation_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get userinformation_phone_number;

  /// No description provided for @userinformation_hn.
  ///
  /// In en, this message translates to:
  /// **'HN'**
  String get userinformation_hn;

  /// No description provided for @userinformation_no_hn.
  ///
  /// In en, this message translates to:
  /// **'No HN'**
  String get userinformation_no_hn;

  /// No description provided for @userinformation_vn.
  ///
  /// In en, this message translates to:
  /// **'VN'**
  String get userinformation_vn;

  /// No description provided for @userinformation_no_vn.
  ///
  /// In en, this message translates to:
  /// **'No VN'**
  String get userinformation_no_vn;

  /// No description provided for @userinformation_pleaseCheckHealthFirst.
  ///
  /// In en, this message translates to:
  /// **'(PLEASE CHECK HEALTH FIRST)'**
  String get userinformation_pleaseCheckHealthFirst;

  /// No description provided for @userinformation_back.
  ///
  /// In en, this message translates to:
  /// **'BACK'**
  String get userinformation_back;

  /// No description provided for @userinformation_cancle.
  ///
  /// In en, this message translates to:
  /// **'Cancle'**
  String get userinformation_cancle;

  /// No description provided for @waitting_cancle.
  ///
  /// In en, this message translates to:
  /// **'Cancle'**
  String get waitting_cancle;

  /// No description provided for @waitting_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get waitting_ok;

  /// No description provided for @waitting_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get waitting_loading;

  /// No description provided for @waitting_pleaseCheckHealthFirst.
  ///
  /// In en, this message translates to:
  /// **'(PLEASE CHECK HEALTH FIRST)'**
  String get waitting_pleaseCheckHealthFirst;

  /// No description provided for @waitting_waitting_doctor.
  ///
  /// In en, this message translates to:
  /// **'Waiting doctor.'**
  String get waitting_waitting_doctor;

  /// No description provided for @waitting_results.
  ///
  /// In en, this message translates to:
  /// **'Waiting test results.'**
  String get waitting_results;

  /// No description provided for @waitting_review.
  ///
  /// In en, this message translates to:
  /// **'Reviewing test results.'**
  String get waitting_review;

  /// No description provided for @waitting_under_exam.
  ///
  /// In en, this message translates to:
  /// **'Undergoing a re-examination.'**
  String get waitting_under_exam;

  /// No description provided for @waitting_backButton.
  ///
  /// In en, this message translates to:
  /// **'< BACK'**
  String get waitting_backButton;

  /// No description provided for @patient_appointment.
  ///
  /// In en, this message translates to:
  /// **'Apppointment'**
  String get patient_appointment;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
