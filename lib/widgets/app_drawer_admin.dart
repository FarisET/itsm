import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/admin_pages/add_asset_type_page.dart';
import 'package:safify/Admin%20Module/admin_pages/add_location_page.dart';
import 'package:safify/Admin%20Module/admin_pages/add_asset_page.dart';
import 'package:safify/Admin%20Module/admin_pages/add_sublocation_page.dart';
import 'package:safify/Admin%20Module/admin_pages/search_solution_forum_page.dart';
import 'package:safify/Admin%20Module/admin_pages/view_all_logs_page.dart';
import 'package:safify/Admin%20Module/admin_pages/view_asset_list.dart';
import 'package:safify/Admin%20Module/providers/announcement_provider.dart';
import 'package:safify/models/announcement_notif.dart';
import 'package:safify/services/pdf_download_service.dart';
import 'package:safify/widgets/pdf_download_dialog.dart';

// import 'package:fluent_ui/fluent_ui.dart' as fluent;
class AppDrawer extends StatelessWidget {
  final String? username;
  final double mainHeaderSize = 16;

  AppDrawer({required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.15,
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 24,
                    color: Theme.of(context).cardColor,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    username!,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ExpansionTile(
                    // horizontalTitleGap: 0,
                    leading: Icon(Icons.person_outline_outlined,
                        color: Theme.of(context).secondaryHeaderColor),
                    title: Text(
                      'Manage Users',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: mainHeaderSize,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Add User',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: mainHeaderSize,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined,
                                color: Theme.of(context).secondaryHeaderColor,
                                size:
                                    MediaQuery.of(context).size.width * 0.035),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/create_user_form');
                        },
                      ),
                      ListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'View Users',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: mainHeaderSize,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined,
                                color: Theme.of(context).secondaryHeaderColor,
                                size:
                                    MediaQuery.of(context).size.width * 0.035),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddLocationPage()));
                          // Navigate to Add Country page
                          //  Navigator.pushNamed(context, '/addCountry');
                        },
                      ),
                    ]),
                ExpansionTile(
                  // horizontalTitleGap: 0,
                  leading: Icon(Icons.location_on_outlined,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'Manage Locations',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: mainHeaderSize,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Add Location',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: mainHeaderSize,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).secondaryHeaderColor,
                              size: MediaQuery.of(context).size.width * 0.035),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddLocationPage()));
                        // Navigate to Add Country page
                        //  Navigator.pushNamed(context, '/addCountry');
                      },
                    ),
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Add Sub Location',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: mainHeaderSize,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).secondaryHeaderColor,
                              size: MediaQuery.of(context).size.width * 0.035),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddSublocationPage()));
                      },
                    ),
                  ],
                  // subtitle: const Text("Coming soon"),
                  // onTap: () {
                  //   // Navigate to Add Location page
                  //   //    Navigator.pushNamed(context, '/addLocation');
                  // },
                ),
                ExpansionTile(
                  // horizontalTitleGap: 0,
                  leading: Icon(Icons.label_important_outline,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'Manage Assets',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: mainHeaderSize,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  // subtitle: const Text("Coming soon"),
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Add Asset Type',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: mainHeaderSize,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).secondaryHeaderColor,
                              size: MediaQuery.of(context).size.width * 0.035),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddAssetTypePage()));
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Text(
                            'Add Asset',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: mainHeaderSize,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).secondaryHeaderColor,
                              size: MediaQuery.of(context).size.width * 0.035),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddAssetPage()));
                        // Navigate to Add Incident Subtype page
                        //  Navigator.pushNamed(context, '/addIncidentSubtype');
                      },
                    ),
                  ],
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(Icons.download_outlined,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'Download Report',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: mainHeaderSize,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () async {
                    final pdfService = PDFDownloadService();
                    await _showDateInputDialog(context, pdfService);
                  },
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(Icons.holiday_village_outlined,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'View Assets',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: mainHeaderSize,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ViewAsset()));
                  },
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(Icons.crisis_alert_outlined,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'Announcement',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: mainHeaderSize,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () {
                    _showAnnouncementDialog(context);
                  },
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(Icons.manage_search_outlined,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'Solution Forum',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: mainHeaderSize,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SearchSolutionForum()));
                  },
                ),
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(Icons.list_alt_outlined,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'View Logs',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: mainHeaderSize,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LogPage()));
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            horizontalTitleGap: 0,
            title: Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: mainHeaderSize,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            // subtitle: const Text("Coming soon"),
            onTap: () {
              // Navigate to Settings page
              //  Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDateInputDialog(
      BuildContext context, PDFDownloadService pdfDownloadService) async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return PDFdownloadDialog(pdfDownloadService: pdfDownloadService);
      },
    );
  }

  void _showAnnouncementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String body = '';

        return AlertDialog(
          title: const Text('Create Announcement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Alert Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Alert Body'),
                onChanged: (value) {
                  body = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                // Perform action to send the announcement
                _sendAnnouncement(context, title, body);
              },
            ),
          ],
        );
      },
    );
  }

  void _sendAnnouncement(BuildContext context, String title, String body) {
    final announcementProvider =
        Provider.of<AnnouncementProvider>(context, listen: false);

    // Create an Announcement object
    Announcement announcement = Announcement(
      messageTitle: title,
      messageBody: body,
    );

    // Call the provider method to send the announcement
    announcementProvider.sendAlert(announcement).then((_) {
      // Handle success, e.g., show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blue,
          content: Text('Announcement sent successfully'),
        ),
      );
    }).catchError((error) {
      // Handle error, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to send announcement'),
        ),
      );
    });
  }
}
