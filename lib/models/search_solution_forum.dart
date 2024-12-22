class SolutionForum {
  final String problem;
  final String solution;
  final String assetName;
  final String assetNo;
  final List<Step> steps;

  SolutionForum({
    required this.problem,
    required this.solution,
    required this.assetName,
    required this.assetNo,
    required this.steps,
  });

  factory SolutionForum.fromJson(Map<String, dynamic> json) {
    var stepsJson = json['steps'] as List;
    List<Step> stepsList =
        stepsJson.map((step) => Step.fromJson(step)).toList();

    return SolutionForum(
      problem: json['Problem'] ?? '',
      solution: json['Solution'] ?? '',
      assetName: json['Asset Name'] ?? '',
      assetNo: json['Asset Number'] ?? '',
      steps: stepsList,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'Problem': problem,
  //     'Solution': solution,
  //     'steps': steps.map((step) => step.toJson()).toList(),
  //   };
  // }
}

class Step {
  final String stepKey;
  final String stepValue;

  Step({required this.stepKey, required this.stepValue});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      stepKey: json.keys.first, // Get the key dynamically
      stepValue: json.values.first, // Get the value dynamically
    );
  }
}
