import 'package:flutter/material.dart';
import 'package:safify/models/action_team.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearchChanged;
  final Function(String?) onFilterChanged;
  final List<String> filterOptions;
  final List<ActionTeam> actionTeams;
  final Function(String) onActionTeamSelected; // New callback function

  const CustomSearchBar({
    required this.controller,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.filterOptions,
    required this.actionTeams,
    required this.onActionTeamSelected, // New callback function
    Key? key,
  }) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  String? selectedFilter;
  bool showDropdown = false;

  void _showFilterDialog() async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Department'),
          content: DropdownButtonFormField<String>(
            value: selectedFilter,
            items: widget.filterOptions.map((String department) {
              return DropdownMenuItem<String>(
                value: department,
                child: Text(department),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, selectedFilter);
              },
              child: Text('Apply'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text('Clear'),
            ),
          ],
        );
      },
    );

    widget.onFilterChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FocusScope(
                onFocusChange: (hasFocus) {
                  setState(() {
                    showDropdown = hasFocus;
                  });
                },
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: 'Search Action Team',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: widget.onSearchChanged,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              tooltip: 'Filter',
              onPressed: _showFilterDialog,
            ),
          ],
        ),
        if (showDropdown)
          Card(
            elevation: 5,
            margin: EdgeInsets.only(top: 5),
            child: Container(
              height: 200,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: widget.actionTeams.length,
                  itemBuilder: (context, index) {
                    final actionTeam = widget.actionTeams[index];
                    return ListTile(
                      title: Text(actionTeam.ActionTeam_Name),
                      subtitle:
                          Text(actionTeam.department_name ?? 'No Department'),
                      onTap: () {
                        setState(() {
                          widget.controller.text = actionTeam.ActionTeam_Name;
                          showDropdown = false;
                        });
                        widget.onActionTeamSelected(
                            actionTeam.ActionTeam_ID); // Notify parent widget
                      },
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
