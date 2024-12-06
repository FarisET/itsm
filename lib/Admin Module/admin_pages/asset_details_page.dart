import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/admin_pages/asset_ticket_history_page.dart';
import 'package:safify/Admin%20Module/providers/asset_details_provider.dart';
import 'package:safify/models/asset_history.dart';
import 'package:safify/utils/string_utils.dart';

class AssetDetailsPage extends StatefulWidget {
  final String assetNo;

  AssetDetailsPage({required this.assetNo});

  @override
  _AssetDetailsPageState createState() => _AssetDetailsPageState();
}

class _AssetDetailsPageState extends State<AssetDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetDetailsProvider>(context, listen: false)
          .fetchAssetDetails(widget.assetNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double mainHeaderSize = 18;

    return ChangeNotifierProvider(
      create: (_) => AssetDetailsProvider()..fetchAssetDetails(widget.assetNo),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Asset Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: mainHeaderSize,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AssetDetailsProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (provider.errorMessage != null) {
                return Center(child: Text(provider.errorMessage!));
              }
              if (provider.assetHistory.isEmpty) {
                return Center(
                  child: Text("No details available for this asset."),
                );
              }

              final asset = provider.assetHistory[0];
              return SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 70,
                              child: Text(
                                asset.assetName ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: asset.status!.contains('available')
                                    ? Colors.green[100]
                                    : asset.status!.contains('high')
                                        ? Colors.orange[100]
                                        : Colors.red[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                ' ${capitalizeFirstLetter(asset.status)}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.numbers, color: Colors.blue),
                            SizedBox(width: 8),
                            Text("${asset.assetNo}"),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.description, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(child: Text("${asset.assetDesc}")),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.type_specimen, color: Colors.green),
                            SizedBox(width: 8),
                            Text("${asset.assetType}"),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.person_outline_outlined,
                                color: Colors.blue),
                            SizedBox(width: 8),
                            Text("${asset.assignedTo}"),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.pin_drop_outlined, color: Colors.blue),
                            SizedBox(width: 8),
                            Text("${asset.assetLocation}"),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.purple),
                            SizedBox(width: 8),
                            Text(
                                "Created on ${asset.assetCreationDate.toLocal()}"),
                          ],
                        ),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.support_agent_sharp, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tickets: ${asset.assetIssueCount}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the Linked Tickets page
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            AssetTicketHistoryPage(
                                          assetNo: asset.assetNo,
                                        ),
                                      ));
                                    },
                                    child: Text(
                                      "View Linked Tickets",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
