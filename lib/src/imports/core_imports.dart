// Flutter SDK
export 'package:flutter/material.dart';
export 'package:flutter/cupertino.dart' hide RefreshCallback;
export 'package:flutter/foundation.dart';
export 'package:flutter/services.dart';
export 'package:flutter_native_splash/flutter_native_splash.dart';

export 'package:easy_localization/easy_localization.dart'
    hide TextDirection, MapExtension;

// Project Core — everything exported through shared.dart (theme, extensions,
// utils, widgets, enums) plus routing and services.
export '../app/config/app_config.dart';
export '../app/routing/app_router.dart';
export '../app/routing/global_navigator.dart';
export '../app/services/services.dart';
export '../app/shared/shared.dart';
export '../app/routing/app_router.gr.dart';
