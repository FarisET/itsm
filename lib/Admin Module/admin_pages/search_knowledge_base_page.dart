import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/action_team.dart';
import '../providers/all_action_team_provider.dart';

class SearchKnowledgeBase extends StatefulWidget {
  const SearchKnowledgeBase({super.key});

  @override
  State<SearchKnowledgeBase> createState() => _SearchKnowledgeBaseState();
}

class _SearchKnowledgeBaseState extends State<SearchKnowledgeBase> {
  final TextEditingController searchController = TextEditingController();
  String actionTeam = '';
  List<ActionTeam> filteredActionTeams = [];
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AllActionTeamProviderClass>(context, listen: false)
          .fetchAllActionTeams();
      filterActionTeams(''); // Initially load all action teams
    });
  }

  // Filter action teams based on the search query
  void filterActionTeams(String query) {
    final allActionTeams =
        Provider.of<AllActionTeamProviderClass>(context, listen: false)
                .allActionTeams ??
            [];
    setState(() {
      filteredActionTeams = allActionTeams.where((team) {
        final matchesQuery =
            team.ActionTeam_Name.toLowerCase().contains(query.toLowerCase());
        return matchesQuery;
      }).toList();
    });
  }

  void _handleActionTeamSelected(String actionTeamName) {
    setState(() {
      actionTeam = actionTeamName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSubmitting) {
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).secondaryHeaderColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Search Knowledge Base',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Find a quick solution: $actionTeam",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Simple search bar
                      TextField(
                        controller: searchController,
                        onChanged: (value) => filterActionTeams(value),
                        decoration: InputDecoration(
                          hintText: 'Search action teams...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredActionTeams.length,
                          itemBuilder: (context, index) {
                            final actionTeam = filteredActionTeams[index];
                            return Card(
                              child: ListTile(
                                title: Text(actionTeam.ActionTeam_Name),
                                subtitle:
                                    Text(actionTeam.department_name ?? ''),
                                onTap: () {
                                  _handleActionTeamSelected(
                                      actionTeam.ActionTeam_Name);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            if (actionTeam != '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.blue,
                                  content:
                                      Text('Problem "$actionTeam" selected!'),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text(
                                      'Please select an action team first'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: const Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
