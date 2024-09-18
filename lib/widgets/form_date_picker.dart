import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const FormDatePicker({
    super.key,
    required this.date,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                 Text(
                  'Date: ',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  intl.DateFormat('d MMMM y').format(widget.date),
                  style:  TextStyle(fontSize: 16, color: Theme.of(context).secondaryHeaderColor),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.01,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
              children: [
                 Text(
                  'Time: ',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  intl.DateFormat('h:mm a').format(widget.date),
                  style:  TextStyle(fontSize: 16, color: Theme.of(context).secondaryHeaderColor),
                )
              ],
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,      
          child: IconButton(
            icon: const Icon(Icons.edit,color: Colors.white,),
            onPressed: () async {
              var newDateTime = await showDatePicker(
                context: context,
                initialDate: widget.date,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
          
              if (newDateTime == null) {
                return;
              }
          
              final newTimeOfDay = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(widget.date),
              );
          
              if (newTimeOfDay == null) {
                return;
              }
          
              final combinedDateTime = DateTime(
                newDateTime.year,
                newDateTime.month,
                newDateTime.day,
                newTimeOfDay.hour,
                newTimeOfDay.minute,
              );
          
              widget.onChanged(combinedDateTime);
            },
          ),
        )
      ],
    );
  }
}
