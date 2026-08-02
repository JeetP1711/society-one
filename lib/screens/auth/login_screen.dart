import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/glass_card.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController(text: 'rajesh');
  final _passwordController = TextEditingController(text: 'pass123');

  void _fillDemo(String username, String pass) {
    setState(() {
      _usernameController.text = username;
      _passwordController.text = pass;
    });
  }

  void _handleLogin() async {
    final success = await ref.read(authProvider.notifier).login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.read(authProvider).error ?? 'Login failed'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF15803D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Branding Logo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'SocietyOne',
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Residential Society Management Platform',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Glassmorphism Login Card
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    customColor: const Color(0xFF1E293B).withOpacity(0.75),
                    borderColor: Colors.white.withOpacity(0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sign In',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.person_outline, color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: authState.isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppColors.primary,
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'LOGIN',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Quick Demo Accounts Pre-seed Selector
                  Text(
                    'QUICK DEMO LOGIN',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.person, size: 16, color: Colors.white),
                        label: const Text('Member (Rajesh)'),
                        backgroundColor: AppColors.primary.withOpacity(0.8),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        onPressed: () => _fillDemo('rajesh', 'pass123'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.person_outline, size: 16, color: Colors.white),
                        label: const Text('Member (Priya)'),
                        backgroundColor: AppColors.primary.withOpacity(0.8),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        onPressed: () => _fillDemo('priya', 'pass123'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.manage_accounts, size: 16, color: Colors.white),
                        label: const Text('Secretary'),
                        backgroundColor: AppColors.secondary.withOpacity(0.8),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        onPressed: () => _fillDemo('secretary', 'sec123'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.admin_panel_settings, size: 16, color: Colors.white),
                        label: const Text('Admin'),
                        backgroundColor: AppColors.danger.withOpacity(0.8),
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                        onPressed: () => _fillDemo('admin', 'admin123'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
