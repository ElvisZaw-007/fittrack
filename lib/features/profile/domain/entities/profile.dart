enum UnitPreference { metric, imperial }

class Profile {
  final String userId;
  final String name;
  final int age;
  final double heightCm;
  final UnitPreference unitPreference;

const Profile({
    required this.userId,
    required this.name,
    required this.age,
    required this.heightCm,
    required this.unitPreference,
  });
}
