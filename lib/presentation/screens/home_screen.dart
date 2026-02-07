import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../providers/project_provider.dart';
import '../widgets/empty_state.dart';
import 'add_project_screen.dart';
import 'profile_screen.dart';
import 'project_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('projects'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: projects.isEmpty
          ? EmptyState(
              icon: Icons.folder_open,
              message: '${'noProjects'.tr}\n${'addProject'.tr}',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  margin: const EdgeInsets.only(
                    bottom: AppConstants.defaultPadding,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(project.name[0].toUpperCase()),
                    ),
                    title: Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${project.machineIds.length} ${'machines'.tr}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailsScreen(
                            projectId: project.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProjectScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text('addProject'.tr),
      ),
    );
  }
}
