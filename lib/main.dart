import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phonemanager/ads/ad_service.dart';
import 'package:phonemanager/ads/google_ad_service.dart';
import 'package:phonemanager/app.dart';
import 'package:phonemanager/core/clock.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) debugPrint('Unhandled Flutter error: ${details.exception}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Unhandled error: $error\n$stack');
    return true;
  };
  final ads = GoogleAdService(const SystemClock());
  runApp(
    ProviderScope(
      // A failed read is shown with a "Try again" button; no silent automatic retries.
      retry: (_, _) => null,
      overrides: [adServiceProvider.overrideWithValue(ads)],
      child: const PhoneManagerApp(),
    ),
  );
  unawaited(ads.start());
}
