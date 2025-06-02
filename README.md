# Travel Planner Android App

Упрощенная версия мобильного приложения для планирования путешествий без оффлайн режима и синхронизации.

## Изменения в архитектуре

### Что было убрано:
- ✅ Оффлайн хранилище (offline_storage.dart)
- ✅ Сервис синхронизации (sync_service.dart) 
- ✅ Зависимость от connectivity_plus
- ✅ Локальное кеширование данных
- ✅ Очереди синхронизации

### Что добавлено:
- ✅ Прямое взаимодействие с API через HTTP
- ✅ Упрощенные сервисы (trip_service.dart, library_service.dart)
- ✅ View Models для прямой работы с API
- ✅ Обработка ошибок сети

## Структура сервисов

### TripService
- Управление поездками (CRUD операции)
- Работа с TODO списками
- Управление днями поездки и событиями
- Шаринг и публикация поездок

### LibraryService  
- Просмотр опубликованных маршрутов
- Поиск и фильтрация маршрутов
- Работа с отзывами
- Управление публикациями (для админов)

## API Endpoints

Приложение работает с следующими микросервисами:

- **Auth Service**: `http://localhost:8081/api/v1`
- **Planner Service**: `http://localhost:8082/api/v1` 
- **Library Service**: `http://localhost:8084/api/v1`
- **External Service**: `http://localhost:8083/api/v1`

## Настройка и запуск

### Предварительные требования
1. Flutter SDK (версия 3.0+)
2. Dart SDK
3. Запущенные микросервисы бекенда

### Установка зависимостей
```bash
cd travel-planner-android
flutter pub get
```

### Конфигурация
Создайте файл `.env` в корне папки `travel-planner-android`:

```env
# Environment configuration
ENVIRONMENT=dev

# API Base URLs for development  
AUTH_SERVICE_URL=http://localhost:8081/api/v1
PLANNER_SERVICE_URL=http://localhost:8082/api/v1
EXTERNAL_SERVICE_URL=http://localhost:8083/api/v1
LIBRARY_SERVICE_URL=http://localhost:8084/api/v1
```

### Запуск приложения
```bash
flutter run
```

## Основные функции

### Путешествия
- Создание новых поездок
- Просмотр списка поездок (предстоящие, текущие, завершенные)
- Редактирование и удаление поездок
- Управление днями поездки
- Добавление событий в дни поездки

### TODO Списки
- Создание списков задач
- Привязка списков к поездкам
- Управление задачами (добавление, редактирование, удаление)
- Отметка задач как выполненных

### Библиотека маршрутов
- Просмотр опубликованных маршрутов
- Поиск маршрутов по ключевым словам
- Фильтрация по странам, городам, длительности
- Добавление и редактирование отзывов
- Публикация собственных маршрутов

### Авторизация
- Вход и регистрация пользователей
- Автоматическое обновление токенов
- Logout с очисткой токенов

## Обработка ошибок

Приложение включает комплексную обработку ошибок:

- Сетевые ошибки (timeout, connection issues)
- Ошибки API (4xx, 5xx статус коды)
- Автоматическое обновление токенов при 401 ошибках
- Пользовательские сообщения об ошибках

## View Models

### TripsViewModel
- Загрузка поездок по статусу
- CRUD операции для поездок
- Управление состоянием загрузки и ошибок

### TodoListViewModel  
- Управление TODO списками
- Операции с задачами
- Поддержка реорганизации списков

### LibraryViewModel
- Работа с библиотекой маршрутов
- Пагинация результатов
- Управление отзывами

## Технические детали

### Архитектура
- MVVM паттерн с Provider
- Единый API клиент с interceptors
- Автоматическое управление токенами
- Centralized error handling

### Зависимости
- `flutter/material.dart` - UI framework
- `provider` - State management  
- `dio` - HTTP client
- `shared_preferences` - Local storage для токенов
- `flutter_dotenv` - Environment variables

## Развертывание

Для production сборки измените URL в константах или переменных окружения:

```dart
static String get authServiceUrl => isProduction 
  ? 'https://www.putevod-app.ru/auth/api/v1'
  : 'http://localhost:8081/api/v1';
```