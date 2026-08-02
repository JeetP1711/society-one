import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'mock_data.dart';

class AuthState {
  final AppUser? currentUser;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => currentUser != null;

  AuthState copyWith({
    AppUser? currentUser,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _loadUserFromPrefs();
  }

  static const String _userKey = 'society_one_current_user_id';

  Future<void> _loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_userKey);
      if (userId != null) {
        final user = MockData.preseededUsers.firstWhere(
          (u) => u.id == userId,
          orElse: () => MockData.preseededUsers[2], // default rajesh
        );
        state = AuthState(currentUser: user);
      } else {
        // Pre-select Rajesh (Member) as default logged-in demo user
        state = AuthState(currentUser: MockData.preseededUsers[2]);
      }
    } catch (_) {
      state = AuthState(currentUser: MockData.preseededUsers[2]);
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    await Future.delayed(const Duration(milliseconds: 500)); // Simulate net latency

    AppUser? foundUser;
    if (username == 'admin' && password == 'admin123') {
      foundUser = MockData.preseededUsers[0];
    } else if (username == 'secretary' && password == 'sec123') {
      foundUser = MockData.preseededUsers[1];
    } else if (username == 'rajesh' && password == 'pass123') {
      foundUser = MockData.preseededUsers[2];
    } else if (username == 'priya' && password == 'pass123') {
      foundUser = MockData.preseededUsers[3];
    }

    if (foundUser != null) {
      state = AuthState(currentUser: foundUser);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, foundUser.id);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid credentials. Use demo buttons to quick log in.',
      );
      return false;
    }
  }

  Future<void> switchRole(UserRole newRole) async {
    AppUser newUser;
    switch (newRole) {
      case UserRole.admin:
        newUser = MockData.preseededUsers[0];
        break;
      case UserRole.secretary:
        newUser = MockData.preseededUsers[1];
        break;
      case UserRole.member:
      default:
        newUser = MockData.preseededUsers[2];
        break;
    }

    state = AuthState(currentUser: newUser);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, newUser.id);
  }

  Future<void> logout() async {
    state = const AuthState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
