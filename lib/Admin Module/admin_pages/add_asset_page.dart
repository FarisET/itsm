import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/admin_asset_provider.dart';
import 'package:safify/api/asset_data_services.dart';
import 'package:safify/services/toast_service.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  State<AddAssetPage> createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final TextEditingController _assetController = TextEditingController();
  final TextEditingController _assetTypeController = TextEditingController();
  String? _selectedAssetType;
  String? _selectedAssetTypeId;
  String _searchQuery = '';
  bool isAssetTypeDropdownSelected = false;

  @override
  void dispose() {
    _assetController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AdminAssetProvider>(context, listen: false)
        .fetchAssetTypesandSubTypes();
  }

  void _refreshAssets() {
    Provider.of<AdminAssetProvider>(context, listen: false)
        .fetchAssetTypesandSubTypes();
    setState(() {});
  }

  void _onAssetSelected(String? assetTypeId) {
    Provider.of<AdminAssetProvider>(context, listen: false)
        .getFilteredAssets(assetTypeId);
  }

  void _showConfirmationDialog(
      String assetName, String assetTypeId, String assetTypeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AssetAlertDialogBox(
          assetName: assetName,
          assetTypeId: assetTypeId,
          assetTypeName: assetTypeName,
          onAssetAdded: _refreshAssets,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assetsProvider = Provider.of<AdminAssetProvider>(context);
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
            "Add Asset",
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
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.location_solid,
                                    color: Colors.black,
                                    size: 20.0,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    "Select Asset Type",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            DropdownMenu(
                                inputDecorationTheme: InputDecorationTheme(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                menuStyle: MenuStyle(
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                                ),
                                expandedInsets:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                requestFocusOnTap: true,
                                menuHeight:
                                    MediaQuery.sizeOf(context).height * 0.3,
                                label: const Text("Select Asset Type"),
                                controller: _assetTypeController,
                                enableFilter: true,
                                enableSearch: true,
                                onSelected: (value) {
                                  setState(() {
                                    _selectedAssetTypeId = value.toString();
                                    _selectedAssetType =
                                        _assetTypeController.text.isEmpty
                                            ? null
                                            : _assetTypeController.text;
                                    isAssetTypeDropdownSelected = true;
                                  });
                                  _assetController.clear();
                                  _onAssetSelected(_selectedAssetTypeId);
                                },
                                dropdownMenuEntries: [
                                  const DropdownMenuEntry(
                                    labelWidget: Text(
                                      "Select Asset Type",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    label: "",
                                    value: null,
                                  ),
                                  ...assetsProvider.assetTypeList!
                                      .map((assetType) {
                                    return DropdownMenuEntry(
                                      label: assetType.assetTypeDesc,
                                      value: assetType.assetTypeId,
                                    );
                                  }).toList()
                                ]),
                            const SizedBox(height: 20),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Selected Type Name: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: _selectedAssetType ?? 'None',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 40.0),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    _selectedAssetTypeId == null
                                        ? Icons.info_outline
                                        : Icons.info,
                                    color: _selectedAssetType == null
                                        ? Colors.grey
                                        : Colors.black,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text("Asset Name",
                                      style: TextStyle(
                                        fontWeight: _selectedAssetTypeId == null
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        color: _selectedAssetTypeId == null
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .secondaryHeaderColor,
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            TextField(
                              enabled: _selectedAssetType != null,
                              controller: _assetController,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: _selectedAssetTypeId != null,
                                alignLabelWithHint: true,
                                hintText: _selectedAssetTypeId == null
                                    ? 'Select asset type first'
                                    : 'Enter asset name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 20.0),
                            if (isAssetTypeDropdownSelected)
                              Expanded(child: Consumer<AdminAssetProvider>(
                                builder: (context, assetProvider, child) {
                                  final filteredAssets = assetProvider
                                      .getFilteredAssets(_selectedAssetTypeId);

                                  if (assetProvider.loading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  // Apply search query filtering
                                  final filteredAssetsByQuery = filteredAssets
                                      .where((asset) => asset.assetName!
                                          .toLowerCase()
                                          .contains(_searchQuery.toLowerCase()))
                                      .toList();

                                  // Check if the filtered list based on query is empty
                                  if (filteredAssetsByQuery.isEmpty) {
                                    return const Center(
                                      child: Text('No assets available.'),
                                    );
                                  }

                                  return Scrollbar(
                                    thumbVisibility: true,
                                    child: ListView.builder(
                                      itemCount: filteredAssetsByQuery.length,
                                      itemBuilder: (context, index) {
                                        final asset =
                                            filteredAssetsByQuery[index];
                                        return ListTile(
                                          title: Text(asset.assetName!),
                                          onTap: () {
                                            assetProvider
                                                .setSelectedAssetSubtype(
                                                    asset.assetName);
                                          },
                                          selected: assetProvider
                                                  .selectedAssetSubtype ==
                                              asset.assetName,
                                        );
                                      },
                                    ),
                                  );
                                },
                              )),
                          ],
                        ),
                      ),
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
                            final assetName = _assetController.text;
                            if (_selectedAssetType != null &&
                                assetName.isNotEmpty) {
                              _showConfirmationDialog(assetName,
                                  _selectedAssetTypeId!, _selectedAssetType!);
                              FocusScope.of(context).unfocus();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                        'Please select asset type and enter an asset name')),
                              );
                            }
                          },
                          child: const Text('Add Asset'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AssetAlertDialogBox extends StatefulWidget {
  final String assetName;
  final String assetTypeId;
  final String assetTypeName;
  final VoidCallback onAssetAdded;

  AssetAlertDialogBox({
    super.key,
    required this.assetName,
    required this.assetTypeId,
    required this.assetTypeName,
    required this.onAssetAdded,
  });

  @override
  State<AssetAlertDialogBox> createState() => _AssetAlertDialogBoxState();
}

class _AssetAlertDialogBoxState extends State<AssetAlertDialogBox> {
  final AssetDataServices _assetsDataService = AssetDataServices();
  final TextEditingController _assetDescController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    _assetDescController.dispose();
    super.dispose();
  }

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
      title: const Text('Confirm asset'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to add this new asset:'),
          const SizedBox(height: 20.0),
          Center(
            child: Text(widget.assetName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0)),
          ),
          const SizedBox(height: 20.0),
          RichText(
            text: TextSpan(
              text: 'To the asset type: ',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: widget.assetTypeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _assetDescController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Optional Description',
              border: OutlineInputBorder(),
            ),
          ),
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
                      // Call the addAsset method with the optional description
                      await _assetsDataService.addAsset(
                        widget.assetName,
                        _assetDescController.text, // Pass the description text
                        widget.assetTypeId,
                      );
                      widget.onAssetAdded();
                    } catch (e) {
                      print('Error adding asset: $e');
                      _showErrorDialog(e.toString());
                      return;
                    } finally {
                      setState(() {
                        isSubmitting = false;
                      });
                    }

                    Navigator.of(context).pop();
                    ToastService.showAssetAddedSnackBar(context);
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Center(
                      child: isSubmitting
                          ? SizedBox(
                              width: MediaQuery.of(context).size.height * 0.025,
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Add',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
