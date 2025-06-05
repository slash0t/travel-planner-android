# Настройка AppMetrica для приложения Putevod

## Информация об интеграции

**ID приложения:** 4756801  
**API Key:** 698ca2d8-e95c-407b-aec7-4d5dcd460d62

## Структура воронки пользователей

Воронка пользователей настроена для отслеживания следующих этапов:

### 1. Запуск и онбординг
- `app_launch` - Запуск приложения
- `onboarding_view` - Просмотр экрана онбординга (с параметром screen)
- `onboarding_next` - Переход к следующему экрану онбординга
- `onboarding_back` - Возврат к предыдущему экрану онбординга
- `onboarding_skipped` - Пропуск онбординга
- `onboarding_completed` - Завершение онбординга

### 2. Авторизация и регистрация
- `registration_started` - Начало регистрации
- `registration_completed` - Успешная регистрация
- `registration_failed` - Ошибка при регистрации
- `login_started` - Начало входа в систему
- `login_completed` - Успешный вход
- `login_failed` - Ошибка при входе
- `password_recovery_requested` - Запрос восстановления пароля

### 3. Основная функциональность
- `main_screen_view` - Просмотр главного экрана
- `trip_creation_started` - Начало создания поездки
- `trip_created` - Успешное создание поездки (с ID поездки)
- `trip_updated` - Обновление поездки
- `trip_detail_view` - Просмотр деталей поездки
- `trip_published` - Публикация поездки
- `trip_search` - Поиск поездок

### 4. Дополнительные события
- `ai_todo_creation_started` - Начало создания задачи через ИИ
- `ai_todo_created` - Успешное создание задачи через ИИ
- `place_added` - Добавление места
- `library_view` - Просмотр библиотеки
- `profile_view` - Просмотр профиля
- `notifications_view` - Просмотр уведомлений

### 4. Туду листы и задачи
- `todo_list_view` - Просмотр списка туду листов
- `todo_list_created` - Создание нового туду листа (manual/ai)
- `todo_list_detail_view` - Просмотр деталей туду листа
- `todo_list_deleted` - Удаление туду листа
- `todo_list_renamed` - Переименование туду листа
- `todo_list_completed` - Завершение всех задач в туду листе
- `todo_list_progress_view` - Просмотр прогресса туду листа
- `todo_task_added` - Добавление новой задачи
- `todo_task_completed` - Выполнение задачи
- `todo_task_uncompleted` - Отмена выполнения задачи
- `todo_task_deleted` - Удаление задачи
- `todo_task_edited` - Редактирование задачи
- `todo_list_creation_method_selected` - Выбор метода создания (empty/ai)

### 5. ИИ функции для туду листов
- `ai_todo_list_creation_started` - Начало создания туду листа через ИИ
- `ai_todo_list_created` - Успешное создание туду листа через ИИ
- `ai_todo_list_creation_failed` - Ошибка создания туду листа через ИИ

### 6. Дополнительные события
- `place_added` - Добавление места
- `library_view` - Просмотр библиотеки
- `profile_view` - Просмотр профиля
- `notifications_view` - Просмотр уведомлений

### 7. Навигационные события
- `registration_from_login` - Переход к регистрации с экрана входа
- `login_from_registration` - Переход к входу с экрана регистрации
- `main_create_button_pressed` - Нажатие кнопки создания на главном экране

### 8. Ошибки и валидация
- `trip_creation_error` - Ошибка при создании поездки
- `trip_creation_validation_failed` - Ошибка валидации при создании поездки

## Настройка проекта

### 1. Зависимости уже добавлены в pubspec.yaml:
```yaml
dependencies:
  appmetrica_plugin: ^3.0.0
```

### 2. Разрешения Android добавлены в AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
```

### 3. Инициализация в main.dart:
AppMetrica инициализируется при запуске приложения и отправляет событие `app_launch`.

## Для завершения настройки выполните:

1. Запустите команду для установки зависимостей:
```bash
flutter pub get
```

2. Пересоберите проект:
```bash
flutter clean
flutter build apk
```

## Анализ воронки в AppMetrica

После внедрения вы сможете анализировать следующие метрики:

### Основные KPI:
- **Конверсия из установки в запуск** - `app_launch` / количество установок
- **Прохождение онбординга** - `onboarding_completed` / `app_launch`
- **Регистрация** - `registration_completed` / `onboarding_completed`
- **Создание первой поездки** - `trip_created` / `registration_completed`
- **Активность пользователей** - `main_screen_view`, `trip_detail_view`
- **Использование туду листов** - `todo_list_view` / `main_screen_view`
- **Создание туду листов** - `todo_list_created` / `todo_list_view`
- **Завершение задач** - `todo_task_completed` / `todo_task_added`
- **Использование ИИ** - `ai_todo_list_creation_started` / `todo_list_creation_method_selected`

### Воронка пользователя:
1. Установка → Запуск (`app_launch`)
2. Запуск → Просмотр онбординга (`onboarding_view`)
3. Онбординг → Завершение онбординга (`onboarding_completed`)
4. Завершение онбординга → Регистрация (`registration_completed`)
5. Регистрация → Главный экран (`main_screen_view`)
6. Главный экран → Создание поездки (`trip_created`)
7. Создание поездки → Просмотр туду листов (`todo_list_view`)
8. Туду листы → Создание туду листа (`todo_list_created`)
9. Создание туду листа → Добавление задач (`todo_task_added`)
10. Добавление задач → Выполнение задач (`todo_task_completed`)

### Дополнительная аналитика:
- Точки отвала в онбординге (`onboarding_skipped`)
- Проблемы с авторизацией (`login_failed`, `registration_failed`)
- Использование функций поиска (`trip_search`)
- Активность в библиотеке (`library_view`)
- **Эффективность туду листов** - процент завершенных задач
- **Популярность ИИ функций** - `ai_todo_list_created` vs `todo_list_created` с manual
- **Прогресс туду листов** - распределение прогресса (`todo_list_progress_view`)
- **Продуктивность пользователей** - среднее количество выполненных задач

## Пользовательские атрибуты

Сервис поддерживает установку следующих атрибутов пользователя:
- `user_id` - ID пользователя
- `name` - Имя пользователя
- `email` - Email пользователя
- `age` - Возраст
- `gender` - Пол

Используйте метод `AnalyticsService.setUserProfile()` для их установки. 