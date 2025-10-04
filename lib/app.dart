import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:take_home/core/constants/app_strings.dart';
import 'package:take_home/core/theme/app_theme.dart';
import 'package:take_home/core/config/dio_config.dart';

import 'package:take_home/data/datasources/category_remote_datasource.dart';
import 'package:take_home/data/repositories/category_repository_impl.dart';
import 'package:take_home/domain/repositories/category_repository.dart';
import 'package:take_home/domain/usecases/get_categories.dart';
import 'package:take_home/presentation/analytics/bloc/analytics_bloc.dart';
import 'package:take_home/presentation/bottom_nav_bar/bloc/bottom_nav_bar_bloc.dart';
import 'package:take_home/presentation/bottom_nav_bar/pages/bottom_nav_bar.dart';
import 'package:take_home/presentation/category/bloc/category_bloc.dart';
import 'package:take_home/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:take_home/presentation/transactions/bloc/transactions_bloc.dart';

class TakeHomeApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const TakeHomeApp({super.key});

  @override
  State<TakeHomeApp> createState() => _TakeHomeAppState();
}

class _TakeHomeAppState extends State<TakeHomeApp> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CategoryRepository>(
          create: (context) =>
              CategoryRepositoryImpl(remoteDataSource: CategoryRemoteDataSourceImpl(dio: DioConfig.instance)),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavBarBloc>(create: (context) => BottomNavBarBloc()),
          BlocProvider<DashboardBloc>(create: (context) => DashboardBloc()),
          BlocProvider<AnalyticsBloc>(create: (context) => AnalyticsBloc()),
          BlocProvider<TransactionsBloc>(create: (context) => TransactionsBloc()),
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(getCategories: GetCategories(context.read<CategoryRepository>())),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: TakeHomeApp.navigatorKey,
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
