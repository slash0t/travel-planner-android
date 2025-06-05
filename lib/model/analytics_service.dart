import 'package:appmetrica_plugin/appmetrica_plugin.dart';

class AnalyticsService {
  static const String _apiKey = '698ca2d8-e95c-407b-aec7-4d5dcd460d62';
  
  static Future<void> initialize() async {
    try {
      await AppMetrica.activate(AppMetricaConfig(_apiKey));
      print('AppMetrica инициализирована успешно');
    } catch (e) {
      print('Ошибка инициализации AppMetrica: $e');
    }
  }

  // Базовые события воронки пользователей
  
  /// Запуск приложения
  static void trackAppLaunch() {
    AppMetrica.reportEvent('app_launch');
  }
  
  /// Просмотр онбординга
  static void trackOnboardingView(String screenName) {
    AppMetrica.reportEvent('onboarding_view', {'screen': screenName});
  }
  
  /// Завершение онбординга
  static void trackOnboardingCompleted() {
    AppMetrica.reportEvent('onboarding_completed');
  }
  
  /// Начало регистрации
  static void trackRegistrationStarted() {
    AppMetrica.reportEvent('registration_started');
  }
  
  /// Успешная регистрация
  static void trackRegistrationCompleted() {
    AppMetrica.reportEvent('registration_completed');
  }
  
  /// Начало входа
  static void trackLoginStarted() {
    AppMetrica.reportEvent('login_started');
  }
  
  /// Успешный вход
  static void trackLoginCompleted() {
    AppMetrica.reportEvent('login_completed');
  }
  
  /// Просмотр главного экрана
  static void trackMainScreenView() {
    AppMetrica.reportEvent('main_screen_view');
  }
  
  /// Создание поездки
  static void trackTripCreationStarted() {
    AppMetrica.reportEvent('trip_creation_started');
  }
  
  /// Успешное создание поездки
  static void trackTripCreated(String tripId) {
    AppMetrica.reportEvent('trip_created', {'trip_id': tripId});
  }
  
  /// Просмотр деталей поездки
  static void trackTripDetailView(String tripId) {
    AppMetrica.reportEvent('trip_detail_view', {'trip_id': tripId});
  }
  
  /// Публикация поездки
  static void trackTripPublished(String tripId) {
    AppMetrica.reportEvent('trip_published', {'trip_id': tripId});
  }
  
  /// Поиск поездок
  static void trackTripSearch(String query) {
    AppMetrica.reportEvent('trip_search', {'query': query});
  }
  
  /// Создание задачи через ИИ
  static void trackAITodoCreationStarted() {
    AppMetrica.reportEvent('ai_todo_creation_started');
  }
  
  /// Успешное создание задачи через ИИ
  static void trackAITodoCreated() {
    AppMetrica.reportEvent('ai_todo_created');
  }
  
  /// Добавление места
  static void trackPlaceAdded(String placeType) {
    AppMetrica.reportEvent('place_added', {'place_type': placeType});
  }
  
  /// Просмотр библиотеки
  static void trackLibraryView() {
    AppMetrica.reportEvent('library_view');
  }
  
  /// Просмотр профиля
  static void trackProfileView() {
    AppMetrica.reportEvent('profile_view');
  }
  
  /// Просмотр уведомлений
  static void trackNotificationsView() {
    AppMetrica.reportEvent('notifications_view');
  }
  
  /// Отчет об ошибке
  static void trackError(String errorType, String errorMessage) {
    AppMetrica.reportError(errorMessage, AppMetricaErrorDescription(
      type: errorType,
      message: errorMessage,
    ));
  }
  
  /// Пользовательское событие
  static void trackCustomEvent(String eventName, [Map<String, String>? parameters]) {
    AppMetrica.reportEvent(eventName, parameters);
  }
  
  /// Установка пользовательских атрибутов
  static void setUserProfile({
    String? userId,
    String? name,
    String? email,
    int? age,
    String? gender,
  }) {
    final userProfile = AppMetricaUserProfile();
    
    if (userId != null) {
      userProfile.apply(AppMetricaStringAttribute.customString('user_id').withValue(userId));
    }
    if (name != null) {
      userProfile.apply(AppMetricaStringAttribute.name().withValue(name));
    }
    if (email != null) {
      userProfile.apply(AppMetricaStringAttribute.customString('email').withValue(email));
    }
    if (age != null) {
      userProfile.apply(AppMetricaNumberAttribute.customNumber('age').withValue(age.toDouble()));
    }
    if (gender != null) {
      userProfile.apply(AppMetricaStringAttribute.gender().withValue(gender));
    }
    
    AppMetrica.reportUserProfile(userProfile);
  }
  
