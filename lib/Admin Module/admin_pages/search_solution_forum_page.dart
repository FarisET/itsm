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
              'Search Solution Forum',
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
                          hintText: 'Search solutions...',
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
                                child: ListTile(
                                  title: Text(forum.problem),
                                  subtitle: Text(forum.solution ?? ''),
                                ),
                              );
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
