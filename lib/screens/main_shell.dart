import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import 'dashboard/dashboard_screen.dart';
import 'visitors/visitor_list_screen.dart';
import 'visitors/visitor_form_screen.dart';
import 'announcements/announcements_screen.dart';
import 'maintenance/maintenance_screen.dart';
import 'amenities/amenity_booking_screen.dart';
import 'complaints/complaint_list_screen.dart';
import 'complaints/complaint_form_screen.dart';
import 'directory/directory_screen.dart';
import 'noc/noc_screen.dart';
import 'admin/admin_societies_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider).currentUser;
    final role = currentUser?.role ?? UserRole.member;

    final List<Widget> pages = _getPagesForRole(role);
    final List<BottomNavigationBarItem> items = _getNavItemsForRole(role);

    // Safeguard index out of bounds on role change
    if (_currentIndex >= pages.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      drawer: AppDrawer(
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: items,
      ),
      floatingActionButton: _buildFabForRole(context, role),
    );
  }

  List<Widget> _getPagesForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const [
          DashboardScreen(),
          AdminSocietiesScreen(),
          AnnouncementsScreen(),
          DirectoryScreen(),
          MaintenanceScreen(),
        ];
      case UserRole.secretary:
        return const [
          DashboardScreen(),
          VisitorListScreen(),
          AnnouncementsScreen(),
          ComplaintListScreen(),
          NocScreen(),
        ];
      case UserRole.member:
      default:
        return const [
          DashboardScreen(),
          VisitorListScreen(),
          AmenityBookingScreen(),
          ComplaintListScreen(),
          MaintenanceScreen(),
        ];
    }
  }

  List<BottomNavigationBarItem> _getNavItemsForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.domain_rounded), label: 'Societies'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign_rounded), label: 'Notices'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts_rounded), label: 'Directory'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Finances'),
        ];
      case UserRole.secretary:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner_rounded), label: 'Visitors'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign_rounded), label: 'Notices'),
          BottomNavigationBarItem(icon: Icon(Icons.build_rounded), label: 'Tickets'),
          BottomNavigationBarItem(icon: Icon(Icons.verified_user_rounded), label: 'NOCs'),
        ];
      case UserRole.member:
      default:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_rounded), label: 'Visitors'),
          BottomNavigationBarItem(icon: Icon(Icons.pool_rounded), label: 'Amenities'),
          BottomNavigationBarItem(icon: Icon(Icons.report_problem_rounded), label: 'Complaints'),
          BottomNavigationBarItem(icon: Icon(Icons.payments_rounded), label: 'Dues'),
        ];
    }
  }

  Widget? _buildFabForRole(BuildContext context, UserRole role) {
    if (role == UserRole.member) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VisitorFormScreen()),
          );
        },
        icon: const Icon(Icons.add_moderator),
        label: const Text('Add Visitor'),
      );
    } else if (role == UserRole.secretary) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const VisitorFormScreen()),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('New Pass'),
      );
    }
    return null;
  }
}
