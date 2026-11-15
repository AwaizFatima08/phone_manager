import 'package:flutter/foundation.dart';

/// The runtime permission groups a user sees in Android's Permission manager.
enum PermissionGroup {
  location,
  camera,
  microphone,
  contacts,
  phone,
  sms,
  callLog,
  calendar,
  photosAndMedia,
  files,
  bodySensors,
  physicalActivity,
  nearbyDevices,
  notifications,
  other
  ;

  /// The group of a runtime permission name such as `android.permission.CAMERA`.
  static PermissionGroup of(String permission) => _byName[permission.split('.').last] ?? other;

  static const _byName = <String, PermissionGroup>{
    'ACCESS_FINE_LOCATION': location,
    'ACCESS_COARSE_LOCATION': location,
    'ACCESS_BACKGROUND_LOCATION': location,
    'ACCESS_MEDIA_LOCATION': location,
    'CAMERA': camera,
    'RECORD_AUDIO': microphone,
    'READ_CONTACTS': contacts,
    'WRITE_CONTACTS': contacts,
    'GET_ACCOUNTS': contacts,
    'READ_PHONE_STATE': phone,
    'READ_PHONE_NUMBERS': phone,
    'CALL_PHONE': phone,
    'ANSWER_PHONE_CALLS': phone,
    'ADD_VOICEMAIL': phone,
    'USE_SIP': phone,
    'ACCEPT_HANDOVER': phone,
    'SEND_SMS': sms,
    'RECEIVE_SMS': sms,
    'READ_SMS': sms,
    'RECEIVE_MMS': sms,
    'RECEIVE_WAP_PUSH': sms,
    'READ_CALL_LOG': callLog,
    'WRITE_CALL_LOG': callLog,
    'PROCESS_OUTGOING_CALLS': callLog,
    'READ_CALENDAR': calendar,
    'WRITE_CALENDAR': calendar,
    'READ_MEDIA_IMAGES': photosAndMedia,
    'READ_MEDIA_VIDEO': photosAndMedia,
    'READ_MEDIA_AUDIO': photosAndMedia,
    'READ_MEDIA_VISUAL_USER_SELECTED': photosAndMedia,
    'READ_EXTERNAL_STORAGE': files,
    'WRITE_EXTERNAL_STORAGE': files,
    'BODY_SENSORS': bodySensors,
    'BODY_SENSORS_BACKGROUND': bodySensors,
    'ACTIVITY_RECOGNITION': physicalActivity,
    'BLUETOOTH_SCAN': nearbyDevices,
    'BLUETOOTH_CONNECT': nearbyDevices,
    'BLUETOOTH_ADVERTISE': nearbyDevices,
    'NEARBY_WIFI_DEVICES': nearbyDevices,
    'UWB_RANGING': nearbyDevices,
    'POST_NOTIFICATIONS': notifications,
  };
}

/// Which apps currently hold each permission group, most-shared groups first.
@immutable
final class PermissionOverview {
  const PermissionOverview(this.appsByGroup);

  /// Builds the overview from package -> granted runtime permission names, keeping only the
  /// packages in [include] (e.g. installed, non-system apps).
  factory PermissionOverview.from(
    Map<String, List<String>> granted, {
    bool Function(String packageName)? include,
  }) {
    final byGroup = <PermissionGroup, Set<String>>{};
    for (final MapEntry(key: pkg, value: permissions) in granted.entries) {
      if (include != null && !include(pkg)) continue;
      for (final p in permissions) {
        (byGroup[PermissionGroup.of(p)] ??= {}).add(pkg);
      }
    }
    final sorted = byGroup.entries.toList()
      ..sort((a, b) {
        final bySize = b.value.length.compareTo(a.value.length);
        return bySize != 0 ? bySize : a.key.index.compareTo(b.key.index);
      });
    return PermissionOverview({
      for (final e in sorted) e.key: List.unmodifiable(e.value.toList()..sort()),
    });
  }

  /// In display order; each list is sorted by package name.
  final Map<PermissionGroup, List<String>> appsByGroup;

  List<String> appsWith(PermissionGroup group) => appsByGroup[group] ?? const [];

  @override
  bool operator ==(Object other) =>
      other is PermissionOverview && mapEquals(other.appsByGroup, appsByGroup);

  @override
  int get hashCode => Object.hashAllUnordered(appsByGroup.keys);
}
