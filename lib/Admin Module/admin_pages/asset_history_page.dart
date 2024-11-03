import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/asset_history_provider.dart';
import 'package:safify/widgets/asset_history_card.dart';

class AssetHistoryPage extends StatefulWidget {
  final String assetNo;

  AssetHistoryPage({required this.assetNo});

  @override
  _AssetHistoryPageState createState() => _AssetHistoryPageState();
}

class _AssetHistoryPageState extends State<AssetHistoryPage> {
  String _searchQuery = '';
  List filteredAssetHistory = [];
  List filteredAssetLog = [];

  @override
  void initState() {
    super.initState();
    // Initialize the filtered list
    filteredAssetHistory = [];
    filteredAssetLog = [];
  }

  void filterAssetHistory(String query, List assetHistory) {
    if (query.isEmpty) {
      // If query is empty, show all asset history
      filteredAssetHistory = assetHistory;
    } else {
      // Filter based on the search query
      filteredAssetHistory = assetHistory
          .where((asset) =>
              asset.problem.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) {
        final provider = AssetHistoryProvider();
        provider.fetchAssetHistory(widget.assetNo).then((_) {
          // Set the initial filtered list with the full asset history
          filteredAssetHistory = provider.assetHistory;
          setState(() {}); // Update the state to rebuild with full history
        });
        return provider;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("History for ${widget.assetNo}"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (query) {
                  final provider =
                      Provider.of<AssetHistoryProvider>(context, listen: false);
                  filterAssetHistory(query, provider.assetHistory);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(),
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: Consumer<AssetHistoryProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }
                  // Check if filteredAssetHistory is empty after filtering
                  if (filteredAssetHistory.isEmpty) {
                    return Center(
                        child: Text("No history available for this asset."));
                  }

                  // Display the filtered asset history
                  return ListView.builder(
                    itemCount: filteredAssetHistory.length,
                    itemBuilder: (context, index) {
                      return AssetHistoryTile(
                          assetHistory: filteredAssetHistory[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
