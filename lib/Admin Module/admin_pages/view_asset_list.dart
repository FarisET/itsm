import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/admin_pages/asset_details_page.dart';
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

  void filterAssets(String query) {
    final allAssets =
        Provider.of<AdminAssetProvider>(context, listen: false).allAssets;
    setState(() {
      filteredAssets = allAssets.where((asset) {
        // Exclude null assets directly here
        return asset != null &&
            asset.assetName != null &&
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
                    // Check if the provider is loading
                    if (provider.loading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // Handle filteredAssets based on search query
                    filteredAssets = searchController.text.isEmpty
                        ? provider.allAssets
                            .where((asset) => asset.assetName != null)
                            .toList()
                        : filteredAssets
                            .where((asset) => asset.assetName != null)
                            .toList();

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
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  title: Row(
                                    children: [
                                      const Icon(Icons.label_important_outline,
                                          color: Colors.blueAccent),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          asset.assetName!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.history,
                                              color: Colors.orange),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Past Tickets: ${asset.assetIssueCount ?? 0}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Divider(thickness: 1),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AssetDetailsPage(
                                                assetNo: asset.assetNo!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'View Details',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 18,
                                              color: Colors.blueAccent,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        );
                      },
                    );
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
