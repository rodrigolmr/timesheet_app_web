class AppRoutes {
  // Paths (usados em redirecionamentos e URLs)
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/';
  static const String debug = '/debug';
  static const String test = '/test';
  static const String layoutTest = '/layout-test';
  static const String buttonShowcase = '/button-showcase';
  static const String feedbackShowcase = '/feedback-showcase';
  static const String timesheets = '/timesheets';
  static const String timesheetNew = '/timesheets/new';
  static const String timesheetView = '/timesheets/view/:id';
  static const String timesheetEdit = '/timesheets/edit/:id';

  // Route names (usados na navegação por nome)
  static const String homeName = 'home';
  static const String loginName = 'login';
  static const String debugName = 'debug';
  static const String testName = 'test';
  static const String layoutTestName = 'layout-test';
  static const String buttonShowcaseName = 'button-showcase';
  static const String feedbackShowcaseName = 'feedback-showcase';
  static const String timesheetsName = 'timesheets';
  static const String timesheetNewName = 'timesheet-new';
  static const String timesheetViewName = 'timesheet-view';
  static const String timesheetEditName = 'timesheet-edit';

  // Métodos helpers para navegação
  static String getTimesheetViewPath(String id) => '/timesheets/view/$id';
  static String getTimesheetEditPath(String id) => '/timesheets/edit/$id';
}
