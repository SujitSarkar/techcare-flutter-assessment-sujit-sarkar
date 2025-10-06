import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker/core/constants/app_strings.dart';
import 'package:finance_tracker/core/theme/app_theme.dart';
import 'package:finance_tracker/core/config/dio_config.dart';
import 'package:finance_tracker/core/utils/network_connection.dart';
import 'package:finance_tracker/data/datasources/analytics_remote_datasource.dart';
import 'package:finance_tracker/data/datasources/category_local_datasource.dart';
import 'package:finance_tracker/data/datasources/transaction_local_datasource.dart';
import 'package:finance_tracker/data/datasources/category_remote_datasource.dart';
import 'package:finance_tracker/data/datasources/transaction_remote_datasource.dart';
import 'package:finance_tracker/data/repositories/analytics_repository_impl.dart';
import 'package:finance_tracker/data/repositories/category_repository_impl.dart';
import 'package:finance_tracker/data/repositories/transaction_repository_impl.dart';
import 'package:finance_tracker/domain/repositories/analytics_repository.dart';
import 'package:finance_tracker/domain/repositories/category_repository.dart';
import 'package:finance_tracker/domain/repositories/transaction_repository.dart';
import 'package:finance_tracker/domain/usecases/get_analytics.dart';
import 'package:finance_tracker/domain/usecases/get_categories.dart';
import 'package:finance_tracker/domain/usecases/get_transactions.dart';
import 'package:finance_tracker/domain/usecases/add_transaction.dart';
import 'package:finance_tracker/domain/usecases/update_transaction.dart';
import 'package:finance_tracker/domain/usecases/delete_transaction.dart';
import 'package:finance_tracker/presentation/analytics/bloc/analytics_bloc.dart';
import 'package:finance_tracker/presentation/bottom_nav_bar/bloc/bottom_nav_bar_bloc.dart';
import 'package:finance_tracker/presentation/bottom_nav_bar/pages/bottom_nav_bar.dart';
import 'package:finance_tracker/presentation/category/bloc/category_bloc.dart';
import 'package:finance_tracker/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:finance_tracker/presentation/transactions/bloc/transactions_bloc.dart';

class TakeHomeApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const TakeHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepositoryImpl(
            remoteDataSource: CategoryRemoteDataSourceImpl(dio: DioConfig.instance),
            localDataSource: CategoryLocalDataSourceImpl(),
            networkConnection: NetworkConnection(),
          ),
        ),
        RepositoryProvider<TransactionRepository>(
          create: (context) => TransactionRepositoryImpl(
            remoteDataSource: TransactionRemoteDataSourceImpl(dio: DioConfig.instance),
            localDataSource: TransactionLocalDataSourceImpl(),
            networkConnection: NetworkConnection(),
          ),
        ),
        RepositoryProvider<AnalyticsRepository>(
          create: (context) => AnalyticsRepositoryImpl(
            remoteDataSource: AnalyticsRemoteDataSourceImpl(dio: DioConfig.instance),
            networkConnection: NetworkConnection(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavBarBloc>(create: (context) => BottomNavBarBloc()),
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(getCategories: GetCategories(context.read<CategoryRepository>())),
          ),
          BlocProvider<TransactionsBloc>(
            create: (context) => TransactionsBloc(
              getTransactions: GetTransactions(repository: context.read<TransactionRepository>()),
              addTransaction: AddTransaction(repository: context.read<TransactionRepository>()),
              updateTransaction: UpdateTransaction(repository: context.read<TransactionRepository>()),
              deleteTransaction: DeleteTransaction(repository: context.read<TransactionRepository>()),
            ),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
              getTransactions: GetTransactions(repository: context.read<TransactionRepository>()),
              getCategories: GetCategories(context.read<CategoryRepository>()),
              transactionsBloc: context.read<TransactionsBloc>(),
            ),
          ),

          BlocProvider<AnalyticsBloc>(
            create: (context) =>
                AnalyticsBloc(getAnalytics: GetAnalytics(repository: context.read<AnalyticsRepository>())),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: AppStrings.appName,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.lightTheme,
          themeMode: ThemeMode.light,
          home: const BottomNavBar(),
        ),
      ),
    );
  }
}
