import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('École Assalam'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context,
              icon: Icons.school,
              title: 'Niveaux',
              subtitle: 'Gérer les niveaux scolaires',
              color: Colors.blue,
              onTap: () => context.go('/niveaux'),
            ),
            _buildMenuCard(
              context,
              icon: Icons.groups,
              title: 'Groupes',
              subtitle: 'Gérer les classes',
              color: Colors.green,
              onTap: () => context.go('/groupes'),
            ),
            _buildMenuCard(
              context,
              icon: Icons.person,
              title: 'Élèves',
              subtitle: 'Gérer les élèves',
              color: Colors.orange,
              onTap: () => context.go('/eleves'),
            ),
            _buildMenuCard(
              context,
              icon: Icons.assignment,
              title: 'Examens',
              subtitle: 'Examens de passage',
              color: Colors.purple,
              onTap: () => context.go('/examens'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
