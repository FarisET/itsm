import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/admin_pages/asset_history_page.dart';
import 'package:safify/Admin%20Module/providers/admin_asset_provider.dart';
import 'package:safify/models/asset.dart';

class ViewAsset extends StatefulWidget {
  const ViewAsset({super.key});

  @override
  State<ViewAsset> createState() => _ViewAssetState();
}

class _ViewAssetState extends State<ViewAsset> {
  final TextEditingController searchController = TextEditingController();
  List<Asset> filteredAssets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AdminAssetProvider>(context, listen: false);
      provider.loadAllAssets();
    });
  }

  // Filter assets based on the search query
  void filterAssets(String query) {
    final allAssets =
        Provider.of<AdminAssetProvider>(context, listen: false).allAssets;
    setState(() {
      filteredAssets = allAssets.where((asset) {
        return asset.assetName != null &&
            asset.assetName!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).secondaryHeaderColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("View Asset",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).secondaryHeaderColor,
            )),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: TextField(
                  controller: searchController,
                  onChanged: filterAssets,
                  decoration: InputDecoration(
                    hintText: 'Search Assets...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Consumer<AdminAssetProvider>(
                  builder: (context, provider, child) {
                    if (provider.loading) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      filteredAssets = searchController.text.isEmpty
                          ? provider.allAssets
                          : filteredAssets;
                      return ListView.builder(
                        itemCount: filteredAssets.length,
                        itemBuilder: (context, index) {
                          final asset = filteredAssets[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.005),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title:
                                      Text(asset.assetName ?? 'Unknown Asset'),
                                  subtitle: Text(
                                      'Past Tickets: ${asset.assetIssueCount ?? 0}'),
                                  trailing: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AssetHistoryPage(
                                            assetNo: asset.assetNo!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text('View History'),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
