class AppUrls {
  static const String baseUrl = "https://hr.digitalmandee.com/api/";
  static const String logIn = "login";
  static const String logOut = "logout";
  static const String markAttendence = "employee/attendance/store";
  static const String checkOut = "employee/attendance/checkout";
  static const String getEmpProfile = "profile/user-profile/index";
  static const String updateProfile = "profile/user-profile";
  static const String getLeaveTypes = "employee/leave_categories/index";
  static const String requestLeave = "employee/leave_application/store";
  static const String getLeavesQuota = "employee/leave_application/index";
  static const String getAttendences = "employee/attendance/report";
  static const String getNotices = "employee/notice/show";
  static const String getEvents = "personal_events";
  static const String getHodEmployees = "hod/employees";
  static const String getEmployeeLeaveRequests =
      "hod/employee/leave_application";
  static const String getHREmployeeLeaveRequests =
      "/hr/employee/leave_application/accept-by-hod";
  static const String approvedByHod = "hod/employee/leave_application/approved";
  static const String rejectByHod =
      "hod/employee/leave_application/not_approved";
  static const String approvedByHr =
      "/hr/employee/leave_application/approved-by-hr";
  static const String rejectByHr =
      "/hr/employee/leave_application/reject-by-hr";
}
