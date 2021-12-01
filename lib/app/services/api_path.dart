
class APIpath{
  static String job(String uid, String reportid) => '/users/$uid/reports/$reportid';
  static String jobs(String uid) => '/users/$uid/reports';
}