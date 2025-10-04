class AppStrings {
  AppStrings._();

  static const String appName = 'Take Home';
  static const String home = 'Home';
  static const String analytics = 'Analytics';
  static const String transactions = 'Transactions';

  // Transaction Page
  static const String searchTransactionsHint = 'Search here...';
  static const String somethingWentWrong = 'Something went wrong';
  static const String retry = 'Retry';

  // Transaction Empty State
  static const String noTransactionsYet = 'No transactions yet';
  static const String noTransactionsDescription = 'Your transactions will appear here once you start adding them';

  // Transaction Item
  static const String income = 'Income';
  static const String expense = 'Expense';

  // Grouped Transactions List
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String dateFormatPattern = 'EEEE, MMMM dd, yyyy';

  // Filter Bottom Sheet
  static const String filter = 'Filter';
  static const String apply = 'Apply';
  static const String reset = 'Reset';
  static const String dateRange = 'Date Range';
  static const String categories = 'Categories';
  static const String amountRange = 'Amount Range';
  static const String transactionType = 'Transaction Type';
  static const String all = 'All';
  static const String customRange = 'Custom Range';
  static const String custom = 'Custom';
  static const String thisWeek = 'This Week';
  static const String thisMonth = 'This Month';
  static const String last3Months = 'Last 3 Months';
  static const String minAmount = 'Min Amount';
  static const String maxAmount = 'Max Amount';
  static const String activeFilters = 'Active Filters';

  // Date Validation
  static const String fromDateGreaterThanToDate = 'From date cannot be greater than To date';
  static const String toDateLessThanFromDate = 'To date cannot be less than From date';

  // Transaction Details Modal
  static const String transactionDetails = 'Transaction Details';
  static const String title = 'Title';
  static const String notAvailable = 'N/A';
  static const String dateAndTime = 'Date & Time';
  static const String category = 'Category';
  static const String noCategory = 'No category';
  static const String description = 'Description';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String deleteTransaction = 'Delete Transaction';
  static const String deleteConfirmationMessage =
      'Are you sure you want to delete this transaction? This action cannot be undone.';
  static const String cancel = 'Cancel';

  // Filter Bottom Sheet
  static const String from = 'From';
  static const String to = 'To';

  // Dashboard Page
  static const String dashboard = 'Dashboard';

  // Analytics Page
  static const String analyticsPage = 'Analytics';

  // Date Format Patterns
  static const String dateFormatWithTime = 'MMMM dd, yyyy • hh:mm a';
  static const String dateFormatShort = 'MMM dd, yyyy';
  static const String dateFormatShortWithTime = 'MMM dd, yyyy • hh:mm a';

  // Error Messages
  static const String failedToFetchCategories = 'Failed to fetch categories: ';
}
