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
  bool _isImageLoading = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Text(
                widget.assetHistory.problem,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Reported On: ${DateFormat('yyyy-MM-dd – kk:mm').format(widget.assetHistory.datetime)}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  _buildDetailRow(
                    icon: Icons.person_outline_outlined,
                    label: 'Reported By:',
                    value: widget.assetHistory.reportedBy,
                  ),
                  _buildDetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location:',
                    value: widget.assetHistory.location,
                  ),
                  _buildDetailRow(
                    icon: Icons.priority_high_rounded,
                    label: 'Criticality:',
                    value: widget.assetHistory.problemCriticality,
                    valueColor: widget.assetHistory.problemCriticality == 'high'
                        ? Colors.orange
                        : widget.assetHistory.problemCriticality == 'low'
                            ? Colors.green
                            : Colors.red,
                  ),
                  _buildDetailRow(
                    icon: Icons.info_outline,
                    label: 'Status:',
                    value: widget.assetHistory.problemStatus,
                  ),
                  if (widget.assetHistory.image != null) ...[
                    SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Image.network(
                            widget.assetHistory.image!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                // Image has finished loading
                                return child;
                              } else {
                                // Image is still loading
                                return Container(
                                  height: 120,
                                  width: double.infinity,
                                  color: Colors.black.withOpacity(0.5),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedDots(),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// AnimatedDots widget for loading animation
class AnimatedDots extends StatefulWidget {
  @override
  _AnimatedDotsState createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    _dotCount = IntTween(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotCount,
      builder: (context, child) {
        String dots = '.' * (_dotCount.value + 1);
        return Text(
          'Loading$dots',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        );
      },
    );
  }
}
