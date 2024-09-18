
class CountReported {
  final int incidents_reported;

  const CountReported({
    required this.incidents_reported
    });
    
    factory CountReported.fromJson(Map<String, dynamic> json) {
      return CountReported(
       incidents_reported: json['incidents_reported'],
        );
        
    }
}

