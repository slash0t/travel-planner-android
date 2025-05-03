import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view-model/loading_view_model.dart';
import 'package:putevod/view-model/navigation_view_model.dart';
import 'package:putevod/view-model/profile_view_model.dart';
import 'package:putevod/view-model/todo_list_view_model.dart';
import 'package:putevod/view-model/trip_search_view_model.dart';
import 'package:putevod/view-model/trips_view_model.dart';
import 'package:putevod/view/screens/loading_screen.dart';
import 'package:putevod/view/widgets/app_header_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadingViewModel()),
        ChangeNotifierProvider(create: (_) => TripsViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => AppHeaderViewModel()),
        ChangeNotifierProvider(create: (_) => TodoListViewModel()),
        ChangeNotifierProvider(create: (_) => TripSearchViewModel()),
      ],
      child: MaterialApp(
        title: 'Putevod',
        theme: ThemeData(
          primaryColor: AppColors.accent,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.accent,
            background: AppColors.background,
          ),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'NotoSans',
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}
