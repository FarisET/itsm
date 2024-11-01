import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for LengthLimitingTextInputFormatter
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/admin_asset_provider.dart';
import 'package:safify/Admin%20Module/providers/fetch_locations_server.dart';
import 'package:safify/User%20Module/providers/location_provider.dart';
import 'package:safify/api/asset_data_services.dart';
import 'package:safify/api/locations_data_service.dart';
import 'package:safify/services/toast_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for LengthLimitingTextInputFormatter
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/admin_asset_provider.dart';
import 'package:safify/services/toast_service.dart';

class AddAssetTypePage extends StatefulWidget {
  const AddAssetTypePage({super.key});

  @override
  State<AddAssetTypePage> createState() => _AddAssetTypePageState();
}

class _AddAssetTypePageState extends State<AddAssetTypePage> {
  final TextEditingController _assetTypeController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _assetTypeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AdminAssetProvider>(context, listen: false)
        .fetchAssetTypesandSubTypes();
    _assetTypeController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _assetTypeController.text;
    });
  }

  void _showConfirmationDialog(String assetTypeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogBox(
          assetTypeName: assetTypeName,
          onAssetTypeAdded: _refreshAssetTypes, // Call refresh function
        );
      },
    );
  }

  // New function to refresh asset types list after adding a new asset type
  void _refreshAssetTypes() {
    Provider.of<AdminAssetProvider>(context, listen: false)
        .fetchAssetTypesandSubTypes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).secondaryHeaderColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Add Asset Type",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(CupertinoIcons.briefcase,
                                  color: Colors.black, size: 20.0),
                              SizedBox(width: 10.0),
                              Text(
                                "Name",
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: _assetTypeController,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'enter asset type...',
                              labelText: 'New Asset Type Name',
                              labelStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 20.0),

                          // ListView for displaying fetched asset types with search functionality
                          Expanded(
                            child: Consumer<AdminAssetProvider>(
                              builder: (context, assetProvider, child) {
                                if (assetProvider.assetTypeList == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (assetProvider.assetTypeList!.isEmpty) {
                                  return const Center(
                                    child: Text('No asset types available.'),
                                  );
                                }

                                final filteredAssetTypes = assetProvider
                                    .assetTypeList!
                                    .where((type) => type.assetTypeDesc
                                        .toLowerCase()
                                        .contains(_searchQuery.toLowerCase()))
                                    .toList();

                                return filteredAssetTypes.isEmpty
                                    ? const Center(
                                        child: Text('No matching asset types.'),
                                      )
                                    : Scrollbar(
                                        thumbVisibility: true,
                                        child: ListView.builder(
                                          itemCount: filteredAssetTypes.length,
                                          itemBuilder: (context, index) {
                                            final assetType =
                                                filteredAssetTypes[index];
                                            return ListTile(
                                              title:
                                                  Text(assetType.assetTypeDesc),
                                              onTap: () {
                                                assetProvider
                                                    .setSelectedAssetType(
                                                        assetType
                                                            .assetTypeDesc);
                                              },
                                              selected: assetProvider
                                                      .selectedAssetType ==
                                                  assetType.assetTypeDesc,
                                            );
                                          },
                                        ),
                                      );
                              },
                            ),
                          ),

                          const SizedBox(height: 20.0),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                final assetTypeName = _assetTypeController.text;
                                if (assetTypeName.isNotEmpty) {
                                  _showConfirmationDialog(assetTypeName);
                                  FocusScope.of(context)
                                      .unfocus(); // Dismiss the keyboard
                                  _assetTypeController.clear(); // Clear input
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text(
                                          'Please enter an asset type name'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Add Asset Type'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlertDialogBox extends StatefulWidget {
  final String assetTypeName;
  final VoidCallback onAssetTypeAdded;

  AlertDialogBox({
    super.key,
    required this.assetTypeName,
    required this.onAssetTypeAdded,
  });

  @override
  State<AlertDialogBox> createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
  bool isSubmitting = false;
  AssetDataServices _assetDataServices = AssetDataServices();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message.replaceFirst('Exception: ', '')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: const Text('Confirm Asset Type'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to add this new asset type:'),
          const SizedBox(height: 10.0),
          Text(widget.assetTypeName,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
          const SizedBox(height: 20.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      isSubmitting = true;
                    });

                    try {
                      await _assetDataServices
                          .addAssetType(widget.assetTypeName);
                      widget.onAssetTypeAdded();
                      Navigator.of(context).pop();
                    } on Exception catch (e) {
                      setState(() {
                        isSubmitting = false;
                      });
                      _showErrorDialog(e.toString());
                      return;
                    }

                    setState(() {
                      isSubmitting = false;
                    });

                    ToastService.showAssetTypeAddedSnackBar(context);
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Center(
                      child: isSubmitting
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Yes',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
