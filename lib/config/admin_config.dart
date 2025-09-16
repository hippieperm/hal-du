class AdminConfig {
  static const List<String> adminEmails = [
    'admin@haldo.kr',
    'team@haldo.kr',
  ];
  
  static bool isAdminEmail(String email) {
    return adminEmails.contains(email.toLowerCase());
  }
}