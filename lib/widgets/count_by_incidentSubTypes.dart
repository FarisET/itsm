// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../Admin Module/providers/fetch_countOfSubtypes_provider.dart';
// import '../models/count_incidents_by_subtype.dart';

// class CountByIncidentSubTypeList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<CountByIncidentSubTypes>>(
//  future: Provider.of<CountByIncidentSubTypesProviderClass>(context).getcountByIncidentSubTypesPostData(),     
//   builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // While data is loading, return a loading indicator or placeholder
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // If an error occurs during data fetching, handle it here
//           return Text('Error: ${snapshot.error}');
//         } else {
//           // Data has been successfully fetched, display it
//           List<CountByIncidentSubTypes> incidents = snapshot.data!;
//           return ListView.builder(
//             itemCount: incidents.length,
//             itemBuilder: (context, index) {
//               var incident = incidents[index];
//               return Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 child: ListTile(
//                   title: Text(incident.incident_type_description!),
//                   subtitle: Text('Total Cases: ${incident.incident_count}'),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
