
class APIpath{
  static String report(String uid, String reportid) => '/users/$uid/reports/$reportid';
  static String reports(String uid) => '/users/$uid/reports';
}