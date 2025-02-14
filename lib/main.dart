import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'location_tracking', // Custom channel ID
      initialNotificationTitle: 'App Running in Background',
      initialNotificationContent: 'Tracking Location...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Set up the foreground notification
    service.setForegroundNotificationInfo(
      title: "Tracking Location",
      content: "Initializing...",
    );
  }

  Timer.periodic(Duration(seconds: 10), (timer) async {
    Position position = await _getCurrentLocation();
    print("Background Location: ${position.latitude}, ${position.longitude}");

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Tracking Location",
        content: "Lat: ${position.latitude}, Lng: ${position.longitude}",
      );
    }
  });
}

Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}

Future<Position> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied.');
    }
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Background Location Tracking")),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final service = FlutterBackgroundService();
              service.invoke('stopService');
            },
            child: Text("Stop Service"),
          ),
        ),
      ),
    );
  }
}
