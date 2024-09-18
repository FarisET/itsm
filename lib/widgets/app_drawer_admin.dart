import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/admin_pages/add_incident_type_page.dart';
import 'package:safify/Admin%20Module/admin_pages/add_location_page.dart';
import 'package:safify/Admin%20Module/admin_pages/add_subincident_type.dart';
import 'package:safify/Admin%20Module/admin_pages/add_sublocation_page.dart';
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
                ListTile(
                  horizontalTitleGap: 0,
                  leading: Icon(Icons.person_add_outlined,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'Add User',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: mainHeaderSize,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  onTap: () {
                    // Navigate to Add User page
                    Navigator.pushNamed(context, '/create_user_form');
                  },
                ),
                ExpansionTile(
                  // horizontalTitleGap: 0,
                  leading: Icon(Icons.location_on_outlined,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'Add Location',
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
                          Icon(Icons.add,
                              color: Theme.of(context).secondaryHeaderColor),
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
                            'Add SubLocation',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: mainHeaderSize,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          Icon(Icons.add,
                              color: Theme.of(context).secondaryHeaderColor),
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
                  leading: Icon(Icons.type_specimen_outlined,
                      color: Theme.of(context).secondaryHeaderColor),
                  title: Text(
                    'Add Category',
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
                            'Add Incident Type',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: mainHeaderSize,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.add,
                              color: Theme.of(context).secondaryHeaderColor),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddIncidentTypePage()));
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Text(
                            'Add Incident Subtype',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: mainHeaderSize,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.add,
                              color: Theme.of(context).secondaryHeaderColor),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddSubIncidentTypePage()));
                        // Navigate to Add Incident Subtype page
                        //  Navigator.pushNamed(context, '/addIncidentSubtype');
                      },
                    ),
                  ],
                  // onTap: () {
                  //   // ExpansionTile()
                  //   // Navigate to Add Category page
                  //   //  Navigator.pushNamed(context, '/addCategory');
                  // },
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
                    // Navigate to Add Category page
                    //  Navigator.pushNamed(context, '/addCategory');
                    final pdfService = PDFDownloadService();
                    // await pdfService.downloadPDF(
                    //     'https://api.arya.ai/images/test.pdf', "dummy.pdf");
                    // // await Future.delayed(Duration(seconds: 1));
                    // print("Download PDF");
                    // await pdfService.getPdf(null, null, null);
                    // Navigator.of(context).pop();
                    await _showDateInputDialog(context, pdfService);
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
              ],
            ),
          ),
          const Divider(),
          ListTile(
            horizontalTitleGap: 0,
            leading: Icon(Icons.settings_outlined,
                color: Theme.of(context).secondaryHeaderColor),
            title: Text(
              'Settings',
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
