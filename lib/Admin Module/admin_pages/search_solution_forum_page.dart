import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safify/Admin%20Module/providers/search_solution_forum_provider.dart';
import '../../models/search_solution_forum.dart';

class SearchSolutionForum extends StatefulWidget {
  const SearchSolutionForum({super.key});

  @override
  State<SearchSolutionForum> createState() => _SearchSolutionForumState();
}

class _SearchSolutionForumState extends State<SearchSolutionForum> {
  final TextEditingController searchController = TextEditingController();
  String actionTeam = '';
  List<SolutionForum> filteredSolutionForums = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<SearchSolutionForumProvider>(context, listen: false)
          .getAllSolutionForumData();
      filterActionTeams(''); // Initially load all solution forums
    });
  }

  // Filter solution forums based on the search query
  void filterActionTeams(String query) {
    final allSolutionForums =
        Provider.of<SearchSolutionForumProvider>(context, listen: false)
                .solutionForum ??
            [];
    setState(() {
      filteredSolutionForums = allSolutionForums.where((team) {
        final matchesQuery =
            team.problem.toLowerCase().contains(query.toLowerCase());
        return matchesQuery;
      }).toList();
    });
  }

  void showStepsModal(SolutionForum forum) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.43, // Set height to 70% of the screen height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Steps',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Expanded(
                child: forum.steps.isNotEmpty
                    ? ListView.builder(
                        itemCount: forum.steps.length,
                        itemBuilder: (context, index) {
                          final step = forum.steps[index];
                          bool isLastStep = index == forum.steps.length - 1;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  // Circle with step number
                                  CircleAvatar(
                                    radius: 12, // Adjust size as needed
                                    backgroundColor:
                                        Colors.blue, // Customize as needed
                                    child: Text(
                                      '${index + 1}', // Step number
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  if (!isLastStep) ...[
                                    // Connecting vertical line for all except the last step
                                    Container(
                                      width: 2, // Line width
                                      height: 40, // Line height
                                      color: Colors.blue, // Customize as needed
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(width: 10),
                              // Step key and value
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step.stepValue, // Step title/key
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Text(step
                                    //     .stepValue), // Step value/description
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : const Center(child: Text('No steps available')),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchSolutionForumProvider>(context);
    final isLoading = provider.loading;
    final solutionForums = provider.solutionForum ?? [];

    return WillPopScope(
      onWillPop: () async {
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
              'Solution Forum',
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
                      const Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Find a quick solution",
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
                          hintText: 'Search problem...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Show loading spinner while fetching data
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (solutionForums.isEmpty)
                        const Center(child: Text('No solutions available'))
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredSolutionForums.isNotEmpty
                                ? filteredSolutionForums.length
                                : solutionForums.length,
                            itemBuilder: (context, index) {
                              final forum = filteredSolutionForums.isNotEmpty
                                  ? filteredSolutionForums[index]
                                  : solutionForums[index];
                              return Card(
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        // horizontal:
                                        //     MediaQuery.of(context).size.width * 0.0,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Problem Section
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.error_outline,
                                                    color: Colors.redAccent),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02),
                                                Expanded(
                                                  child: Text(
                                                    forum.problem,
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // Divider between Problem and Solution
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0),
                                              child: Divider(thickness: 1),
                                            ),

                                            // Solution Section
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                    Icons.lightbulb_outline,
                                                    color: Colors.green),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    forum.solution ??
                                                        'No solution available',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // "View Steps" Button
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: TextButton(
                                                child: const Text(
                                                  'View resolution steps',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent),
                                                ),
                                                onPressed: () =>
                                                    showStepsModal(forum),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () => showStepsModal(forum),
                                      )));
                            },
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
