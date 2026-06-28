import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 881
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Used in lib\features\home\presentation\views\donor\widgets\requests_container.dart line 147
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Used in lib\features\hospital_dashboard\presentation\views\hospital_dashboard_screen.dart line 119 (+2 more)
  ///
  /// In en, this message translates to:
  /// **'Active Requests'**
  String get activeRequests;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 22
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// Used in lib\features\map\presentation\view\widgets\bottom_panel.dart line 204
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrived;

  /// Used in lib\features\admin_dashboard\presentation\views\backup_screen.dart line 139
  ///
  /// In en, this message translates to:
  /// **'AUTOMATIC BACKUP'**
  String get automaticBackup;

  /// Used in lib\features\hospital_dashboard\presentation\views\hospital_dashboard_screen.dart line 218
  ///
  /// In en, this message translates to:
  /// **'Available Donors'**
  String get availableDonors;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 173 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Backup Database'**
  String get backupDatabase;

  /// Used in lib\features\admin_dashboard\presentation\views\backup_screen.dart line 117
  ///
  /// In en, this message translates to:
  /// **'BACKUP OPTIONS'**
  String get backupOptions;

  /// Used in lib\features\admin_dashboard\presentation\views\backup_screen.dart line 122
  ///
  /// In en, this message translates to:
  /// **'Backup to Cloud'**
  String get backupToCloud;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 856
  ///
  /// In en, this message translates to:
  /// **'Blood Inventory'**
  String get bloodInventory;

  /// Used in lib\features\donations\presentation\views\create_donation_screen.dart line 102
  ///
  /// In en, this message translates to:
  /// **'Blood Request ID'**
  String get bloodRequestId;

  /// Used in lib\features\hospital_dashboard\presentation\views\hospital_dashboard_screen.dart line 114
  ///
  /// In en, this message translates to:
  /// **'Blood Stock Overview'**
  String get bloodStockOverview;

  /// Used in lib\features\map\presentation\view\widgets\map_screen_body.dart line 171
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 378 (+4 more)
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Used in lib\features\home\presentation\views\donor\widgets\requests_container.dart line 230
  ///
  /// In en, this message translates to:
  /// **'Cancel Acceptance'**
  String get cancelAcceptance;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_requests_screen.dart line 288 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequest;

  /// Used in lib\features\admin_dashboard\presentation\views\backup_screen.dart line 194
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// Used in lib\features\auth\presentation\views\reset_password_screen.dart line 93
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Used in lib\features\map\presentation\view\widgets\bottom_panel.dart line 134
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 878
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Used in lib\features\admin_dashboard\presentation\views\backup_screen.dart line 220
  ///
  /// In en, this message translates to:
  /// **'Create New Backup'**
  String get createNewBackup;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 830
  ///
  /// In en, this message translates to:
  /// **'Current Role'**
  String get currentRole;

  /// Used in lib\features\admin_dashboard\presentation\views\backup_screen.dart line 144
  ///
  /// In en, this message translates to:
  /// **'Daily Backup'**
  String get dailyBackup;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 191
  ///
  /// In en, this message translates to:
  /// **'DANGER ZONE'**
  String get dangerZone;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 817
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Used in lib\features\admin_dashboard\presentation\views\language_settings_screen.dart line 54
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get dateFormat;

  /// Used in lib\features\user_information\presentation\views\widgets\first_info_screen.dart line 49
  ///
  /// In en, this message translates to:
  /// **'Date of Birth *'**
  String get dateOfBirth;

  /// Used in lib\features\home\presentation\views\donor\widgets\requests_container.dart line 159
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_donations_screen.dart line 335
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 906
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_donations_screen.dart line 323
  ///
  /// In en, this message translates to:
  /// **'Delete Donation Record'**
  String get deleteDonationRecord;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 464
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanently;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_donations_screen.dart line 287
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteRecord;

  /// Used in lib\features\welcome\presentation\views\widgets\welcome_view_body.dart line 115
  ///
  /// In en, this message translates to:
  /// **'Donate Blood'**
  String get donateBlood;

  /// Used in lib\features\setting\presentation\views\widgets\notification_section.dart line 34 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Donation Reminders'**
  String get donationReminders;

  /// Used in lib\features\setting\presentation\views\widgets\user_type_switcher.dart line 52
  ///
  /// In en, this message translates to:
  /// **'Donor'**
  String get donor;

  /// Used in lib\features\auth\presentation\views\login_screen.dart line 73 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Used in lib\features\auth\presentation\views\reset_password_screen.dart line 70
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 140
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// Used in lib\features\setting\presentation\views\widgets\notification_section.dart line 19 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Emergency Alerts'**
  String get emergencyAlerts;

  /// Used in lib\features\setting\presentation\views\widgets\language_selector.dart line 39
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Used in lib\features\home\presentation\views\reciver\widgets\submit_request_sheet.dart line 284
  ///
  /// In en, this message translates to:
  /// **'Enter case details (e.g. post-operative care, accident, leukemia treatment...)'**
  String get enterCaseDetailsEGPostOperativeCareAccidentLeukemiaTreatment;

  /// Used in lib\features\user_information\presentation\views\widgets\first_info_screen.dart line 43
  ///
  /// In en, this message translates to:
  /// **'Enter national ID number'**
  String get enterNationalIdNumber;

  /// Used in lib\features\user_information\presentation\views\widgets\third_info_screen.dart line 64
  ///
  /// In en, this message translates to:
  /// **'Enter weight'**
  String get enterWeight;

  /// Used in lib\features\user_information\presentation\views\widgets\second_info_screen.dart line 40
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enterYourAddress;

  /// Used in lib\features\user_information\presentation\views\widgets\first_info_screen.dart line 34
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// Used in lib\features\user_information\presentation\views\widgets\third_info_screen.dart line 79
  ///
  /// In en, this message translates to:
  /// **'Enter your medical conditions'**
  String get enterYourMedicalConditions;

  /// Used in lib\features\on_boarding\presentaion\views\widgets\on_boarder_view_body.dart line 85
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 876
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// Used in lib\features\welcome\presentation\views\widgets\welcome_view_body.dart line 132
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// Used in lib\features\donations\presentation\views\create_donation_screen.dart line 113
  ///
  /// In en, this message translates to:
  /// **'Hospital ID'**
  String get hospitalId;

  /// Used in lib\features\admin_dashboard\presentation\views\backup_screen.dart line 130 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Local Backup'**
  String get localBackup;

  /// Used in lib\features\permissions\presntation\views\permissions_screen.dart line 95
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationAccess;

  /// Used in lib\features\setting\presentation\views\widgets\privacy_section.dart line 19 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Location Sharing'**
  String get locationSharing;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 197
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mode'**
  String get maintenanceMode;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 102
  ///
  /// In en, this message translates to:
  /// **'Manage Donations'**
  String get manageDonations;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 86
  ///
  /// In en, this message translates to:
  /// **'Manage Donors'**
  String get manageDonors;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 94
  ///
  /// In en, this message translates to:
  /// **'Manage Requests'**
  String get manageRequests;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 325
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// Used in lib\features\profile\presentation\views\profile_screen.dart line 106
  ///
  /// In en, this message translates to:
  /// **'Medical Information'**
  String get medicalInformation;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 843
  ///
  /// In en, this message translates to:
  /// **'My Donations'**
  String get myDonations;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 298
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// Used in lib\features\map\presentation\view\widgets\bottom_panel.dart line 152
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// Used in lib\features\hospital_dashboard\presentation\views\hospital_dashboard_screen.dart line 127
  ///
  /// In en, this message translates to:
  /// **'Nearby Available Donors'**
  String get nearbyAvailableDonors;

  /// Used in lib\features\auth\presentation\views\reset_password_screen.dart line 82
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_requests_screen.dart line 329 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 327
  ///
  /// In en, this message translates to:
  /// **'None, diabetes, etc.'**
  String get noneDiabetesEtc;

  /// Used in lib\features\permissions\presntation\views\permissions_screen.dart line 107
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Used in lib\features\auth\presentation\views\login_screen.dart line 84 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Used in lib\features\profile\presentation\views\profile_screen.dart line 123
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 890
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Used in lib\features\home\presentation\views\donor\donor_screen.dart line 33 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Used in lib\features\setting\presentation\views\widgets\privacy_section.dart line 26 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Profile Visibility'**
  String get profileVisibility;

  /// Used in lib\features\setting\presentation\views\widgets\user_type_switcher.dart line 62
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 239
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// Used in lib\features\welcome\presentation\views\widgets\welcome_view_body.dart line 124
  ///
  /// In en, this message translates to:
  /// **'Request Blood'**
  String get requestBlood;

  /// Used in lib\features\setting\presentation\views\widgets\notification_section.dart line 26 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Request Notifications'**
  String get requestNotifications;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 393
  ///
  /// In en, this message translates to:
  /// **'Reset Everything'**
  String get resetEverything;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 215 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Reset System'**
  String get resetSystem;

  /// Used in lib\features\auth\presentation\views\reset_password_screen.dart line 76
  ///
  /// In en, this message translates to:
  /// **'Reset Token'**
  String get resetToken;

  /// Used in lib\features\admin_dashboard\presentation\views\backup_screen.dart line 52 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Retention Period'**
  String get retentionPeriod;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_donations_screen.dart line 207 (+12 more)
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 601
  ///
  /// In en, this message translates to:
  /// **'Save Inventory'**
  String get saveInventory;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 823
  ///
  /// In en, this message translates to:
  /// **'Search Radius'**
  String get searchRadius;

  /// Used in lib\features\admin_dashboard\presentation\views\backup_screen.dart line 188
  ///
  /// In en, this message translates to:
  /// **'Select Backup Type'**
  String get selectBackupType;

  /// Used in lib\features\admin_dashboard\presentation\views\language_settings_screen.dart line 39
  ///
  /// In en, this message translates to:
  /// **'SELECT LANGUAGE'**
  String get selectLanguage;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 125 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Session Timeout'**
  String get sessionTimeout;

  /// Used in lib\features\map\presentation\view\widgets\map_screen_body.dart line 154
  ///
  /// In en, this message translates to:
  /// **'Show Route'**
  String get showRoute;

  /// Used in lib\features\auth\presentation\views\login_screen.dart line 111
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 898
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Used in lib\features\auth\presentation\views\sign_up_screen.dart line 103
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 153
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 397 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchh;

  /// Used in lib\features\setting\presentation\views\widgets\user_type_switcher.dart line 82
  ///
  /// In en, this message translates to:
  /// **'Switch to Donor'**
  String get switchToDonor;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 117 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'System Language'**
  String get systemLanguage;

  /// Used in lib\features\admin_dashboard\presentation\views\system_logs_screen.dart line 15
  ///
  /// In en, this message translates to:
  /// **'System Logs'**
  String get systemLogs;

  /// Used in lib\features\setting\presentation\views\widgets\language_selector.dart line 45
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get text072;

  /// Used in lib\features\setting\presentation\views\widgets\user_type_switcher.dart line 89
  ///
  /// In en, this message translates to:
  /// **'إلغاء'**
  String get text100;

  /// Used in lib\features\setting\presentation\views\widgets\user_type_switcher.dart line 104
  ///
  /// In en, this message translates to:
  /// **'تأكيد'**
  String get text101;

  /// Used in lib\features\user_information\presentation\views\widgets\second_info_screen.dart line 31
  ///
  /// In en, this message translates to:
  /// **'+20 123456789'**
  String get text20123456789;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 372
  ///
  /// In en, this message translates to:
  /// **'This will completely clear the system database and log files. This action CANNOT be undone.'**
  String get thisWillCompletelyClearTheSystemDatabaseAndLogFilesThisActio;

  /// Used in lib\features\admin_dashboard\presentation\views\language_settings_screen.dart line 61
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get timeFormat;

  /// Used in lib\features\hospital_dashboard\presentation\views\hospital_dashboard_screen.dart line 204
  ///
  /// In en, this message translates to:
  /// **'Total Stock'**
  String get totalStock;

  /// Used in lib\features\requests\presentation\views\detection_confirmation_screen.dart line 134
  ///
  /// In en, this message translates to:
  /// **'Urgency Level'**
  String get urgencyLevel;

  /// Used in lib\features\home\presentation\views\donor\widgets\requests_container.dart line 172
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Used in lib\features\home\presentation\views\donor\widgets\requests_container.dart line 264
  ///
  /// In en, this message translates to:
  /// **'View Status'**
  String get viewStatus;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_dashboard_screen.dart line 181
  ///
  /// In en, this message translates to:
  /// **'View System Logs'**
  String get viewSystemLogs;

  /// Used in lib\features\setting\presentation\views\widgets\user_type_switcher.dart line 84
  ///
  /// In en, this message translates to:
  /// **'سيتم تنفيذ نموذج إدخال البيانات هنا (Weight, DOB, etc.)'**
  String get weightDobEtc;

  /// Used in lib\features\setting\presentation\views\widgets\setting_view_body.dart line 310
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// Used in lib\features\admin_dashboard\presentation\views\admin_requests_screen.dart line 336 (+1 more)
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
