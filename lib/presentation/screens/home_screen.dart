import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../providers/project_provider.dart';
import '../utils/smooth_transitions.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/enhanced_widgets.dart';
import '../widgets/gradient_card.dart';
import '../widgets/stat_card.dart';
import 'add_project_screen.dart';
import 'profile_screen.dart';
import 'project_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'projects'.tr,
        prefixWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.folder_special,
            color: Theme.of(context).colorScheme.primary,
            size: isTablet ? 28 : 24,
          ),
        ),
        suffixWidget: Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.person,
              size: isTablet ? 28 : 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.of(context).push(
                SmoothTransitions.slideTransition(const ProfileScreen()),
              );
            },
          ),
        ),
      ),
      body: projects.isEmpty
          ? EmptyState(
              icon: Icons.folder_open,
              message: '${'noProjects'.tr}\n${'addProject'.tr}',
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics Section
                  if (projects.isNotEmpty) ...[
                    SizedBox(
                      height: isTablet ? 180 : 150,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: isTablet ? 160 : 140,
                              child: StatCard(
                                value: projects.length,
                                label: 'totalProjects'.tr,
                                icon: Icons.folder,
                                iconColor:
                                    Theme.of(context).colorScheme.primary,
                                animateCounter: true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: isTablet ? 160 : 140,
                              child: StatCard(
                                value: projects.fold<int>(
                                  0,
                                  (sum, p) => sum + (p.machineIds.length),
                                ),
                                label: 'totalMachines'.tr,
                                icon: Icons.construction,
                                iconColor:
                                    Theme.of(context).colorScheme.tertiary,
                                animateCounter: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Section Header
                  SectionHeader(
                    title: 'activeProjects'.tr,
                    icon: Icons.star,
                    actionText: 'viewAll'.tr,
                    onAction: () {},
                    showDivider: true,
                  ),
                  const SizedBox(height: 12),

                  // Projects Grid
                  AnimatedList(
                    key: GlobalKey<AnimatedListState>(),
                    initialItemCount: projects.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index, animation) {
                      final project = projects[index];
                      return _buildProjectCard(
                        context,
                        project,
                        index,
                        ref,
                        isTablet,
                      );
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            SmoothTransitions.slideUpTransition(const AddProjectScreen()),
          );
        },
        elevation: 8,
        icon: const Icon(Icons.add),
        label: Text('addProject'.tr),
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    dynamic project,
    int index,
    WidgetRef ref,
    bool isTablet,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GradientCard(
        onTap: () {
          Navigator.of(context).push(
            SmoothTransitions.slideTransition(
              ProjectDetailsScreen(projectId: project.id),
            ),
          );
        },
        animateOnTap: true,
        borderRadius: BorderRadius.circular(16),
        gradientColors: [
          Theme.of(context).colorScheme.primary.withOpacity(0.05),
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.03),
        ],
        border: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1.5,
        ),
        child: Row(
          children: [
            // Project Icon
            Container(
              width: isTablet ? 70 : 60,
              height: isTablet ? 70 : 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  project.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Project Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.construction,
                              size: isTablet ? 18 : 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${project.machineIds.length}',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'machines'.tr,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action Icon
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.primary,
              size: isTablet ? 28 : 24,
            ),
          ],
        ),
      ),
    );
  }
}
