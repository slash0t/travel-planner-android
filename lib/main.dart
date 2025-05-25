import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view-model/loading_view_model.dart';
import 'package:putevod/view-model/navigation_view_model.dart';
import 'package:putevod/view-model/profile_view_model.dart';
import 'package:putevod/view-model/todo_item_detail_view_model.dart';
import 'package:putevod/view-model/todo_list_view_model.dart';
import 'package:putevod/view-model/trip_creation_view_model.dart';
import 'package:putevod/view-model/trip_detail_view_model.dart';
import 'package:putevod/view-model/trip_search_view_model.dart';
import 'package:putevod/view-model/trips_view_model.dart';
import 'package:putevod/view/screens/loading_screen.dart';
import 'package:putevod/view/screens/login_screen.dart';
import 'package:putevod/view/widgets/app_header_view_model.dart';
import 'package:putevod/view-model/login_view_model.dart';
import 'package:putevod/view-model/registration_view_model.dart';
import 'package:putevod/view-model/password_recovery_view_model.dart';
import 'package:putevod/external/offline_storage.dart';
import 'package:putevod/external/sync_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Загружаем переменные окружения
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // Если .env файл не найден, используем значения по умолчанию
    print('Warning: .env file not found, using default values');
  }
  
  // Инициализируем оффлайн хранилище
  await OfflineStorage.init();
  
  // Инициализируем сервис синхронизации
  SyncService.instance.init();
  
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
        ChangeNotifierProvider(create: (_) => TodoItemDetailViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegistrationViewModel()),
        ChangeNotifierProvider(create: (_) => PasswordRecoveryViewModel()),
        ChangeNotifierProvider(create: (_) => TripCreationViewModel()),
        ChangeNotifierProvider(create: (_) => TripDetailViewModel()),
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
          useMaterial3: true,
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}
