import 'package:flutter/material.dart';

class AssetHistoryPage extends StatelessWidget {
  late final String assetName;

  AssetHistoryPage({required this.assetName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History for $assetName"),
      ),
      body: Center(
        child: Text("History details for $assetName will be displayed here."),
      ),
    );
  }
}
