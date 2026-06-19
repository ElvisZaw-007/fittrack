class AppUser {
  final String id;
  final String email;
  //V2=> final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    //V2=> required this.createdAt,
  });
}
