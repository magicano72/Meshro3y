import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/localization/app_localizations.dart';
import '../providers/owner_provider.dart';
import '../widgets/custom_text_field.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedAvatarPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOwnerData();
    });
  }

  void _loadOwnerData() {
    final owner = ref.read(ownerProvider);
    if (owner != null) {
      _nameController.text = owner.name;
      _phoneController.text = owner.phone;
      setState(() {
        _selectedAvatarPath = owner.avatarPath;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        // Copy image to app documents directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'avatar_${const Uuid().v4()}.jpg';
        final savedImage = await File(pickedFile.path).copy(
          '${appDir.path}/$fileName',
        );

        setState(() {
          _selectedAvatarPath = savedImage.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في اختيار الصورة: $e')),
        );
      }
    }
  }

  void _saveOwner() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('pleaseEnterName'.tr)),
      );
      return;
    }

    final owner = ref.read(ownerProvider);
    if (owner == null) {
      ref.read(ownerProvider.notifier).saveOwner(
            _nameController.text.trim(),
            _phoneController.text.trim(),
            const Uuid().v4(),
            avatarPath: _selectedAvatarPath,
          );
    } else {
      ref.read(ownerProvider.notifier).updateOwner(
            _nameController.text.trim(),
            _phoneController.text.trim(),
            avatarPath: _selectedAvatarPath,
          );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('profileSaved'.tr)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final owner = ref.watch(ownerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    // Sync avatar path with owner whenever it changes
    if (owner != null && _selectedAvatarPath != owner.avatarPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedAvatarPath = owner.avatarPath;
        });
      });
    }

    // Responsive sizing
    final sectionSpacing = isTablet ? 40.0 : 32.0;
    final fieldSpacing = isTablet ? 20.0 : 16.0;
    final cardPadding = isTablet ? 24.0 : 20.0;
    final fontSize = isTablet ? 18.0 : 16.0;
    final avatarSize = isTablet ? 120.0 : 100.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي'.tr),
        elevation: 0,
        actions: [
          TextButton(
            child: Text(
              'save'.tr,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: _saveOwner,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Large Avatar with Edit Button
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: _selectedAvatarPath != null &&
                          File(_selectedAvatarPath!).existsSync()
                      ? ClipOval(
                          child: Image.file(
                            File(_selectedAvatarPath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.person,
                            size: avatarSize * 0.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 3,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: isTablet ? 20 : 18,
                    ),
                    onPressed: _pickAvatar,
                  ),
                ),
              ],
            ),
            SizedBox(height: sectionSpacing),

            // Owner Info Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: isTablet ? 28 : 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'ownerInfo'.tr,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: fieldSpacing + 4),
                      SizedBox(
                        height: isTablet ? 75 : 70,
                        child: CustomTextField(
                          label: 'Name'.tr,
                          controller: _nameController,
                          prefixIcon: Icons.badge,
                        ),
                      ),
                      SizedBox(height: fieldSpacing),
                      SizedBox(
                        height: isTablet ? 75 : 70,
                        child: CustomTextField(
                          label: 'Phone Number'.tr,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: sectionSpacing),
          ],
        ),
      ),
    );
  }
}