  // Туду листы и задачи
  
  /// Просмотр списка туду листов
  static void trackTodoListView() {
    AppMetrica.reportEvent('todo_list_view');
  }
  
  /// Создание нового туду листа
  static void trackTodoListCreated(String method, {String? tripId}) {
    AppMetrica.reportEvent('todo_list_created', {
      'creation_method': method, // 'manual' или 'ai'
      if (tripId != null) 'trip_id': tripId,
    });
  }
  
  /// Просмотр деталей туду листа
  static void trackTodoListDetailView(String todoListId) {
    AppMetrica.reportEvent('todo_list_detail_view', {'todo_list_id': todoListId});
  }
  
  /// Удаление туду листа
  static void trackTodoListDeleted(String todoListId) {
    AppMetrica.reportEvent('todo_list_deleted', {'todo_list_id': todoListId});
  }
  
  /// Переименование туду листа
  static void trackTodoListRenamed(String todoListId) {
    AppMetrica.reportEvent('todo_list_renamed', {'todo_list_id': todoListId});
  }
  
  /// Добавление новой задачи в туду лист
  static void trackTodoTaskAdded(String todoListId, String taskType) {
    AppMetrica.reportEvent('todo_task_added', {
      'todo_list_id': todoListId,
      'task_type': taskType, // 'manual', 'ai_suggestion', etc.
    });
  }
  
  /// Выполнение задачи
  static void trackTodoTaskCompleted(String todoListId, String taskId) {
    AppMetrica.reportEvent('todo_task_completed', {
      'todo_list_id': todoListId,
      'task_id': taskId,
    });
  }
  
  /// Отмена выполнения задачи
  static void trackTodoTaskUncompleted(String todoListId, String taskId) {
    AppMetrica.reportEvent('todo_task_uncompleted', {
      'todo_list_id': todoListId,
      'task_id': taskId,
    });
  }
  
  /// Удаление задачи
  static void trackTodoTaskDeleted(String todoListId, String taskId) {
    AppMetrica.reportEvent('todo_task_deleted', {
      'todo_list_id': todoListId,
      'task_id': taskId,
    });
  }
  
  /// Редактирование задачи
  static void trackTodoTaskEdited(String todoListId, String taskId) {
    AppMetrica.reportEvent('todo_task_edited', {
      'todo_list_id': todoListId,
      'task_id': taskId,
    });
  }
  
  /// Начало создания туду листа через ИИ
  static void trackAITodoListCreationStarted() {
    AppMetrica.reportEvent('ai_todo_list_creation_started');
  }
  
  /// Успешное создание туду листа через ИИ
  static void trackAITodoListCreated(String direction, String season, int duration) {
    AppMetrica.reportEvent('ai_todo_list_created', {
      'direction': direction,
      'season': season,
      'duration': duration.toString(),
    });
  }
  
  /// Ошибка создания туду листа через ИИ
  static void trackAITodoListCreationFailed(String errorReason) {
    AppMetrica.reportEvent('ai_todo_list_creation_failed', {
      'error_reason': errorReason,
    });
  }
  
  /// Выбор типа создания туду листа (пустой или через ИИ)
  static void trackTodoListCreationMethodSelected(String method) {
    AppMetrica.reportEvent('todo_list_creation_method_selected', {
      'method': method, // 'empty' или 'ai'
    });
  }
  
  /// Просмотр прогресса туду листа
  static void trackTodoListProgressView(String todoListId, double progress) {
    AppMetrica.reportEvent('todo_list_progress_view', {
      'todo_list_id': todoListId,
      'progress_percentage': (progress * 100).round().toString(),
    });
  }
  
  /// Завершение всех задач в туду листе
  static void trackTodoListCompleted(String todoListId, int totalTasks) {
    AppMetrica.reportEvent('todo_list_completed', {
      'todo_list_id': todoListId,
      'total_tasks': totalTasks.toString(),
    });
  }
} 