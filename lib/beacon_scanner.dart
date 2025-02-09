import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:permission_handler/permission_handler.dart';

class BeaconScannerApp extends StatefulWidget {
  const BeaconScannerApp({super.key});

  @override
  State<BeaconScannerApp> createState() => _BeaconScannerAppState();
}

class _BeaconScannerAppState extends State<BeaconScannerApp> {
  bool isScanning = false;
  StreamSubscription<RangingResult>? _scanStream;
  List<Beacon> _beacons = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationAlways,
      Permission.locationWhenInUse
    ].request();
  }

  void _startScanning() async {
    if (isScanning) return;

    await flutterBeacon.initializeScanning;
    if (await flutterBeacon.bluetoothState != BluetoothState.stateOn) {
      debugPrint('Bluetooth is OFF');
      return;
    }

    final region = Region(
      identifier: 'TestRegion',
      proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0',
    );

    _scanStream =
        flutterBeacon.ranging([region]).listen((RangingResult result) {
      setState(() {
        _beacons = result.beacons;
        isScanning = true;
      });
    });
  }

  void _stopScanning() {
    _scanStream?.cancel();
    setState(() {
      isScanning = false;
      _beacons.clear();
    });
  }

  @override
  void dispose() {
    _scanStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beacon Scanner")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text("Scanning: ${isScanning ? "ON" : "OFF"}",
              style: const TextStyle(fontSize: 18)),
          ElevatedButton(
            onPressed: isScanning ? _stopScanning : _startScanning,
            child: Text(isScanning ? "Stop Scanning" : "Start Scanning"),
          ),
          Expanded(
            child: _beacons.isEmpty
                ? const Center(child: Text("No Beacons Found"))
                : ListView.builder(
                    itemCount: _beacons.length,
                    itemBuilder: (context, index) {
                      final beacon = _beacons[index];
                      return ListTile(
                        title: Text("UUID: ${beacon.proximityUUID}"),
                        subtitle: Text(
                            "RSSI: ${beacon.rssi} | Distance: ${beacon.accuracy.toStringAsFixed(2)}m"),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
