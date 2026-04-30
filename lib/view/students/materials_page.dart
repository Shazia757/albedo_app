import 'package:albedo_app/widgets/custom_appbar.dart';
import 'package:albedo_app/widgets/drawer_menu.dart';
import 'package:albedo_app/widgets/session_widgets.dart';
import 'package:flutter/material.dart';

class StudentMaterialsPage extends StatelessWidget {
  const StudentMaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: DrawerMenu(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: EmptyState(
            cs: cs,
            icon: Icons.menu_book_outlined,
            title: 'No materials found',
            subtitle:
                'We don’t have any study materials available right now. Check back later for updates.',
          ),
        ),
      ),
    );
  }
}
