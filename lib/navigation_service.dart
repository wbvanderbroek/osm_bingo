import 'package:flutter/material.dart';

// Allow for easy access of the navigator key and navigation index

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final ValueNotifier<int> navigationIndexNotifier = ValueNotifier<int>(0);
