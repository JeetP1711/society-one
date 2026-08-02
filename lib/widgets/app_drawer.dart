import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';

class AppDrawer extends ConsumerWidget {
  final Function(int)? onSelectTab;

  const AppDrawer({super.key, this.onSelectTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user != null && user.fullName.isNotEmpty ? user.fullName[0] : 'S',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            accountName: Text(
              user?.fullName ?? 'SocietyOne User',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.email ?? '',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${user?.role.displayName}${user?.flatNumber != null ? ' (${user!.flatNumber})' : ''}',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.apartment_outlined),
            title: Text(
              user?.societyName ?? 'Green Valley CHS',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            subtitle: const Text('Active Housing Society'),
          ),
          const Divider(),

          // Role Switcher Section (For Demo Testing)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  'DEMO ROLE SWITCHER',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            dense: true,
            leading: Icon(
              Icons.admin_panel_settings,
              color: user?.role == UserRole.admin ? AppColors.primary : null,
            ),
            title: const Text('Switch to Admin'),
            trailing: user?.role == UserRole.admin
                ? const Icon(Icons.check, color: AppColors.primary, size: 18)
                : null,
            onTap: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).switchRole(UserRole.admin);
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(
              Icons.manage_accounts,
              color: user?.role == UserRole.secretary ? AppColors.primary : null,
            ),
            title: const Text('Switch to Secretary'),
            trailing: user?.role == UserRole.secretary
                ? const Icon(Icons.check, color: AppColors.primary, size: 18)
                : null,
            onTap: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).switchRole(UserRole.secretary);
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(
              Icons.person,
              color: user?.role == UserRole.member ? AppColors.primary : null,
            ),
            title: const Text('Switch to Resident (Rajesh)'),
            trailing: user?.role == UserRole.member
                ? const Icon(Icons.check, color: AppColors.primary, size: 18)
                : null,
            onTap: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).switchRole(UserRole.member);
            },
          ),
          const Divider(),

          // Settings & Theme
          ListTile(
            leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            title: Text(isDark ? 'Dark Mode' : 'Light Mode'),
            trailing: Switch(
              value: isDark,
              onChanged: (_) {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
          ),

          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title: Text(
              'Logout',
              style: GoogleFonts.montserrat(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
