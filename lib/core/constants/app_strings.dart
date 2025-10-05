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
  static const String addIncome = 'Add Income';
  static const String addExpense = 'Add Expense';

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
  static const String totalBalance = 'Total Balance';
  static const String spendingOverview = 'Spending Overview';
  static const String recentTransactions = 'Recent Transactions';
  static const String viewAll = 'View All';

  // Analytics Page
  static const String analyticsPage = 'Analytics';

  // Date Format Patterns
  static const String dateFormatWithTime = 'MMMM dd, yyyy • hh:mm a';
  static const String dateFormatShort = 'MMM dd, yyyy';
  static const String dateFormatShortWithTime = 'MMM dd, yyyy • hh:mm a';

  // Error Messages
  static const String failedToFetchCategories = 'Failed to fetch categories: ';

  // Success Messages
  static const String transactionAddedSuccessfully = 'Transaction added successfully';
  static const String transactionUpdatedSuccessfully = 'Transaction updated successfully';
  static const String transactionDeletedSuccessfully = 'Transaction deleted successfully';

  // Currency
  static const String currencySymbol = 'BDT';

  // Add Transaction Screen
  static const String addTransaction = 'Add Transaction';
  static const String amount = 'Amount';
  static const String enterAmount = 'Enter amount';
  static const String transactionTypeIncome = 'Income';
  static const String transactionTypeExpense = 'Expense';
  static const String selectCategory = 'Select Category';
  static const String transactionTitle = 'Transaction Title';
  static const String enterTitle = 'Enter transaction title';
  static const String transactionDescription = 'Description (Optional)';
  static const String enterDescription = 'Enter description';
  static const String selectDate = 'Select Date';
  static const String selectTime = 'Select Time (Optional)';
  static const String save = 'Save';
  static const String saving = 'Saving...';

  // Edit Transaction Screen
  static const String editTransaction = 'Edit Transaction';
  static const String update = 'Update';
  static const String updating = 'Updating...';

  // Validation Messages
  static const String amountRequired = 'Amount is required';
  static const String amountMustBeGreaterThanZero = 'Amount must be greater than zero';
  static const String titleRequired = 'Title is required';
  static const String titleMaxLength = 'Title cannot exceed 100 characters';
  static const String descriptionMaxLength = 'Description cannot exceed 500 characters';
  static const String categoryRequired = 'Please select a category';
  static const String dateCannotBeInFuture = 'Date cannot be in the future';
  static const String invalidAmount = 'Please enter a valid amount';

  // Analytics Page
  static const String categoryBreakdown = 'Category Breakdown';
  static const String timePeriod = 'Time Period';
  static const String unknown = 'Unknown';
  static const String loadingAnalytics = 'Loading analytics...';
  static const String error = 'Error';
  static const String totalIncome = 'Total Income';
  static const String totalExpenses = 'Total Expenses';
  static const String netBalance = 'Net Balance';
  static const String spendingTrend = 'Spending Trend';
  static const String budgetProgress = 'Budget Progress';
}
