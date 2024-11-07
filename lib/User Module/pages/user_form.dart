import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:safify/User%20Module/pages/home_page.dart';
import 'package:safify/User%20Module/providers/asset_provider.dart';
import 'package:safify/User%20Module/providers/user_reports_provider.dart';
import 'package:safify/db/database_helper.dart';
import 'package:safify/models/asset.dart';
import 'package:safify/models/asset_type.dart';
import 'package:safify/models/location.dart';
import 'package:safify/models/user_report_form_details.dart';
import 'package:safify/services/toast_service.dart';
import 'package:safify/utils/file_utils.dart';
import 'package:safify/utils/network_util.dart';
import 'package:safify/widgets/image_utils.dart';

import '../../models/sub_location.dart';
import '../../models/incident_sub_type.dart';
import '../../models/incident_types.dart';
import '../../widgets/build_dropdown_menu_util.dart';
import '../../widgets/form_date_picker.dart';

import '../providers/incident_type_provider.dart';
import '../providers/location_provider.dart';
import '../providers/sub_location_provider.dart';
import '../../services/report_service.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  int selectedChipIndex = -1;
  List<bool> isSelected = [false, false, false];
  List<String> chipLabels = ['Low', 'High', 'Critical'];
  List<String> chipLabelsid = ['CRT1', 'CRT2', 'CRT3'];
  String incidentType = '';
  String incidentSubType = '';
  List<String> dropdownMenuEntries = [];
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  bool _confirmedExit = false;
  bool isFirstLocationDropdownSelected = false;
  XFile? _imageFile;
  final ImageUtils _imageService = ImageUtils();
  bool _isEditing = false;
  ImageStream? _imageStream;
  bool isSubmitting = false;
  String? selectedAssetType = '';
  String? selectedAssetSubType = '';
  String? searchQuery = '';

  void _processData() {
    if (mounted) {
      setState(() {
        _formKey.currentState?.reset();
      });
    }
  }

  Color? _getSelectedColor(int index) {
    if (isSelected[index]) {
      if (index == 0) {
        return Colors.greenAccent;
      } else if (index == 1) {
        return Colors.orangeAccent;
      } else if (index == 2) {
        return Colors.redAccent;
      }
    }
    return null;
  }

  int id = 0; // auto-generated
  //String location = '';
  String description = '';
  DateTime date = DateTime.now();
  bool status =
      false; // how to update, initially false, will be changed by admin.
  String risklevel = '';
  String title = "PPE Violation";
  String? SelectedIncidentType;
  String? SelectedLocationType;
  String SelectedSubLocationType = '';
  XFile? returnedImage;
  bool isRiskLevelSelected = false;
  ImageUtils imageUtils = ImageUtils();
  DropdownMenuItem<String> buildIncidentMenuItem(IncidentType type) {
    return DropdownMenuItemUtil.buildDropdownMenuItem<IncidentType>(
        type, type.incidentTypeId, type.incidentTypeDescription
        // Add the condition to check if it's selected based on your logic
        );
  }

  DropdownMenuItem<String> buildSubIncidentMenuItem(IncidentSubType type) {
    return DropdownMenuItemUtil.buildDropdownMenuItem<IncidentSubType>(
        type, type.incidentSubtypeId, type.incidentSubtypeDescription
        // Add the condition to check if it's selected based on your logic
        );
  }

  DropdownMenuItem<String> buildLocationMenuItem(Location type) {
    return DropdownMenuItemUtil.buildDropdownMenuItem<Location>(
        type, type.locationId, type.locationName
        // Add the condition to check if it's selected based on your logic
        );
  }

  DropdownMenuItem<String> buildSubLocationMenuItem(SubLocation type) {
    return DropdownMenuItemUtil.buildDropdownMenuItem<SubLocation>(
        type, type.sublocationId, type.sublocationName);
  }

  DropdownMenuItem<String> buildAssetMenuItem(AssetType type) {
    return DropdownMenuItemUtil.buildDropdownMenuItem<AssetType>(
        type, type.assetTypeId.toString(), type.assetTypeDesc);
  }

  DropdownMenuItem<String> buildSubAssetMenuItem(Asset type) {
    return DropdownMenuItemUtil.buildDropdownMenuItem<Asset>(type,
        type.assetNo.toString() ?? 'n/a', type.assetName.toString() ?? 'n/a');
  }

  void _editImage() {
    setState(() {
      _isEditing = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<LocationProviderClass>(context, listen: false)
          .fetchLocations();
      if (SelectedLocationType != null) {
        Provider.of<SubLocationProviderClass>(context, listen: false)
            .getSubLocationPostData(SelectedLocationType!);
      }

      Provider.of<AssetProviderClass>(context, listen: false).loadAllAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_confirmedExit) {
          // If the exit is confirmed, replace the current route with the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage2()),
          );
          return false; // Prevent the user from going back
        } else {
          // Show the confirmation dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Exit'),
              content: const Text(
                  'Do you want to leave this page? Any unsaved changes will be lost.'),
              actions: [
                TextButton(
                  onPressed: () {
                    // If the user confirms, set _confirmedExit to true and pop the dialog
                    setState(() {
                      _confirmedExit = true;
                    });

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage2()),
                    );
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    // If the user cancels, do nothing and pop the dialog
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          );
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).secondaryHeaderColor),
            onPressed: () {
              // Add your navigation logic here, such as pop or navigate back
              Navigator.of(context).pop();
            },
          ),
          title: Text("Register Ticket",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).secondaryHeaderColor,
              )),
          actions: [
            IconButton(
              icon: Image.asset('assets/images/safify_icon.png'),
              onPressed: () {
                // Handle settings button press
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.05,
              vertical: MediaQuery.sizeOf(context).height * 0.02),
          child: Form(
            key: _formKey,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormDatePicker(
                                  date: date,
                                  onChanged: (newDateTime) {
                                    // Handle the updated date
                                    setState(() {
                                      date = newDateTime;
                                    });
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Divider(
                                    thickness: 1,
                                    color: Theme.of(context).highlightColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Associate Asset',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        '*',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                Consumer<AssetProviderClass>(
                                  builder: (context, assetProvider, child) {
                                    if (assetProvider.loading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller: _searchController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Search Asset',
                                                    prefixIcon:
                                                        Icon(Icons.search),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  onChanged: (query) {
                                                    setState(() {
                                                      searchQuery = query;
                                                    });
                                                  },
                                                  onTap: () {
                                                    assetProvider
                                                        .setSearchFocus(true);
                                                  },
                                                  onEditingComplete: () {
                                                    assetProvider
                                                        .setSearchFocus(false);
                                                  },
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.filter_list,
                                                  color: Theme.of(context)
                                                      .secondaryHeaderColor,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        SimpleDialog(
                                                      title: Text(
                                                          'Select Asset Type'),
                                                      children: assetProvider
                                                                  .assetTypeList !=
                                                              null
                                                          ? assetProvider
                                                              .assetTypeList!
                                                              .map((type) =>
                                                                  SimpleDialogOption(
                                                                    onPressed:
                                                                        () {
                                                                      assetProvider.setSelectedAssetType(type
                                                                          .assetTypeId
                                                                          .toString());
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        type.assetTypeDesc),
                                                                  ))
                                                              .toList()
                                                          : [
                                                              Text(
                                                                  'No asset types available')
                                                            ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          // if (!assetProvider.getSearchFocused())
                                          //   Image.asset(
                                          //     'assets/images/check-list.png',
                                          //     width: MediaQuery.of(context)
                                          //             .size
                                          //             .width *
                                          //         0.2,
                                          //     height: MediaQuery.of(context)
                                          //             .size
                                          //             .width *
                                          //         0.2,
                                          //   ),
                                          // const SizedBox(height: 10),
                                          if (assetProvider.getSearchFocused())
                                            Container(
                                              height:
                                                  200, // Adjust height as needed
                                              child: ListView(
                                                children: assetProvider
                                                    .getFilteredAssets()
                                                    .where((asset) =>
                                                        searchQuery == null ||
                                                        searchQuery!.isEmpty ||
                                                        (asset.assetName !=
                                                                null && // Check for non-null value
                                                            asset.assetName!
                                                                .isNotEmpty && // Check for non-empty string
                                                            asset.assetName!
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchQuery!
                                                                        .toLowerCase())))
                                                    .map((asset) => ListTile(
                                                          title: Text(
                                                              asset.assetName!),
                                                          onTap: () {
                                                            assetProvider
                                                                .setSelectedAssetSubtype(
                                                                    asset
                                                                        .assetNo);
                                                            _searchController
                                                                .text = asset
                                                                    .assetName ??
                                                                '';
                                                            assetProvider
                                                                .setSearchFocus(
                                                                    false);
                                                            setState(() {});
                                                          },
                                                          selected: assetProvider
                                                                  .selectedAssetSubtype ==
                                                              asset.assetNo,
                                                        ))
                                                    .toList(),
                                              ),
                                            ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 12),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Where are you located?',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          '*',
                                          style: TextStyle(
                                            color: Colors
                                                .red, // Set the asterisk color to red
                                          ),
                                        ),
                                      ],
                                    )),
                                Consumer<LocationProviderClass>(
                                  builder: (context, selectedVal, child) {
                                    if (selectedVal.loading) {
                                      return const Center(
                                        child:
                                            CircularProgressIndicator(), // Display a loading indicator
                                      );
                                    } else {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .highlightColor),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: FormField<String>(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Location is required';
                                            }
                                            return null;
                                          },
                                          builder:
                                              (FormFieldState<String> state) {
                                            return DropdownButton<String>(
                                              value:
                                                  selectedVal.selectedLocation,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              isExpanded: true,
                                              icon: Icon(Icons.arrow_drop_down,
                                                  color: Theme.of(context)
                                                      .secondaryHeaderColor),
                                              underline: Container(),
                                              items: [
                                                DropdownMenuItem<String>(
                                                  value:
                                                      null, // Placeholder value
                                                  child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 8.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Support Location',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .secondaryHeaderColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 14),
                                                          ),
                                                          const Text(
                                                            '*',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .red, // Set the asterisk color to red
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                if (selectedVal.allLocations !=
                                                    null)
                                                  ...selectedVal.allLocations!
                                                      .map((type) {
                                                    return buildLocationMenuItem(
                                                        type);
                                                  }).toList(),
                                              ],
                                              onChanged: (v) {
                                                selectedVal.setLocation(v);
                                                //    incidentType = v!;
                                                SelectedLocationType = v!;
                                                Provider.of<SubLocationProviderClass>(
                                                        context,
                                                        listen: false)
                                                    .selectedSubLocation = null;
                                                Provider.of<SubLocationProviderClass>(
                                                        context,
                                                        listen: false)
                                                    .getSubLocationPostData(v);
                                                isFirstLocationDropdownSelected =
                                                    v != null;
                                                setState(() {});
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (isFirstLocationDropdownSelected)
                                  Consumer<SubLocationProviderClass>(
                                      builder: (context, selectedValue, child) {
                                    if (SelectedLocationType != null) {
                                      if (selectedValue.loading) {
                                        return const Center(
                                          child:
                                              CircularProgressIndicator(), // Display a loading indicator
                                        );
                                      } else {
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .hintColor),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: FormField<String>(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Sub Location is required';
                                              }
                                              return null;
                                            },
                                            builder:
                                                (FormFieldState<String> state) {
                                              return DropdownButton<String>(
                                                value: selectedValue
                                                    .selectedSubLocation,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .secondaryHeaderColor,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                isExpanded: true,
                                                icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Theme.of(context)
                                                        .secondaryHeaderColor),
                                                underline: Container(),
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value:
                                                        null, // Placeholder value
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 8.0),
                                                      child: Text(
                                                        'Sub Location',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .secondaryHeaderColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ),
                                                  if (selectedValue
                                                          .subLocations !=
                                                      null)
                                                    ...selectedValue
                                                        .subLocations!
                                                        .map((type) {
                                                      print(type);
                                                      return buildSubLocationMenuItem(
                                                          type);
                                                    }).toList(),
                                                ],
                                                onChanged: (v) {
                                                  selectedValue
                                                      .setSubLocationType(v);
                                                  SelectedSubLocationType = v!;
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    } else {
                                      return const Text(
                                          'Please select a location first',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ));
                                    }
                                  }),
                                const Padding(
                                  padding: EdgeInsets.only(left: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22, vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment
                                        .centerLeft, // Align the text to the left

                                    child: Text(
                                      'Add image of the issue',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 22.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Builder(builder: (context) {
                                          return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              _showBottomSheet();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.image),
                                                  Text(_imageFile != null
                                                      ? '  Image Added'
                                                      : ' Add Image'),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Description',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextFormField(
                                  controller: _textFieldController,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Describe the issue in a few words',
                                    fillColor: Colors.blue,
                                    labelStyle: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).hintColor),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.green),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  onChanged: (value) =>
                                      setState(() => description = value),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'How critical is the issue?',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        ' (required)',
                                        style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children:
                                      List.generate(chipLabels.length, (index) {
                                    return ChoiceChip(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: isSelected[index]
                                              ? Colors.transparent
                                              : Theme.of(context).hintColor,
                                          width:
                                              1.0, // Set your desired border width
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            20.0), // Set your desired border radius
                                      ),
                                      backgroundColor: isSelected[index]
                                          ? null
                                          : Colors.white,
                                      label: Text(
                                        chipLabels[index],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      selected: isSelected[index],
                                      selectedColor: _getSelectedColor(index),
                                      onSelected: (bool selected) {
                                        setState(() {
                                          for (int i = 0;
                                              i < isSelected.length;
                                              i++) {
                                            isSelected[i] =
                                                i == index ? selected : false;
                                            risklevel = chipLabelsid[index];
                                          }
                                          isRiskLevelSelected = true;
                                        });
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        OverflowBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text('CANCEL',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                )),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              //_formKey.currentState!.validate()
                              onPressed: isSubmitting
                                  ? null
                                  : () async {
                                      if (isFirstLocationDropdownSelected &&
                                          isRiskLevelSelected &&
                                          // (incidentSubType != '') &&
                                          (SelectedSubLocationType != '') &&
                                          (selectedAssetSubType != '')) {
                                        print("pressed");
                                        int flag = await handleReportSubmitted(
                                            context, this, _imageFile);
                                        if (flag == 1) {
                                          // Show loading indicator
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              content: const Text(
                                                  'Report Submitted'),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ));

                                            await Provider.of<
                                                        UserReportsProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchReports(context)
                                                .then((_) {
                                              // Fetch reports completed, proceed with other tasks
                                              setState(() {
                                                _imageFile = null;
                                                Provider.of<IncidentProviderClass>(
                                                            context,
                                                            listen: false)
                                                        .selectedIncidentType =
                                                    null;
                                                Provider.of<LocationProviderClass>(
                                                        context,
                                                        listen: false)
                                                    .selectedLocation = null;
                                              });
                                              _processData();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomePage2()),
                                              );
                                            });
                                          } else {
                                            throw Exception("not mounted");
                                          }
                                        } else if (flag == 4) {
                                          Navigator.pop(context);

                                          ToastService.showLocallySavedSnackBar(
                                              context);

                                          return;
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              content: const Text(
                                                  'Failed to Submit Report'),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text(
                                                'Please fill in all required fields'),
                                          ),
                                        );
                                      }
                                    },
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: isSubmitting
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Submitting',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SizedBox(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.02,
                                              width: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.02,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        )
                                      : const Text(
                                          'Submit',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
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

  Future _pickImageFromGallery() async {
    XFile? returnedImage1 =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage1 != null) {
      setState(() {
        _imageFile = returnedImage1;
      });
      Fluttertoast.showToast(msg: 'Image selected');
    }
  }

  Future _pickImageFromCamera() async {
    XFile? returnedImage1 =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage1 != null) {
      setState(() {
        _imageFile = returnedImage1;
      });
      Fluttertoast.showToast(msg: 'Image captured');
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height * .03,
                bottom: MediaQuery.sizeOf(context).height * .05),
            children: [
              //pick profile picture label
              Text('Add Image',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).secondaryHeaderColor)),

              //for adding some space
              SizedBox(height: MediaQuery.sizeOf(context).height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.sizeOf(context).width * .3,
                              MediaQuery.sizeOf(context).height * .15)),
                      onPressed: () async {
                        _pickImageFromCamera();
                        // _pickImageCamera(context);
                      },
                      child: Image.asset('assets/images/camera.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.sizeOf(context).width * .3,
                              MediaQuery.sizeOf(context).height * .15)),
                      onPressed: () async {
                        _pickImageFromGallery();
                        // _pickImageGallery(context);
                      },
                      child: Image.asset('assets/images/add_image.png')),
                ],
              )
            ],
          );
        });
  }

  Future<int> handleReportSubmitted(BuildContext context,
      _UserFormState userFormState, XFile? selectedImage) async {
    setState(() {
      isSubmitting = true;
    });
    DatabaseHelper databaseHelper = DatabaseHelper();
    var maps = await databaseHelper.getAllUserReports();

    for (var map in maps) {
      print(map);
    }

    final pingSuccess = await ping_google();

    if (!pingSuccess) {
      final tempImgPath = selectedImage != null
          ? await saveImageTempLocally(File(_imageFile!.path))
          : null;

      final userFormReport = UserReportFormDetails(
          sublocationId: userFormState.SelectedSubLocationType,
          // incidentSubtypeId: userFormState.incidentSubType,
          description: userFormState.description,
          date: userFormState.date,
          criticalityId: userFormState.risklevel,
          imagePath: tempImgPath,
          assetNo: userFormState.selectedAssetSubType!);

      final dbHelper = DatabaseHelper();
      await dbHelper.insertUserFormReport(userFormReport);
      setState(() {
        isSubmitting = false;
      });
      print("Failed to send, report saved locally");
      return 4;
    }

    if (selectedImage != null) {
      // image attached

      try {
        ReportServices reportServices = ReportServices();
        int flag = await reportServices.uploadReportWithImage(
            userFormState._imageFile?.path,
            userFormState.SelectedSubLocationType,
            // userFormState.incidentSubType,
            userFormState.description,
            userFormState.date,
            userFormState.risklevel,
            userFormState.selectedAssetSubType!);
        setState(() {
          isSubmitting = false;
        });

        return flag;
      } catch (e) {
        final tempImgPath = await saveImageTempLocally(File(_imageFile!.path));

        final userFormReport = UserReportFormDetails(
            sublocationId: userFormState.SelectedSubLocationType,
            // incidentSubtypeId: userFormState.incidentSubType,
            description: userFormState.description,
            date: userFormState.date,
            criticalityId: userFormState.risklevel,
            imagePath: tempImgPath,
            assetNo: userFormState.selectedAssetSubType!);

        final dbHelper = DatabaseHelper();
        await dbHelper.insertUserFormReport(userFormReport);
        setState(() {
          isSubmitting = false;
        });
        print("Failed to send, report saved locally");
        return 4;
      }
    } else {
      // no image
      try {
        ReportServices reportServices = ReportServices();
        int flag = await reportServices.postReport(
            userFormState.SelectedSubLocationType,
            //userFormState.incidentSubType,
            userFormState.description,
            userFormState.date,
            userFormState.risklevel,
            userFormState.selectedAssetSubType!);
        setState(() {
          isSubmitting = false;
        });
        return flag;
      } catch (e) {
        final userFormReport = UserReportFormDetails(
            sublocationId: userFormState.SelectedSubLocationType,
            // incidentSubtypeId: userFormState.incidentSubType,
            description: userFormState.description,
            date: userFormState.date,
            criticalityId: userFormState.risklevel,
            imagePath: null,
            assetNo: userFormState.selectedAssetSubType!);
        final dbHelper = DatabaseHelper();
        await dbHelper.insertUserFormReport(userFormReport);
        setState(() {
          isSubmitting = false;
        });
        print("Failed to send, report saved locally");
        return 4;
      }
    }
  }
}
