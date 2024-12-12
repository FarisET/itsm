import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/asset_details_provider.dart';
import 'package:safify/User%20Module/providers/location_provider.dart';
import 'package:safify/User%20Module/providers/sub_location_provider.dart';

class AssetDetailsPage extends StatefulWidget {
  final String assetNo;

  AssetDetailsPage({required this.assetNo});

  @override
  _AssetDetailsPageState createState() => _AssetDetailsPageState();
}

class _AssetDetailsPageState extends State<AssetDetailsPage> {
  String? _selectedSubLocation; // To store selected sub-location
  bool isEditingName = false;
  bool isEditingDesc = false;
  bool isEditingType = false;
  bool isEditingLocation = false;

  final _formKey = GlobalKey<FormState>();

  // Controllers for editable fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch asset details in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<AssetDetailsProvider>(context, listen: false);
      provider.fetchAssetDetails(widget.assetNo);

      Provider.of<LocationProviderClass>(context, listen: false)
          .fetchLocations();
    });
  }

  Future<String?> _showLocationBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ChangeNotifierProvider<SubLocationProviderClass>(
          create: (_) => SubLocationProviderClass()..getAllSublocations(),
          child: Consumer2<SubLocationProviderClass, LocationProviderClass>(
            builder: (context, subLocationProvider, locationProvider, child) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search Sub-Locations',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        subLocationProvider.setSearchFocus(true);
                      },
                    ),
                    Expanded(
                      child: subLocationProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount:
                                  subLocationProvider.allSubLocations?.length ??
                                      0,
                              itemBuilder: (context, index) {
                                final subLocation =
                                    subLocationProvider.allSubLocations![index];
                                final location =
                                    locationProvider.allLocations?.firstWhere(
                                  (loc) =>
                                      loc.locationId == subLocation.location_id,
                                );

                                return ListTile(
                                  title: Text(
                                      subLocation.sublocationName ?? 'Unknown'),
                                  subtitle:
                                      Text(location?.locationName ?? 'N/A'),
                                  onTap: () {
                                    setState(() {
                                      _selectedSubLocation =
                                          subLocation.sublocationId;
                                      locationController.text =
                                          subLocation.sublocationName ?? '';
                                    });
                                    Navigator.pop(
                                        context, _selectedSubLocation);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    return _selectedSubLocation;
  }

  @override
  Widget build(BuildContext context) {
    final double mainHeaderSize = 18;

    return Scaffold(
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
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }
            if (provider.assetHistory.isEmpty) {
              return const Center(
                child: Text("No details available for this asset."),
              );
            }

            final asset = provider.assetHistory[0];

            // Initialize controllers with current values
            if (_selectedSubLocation == null || _selectedSubLocation == '') {
              nameController.text = asset.assetName ?? '';
              descController.text = asset.assetDesc ?? '';
              typeController.text = asset.assetType ?? '';
              locationController.text = asset.assetLocation ?? '';
            }

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                        // Asset Name Field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 70,
                              child: isEditingName
                                  ? TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                          labelText: 'Asset Name'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Asset Name cannot be empty';
                                        }
                                        return null;
                                      },
                                    )
                                  : Text(
                                      (nameController.text.isNotEmpty
                                              ? nameController.text
                                              : asset.assetName) ??
                                          'N/A',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            IconButton(
                              icon: Icon(
                                isEditingName
                                    ? Icons.check
                                    : Icons.edit_outlined,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditingName = !isEditingName;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns the label with the Row
                          children: [
                            Text(
                              "Asset Number", // Label text
                              style: TextStyle(
                                fontSize: 10, // Smaller font size
                                color: Colors.grey, // Gray color
                              ),
                            ),
                            SizedBox(height: 4), // Space between label and Row
                            Row(
                              children: [
                                Icon(Icons.numbers, color: Colors.blue),
                                SizedBox(width: 8),
                                Text("${asset.assetNo}"),
                              ],
                            ),
                          ],
                        ),

                        const Divider(),
                        // Description Field

                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns the label with the Row
                          children: [
                            Text(
                              "Asset Description", // Label text
                              style: TextStyle(
                                fontSize: 10, // Smaller font size
                                color: Colors.grey, // Gray color
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.description,
                                    color: Colors.orange),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: isEditingDesc
                                      ? TextFormField(
                                          controller: descController,
                                        )
                                      : Text(
                                          (descController.text.isNotEmpty
                                                  ? descController.text
                                                  : asset.assetDesc) ??
                                              'N/A',
                                        ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isEditingDesc
                                        ? Icons.check
                                        : Icons.edit_outlined,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isEditingDesc = !isEditingDesc;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        // Type Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns the label with the Row
                          children: [
                            Text(
                              "Asset Type", // Label text
                              style: TextStyle(
                                fontSize: 10, // Smaller font size
                                color: Colors.grey, // Gray color
                              ),
                            ),
                            SizedBox(height: 4), // Space between label and Row
                            Row(
                              children: [
                                Icon(Icons.numbers, color: Colors.blue),
                                SizedBox(width: 8),
                                Text("${asset.assetType}"),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Asset Location", // Label text
                              style: TextStyle(
                                fontSize: 10, // Smaller font size
                                color: Colors.grey, // Gray color
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.pin_drop_outlined,
                                    color: Colors.blue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: isEditingLocation
                                      ? AbsorbPointer(
                                          child: TextFormField(
                                            //   readOnly: true,
                                            controller: locationController,
                                          ),
                                        )
                                      : Text(
                                          (locationController.text.isNotEmpty
                                                  ? locationController.text
                                                  : asset.assetLocation) ??
                                              'N/A',
                                        ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isEditingLocation
                                        ? Icons.check
                                        : Icons.edit_outlined,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await _showLocationBottomSheet(context);
                                    setState(() {
                                      isEditingLocation = !isEditingLocation;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        // Update Button
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              provider.updateAsset(
                                asset.assetNo!,
                                nameController.text,
                                descController.text,
                                asset.assetTypeId,
                                locationController.text,
                                asset.status!,
                                asset.assignedTo,
                              );
                            }
                          },
                          child: const Text('Update Asset'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
