import 'package:flutter/material.dart';
import 'package:putevod/external/library_service.dart';

/// ViewModel for the Library screen
class LibraryViewModel extends ChangeNotifier {
  final LibraryService _libraryService = LibraryService();
  
  /// List of published routes
  List<dynamic> _routes = [];
  
  /// List of pending routes (for admins)
  List<dynamic> _pendingRoutes = [];
  
  /// Current route details
  dynamic _currentRouteDetails;
  
  /// Route reviews
  List<dynamic> _routeReviews = [];
  
  /// Current user's review
  dynamic _myReview;
  
  /// Loading states
  bool _isLoading = false;
  bool _isLoadingDetails = false;
  bool _isLoadingReviews = false;
  
  /// Error message
  String? _errorMessage;
  
  /// Pagination info
  int _currentPage = 0;
  bool _hasMoreData = true;

  // Getters
  List<dynamic> get routes => _routes;
  List<dynamic> get pendingRoutes => _pendingRoutes;
  dynamic get currentRouteDetails => _currentRouteDetails;
  List<dynamic> get routeReviews => _routeReviews;
  dynamic get myReview => _myReview;
  bool get isLoading => _isLoading;
  bool get isLoadingDetails => _isLoadingDetails;
  bool get isLoadingReviews => _isLoadingReviews;
  String? get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  int get currentPage => _currentPage;

  /// Load published routes
  Future<void> loadPublishedRoutes({bool refresh = false, int size = 20}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMoreData = true;
      _routes.clear();
    }
    
    if (!_hasMoreData) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _libraryService.getPublishedRoutes(
        page: _currentPage,
        size: size,
      );
      
      final List<dynamic> newRoutes = response['content'] ?? [];
      if (refresh) {
        _routes = newRoutes;
      } else {
        _routes.addAll(newRoutes);
      }
      
