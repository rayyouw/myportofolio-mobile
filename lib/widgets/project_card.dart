import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/education_list.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/screens/skill_list.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Tappable colored card for an [ItemHomepage]; shows a SnackBar and
/// navigates to the matching screen when pressed.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: item.color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _logout(BuildContext context) async {
    final authState = context.read<AuthState>();
    if (!authState.isLoggedIn) {
      _showSnackBar(context, 'You are not logged in.');
      return;
    }
    await authState.logout();
    if (!context.mounted) return;
    _showSnackBar(context, 'You have been logged out.');
  }

  Future<void> _onTap(BuildContext context) async {
    if (item.name == 'Logout') {
      await _logout(context);
      return;
    }

    _showSnackBar(context, 'You pressed the ${item.name} button!');

    // Adding a project needs an authenticated user.
    if (item.name == 'Add Project') {
      if (!await ensureLoggedIn(context)) return;
      if (!context.mounted) return;
    }

    // Navigate to the appropriate screen.
    final Widget? destination = switch (item.name) {
      'View Projects' => const ProjectListScreen(),
      'Add Project' => const ProjectFormPage(),
      'Add Education' => const EducationFormPage(),
      'View Education' => const EducationListPage(),
      'Add Skill' => const SkillFormPage(),
      'View Skills' => const SkillListPage(),
      _ => null,
    };
    if (destination != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _onTap(context),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
