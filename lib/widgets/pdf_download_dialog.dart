import 'package:flutter/material.dart';
import 'package:safify/components/custom_button.dart';
import 'package:safify/services/pdf_download_service.dart';

class PDFdownloadDialog extends StatefulWidget {
  final PDFDownloadService pdfDownloadService;

  PDFdownloadDialog({required this.pdfDownloadService});

  @override
  _PDFdownloadDialogState createState() => _PDFdownloadDialogState();
}

class _PDFdownloadDialogState extends State<PDFdownloadDialog> {
  final _formKey = GlobalKey<FormState>();
  String day = '';
  String month = '';
  String year = '';
  bool isUserReport = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Center(
        child: Text(
          'Download Report',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Note: Please specify time period for the report. You can specify a day, month, or year. Press 'Get all' to get all reports so far.",
              style: TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.grey.shade600),
            ),
            Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Year (yyyy)',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => year = value,
                    validator: (value) {
                      if (double.tryParse(value!) == null) {
                        return 'Please enter a valid year';
                      }
                      if (value.isEmpty) {
                        return 'Please enter a year';
                      }
                      if (value.length != 4) {
                        return 'Please enter a valid year';
                      }
                      if (int.parse(value) > DateTime.now().year.toInt()) {
                        return 'Please enter a valid year';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Month (mm)',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => month = value,
                    validator: (value) {
                      if (month.isNotEmpty && double.tryParse(value!) == null) {
                        return 'Please enter a valid month';
                      }
                      if (month.isNotEmpty &&
                          (int.parse(month) < 1 || int.parse(month) > 12)) {
                        return 'Please enter a number between 1 and 12';
                      }
                      if (day.isNotEmpty && month.isEmpty) {
                        return 'Please enter a month';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Day (dd)',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => day = value,
                    validator: (value) {
                      if (day.isNotEmpty && double.tryParse(value!) == null) {
                        return 'Please enter a valid day';
                      }
                      if (day.isNotEmpty &&
                          (int.parse(day) < 1 || int.parse(day) > 31)) {
                        return 'Please enter a number between 1 and 31';
                      }
                      if (day.isNotEmpty &&
                          !isValidDate(int.tryParse(day), int.tryParse(month),
                              int.tryParse(year))) {
                        return 'Please enter a valid date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const Text("Select the type of report:"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Radio(
                              value: false,
                              groupValue: isUserReport,
                              onChanged: (value) {
                                setState(() {
                                  isUserReport = value as bool;
                                });
                              }),
                          const Flexible(child: Text('User Reports')),
                        ],
                      )),
                      Expanded(
                          child: Row(
                        children: [
                          Radio(
                              value: true,
                              groupValue: isUserReport,
                              onChanged: (value) {
                                setState(() {
                                  isUserReport = value as bool;
                                });
                              }),
                          const Flexible(child: Text('Action Reports')),
                        ],
                      )),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.04,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SimpleButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      buttonText: "Download",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.of(context).pop();
                          widget.pdfDownloadService.getPdf(
                            day.isEmpty ? null : day,
                            month.isEmpty ? null : month,
                            year.isEmpty ? null : year,
                            isUserReport,
                          );
                        }
                      }),
                  SimpleButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      buttonText: "Get All",
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.pdfDownloadService
                            .getPdf(null, null, null, isUserReport);
                      }),
                  SimpleButton(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    buttonText: 'Cancel',
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    backgroundColor: Colors.white,
                    border: Border.all(color: Colors.blue),
                    textColor: Colors.blue,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isValidDate(int? day, int? month, int? year) {
    if (day == null || month == null || year == null) {
      return false;
    }
    try {
      DateTime date = DateTime(year, month, day);
      return true;
    } catch (e) {
      return false;
    }
  }
}
