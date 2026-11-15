import 'package:flutter/foundation.dart';

/// Internal storage: size, free space and, with usage access, what fills it.
@immutable
final class StorageStatus {
  const StorageStatus({required this.totalBytes, required this.freeBytes, this.breakdown});

  final int totalBytes;
  final int freeBytes;

  /// Null without usage access.
  final StorageBreakdown? breakdown;

  int get usedBytes => totalBytes > freeBytes ? totalBytes - freeBytes : 0;

  /// 0–1; 0 when the total is unknown.
  double get usedFraction => totalBytes <= 0 ? 0 : usedBytes / totalBytes;

  @override
  bool operator ==(Object other) =>
      other is StorageStatus &&
      other.totalBytes == totalBytes &&
      other.freeBytes == freeBytes &&
      other.breakdown == breakdown;

  @override
  int get hashCode => Object.hash(totalBytes, freeBytes, breakdown);
}

/// Shared storage by kind, as Android's own Storage page counts it. Apps come from the app sizes.
@immutable
final class StorageBreakdown {
  const StorageBreakdown({
    required this.imageBytes,
    required this.videoBytes,
    required this.audioBytes,
    required this.otherFileBytes,
  });

  final int imageBytes;
  final int videoBytes;
  final int audioBytes;
  final int otherFileBytes;

  @override
  bool operator ==(Object other) =>
      other is StorageBreakdown &&
      other.imageBytes == imageBytes &&
      other.videoBytes == videoBytes &&
      other.audioBytes == audioBytes &&
      other.otherFileBytes == otherFileBytes;

  @override
  int get hashCode => Object.hash(imageBytes, videoBytes, audioBytes, otherFileBytes);
}

enum ChargeStatus { charging, discharging, full, notCharging, unknown }

enum PowerSource { ac, usb, wireless, other, none }

enum BatteryHealth { good, overheat, dead, overVoltage, cold, failure, unknown }

T _parse<T extends Enum>(List<T> values, String? raw, T fallback) =>
    values.firstWhere((v) => v.name == raw, orElse: () => fallback);

/// One battery reading. Optional fields are null where the phone does not report them.
@immutable
final class BatteryStatus {
  const BatteryStatus({
    required this.percent,
    required this.status,
    required this.source,
    required this.health,
    required this.powerSaveOn,
    this.temperatureC,
    this.voltageMv,
    this.technology,
    this.currentMilliA,
    this.chargeTimeLeft,
    this.cycleCount,
  });

  factory BatteryStatus.parse({
    required int percent,
    required String? status,
    required String? source,
    required String? health,
    required bool powerSaveOn,
    int? temperatureTenthsC,
    int? voltageMv,
    String? technology,
    int? currentMicroA,
    int? chargeTimeLeftMillis,
    int? cycleCount,
  }) => BatteryStatus(
    percent: percent,
    status: _parse(ChargeStatus.values, status, ChargeStatus.unknown),
    source: _parse(PowerSource.values, source, PowerSource.none),
    health: _parse(BatteryHealth.values, health, BatteryHealth.unknown),
    powerSaveOn: powerSaveOn,
    temperatureC: temperatureTenthsC == null ? null : temperatureTenthsC / 10,
    voltageMv: voltageMv,
    technology: technology == null || technology.isEmpty ? null : technology,
    currentMilliA: currentMicroA == null ? null : normaliseCurrent(currentMicroA),
    chargeTimeLeft: chargeTimeLeftMillis == null
        ? null
        : Duration(milliseconds: chargeTimeLeftMillis),
    cycleCount: cycleCount,
  );

  /// 0–100, or -1 when unknown.
  final int percent;
  final ChargeStatus status;
  final PowerSource source;
  final BatteryHealth health;
  final bool powerSaveOn;
  final double? temperatureC;
  final int? voltageMv;
  final String? technology;

  /// Positive while charging on most phones; the sign is not reliable across makers.
  final int? currentMilliA;
  final Duration? chargeTimeLeft;
  final int? cycleCount;

  bool get isCharging => status == ChargeStatus.charging || status == ChargeStatus.full;

  bool get isHot => (temperatureC ?? 0) >= 45;

  /// Android reports µA, but some makers report mA. Values under 20 000 are taken as mA already.
  static int normaliseCurrent(int raw) => raw.abs() < 20000 ? raw : raw ~/ 1000;

  @override
  bool operator ==(Object other) =>
      other is BatteryStatus &&
      other.percent == percent &&
      other.status == status &&
      other.source == source &&
      other.health == health &&
      other.powerSaveOn == powerSaveOn &&
      other.temperatureC == temperatureC &&
      other.voltageMv == voltageMv &&
      other.technology == technology &&
      other.currentMilliA == currentMilliA &&
      other.chargeTimeLeft == chargeTimeLeft &&
      other.cycleCount == cycleCount;

  @override
  int get hashCode => Object.hash(
    percent,
    status,
    source,
    health,
    powerSaveOn,
    temperatureC,
    voltageMv,
    technology,
    currentMilliA,
    chargeTimeLeft,
    cycleCount,
  );
}

/// RAM as Android reports it.
@immutable
final class MemoryStatus {
  const MemoryStatus({
    required this.totalBytes,
    required this.availableBytes,
    required this.thresholdBytes,
    required this.isLow,
  });

  final int totalBytes;
  final int availableBytes;

  /// Below this much free memory Android starts closing background apps.
  final int thresholdBytes;
  final bool isLow;

  int get usedBytes => totalBytes > availableBytes ? totalBytes - availableBytes : 0;

  double get usedFraction => totalBytes <= 0 ? 0 : usedBytes / totalBytes;

  @override
  bool operator ==(Object other) =>
      other is MemoryStatus &&
      other.totalBytes == totalBytes &&
      other.availableBytes == availableBytes &&
      other.thresholdBytes == thresholdBytes &&
      other.isLow == isLow;

  @override
  int get hashCode => Object.hash(totalBytes, availableBytes, thresholdBytes, isLow);
}

/// What "Stop background apps" did: how many apps Android was asked to stop, and the measured
/// gain in free memory (often small: Android restarts some apps straight away).
typedef StopReport = ({int apps, int freedBytes});

/// One app's use in the last 24 hours.
@immutable
final class AppUsage {
  const AppUsage({required this.packageName, required this.lastUsed, required this.foreground});

  final String packageName;
  final DateTime lastUsed;
  final Duration foreground;

  @override
  bool operator ==(Object other) =>
      other is AppUsage &&
      other.packageName == packageName &&
      other.lastUsed == lastUsed &&
      other.foreground == foreground;

  @override
  int get hashCode => Object.hash(packageName, lastUsed, foreground);
}

/// System pages the app can open. Names match the native side.
enum SystemScreen { batterySaver, batteryUsage, batteryOptimization, storage, freeUpSpace, privacy }
