import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
/// import 'gen/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Manager'**
  String get appTitle;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Could not read the apps on this phone ({code}).'**
  String loadError(String code);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search apps'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @scopeUser.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get scopeUser;

  /// No description provided for @scopeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get scopeSystem;

  /// No description provided for @scopeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get scopeAll;

  /// No description provided for @sortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortLabel;

  /// No description provided for @sortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortName;

  /// No description provided for @sortTotalSize.
  ///
  /// In en, this message translates to:
  /// **'Largest first'**
  String get sortTotalSize;

  /// No description provided for @sortCacheSize.
  ///
  /// In en, this message translates to:
  /// **'Most cache first'**
  String get sortCacheSize;

  /// No description provided for @sortRecentlyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recently updated'**
  String get sortRecentlyUpdated;

  /// No description provided for @sortNeedsAccess.
  ///
  /// In en, this message translates to:
  /// **'Sizes need usage access'**
  String get sortNeedsAccess;

  /// No description provided for @totalsLine.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 app} other{{count} apps}} · {total} · cache {cache}'**
  String totalsLine(int count, String total, String cache);

  /// No description provided for @totalsCountOnly.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 app} other{{count} apps}}'**
  String totalsCountOnly(int count);

  /// No description provided for @noApps.
  ///
  /// In en, this message translates to:
  /// **'No apps match.'**
  String get noApps;

  /// No description provided for @usageAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'See sizes, cache and screen time'**
  String get usageAccessTitle;

  /// No description provided for @usageAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Allow Usage access. It is read on your phone only; nothing leaves it.'**
  String get usageAccessBody;

  /// No description provided for @usageAccessButton.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get usageAccessButton;

  /// No description provided for @settingsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This phone did not open the settings screen.'**
  String get settingsUnavailable;

  /// No description provided for @badgeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get badgeSystem;

  /// No description provided for @badgeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get badgeDisabled;

  /// No description provided for @versionLine.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLine(String version);

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all shown'**
  String get selectAll;

  /// No description provided for @cancelSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get cancelSelection;

  /// No description provided for @uninstallSelected.
  ///
  /// In en, this message translates to:
  /// **'Uninstall selected'**
  String get uninstallSelected;

  /// No description provided for @batchConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Uninstall {count, plural, =1{1 app} other{{count} apps}}?'**
  String batchConfirmTitle(int count);

  /// No description provided for @batchConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Android asks you to confirm each app. System apps in the selection are skipped.'**
  String get batchConfirmBody;

  /// No description provided for @batchConfirmGo.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get batchConfirmGo;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @batchReport.
  ///
  /// In en, this message translates to:
  /// **'Uninstalled {removed} of {requested}.'**
  String batchReport(int removed, int requested);

  /// No description provided for @openApp.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openApp;

  /// No description provided for @uninstall.
  ///
  /// In en, this message translates to:
  /// **'Uninstall'**
  String get uninstall;

  /// No description provided for @uninstallUpdates.
  ///
  /// In en, this message translates to:
  /// **'Remove updates'**
  String get uninstallUpdates;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App info'**
  String get appInfo;

  /// No description provided for @uninstalled.
  ///
  /// In en, this message translates to:
  /// **'{label} was uninstalled.'**
  String uninstalled(String label);

  /// No description provided for @uninstallFailed.
  ///
  /// In en, this message translates to:
  /// **'Android could not start the uninstall.'**
  String get uninstallFailed;

  /// No description provided for @appGone.
  ///
  /// In en, this message translates to:
  /// **'This app is no longer installed.'**
  String get appGone;

  /// No description provided for @systemAppNote.
  ///
  /// In en, this message translates to:
  /// **'Built into the phone. It cannot be uninstalled, but you can disable it in App info.'**
  String get systemAppNote;

  /// No description provided for @storageTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storageTitle;

  /// No description provided for @storageApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get storageApp;

  /// No description provided for @storageData.
  ///
  /// In en, this message translates to:
  /// **'User data'**
  String get storageData;

  /// No description provided for @storageCache.
  ///
  /// In en, this message translates to:
  /// **'Cache'**
  String get storageCache;

  /// No description provided for @storageTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get storageTotal;

  /// No description provided for @storageNoAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow usage access to see this app\'s size.'**
  String get storageNoAccess;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get clearCache;

  /// No description provided for @clearCacheSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear the cache in Android\'s settings'**
  String get clearCacheSheetTitle;

  /// No description provided for @clearCacheSheetBody.
  ///
  /// In en, this message translates to:
  /// **'Android lets only its own settings clear another app\'s cache. Phone Manager opens the right page for you.'**
  String get clearCacheSheetBody;

  /// No description provided for @clearCacheStep1.
  ///
  /// In en, this message translates to:
  /// **'Tap Storage & cache (or Storage).'**
  String get clearCacheStep1;

  /// No description provided for @clearCacheStep2.
  ///
  /// In en, this message translates to:
  /// **'Tap Clear cache.'**
  String get clearCacheStep2;

  /// No description provided for @clearCacheStep3.
  ///
  /// In en, this message translates to:
  /// **'Come back here: the new size shows up.'**
  String get clearCacheStep3;

  /// No description provided for @permissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissionsTitle;

  /// No description provided for @permissionsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Allowed'**
  String get permissionsAllowed;

  /// No description provided for @permissionsDenied.
  ///
  /// In en, this message translates to:
  /// **'Not allowed'**
  String get permissionsDenied;

  /// No description provided for @permissionsSpecial.
  ///
  /// In en, this message translates to:
  /// **'Special access'**
  String get permissionsSpecial;

  /// No description provided for @permissionsFixed.
  ///
  /// In en, this message translates to:
  /// **'Granted at install ({count})'**
  String permissionsFixed(int count);

  /// No description provided for @permissionsNone.
  ///
  /// In en, this message translates to:
  /// **'This app asks for no permissions.'**
  String get permissionsNone;

  /// No description provided for @permissionsFixedNote.
  ///
  /// In en, this message translates to:
  /// **'Android grants these when the app is installed. They cannot be switched off.'**
  String get permissionsFixedNote;

  /// No description provided for @permissionsError.
  ///
  /// In en, this message translates to:
  /// **'Could not read this app\'s permissions.'**
  String get permissionsError;

  /// No description provided for @changePermissions.
  ///
  /// In en, this message translates to:
  /// **'Change permissions'**
  String get changePermissions;

  /// No description provided for @permissionsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Change permissions in Android\'s settings'**
  String get permissionsSheetTitle;

  /// No description provided for @permissionsSheetBody.
  ///
  /// In en, this message translates to:
  /// **'Only Android\'s settings can allow or deny another app\'s permissions. Phone Manager opens the right page for you.'**
  String get permissionsSheetBody;

  /// No description provided for @permissionsStep1.
  ///
  /// In en, this message translates to:
  /// **'Tap Permissions.'**
  String get permissionsStep1;

  /// No description provided for @permissionsStep2.
  ///
  /// In en, this message translates to:
  /// **'Pick a permission and choose Allow or Don\'t allow.'**
  String get permissionsStep2;

  /// No description provided for @permissionsStep3.
  ///
  /// In en, this message translates to:
  /// **'Come back here: the list updates.'**
  String get permissionsStep3;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTitle;

  /// No description provided for @detailPackage.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get detailPackage;

  /// No description provided for @detailInstalled.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get detailInstalled;

  /// No description provided for @detailUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get detailUpdated;

  /// No description provided for @detailTargetSdk.
  ///
  /// In en, this message translates to:
  /// **'Target Android API'**
  String get detailTargetSdk;

  /// No description provided for @detailMinSdk.
  ///
  /// In en, this message translates to:
  /// **'Minimum Android API'**
  String get detailMinSdk;

  /// No description provided for @detailInstaller.
  ///
  /// In en, this message translates to:
  /// **'Installed from'**
  String get detailInstaller;

  /// No description provided for @detailInstallerUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown (sideloaded or preinstalled)'**
  String get detailInstallerUnknown;

  /// No description provided for @detailStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get detailStatus;

  /// No description provided for @statusEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get statusEnabled;

  /// No description provided for @statusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statusDisabled;

  /// No description provided for @privacyChoices.
  ///
  /// In en, this message translates to:
  /// **'Privacy choices'**
  String get privacyChoices;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Phone Manager by HomiLabs brings storage, battery, apps, memory, cache and app permissions together in one place, and takes you straight to the right Android setting when only Android can make the change. Everything it reads stays on your phone.'**
  String get aboutBody;

  /// No description provided for @cacheValue.
  ///
  /// In en, this message translates to:
  /// **'{size} cache'**
  String cacheValue(String size);

  /// No description provided for @readError.
  ///
  /// In en, this message translates to:
  /// **'Could not read this from the phone ({code}).'**
  String readError(String code);

  /// No description provided for @appsTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get appsTitle;

  /// No description provided for @storageTool.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storageTool;

  /// No description provided for @powerTool.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get powerTool;

  /// No description provided for @appsTool.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get appsTool;

  /// No description provided for @memoryTool.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memoryTool;

  /// No description provided for @cacheTool.
  ///
  /// In en, this message translates to:
  /// **'Cache cleaner'**
  String get cacheTool;

  /// No description provided for @permissionsTool.
  ///
  /// In en, this message translates to:
  /// **'App permissions'**
  String get permissionsTool;

  /// No description provided for @freeOf.
  ///
  /// In en, this message translates to:
  /// **'{free} free of {total}'**
  String freeOf(String free, String total);

  /// No description provided for @usedOf.
  ///
  /// In en, this message translates to:
  /// **'{used} of {total} used'**
  String usedOf(String used, String total);

  /// No description provided for @freeSpace.
  ///
  /// In en, this message translates to:
  /// **'{size} free'**
  String freeSpace(String size);

  /// No description provided for @batteryPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String batteryPercent(int percent);

  /// No description provided for @batteryCharging.
  ///
  /// In en, this message translates to:
  /// **'{percent}% · charging'**
  String batteryCharging(int percent);

  /// No description provided for @needsUsageAccess.
  ///
  /// In en, this message translates to:
  /// **'Needs usage access'**
  String get needsUsageAccess;

  /// No description provided for @cacheInApps.
  ///
  /// In en, this message translates to:
  /// **'{size} of cache in apps'**
  String cacheInApps(String size);

  /// No description provided for @appsWithLocation.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No apps use your location} =1{1 app can use your location} other{{count} apps can use your location}}'**
  String appsWithLocation(int count);

  /// No description provided for @whatUsesSpace.
  ///
  /// In en, this message translates to:
  /// **'What uses the space'**
  String get whatUsesSpace;

  /// No description provided for @storageApps.
  ///
  /// In en, this message translates to:
  /// **'Apps (incl. their data)'**
  String get storageApps;

  /// No description provided for @storageImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get storageImages;

  /// No description provided for @storageVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get storageVideos;

  /// No description provided for @storageAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get storageAudio;

  /// No description provided for @storageOtherFiles.
  ///
  /// In en, this message translates to:
  /// **'Other files'**
  String get storageOtherFiles;

  /// No description provided for @storageAppCache.
  ///
  /// In en, this message translates to:
  /// **'App cache (part of apps)'**
  String get storageAppCache;

  /// No description provided for @storageBreakdownNote.
  ///
  /// In en, this message translates to:
  /// **'Android itself and its system files take the rest.'**
  String get storageBreakdownNote;

  /// No description provided for @freeUpSpaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Free up space'**
  String get freeUpSpaceTitle;

  /// No description provided for @freeUpSpaceBody.
  ///
  /// In en, this message translates to:
  /// **'Android\'s own clean-up suggests large files, old downloads and apps you don\'t use. You choose what goes.'**
  String get freeUpSpaceBody;

  /// No description provided for @freeUpSpaceButton.
  ///
  /// In en, this message translates to:
  /// **'Open free up space'**
  String get freeUpSpaceButton;

  /// No description provided for @storageSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Open storage settings'**
  String get storageSettingsButton;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @batteryDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get batteryDetails;

  /// No description provided for @batteryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get batteryHealth;

  /// No description provided for @batteryTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get batteryTemperature;

  /// No description provided for @batteryVoltage.
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get batteryVoltage;

  /// No description provided for @batteryCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get batteryCurrent;

  /// No description provided for @batteryCycles.
  ///
  /// In en, this message translates to:
  /// **'Charge cycles'**
  String get batteryCycles;

  /// No description provided for @batteryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get batteryTechnology;

  /// No description provided for @batterySaver.
  ///
  /// In en, this message translates to:
  /// **'Battery saver'**
  String get batterySaver;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'{value} °C'**
  String celsius(String value);

  /// No description provided for @volts.
  ///
  /// In en, this message translates to:
  /// **'{value} V'**
  String volts(String value);

  /// No description provided for @milliAmps.
  ///
  /// In en, this message translates to:
  /// **'{value} mA'**
  String milliAmps(int value);

  /// No description provided for @batteryHotTip.
  ///
  /// In en, this message translates to:
  /// **'The battery is hot. Unplug fast chargers, close games and the camera, and keep the phone out of the sun until it cools down.'**
  String get batteryHotTip;

  /// No description provided for @saveBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Save battery'**
  String get saveBatteryTitle;

  /// No description provided for @saveBatteryBody.
  ///
  /// In en, this message translates to:
  /// **'Battery saver limits background work. Battery usage shows which apps used the most power since the last charge.'**
  String get saveBatteryBody;

  /// No description provided for @batterySaverButton.
  ///
  /// In en, this message translates to:
  /// **'Battery saver settings'**
  String get batterySaverButton;

  /// No description provided for @batteryUsageButton.
  ///
  /// In en, this message translates to:
  /// **'Battery usage by app'**
  String get batteryUsageButton;

  /// No description provided for @batteryOptimizationButton.
  ///
  /// In en, this message translates to:
  /// **'Battery optimisation per app'**
  String get batteryOptimizationButton;

  /// No description provided for @sourceCharger.
  ///
  /// In en, this message translates to:
  /// **'charger'**
  String get sourceCharger;

  /// No description provided for @sourceUsb.
  ///
  /// In en, this message translates to:
  /// **'USB'**
  String get sourceUsb;

  /// No description provided for @sourceWireless.
  ///
  /// In en, this message translates to:
  /// **'wireless charger'**
  String get sourceWireless;

  /// No description provided for @sourceOther.
  ///
  /// In en, this message translates to:
  /// **'dock'**
  String get sourceOther;

  /// No description provided for @statusCharging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get statusCharging;

  /// No description provided for @statusFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get statusFull;

  /// No description provided for @statusOnBattery.
  ///
  /// In en, this message translates to:
  /// **'On battery'**
  String get statusOnBattery;

  /// No description provided for @statusNotCharging.
  ///
  /// In en, this message translates to:
  /// **'Plugged in, not charging'**
  String get statusNotCharging;

  /// No description provided for @fullIn.
  ///
  /// In en, this message translates to:
  /// **'full in {hours} h {minutes} min'**
  String fullIn(int hours, int minutes);

  /// No description provided for @healthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get healthGood;

  /// No description provided for @healthOverheat.
  ///
  /// In en, this message translates to:
  /// **'Overheating'**
  String get healthOverheat;

  /// No description provided for @healthDead.
  ///
  /// In en, this message translates to:
  /// **'Worn out'**
  String get healthDead;

  /// No description provided for @healthOverVoltage.
  ///
  /// In en, this message translates to:
  /// **'Over voltage'**
  String get healthOverVoltage;

  /// No description provided for @healthCold.
  ///
  /// In en, this message translates to:
  /// **'Too cold'**
  String get healthCold;

  /// No description provided for @healthFailure.
  ///
  /// In en, this message translates to:
  /// **'Fault reported'**
  String get healthFailure;

  /// No description provided for @screenTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Most used today'**
  String get screenTimeTitle;

  /// No description provided for @screenTimeBody.
  ///
  /// In en, this message translates to:
  /// **'Screen time in the last 24 hours. Apps you use most also use the most battery.'**
  String get screenTimeBody;

  /// No description provided for @allowUsageAccessForScreenTime.
  ///
  /// In en, this message translates to:
  /// **'Allow usage access to see screen time'**
  String get allowUsageAccessForScreenTime;

  /// No description provided for @noRecentUse.
  ///
  /// In en, this message translates to:
  /// **'No app use recorded in the last 24 hours.'**
  String get noRecentUse;

  /// No description provided for @durationHm.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationHm(int hours, int minutes);

  /// No description provided for @memoryLow.
  ///
  /// In en, this message translates to:
  /// **'Memory is low: Android is closing background apps.'**
  String get memoryLow;

  /// No description provided for @memoryFree.
  ///
  /// In en, this message translates to:
  /// **'{size} available'**
  String memoryFree(String size);

  /// No description provided for @stopBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop background apps'**
  String get stopBackgroundTitle;

  /// No description provided for @stopBackgroundBody.
  ///
  /// In en, this message translates to:
  /// **'Asks Android to stop apps running in the background. Android restarts some of them when they are needed, so the gain is often small and short-lived.'**
  String get stopBackgroundBody;

  /// No description provided for @stopBackgroundUnavailable.
  ///
  /// In en, this message translates to:
  /// **'From Android 14, only Android can stop other apps. Android frees memory on its own when it runs low. To stop one app, open it from the list below and tap App info, then Force stop.'**
  String get stopBackgroundUnavailable;

  /// No description provided for @stopBackgroundButton.
  ///
  /// In en, this message translates to:
  /// **'Stop background apps'**
  String get stopBackgroundButton;

  /// No description provided for @stopReport.
  ///
  /// In en, this message translates to:
  /// **'Asked {apps} apps to stop. {size} more memory is free now.'**
  String stopReport(int apps, String size);

  /// No description provided for @stopReportNoGain.
  ///
  /// In en, this message translates to:
  /// **'Asked {apps} apps to stop. Free memory did not change much: Android was already managing it.'**
  String stopReportNoGain(int apps);

  /// No description provided for @stopFailed.
  ///
  /// In en, this message translates to:
  /// **'Android did not stop the apps.'**
  String get stopFailed;

  /// No description provided for @memoryAppsBody.
  ///
  /// In en, this message translates to:
  /// **'The apps you used most in the last 24 hours. Tap one for its details.'**
  String get memoryAppsBody;

  /// No description provided for @cacheExplainer.
  ///
  /// In en, this message translates to:
  /// **'Cache is temporary data apps keep to load faster. Clearing it frees space, but apps build it up again as you use them.'**
  String get cacheExplainer;

  /// No description provided for @ownCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Manager\'s cache'**
  String get ownCacheTitle;

  /// No description provided for @ownCacheLabel.
  ///
  /// In en, this message translates to:
  /// **'Cache now'**
  String get ownCacheLabel;

  /// No description provided for @clearNow.
  ///
  /// In en, this message translates to:
  /// **'Clear now'**
  String get clearNow;

  /// No description provided for @ownCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared {size}.'**
  String ownCacheCleared(String size);

  /// No description provided for @ownCacheFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not clear the cache.'**
  String get ownCacheFailed;

  /// No description provided for @cacheFreeUpBody.
  ///
  /// In en, this message translates to:
  /// **'Android\'s own clean-up can clear cached and unused files for many apps at once.'**
  String get cacheFreeUpBody;

  /// No description provided for @cacheByApp.
  ///
  /// In en, this message translates to:
  /// **'Cache by app (tap to clear)'**
  String get cacheByApp;

  /// No description provided for @noCache.
  ///
  /// In en, this message translates to:
  /// **'No app has cache right now.'**
  String get noCache;

  /// No description provided for @permissionsOverviewBody.
  ///
  /// In en, this message translates to:
  /// **'Which apps are allowed to use sensitive features right now. Tap a permission to see the apps, then an app to change what it may use.'**
  String get permissionsOverviewBody;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Open privacy settings'**
  String get privacySettings;

  /// No description provided for @noGrantedPermissions.
  ///
  /// In en, this message translates to:
  /// **'No installed app holds a sensitive permission.'**
  String get noGrantedPermissions;

  /// No description provided for @groupAppsBody.
  ///
  /// In en, this message translates to:
  /// **'Installed apps that are allowed this now. Tap an app to review or change its permissions.'**
  String get groupAppsBody;

  /// No description provided for @groupLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get groupLocation;

  /// No description provided for @groupCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get groupCamera;

  /// No description provided for @groupMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get groupMicrophone;

  /// No description provided for @groupContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get groupContacts;

  /// No description provided for @groupPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get groupPhone;

  /// No description provided for @groupSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get groupSms;

  /// No description provided for @groupCallLog.
  ///
  /// In en, this message translates to:
  /// **'Call logs'**
  String get groupCallLog;

  /// No description provided for @groupCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get groupCalendar;

  /// No description provided for @groupMedia.
  ///
  /// In en, this message translates to:
  /// **'Photos and media'**
  String get groupMedia;

  /// No description provided for @groupFiles.
  ///
  /// In en, this message translates to:
  /// **'Files and storage'**
  String get groupFiles;

  /// No description provided for @groupBodySensors.
  ///
  /// In en, this message translates to:
  /// **'Body sensors'**
  String get groupBodySensors;

  /// No description provided for @groupActivity.
  ///
  /// In en, this message translates to:
  /// **'Physical activity'**
  String get groupActivity;

  /// No description provided for @groupNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby devices'**
  String get groupNearby;

  /// No description provided for @groupNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get groupNotifications;

  /// No description provided for @groupOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get groupOther;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
