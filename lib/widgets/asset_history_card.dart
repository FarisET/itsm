import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safify/models/asset_history.dart';

class AssetHistoryTile extends StatefulWidget {
  final AssetHistory assetHistory;

  AssetHistoryTile({required this.assetHistory});

  @override
  _AssetHistoryTileState createState() => _AssetHistoryTileState();
}

class _AssetHistoryTileState extends State<AssetHistoryTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ExpansionTile(
        title: Text(
          widget.assetHistory.problem,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('yyyy-MM-dd – kk:mm').format(widget.assetHistory.datetime),
        ),
        trailing: Text(
          _isExpanded ? "View Less" : "View More",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reported By
                Text(
                  'Reported By: ${widget.assetHistory.reportedBy}',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 4),

                // Location
                Text(
                  'Location: ${widget.assetHistory.location}',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 4),

                // Problem Criticality
                Text(
                  'Criticality: ${widget.assetHistory.problemCriticality}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 4),

                // Problem Status
                Text(
                  'Status: ${widget.assetHistory.problemStatus}',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),

                // Image (if available)
                if (widget.assetHistory.image != null)
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(widget.assetHistory.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
