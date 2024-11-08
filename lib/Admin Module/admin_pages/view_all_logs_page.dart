import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/asset_log_provider.dart';
import 'package:safify/models/asset_log.dart';
import 'package:intl/intl.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String searchQuery = '';
  DateTime? startDate;
  DateTime? endDate;

  Map<String, bool> columnVisibility = {
    'Log ID': true,
    'User': true,
  };

  Map<int, bool> isExpanded = {};

  @override
  void initState() {
    super.initState();
    Provider.of<AssetLogProvider>(context, listen: false).fetchAssetLogs('');
  }

  void _filterLogs() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).secondaryHeaderColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("View History",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).secondaryHeaderColor)),
        backgroundColor: Colors.white,
        actions: [_buildColumnVisibilityDropdown()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildSearchBar(),
                    SizedBox(height: 8),
                    _buildDateFilter(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(child: _buildLogTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnVisibilityDropdown() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.view_column,
          color: Theme.of(context).secondaryHeaderColor),
      onSelected: (String column) {
        setState(() {
          columnVisibility[column] = !columnVisibility[column]!;
        });
      },
      itemBuilder: (BuildContext context) {
        return columnVisibility.keys.map((String column) {
          return CheckedPopupMenuItem<String>(
            value: column,
            checked: columnVisibility[column]!,
            child: Text(column),
          );
        }).toList();
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(),
        ),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  Widget _buildDateFilter() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  startDate = pickedDate;
                });
              }
            },
            child: Text(
              startDate == null
                  ? "Start Date"
                  : DateFormat('yyyy-MM-dd').format(startDate!),
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  endDate = pickedDate;
                });
              }
            },
            child: Text(
                endDate == null
                    ? "End Date"
                    : DateFormat('yyyy-MM-dd').format(endDate!),
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontWeight: FontWeight.normal)),
          ),
        ),
        IconButton(
          icon: Icon(Icons.filter_alt),
          onPressed: _filterLogs,
        ),
      ],
    );
  }

  Widget _buildLogTable() {
    return Consumer<AssetLogProvider>(
      builder: (context, provider, child) {
        List<AssetLog> filteredLogs = provider.assetLogs
            .where((log) =>
                log.actionUser.contains(searchQuery) ||
                log.actionPerformed.contains(searchQuery))
            .where((log) {
          if (startDate != null && log.actionDatetime.isBefore(startDate!))
            return false;
          if (endDate != null && log.actionDatetime.isAfter(endDate!))
            return false;
          return true;
        }).toList();

        return provider.isLoading
            ? Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
                ? Center(child: Text(provider.errorMessage!))
                : Card(
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: _buildDataColumns(),
                          rows: filteredLogs.asMap().entries.map((entry) {
                            int index = entry.key;
                            AssetLog log = entry.value;
                            final rowColor = index.isEven
                                ? Colors.white
                                : Colors.lightBlue.shade50;
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) => rowColor),
                              cells: _buildDataCells(log),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
      },
    );
  }

  List<DataColumn> _buildDataColumns() {
    List<DataColumn> columns = [
      DataColumn(label: Text('Asset No')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('Action')),
    ];

    if (columnVisibility['Log ID']!)
      columns.insert(0, DataColumn(label: Text('Log ID')));
    if (columnVisibility['User']!) columns.add(DataColumn(label: Text('User')));

    return columns;
  }

  List<DataCell> _buildDataCells(AssetLog log) {
    List<DataCell> cells = [
      DataCell(Text(log.assetNo)),
      DataCell(Text(log.actionStatus)),
      DataCell(Text(DateFormat('yyyy-MM-dd').format(log.actionDatetime))),
      _buildExpandableActionCell(log),
    ];

    if (columnVisibility['Log ID']!)
      cells.insert(0, DataCell(Text(log.assetLogId.toString())));
    if (columnVisibility['User']!) cells.add(DataCell(Text(log.actionUser)));

    return cells;
  }

  DataCell _buildExpandableActionCell(AssetLog log) {
    final isTextExpanded = isExpanded[log.assetLogId] ?? false;
    String actionText = log.actionPerformed;
    String displayedText = isTextExpanded || actionText.length <= 20
        ? actionText
        : '${actionText.substring(0, 20)}...';

    return DataCell(
      Row(
        children: [
          Expanded(child: Text(displayedText, overflow: TextOverflow.ellipsis)),
          if (actionText.length > 20)
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded[log.assetLogId] = !isTextExpanded;
                });
              },
              child: Icon(
                isTextExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }
}
