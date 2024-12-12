import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/admin_pages/asset_ticket_history_page.dart';
import 'package:safify/Admin%20Module/providers/asset_details_provider.dart';
import 'package:safify/Admin%20Module/providers/fetch_users_provider.dart';
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
  String? _selectedUserId; // To store selected sub-location
  bool isEditingName = false;
  bool isEditingDesc = false;
  bool isEditingType = false;
  bool isEditingLocation = false;
  bool isAssigning = false;

  final _formKey = GlobalKey<FormState>();

  // Controllers for editable fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  TextEditingController assignmentController = TextEditingController();
  TextEditingController assignmentControllerName = TextEditingController();

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

      Provider.of<FetchUsersProvider>(context, listen: false).fetchUsers();
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

  Future<String?> _showAssignmentBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ChangeNotifierProvider<FetchUsersProvider>(
          create: (_) => FetchUsersProvider()..fetchUsers(),
          child: Consumer<FetchUsersProvider>(
            builder: (context, fetchUsersProvider, child) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search Users',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        // You can implement a search/filter logic in your provider
                        // if needed, or simply filter locally
                      },
                    ),
                    Expanded(
                      child: fetchUsersProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: fetchUsersProvider.users.length,
                              itemBuilder: (context, index) {
                                final user = fetchUsersProvider.users[index];
                                return ListTile(
                                  title: Text(user.user_id ?? 'Unknown'),
                                  subtitle: Text(user.user_id ?? 'N/A'),
                                  onTap: () {
                                    setState(() {
                                      _selectedUserId = user.user_id;
                                      assignmentController.text = user.user_id;
                                      assignmentControllerName.text =
                                          user.user_id;
                                    });
                                    Navigator.pop(context, _selectedUserId);
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

    return _selectedUserId;
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
                                    color: Colors.blue),
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
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns the label with the Row
                          children: [
                            Text(
                              "Asset Status", // Label text
                              style: TextStyle(
                                fontSize: 10, // Smaller font size
                                color: Colors.grey, // Gray color
                              ),
                            ),
                            SizedBox(height: 4), // Space between label and Row
                            Row(
                              children: [
                                Icon(Icons.arrow_circle_down_sharp,
                                    color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                    "${asset.status[0].toUpperCase()}${asset.status.substring(1)}"),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Asset Assignment", // Label text
                              style: TextStyle(
                                fontSize: 10, // Smaller font size
                                color: Colors.grey, // Gray color
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.person_2_outlined,
                                    color: Color.fromRGBO(33, 150, 243, 1)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: isAssigning
                                      ? AbsorbPointer(
                                          child: TextFormField(
                                            //   readOnly: true,
                                            controller: assignmentController,
                                          ),
                                        )
                                      : Text(
                                          (assignmentController.text.isNotEmpty
                                                  ? assignmentController.text
                                                  : asset.assignedTo) ??
                                              'N/A',
                                        ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isAssigning
                                        ? Icons.check
                                        : Icons.edit_outlined,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await _showAssignmentBottomSheet(context);
                                    setState(() {
                                      isAssigning = !isAssigning;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns the label with the Row
                          children: [
                            Text(
                              "Creation Date", // Label text
                              style: TextStyle(
                                fontSize: 10, // Smaller font size
                                color: Colors.grey, // Gray color
                              ),
                            ),
                            SizedBox(height: 4), // Space between label and Row
                            Row(
                              children: [
                                Icon(Icons.calendar_month_outlined,
                                    color: Colors.blue),
                                SizedBox(width: 8),
                                Text("${asset.assetCreationDate}"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        const Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns the label with the Row
                          children: [
                            Text(
                              "Is Active", // Label text
                              style: TextStyle(
                                fontSize: 10, // Smaller font size
                                color: Colors.grey, // Gray color
                              ),
                            ),
                            SizedBox(height: 4), // Space between label and Row
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline_rounded,
                                    color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                    "${asset.isActive[0].toUpperCase()}${asset.isActive.substring(1)}"),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.02),

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
                        const Divider(),
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.02),

                        // Update Button
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Show loading dialog
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              );

                              try {
                                // Call the updateAsset method
                                final result = await provider.updateAsset(
                                  asset.assetNo!,
                                  nameController.text,
                                  descController.text,
                                  asset.assetTypeId,
                                  _selectedSubLocation ??
                                      asset.assetSubLocationId,
                                  asset.status!,
                                  _selectedUserId ?? asset.assignedTo,
                                );

                                // Close the loading dialog
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                if (result) {
                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Asset updated successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  // Handle specific error case
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Failed to update asset. Please try again.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } catch (error) {
                                // Close the loading dialog
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'An error occurred: ${error.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
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
