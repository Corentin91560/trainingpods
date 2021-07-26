import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsManager {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  AnalyticsManager();

  void logEvent({required String name, Map<String, dynamic>? parameters}) {
    analytics.logEvent(name: name, parameters: parameters);
  }

  void setUserProperty(String name, dynamic value) {
    analytics.setUserProperty(name: name, value: value.toString());
  }
}
