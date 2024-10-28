// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:safify/components/custom_button.dart';
// import 'package:safify/models/asset.dart';
// import 'package:safify/models/asset_type.dart';
// import 'package:safify/models/user_report.dart';
// import 'package:safify/utils/button_utils.dart';
// import 'package:safify/utils/string_utils.dart';

// class ViewAssettTile extends StatelessWidget {
//   final Asset asset;
//   const ViewAssettTile({super.key, required this.asset});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         // side: BorderSide(
//         //   // color: item.status!.contains('open')?Colors.redAccent:Colors.greenAccent,
//         //    width:1)),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 0.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Flexible(
//                             flex: 70,
//                             child: Text(
//                               asset.assetName!,
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           TextButton(
//                               onPressed: () {}, child: Text('View History'))
//                         ],
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         const Icon(Icons.holiday_village_outlined,
//                             color: Colors.black, size: 20),
//                         Text(' ${asset.assetNo}')
//                       ],
//                     ),
                   
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Icon(Icons.report_problem_outlined,
//                             color: Colors.black, size: 20),
//                         Expanded(
//                           child: Text(
//                             ' ${asset.assetIssueCount}',
//                             style: const TextStyle(
//                                 //  fontSize: 16
//                                 ),
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     SizedBox(
//                       height: 40,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ImageButton(
//                             height: double.infinity,
//                             onTap: () =>
//                                 handleImageButton(userReport.image, context),
//                           ),
//                           // ImageButton(
//                           //     height: double.infinity,
//                           //     //   width: MediaQuery.sizeOf(context).width *
//                           //     //      0.35,
//                           //     onTap: () {
//                           //       if (userReport.image != null) {
//                           //         showDialog(
//                           //           context: context,
//                           //           builder: (context) {
//                           //             return Dialog(
//                           //               child: SizedBox(
//                           //                 width: MediaQuery.of(context)
//                           //                     .size
//                           //                     .width, // 70% of screen width
//                           //                 height: MediaQuery.of(context)
//                           //                     .size
//                           //                     .height, // 70% of screen width (square box)
//                           //                 child: FittedBox(
//                           //                   fit: BoxFit
//                           //                       .contain, // Maintain aspect ratio, fit within the box
//                           //                   child: CachedNetworkImage(
//                           //                     imageUrl: '${userReport.image}',
//                           //                   ),
//                           //                 ),
//                           //               ),
//                           //             );
//                           //           },
//                           //         );
//                           //       } else {

//                           //         // showDialog(
//                           //         //   context: context,
//                           //         //   builder: (context) {
//                           //         //     return const Dialog(
//                           //         //       child: Column(
//                           //         //         mainAxisSize: MainAxisSize.min,
//                           //         //         children: [
//                           //         //           Text('No Image Added'),
//                           //         //         ],
//                           //         //       ),
//                           //         //     );
//                           //         //   },
//                           //         // );
//                           //       }
//                           //     }),
//                           userReport.status!.contains('completed')
//                               ? const Text('Completed',
//                                   style: TextStyle(
//                                       color: Colors.green,
//                                       fontWeight: FontWeight.bold))
//                               : userReport.status!.contains('in progress')
//                                   ? const Text('In progress',
//                                       style: TextStyle(
//                                           color: Colors.orange,
//                                           fontWeight: FontWeight.bold))
//                                   : Text(
//                                       '${capitalizeFirstLetter(userReport.status)}',
//                                       style: const TextStyle(
//                                           color: Colors.red,
//                                           fontWeight: FontWeight.bold))
//                         ],
//                       ),
//                     ),
//                   ]),
//             ],
//           ),
//         ));
//   }
// }
