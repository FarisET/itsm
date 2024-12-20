import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/asset_history_provider.dart';
import 'package:safify/widgets/asset_history_card.dart';
import 'package:intl/intl.dart';

class AssetTicketHistoryPage extends StatefulWidget {
  final String assetNo;

  AssetTicketHistoryPage({required this.assetNo});

  @override
  _AssetTicketHistoryPageState createState() => _AssetTicketHistoryPageState();
}

class _AssetTicketHistoryPageState extends State<AssetTicketHistoryPage> {
  String? _selectedDate; // Store the selected date as a string
  List filteredAssetHistory = [];
  List filteredAssetLog = [];

  @override
  void initState() {
    super.initState();
    filteredAssetHistory = [];
    filteredAssetLog = [];
  }

  void filterAssetHistoryByDate(String? selectedDate, List assetHistory) {
    print("filterAssetHistoryByDate called with date: $selectedDate");
    if (selectedDate == null || selectedDate.isEmpty) {
      filteredAssetHistory = assetHistory;
    } else {
      filteredAssetHistory = assetHistory
          .where((asset) => asset.datetime.startsWith(selectedDate))
          .toList();
    }
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      // Format the date as a string to match "assetHistory.reportedBy"
      final String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        _selectedDate = formattedDate;
      });

      final provider =
          Provider.of<AssetHistoryProvider>(context, listen: false);
      filterAssetHistoryByDate(_selectedDate, provider.assetHistory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) {
        final provider = AssetHistoryProvider();
        provider.fetchAssetHistory(widget.assetNo).then((_) {
          filteredAssetHistory = provider.assetHistory;
          if (_selectedDate != null) {
            filterAssetHistoryByDate(_selectedDate, provider.assetHistory);
          }
          setState(() {});
        });

        return provider;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).secondaryHeaderColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("Tickets",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).secondaryHeaderColor,
              )),
          backgroundColor: Colors.white,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, // Main padding for the container
              vertical: screenHeight * 0.05,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align content to the start
                children: [
                  // Date Filter
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.043),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Filter Tickets by Date",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _selectedDate ?? "No date selected",
                              style: TextStyle(
                                fontSize: 12,
                                color: _selectedDate != null
                                    ? Colors.black
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _selectDate(context),
                          icon: Icon(Icons.calendar_month_outlined),
                          label: Text("Pick Date"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
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
                        if (filteredAssetHistory.isEmpty) {
                          return Center(
                              child:
                                  Text("No history available for this asset."));
                        }
                        return ListView.builder(
                          padding: EdgeInsets
                              .zero, // Ensure alignment with filter row
                          itemCount: filteredAssetHistory.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              child: Container(
                                width: double.infinity,
                                child: AssetHistoryTile(
                                    assetHistory: filteredAssetHistory[index]),
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
        ),
      ),
    );
  }
}
