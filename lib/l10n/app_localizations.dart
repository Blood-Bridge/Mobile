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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  /// **'Cancel'**
  String get text100;

  /// Used in lib\features\setting\presentation\views\widgets\user_type_switcher.dart line 104
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
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
  /// **'(Weight, DOB, etc.)'**
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

  /// No description provided for @continuewithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continuewithGoogle;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noDonationsFound.
  ///
  /// In en, this message translates to:
  /// **'No donations match the selected filters.'**
  String get noDonationsFound;

  /// No description provided for @donation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get donation;

  /// No description provided for @areYouSureYouWantToDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this donation?'**
  String get areYouSureYouWantToDelete;

  /// No description provided for @adminDonors.
  ///
  /// In en, this message translates to:
  /// **'Manage Donors'**
  String get adminDonors;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodType;

  /// No description provided for @noDonorsFound.
  ///
  /// In en, this message translates to:
  /// **'No donors found matching criteria'**
  String get noDonorsFound;

  /// No description provided for @deleteDonor.
  ///
  /// In en, this message translates to:
  /// **'Delete Donor'**
  String get deleteDonor;

  /// No description provided for @deleteDonorConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this donor?'**
  String get deleteDonorConfirmation;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @joinBloodBridgeToSaveLives.
  ///
  /// In en, this message translates to:
  /// **'Join Blood Bridge to save lives'**
  String get joinBloodBridgeToSaveLives;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @askForToken.
  ///
  /// In en, this message translates to:
  /// **'Enter the reset token sent to your email along with your new password.'**
  String get askForToken;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @createDonation.
  ///
  /// In en, this message translates to:
  /// **'Provide donation details to initiate verification and confirmation.'**
  String get createDonation;

  /// No description provided for @hospitalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Hospital ID is required'**
  String get hospitalIdRequired;

  /// No description provided for @logDonation.
  ///
  /// In en, this message translates to:
  /// **'Log Donation'**
  String get logDonation;

  /// No description provided for @donationConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Donation Confirmation'**
  String get donationConfirmation;

  /// No description provided for @donationc.
  ///
  /// In en, this message translates to:
  /// **'Confirm Donation details for Process'**
  String get donationc;

  /// No description provided for @confirmDonation.
  ///
  /// In en, this message translates to:
  /// **'Tapping the button below indicates verification of successful donor collection and recipient delivery of blood units.'**
  String get confirmDonation;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @donationId.
  ///
  /// In en, this message translates to:
  /// **'Donation ID'**
  String get donationId;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'Loading details...'**
  String get noData;

  /// No description provided for @areYouSureYouWantToDeleteThisDonationLogRecord.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this donation log record?'**
  String get areYouSureYouWantToDeleteThisDonationLogRecord;

  /// No description provided for @noDonationHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No donation history found'**
  String get noDonationHistoryFound;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @editDonation.
  ///
  /// In en, this message translates to:
  /// **'Edit Donation'**
  String get editDonation;

  /// No description provided for @confirmationStatus.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Status'**
  String get confirmationStatus;

  /// No description provided for @donationDate.
  ///
  /// In en, this message translates to:
  /// **'Donation Date'**
  String get donationDate;

  /// No description provided for @updateDonation.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get updateDonation;

  /// No description provided for @donorDashboard.
  ///
  /// In en, this message translates to:
  /// **'Ready to save lives?'**
  String get donorDashboard;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available to Donate'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable to Donate'**
  String get unavailable;

  /// No description provided for @nearbyRequests.
  ///
  /// In en, this message translates to:
  /// **'Nearby Requests'**
  String get nearbyRequests;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @noActiveRequests.
  ///
  /// In en, this message translates to:
  /// **'No Active Requests'**
  String get noActiveRequests;

  /// No description provided for @noCompletedDonations.
  ///
  /// In en, this message translates to:
  /// **'No Completed Donations'**
  String get noCompletedDonations;

  /// No description provided for @noDeliveries.
  ///
  /// In en, this message translates to:
  /// **'No active deliveries.\nAccept a request to see it here.'**
  String get noDeliveries;

  /// No description provided for @topDonors.
  ///
  /// In en, this message translates to:
  /// **'Top Donors'**
  String get topDonors;

  /// No description provided for @noTopDonors.
  ///
  /// In en, this message translates to:
  /// **'No top donors found'**
  String get noTopDonors;

  /// No description provided for @beTheFirstChampion.
  ///
  /// In en, this message translates to:
  /// **'Be the first to become a champion'**
  String get beTheFirstChampion;

  /// No description provided for @areYouSureYouWantToCancelAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel acceptance?'**
  String get areYouSureYouWantToCancelAcceptance;

  /// No description provided for @donationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Donation Completed'**
  String get donationCompleted;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @donorAccepted.
  ///
  /// In en, this message translates to:
  /// **'Donor Accepted'**
  String get donorAccepted;

  /// No description provided for @contactDonor.
  ///
  /// In en, this message translates to:
  /// **'Contact Donor'**
  String get contactDonor;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request Cancelled'**
  String get requestCancelled;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @receiverDashboard.
  ///
  /// In en, this message translates to:
  /// **'Find donors quickly'**
  String get receiverDashboard;

  /// No description provided for @emergencyRequest.
  ///
  /// In en, this message translates to:
  /// **'Emergency Request'**
  String get emergencyRequest;

  /// No description provided for @instantDonorNotification.
  ///
  /// In en, this message translates to:
  /// **'Instant Donor Notification'**
  String get instantDonorNotification;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests found'**
  String get noRequests;

  /// No description provided for @highPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get highPriority;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity (Units)'**
  String get quantity;

  /// No description provided for @submitEmergencyRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Emergency Request'**
  String get submitEmergencyRequest;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @bloodManagement.
  ///
  /// In en, this message translates to:
  /// **'Blood Management'**
  String get bloodManagement;

  /// No description provided for @cityHospital.
  ///
  /// In en, this message translates to:
  /// **'City Hospital'**
  String get cityHospital;

  /// No description provided for @createRequest.
  ///
  /// In en, this message translates to:
  /// **'Create Request'**
  String get createRequest;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting your location...'**
  String get gettingLocation;

  /// No description provided for @calculatingRoute.
  ///
  /// In en, this message translates to:
  /// **'Calculating route...'**
  String get calculatingRoute;

  /// No description provided for @tapToSeeRoute.
  ///
  /// In en, this message translates to:
  /// **'Tap a marker to see route & ETA'**
  String get tapToSeeRoute;

  /// No description provided for @arrivedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Arrived Successfully'**
  String get arrivedSuccessfully;

  /// No description provided for @donorDetails.
  ///
  /// In en, this message translates to:
  /// **'Donor Details'**
  String get donorDetails;

  /// No description provided for @compatibleDonors.
  ///
  /// In en, this message translates to:
  /// **'Compatible Donors'**
  String get compatibleDonors;

  /// No description provided for @noCompatibleDonors.
  ///
  /// In en, this message translates to:
  /// **'No compatible donors found'**
  String get noCompatibleDonors;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Try again later'**
  String get tryAgainLater;

  /// No description provided for @saveLives.
  ///
  /// In en, this message translates to:
  /// **'Save Lives'**
  String get saveLives;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Enaple Permissions'**
  String get permissions;

  /// No description provided for @permissionsDesc.
  ///
  /// In en, this message translates to:
  /// **'To ensure the best experience, we need some permissions to be granted. Please allow the permissions to continue.'**
  String get permissionsDesc;

  /// No description provided for @locationAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'To ensure the best experience, we need location access to be granted. Please allow the location access to continue.'**
  String get locationAccessDesc;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @aiRecommendation.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendation'**
  String get aiRecommendation;

  /// No description provided for @completeFirstDonation.
  ///
  /// In en, this message translates to:
  /// **'Complete your first donation to get AI recommendation'**
  String get completeFirstDonation;

  /// No description provided for @bestDonationTime.
  ///
  /// In en, this message translates to:
  /// **'Best Donation Time is'**
  String get bestDonationTime;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Tracking progress'**
  String get timeline;

  /// No description provided for @requestExpired.
  ///
  /// In en, this message translates to:
  /// **'Request Expired'**
  String get requestExpired;

  /// No description provided for @requestCancelledDescription.
  ///
  /// In en, this message translates to:
  /// **'Request has been cancelled'**
  String get requestCancelledDescription;
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
