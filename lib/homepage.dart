import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  // MaterialPageRoute(
                  //     builder: (context) => BeaconBroadcastApp()));
                },
                child: Text("BeaconEmitter")),
            ElevatedButton(onPressed: () {}, child: Text("Scanner"))
          ],
        ),
      ),
    );
  }
}
