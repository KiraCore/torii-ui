import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();
NavigatorState? get navigatorState => navigatorKey.currentState;
BuildContext? get navigatorContext => navigatorKey.currentContext;

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
