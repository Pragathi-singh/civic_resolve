import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const AppShell({
    required this.child,
    required this.onThemeToggle,
    required this.isDarkMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Civic Resolve',
          style: AppTextStyles.title1.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
                  onPressed: onThemeToggle,
                ),
                SizedBox(width: AppSpacing.md),
                _buildProfileMenu(context),
              ],
            ),
          ),
        ],
      ),
      body: isMobile
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Sidebar
        NavigationRail(
          extended: true,
          backgroundColor:
              Theme.of(context).colorScheme.surface.withOpacity(0.95),
          destinations: _buildNavigationDestinations(),
          selectedIndex: 0,
          onDestinationSelected: (int index) {
            // Handle navigation
          },
        ),
        // Main content
        Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  List<NavigationRailDestination> _buildNavigationDestinations() {
    return const [
      NavigationRailDestination(
        icon: Icon(Icons.dashboard),
        label: Text('Dashboard'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.report_problem),
        label: Text('Issues'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.person),
        label: Text('Profile'),
      ),
    ];
  }

  Widget _buildProfileMenu(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.account_circle),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.person, size: 18),
              SizedBox(width: AppSpacing.md),
              Text('Profile'),
            ],
          ),
          onTap: () {
            // Handle profile navigation
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.settings, size: 18),
              SizedBox(width: AppSpacing.md),
              Text('Settings'),
            ],
          ),
          onTap: () {
            // Handle settings navigation
          },
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.logout, size: 18, color: Colors.red),
              SizedBox(width: AppSpacing.md),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: () {
            // Handle logout
          },
        ),
      ],
    );
  }
}
