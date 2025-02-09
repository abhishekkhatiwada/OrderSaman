import 'package:flutter/material.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:permission_handler/permission_handler.dart';

class BeaconBroadcastApp extends StatefulWidget {
  const BeaconBroadcastApp({super.key});

  @override
  State<BeaconBroadcastApp> createState() => _BeaconBroadcastAppState();
}

class _BeaconBroadcastAppState extends State<BeaconBroadcastApp> {
  bool isBroadcasting = false;
  final BeaconBroadcast _beaconBroadcast = BeaconBroadcast();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetoothAdvertise,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationAlways,
      Permission.locationWhenInUse
    ].request();
  }

  void _startBroadcasting() {
    if (isBroadcasting) return;

    _beaconBroadcast
        .setUUID(
            'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0') // Replace with your UUID
        .setMajorId(100)
        .setMinorId(1)
        .setTransmissionPower(-59)
        .setIdentifier('TestBeacon')
        .start()
        .then((_) {
      setState(() {
        isBroadcasting = true;
        print("started broadcasting");
      });
    }).catchError((error) {
      debugPrint("Error starting beacon broadcast: $error");
    });
  }

  void _stopBroadcasting() {
    _beaconBroadcast.stop();
    setState(() {
      isBroadcasting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beacon Broadcaster")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Broadcasting: ${isBroadcasting ? "ON" : "OFF"}",
                style: const TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed:
                  isBroadcasting ? _stopBroadcasting : _startBroadcasting,
              child: Text(
                  isBroadcasting ? "Stop Broadcasting" : "Start Broadcasting"),
            ),
          ],
        ),
      ),
    );
  }
}
