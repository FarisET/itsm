
class CountResolved {
  final String? incidents_resolved;

  const CountResolved({
    required this.incidents_resolved
    });
    
    factory CountResolved.fromJson(Map<String, dynamic> json) {
      return CountResolved(
       incidents_resolved: json['incidents_resolved'] ?? '',
        );
        
    }
}

