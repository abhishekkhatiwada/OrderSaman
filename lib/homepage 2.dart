import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: () {}, child: Text("BeaconEmitter")),
        ElevatedButton(onPressed: () {}, child: Text("Scanner"))
      ],
    );
  }
}
