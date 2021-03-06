
class APIpath{
  static String report(String uid, String reportid) => '/users/$uid/reports/$reportid';
  static String reports(String uid) => '/users/$uid/reports';
  static String users() => '/users';
  static String user(String uid) => '/users/$uid';
  static String adminReport(String reportid) => '/reports/$reportid';
  static String adminReports() => '/reports';
  static String userString() => '/userReport';
  static String userReport(String uid) => '/userReport/$uid';
}