      _hasMoreData = !response['last'];
      if (_hasMoreData) _currentPage++;
      
    } catch (e) {
      _errorMessage = 'Ошибка загрузки маршрутов: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load pending routes (for admins)
  Future<void> loadPendingRoutes({bool refresh = false, int size = 20}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMoreData = true;
      _pendingRoutes.clear();
    }
    
    if (!_hasMoreData) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _libraryService.getPendingRoutes(
        page: _currentPage,
        size: size,
      );
      
      final List<dynamic> newRoutes = response['content'] ?? [];
      if (refresh) {
        _pendingRoutes = newRoutes;
      } else {
        _pendingRoutes.addAll(newRoutes);
      }
      
      _hasMoreData = !response['last'];
      if (_hasMoreData) _currentPage++;
      
    } catch (e) {
      _errorMessage = 'Ошибка загрузки неодобренных маршрутов: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search routes
  Future<void> searchRoutes(String query, {bool refresh = false, int size = 20}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMoreData = true;
      _routes.clear();
    }
    
    if (!_hasMoreData) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _libraryService.searchRoutes(
        query: query,
        page: _currentPage,
        size: size,
      );
      
      final List<dynamic> newRoutes = response['content'] ?? [];
      if (refresh) {
        _routes = newRoutes;
      } else {
        _routes.addAll(newRoutes);
      }
      
      _hasMoreData = !response['last'];
      if (_hasMoreData) _currentPage++;
      
    } catch (e) {
      _errorMessage = 'Ошибка поиска маршрутов: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter routes
  Future<void> filterRoutes({
    String? country,
    String? city,
    int? durationMin,
    int? durationMax,
    String? tag,
    bool refresh = false,
    int size = 20,
  }) async {
    if (refresh) {
      _currentPage = 0;
      _hasMoreData = true;
      _routes.clear();
    }
    
    if (!_hasMoreData) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _libraryService.filterRoutes(
        country: country,
        city: city,
        durationMin: durationMin,
        durationMax: durationMax,
        tag: tag,
        page: _currentPage,
        size: size,
      );
      
      final List<dynamic> newRoutes = response['content'] ?? [];
      if (refresh) {
        _routes = newRoutes;
      } else {
        _routes.addAll(newRoutes);
      }
      
      _hasMoreData = !response['last'];
      if (_hasMoreData) _currentPage++;
      
    } catch (e) {
      _errorMessage = 'Ошибка фильтрации маршрутов: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load popular routes
  Future<void> loadPopularRoutes({bool refresh = false, int size = 20}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMoreData = true;
      _routes.clear();
    }
    
    if (!_hasMoreData) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _libraryService.getPopularRoutes(
        page: _currentPage,
        size: size,
      );
      
      final List<dynamic> newRoutes = response['content'] ?? [];
      if (refresh) {
        _routes = newRoutes;
      } else {
        _routes.addAll(newRoutes);
      }
      
      _hasMoreData = !response['last'];
      if (_hasMoreData) _currentPage++;
      
    } catch (e) {
      _errorMessage = 'Ошибка загрузки популярных маршрутов: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load top rated routes
  Future<void> loadTopRatedRoutes({bool refresh = false, int size = 20}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMoreData = true;
      _routes.clear();
    }
    
    if (!_hasMoreData) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _libraryService.getTopRatedRoutes(
        page: _currentPage,
        size: size,
      );
      
      final List<dynamic> newRoutes = response['content'] ?? [];
      if (refresh) {
        _routes = newRoutes;
      } else {
        _routes.addAll(newRoutes);
      }
      
      _hasMoreData = !response['last'];
      if (_hasMoreData) _currentPage++;
      
    } catch (e) {
      _errorMessage = 'Ошибка загрузки топ маршрутов: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load route details
  Future<void> loadRouteDetails(int routeId) async {
    _isLoadingDetails = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _currentRouteDetails = await _libraryService.getRouteDetails(routeId);
    } catch (e) {
      _errorMessage = 'Ошибка загрузки деталей маршрута: $e';
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  /// Load user routes
  Future<void> loadUserRoutes(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _routes = await _libraryService.getUserRoutes(userId);
    } catch (e) {
      _errorMessage = 'Ошибка загрузки маршрутов пользователя: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Publish route
  Future<bool> publishRoute(int tripId) async {
    try {
      await _libraryService.publishRoute(tripId);
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка публикации маршрута: $e';
      notifyListeners();
      return false;
    }
  }

  /// Approve route (admin only)
  Future<bool> approveRoute(int routeId) async {
    try {
      await _libraryService.approveRoute(routeId);
      // Remove from pending routes
      _pendingRoutes.removeWhere((route) => route['id'] == routeId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка одобрения маршрута: $e';
      notifyListeners();
      return false;
    }
  }

  /// Delete route
  Future<bool> deleteRoute(int routeId) async {
    try {
      await _libraryService.deleteRoute(routeId);
      // Remove from local lists
      _routes.removeWhere((route) => route['id'] == routeId);
      _pendingRoutes.removeWhere((route) => route['id'] == routeId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка удаления маршрута: $e';
      notifyListeners();
      return false;
    }
  }

  /// Load route reviews
  Future<void> loadRouteReviews(int routeId, {bool refresh = false, int size = 20}) async {
    if (refresh) {
      _routeReviews.clear();
      _currentPage = 0;
      _hasMoreData = true;
    }
    
    if (!_hasMoreData) return;
    
    _isLoadingReviews = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _libraryService.getRouteReviews(
        routeId,
        page: _currentPage,
        size: size,
      );
      
      final List<dynamic> newReviews = response['content'] ?? [];
      if (refresh) {
        _routeReviews = newReviews;
      } else {
        _routeReviews.addAll(newReviews);
      }
      
      _hasMoreData = !response['last'];
      if (_hasMoreData) _currentPage++;
      
    } catch (e) {
      _errorMessage = 'Ошибка загрузки отзывов: $e';
    } finally {
      _isLoadingReviews = false;
      notifyListeners();
    }
  }

  /// Load my review for route
  Future<void> loadMyReview(int routeId) async {
    try {
      _myReview = await _libraryService.getMyReview(routeId);
      notifyListeners();
    } catch (e) {
      // No review found or error - this is normal
      _myReview = null;
      notifyListeners();
    }
  }

  /// Add review
  Future<bool> addReview(int routeId, int rating, {String? comment}) async {
    try {
      final review = await _libraryService.addReview(routeId, rating, comment: comment);
      _myReview = review;
      // Add to reviews list if loaded
      if (_routeReviews.isNotEmpty) {
        _routeReviews.insert(0, review);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка добавления отзыва: $e';
      notifyListeners();
      return false;
    }
  }

  /// Update review
  Future<bool> updateReview(int routeId, int rating, {String? comment}) async {
    try {
      final review = await _libraryService.updateReview(routeId, rating, comment: comment);
      _myReview = review;
      // Update in reviews list if exists
      final index = _routeReviews.indexWhere((r) => r['userId'] == review['userId']);
      if (index != -1) {
        _routeReviews[index] = review;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка обновления отзыва: $e';
      notifyListeners();
      return false;
    }
  }

  /// Delete review
  Future<bool> deleteReview(int routeId) async {
    try {
      await _libraryService.deleteReview(routeId);
      final reviewUserId = _myReview?['userId'];
      _myReview = null;
      // Remove from reviews list if exists
      if (reviewUserId != null) {
        _routeReviews.removeWhere((r) => r['userId'] == reviewUserId);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка удаления отзыва: $e';
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset pagination
  void resetPagination() {
    _currentPage = 0;
    _hasMoreData = true;
  }

  /// Clear current route details
  void clearRouteDetails() {
    _currentRouteDetails = null;
    _routeReviews.clear();
    _myReview = null;
    notifyListeners();
  }
} 