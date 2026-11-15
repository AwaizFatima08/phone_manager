// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Phone Manager';

  @override
  String loadError(String code) {
    return 'Could not read the apps on this phone ($code).';
  }

  @override
  String get retry => 'Try again';

  @override
  String get searchHint => 'Search apps';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get scopeUser => 'Installed';

  @override
  String get scopeSystem => 'System';

  @override
  String get scopeAll => 'All';

  @override
  String get sortLabel => 'Sort';

  @override
  String get sortName => 'Name';

  @override
  String get sortTotalSize => 'Largest first';

  @override
  String get sortCacheSize => 'Most cache first';

  @override
  String get sortRecentlyUpdated => 'Recently updated';

  @override
  String get sortNeedsAccess => 'Sizes need usage access';

  @override
  String totalsLine(int count, String total, String cache) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps',
      one: '1 app',
    );
    return '$_temp0 · $total · cache $cache';
  }

  @override
  String totalsCountOnly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps',
      one: '1 app',
    );
    return '$_temp0';
  }

  @override
  String get noApps => 'No apps match.';

  @override
  String get usageAccessTitle => 'See sizes, cache and screen time';

  @override
  String get usageAccessBody =>
      'Allow Usage access. It is read on your phone only; nothing leaves it.';

  @override
  String get usageAccessButton => 'Allow';

  @override
  String get settingsUnavailable => 'This phone did not open the settings screen.';

  @override
  String get badgeSystem => 'System';

  @override
  String get badgeDisabled => 'Disabled';

  @override
  String versionLine(String version) {
    return 'Version $version';
  }

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get selectAll => 'Select all shown';

  @override
  String get cancelSelection => 'Cancel selection';

  @override
  String get uninstallSelected => 'Uninstall selected';

  @override
  String batchConfirmTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps',
      one: '1 app',
    );
    return 'Uninstall $_temp0?';
  }

  @override
  String get batchConfirmBody =>
      'Android asks you to confirm each app. System apps in the selection are skipped.';

  @override
  String get batchConfirmGo => 'Start';

  @override
  String get cancel => 'Cancel';

  @override
  String batchReport(int removed, int requested) {
    return 'Uninstalled $removed of $requested.';
  }

  @override
  String get openApp => 'Open';

  @override
  String get uninstall => 'Uninstall';

  @override
  String get uninstallUpdates => 'Remove updates';

  @override
  String get appInfo => 'App info';

  @override
  String uninstalled(String label) {
    return '$label was uninstalled.';
  }

  @override
  String get uninstallFailed => 'Android could not start the uninstall.';

  @override
  String get appGone => 'This app is no longer installed.';

  @override
  String get systemAppNote =>
      'Built into the phone. It cannot be uninstalled, but you can disable it in App info.';

  @override
  String get storageTitle => 'Storage';

  @override
  String get storageApp => 'App';

  @override
  String get storageData => 'User data';

  @override
  String get storageCache => 'Cache';

  @override
  String get storageTotal => 'Total';

  @override
  String get storageNoAccess => 'Allow usage access to see this app\'s size.';

  @override
  String get clearCache => 'Clear cache';

  @override
  String get clearCacheSheetTitle => 'Clear the cache in Android\'s settings';

  @override
  String get clearCacheSheetBody =>
      'Android lets only its own settings clear another app\'s cache. Phone Manager opens the right page for you.';

  @override
  String get clearCacheStep1 => 'Tap Storage & cache (or Storage).';

  @override
  String get clearCacheStep2 => 'Tap Clear cache.';

  @override
  String get clearCacheStep3 => 'Come back here: the new size shows up.';

  @override
  String get permissionsTitle => 'Permissions';

  @override
  String get permissionsAllowed => 'Allowed';

  @override
  String get permissionsDenied => 'Not allowed';

  @override
  String get permissionsSpecial => 'Special access';

  @override
  String permissionsFixed(int count) {
    return 'Granted at install ($count)';
  }

  @override
  String get permissionsNone => 'This app asks for no permissions.';

  @override
  String get permissionsFixedNote =>
      'Android grants these when the app is installed. They cannot be switched off.';

  @override
  String get permissionsError => 'Could not read this app\'s permissions.';

  @override
  String get changePermissions => 'Change permissions';

  @override
  String get permissionsSheetTitle => 'Change permissions in Android\'s settings';

  @override
  String get permissionsSheetBody =>
      'Only Android\'s settings can allow or deny another app\'s permissions. Phone Manager opens the right page for you.';

  @override
  String get permissionsStep1 => 'Tap Permissions.';

  @override
  String get permissionsStep2 => 'Pick a permission and choose Allow or Don\'t allow.';

  @override
  String get permissionsStep3 => 'Come back here: the list updates.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get detailsTitle => 'Details';

  @override
  String get detailPackage => 'Package';

  @override
  String get detailInstalled => 'Installed';

  @override
  String get detailUpdated => 'Updated';

  @override
  String get detailTargetSdk => 'Target Android API';

  @override
  String get detailMinSdk => 'Minimum Android API';

  @override
  String get detailInstaller => 'Installed from';

  @override
  String get detailInstallerUnknown => 'Unknown (sideloaded or preinstalled)';

  @override
  String get detailStatus => 'Status';

  @override
  String get statusEnabled => 'Enabled';

  @override
  String get statusDisabled => 'Disabled';

  @override
  String get privacyChoices => 'Privacy choices';

  @override
  String get about => 'About';

  @override
  String get aboutBody =>
      'Phone Manager by HomiLabs brings storage, battery, apps, memory, cache and app permissions together in one place, and takes you straight to the right Android setting when only Android can make the change. Everything it reads stays on your phone.';

  @override
  String cacheValue(String size) {
    return '$size cache';
  }

  @override
  String readError(String code) {
    return 'Could not read this from the phone ($code).';
  }

  @override
  String get appsTitle => 'Apps';

  @override
  String get storageTool => 'Storage';

  @override
  String get powerTool => 'Battery';

  @override
  String get appsTool => 'Apps';

  @override
  String get memoryTool => 'Memory';

  @override
  String get cacheTool => 'Cache cleaner';

  @override
  String get permissionsTool => 'App permissions';

  @override
  String freeOf(String free, String total) {
    return '$free free of $total';
  }

  @override
  String usedOf(String used, String total) {
    return '$used of $total used';
  }

  @override
  String freeSpace(String size) {
    return '$size free';
  }

  @override
  String batteryPercent(int percent) {
    return '$percent%';
  }

  @override
  String batteryCharging(int percent) {
    return '$percent% · charging';
  }

  @override
  String get needsUsageAccess => 'Needs usage access';

  @override
  String cacheInApps(String size) {
    return '$size of cache in apps';
  }

  @override
  String appsWithLocation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apps can use your location',
      one: '1 app can use your location',
      zero: 'No apps use your location',
    );
    return '$_temp0';
  }

  @override
  String get whatUsesSpace => 'What uses the space';

  @override
  String get storageApps => 'Apps (incl. their data)';

  @override
  String get storageImages => 'Images';

  @override
  String get storageVideos => 'Videos';

  @override
  String get storageAudio => 'Audio';

  @override
  String get storageOtherFiles => 'Other files';

  @override
  String get storageAppCache => 'App cache (part of apps)';

  @override
  String get storageBreakdownNote => 'Android itself and its system files take the rest.';

  @override
  String get freeUpSpaceTitle => 'Free up space';

  @override
  String get freeUpSpaceBody =>
      'Android\'s own clean-up suggests large files, old downloads and apps you don\'t use. You choose what goes.';

  @override
  String get freeUpSpaceButton => 'Open free up space';

  @override
  String get storageSettingsButton => 'Open storage settings';

  @override
  String get unknown => 'Unknown';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get batteryDetails => 'Details';

  @override
  String get batteryHealth => 'Health';

  @override
  String get batteryTemperature => 'Temperature';

  @override
  String get batteryVoltage => 'Voltage';

  @override
  String get batteryCurrent => 'Current';

  @override
  String get batteryCycles => 'Charge cycles';

  @override
  String get batteryTechnology => 'Type';

  @override
  String get batterySaver => 'Battery saver';

  @override
  String celsius(String value) {
    return '$value °C';
  }

  @override
  String volts(String value) {
    return '$value V';
  }

  @override
  String milliAmps(int value) {
    return '$value mA';
  }

  @override
  String get batteryHotTip =>
      'The battery is hot. Unplug fast chargers, close games and the camera, and keep the phone out of the sun until it cools down.';

  @override
  String get saveBatteryTitle => 'Save battery';

  @override
  String get saveBatteryBody =>
      'Battery saver limits background work. Battery usage shows which apps used the most power since the last charge.';

  @override
  String get batterySaverButton => 'Battery saver settings';

  @override
  String get batteryUsageButton => 'Battery usage by app';

  @override
  String get batteryOptimizationButton => 'Battery optimisation per app';

  @override
  String get sourceCharger => 'charger';

  @override
  String get sourceUsb => 'USB';

  @override
  String get sourceWireless => 'wireless charger';

  @override
  String get sourceOther => 'dock';

  @override
  String get statusCharging => 'Charging';

  @override
  String get statusFull => 'Full';

  @override
  String get statusOnBattery => 'On battery';

  @override
  String get statusNotCharging => 'Plugged in, not charging';

  @override
  String fullIn(int hours, int minutes) {
    return 'full in $hours h $minutes min';
  }

  @override
  String get healthGood => 'Good';

  @override
  String get healthOverheat => 'Overheating';

  @override
  String get healthDead => 'Worn out';

  @override
  String get healthOverVoltage => 'Over voltage';

  @override
  String get healthCold => 'Too cold';

  @override
  String get healthFailure => 'Fault reported';

  @override
  String get screenTimeTitle => 'Most used today';

  @override
  String get screenTimeBody =>
      'Screen time in the last 24 hours. Apps you use most also use the most battery.';

  @override
  String get allowUsageAccessForScreenTime => 'Allow usage access to see screen time';

  @override
  String get noRecentUse => 'No app use recorded in the last 24 hours.';

  @override
  String durationHm(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get memoryLow => 'Memory is low: Android is closing background apps.';

  @override
  String memoryFree(String size) {
    return '$size available';
  }

  @override
  String get stopBackgroundTitle => 'Stop background apps';

  @override
  String get stopBackgroundBody =>
      'Asks Android to stop apps running in the background. Android restarts some of them when they are needed, so the gain is often small and short-lived.';

  @override
  String get stopBackgroundUnavailable =>
      'From Android 14, only Android can stop other apps. Android frees memory on its own when it runs low. To stop one app, open it from the list below and tap App info, then Force stop.';

  @override
  String get stopBackgroundButton => 'Stop background apps';

  @override
  String stopReport(int apps, String size) {
    return 'Asked $apps apps to stop. $size more memory is free now.';
  }

  @override
  String stopReportNoGain(int apps) {
    return 'Asked $apps apps to stop. Free memory did not change much: Android was already managing it.';
  }

  @override
  String get stopFailed => 'Android did not stop the apps.';

  @override
  String get memoryAppsBody =>
      'The apps you used most in the last 24 hours. Tap one for its details.';

  @override
  String get cacheExplainer =>
      'Cache is temporary data apps keep to load faster. Clearing it frees space, but apps build it up again as you use them.';

  @override
  String get ownCacheTitle => 'Phone Manager\'s cache';

  @override
  String get ownCacheLabel => 'Cache now';

  @override
  String get clearNow => 'Clear now';

  @override
  String ownCacheCleared(String size) {
    return 'Cleared $size.';
  }

  @override
  String get ownCacheFailed => 'Could not clear the cache.';

  @override
  String get cacheFreeUpBody =>
      'Android\'s own clean-up can clear cached and unused files for many apps at once.';

  @override
  String get cacheByApp => 'Cache by app (tap to clear)';

  @override
  String get noCache => 'No app has cache right now.';

  @override
  String get permissionsOverviewBody =>
      'Which apps are allowed to use sensitive features right now. Tap a permission to see the apps, then an app to change what it may use.';

  @override
  String get privacySettings => 'Open privacy settings';

  @override
  String get noGrantedPermissions => 'No installed app holds a sensitive permission.';

  @override
  String get groupAppsBody =>
      'Installed apps that are allowed this now. Tap an app to review or change its permissions.';

  @override
  String get groupLocation => 'Location';

  @override
  String get groupCamera => 'Camera';

  @override
  String get groupMicrophone => 'Microphone';

  @override
  String get groupContacts => 'Contacts';

  @override
  String get groupPhone => 'Phone';

  @override
  String get groupSms => 'SMS';

  @override
  String get groupCallLog => 'Call logs';

  @override
  String get groupCalendar => 'Calendar';

  @override
  String get groupMedia => 'Photos and media';

  @override
  String get groupFiles => 'Files and storage';

  @override
  String get groupBodySensors => 'Body sensors';

  @override
  String get groupActivity => 'Physical activity';

  @override
  String get groupNearby => 'Nearby devices';

  @override
  String get groupNotifications => 'Notifications';

  @override
  String get groupOther => 'Other';
}
