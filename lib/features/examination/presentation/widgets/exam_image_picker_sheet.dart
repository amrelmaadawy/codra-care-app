import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'exam_image_type_selector.dart';
import 'exam_picker_source_button.dart';

class ExamImagePickerSheet extends StatefulWidget {
  final void Function(List<String> paths, String type, String? description) onUpload;

  const ExamImagePickerSheet({super.key, required this.onUpload});

  static void show(
    BuildContext context, {
    required void Function(List<String> paths, String type, String? description) onUpload,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => ExamImagePickerSheet(onUpload: onUpload),
    );
  }

  @override
  State<ExamImagePickerSheet> createState() => _ExamImagePickerSheetState();
}

class _ExamImagePickerSheetState extends State<ExamImagePickerSheet> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descController = TextEditingController();
  String _selectedType = 'scan';
  final List<String> _selectedPaths = [];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (photo != null) setState(() => _selectedPaths.add(photo.path));
    } else {
      final images = await _picker.pickMultiImage(imageQuality: 85);
      if (images.isNotEmpty) {
        setState(() => _selectedPaths.addAll(images.map((x) => x.path)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                borderRadius: AppRadius.chipRadius,
              ),
            ),
          ),
          Text(
            'examination.add_image'.tr(),
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'examination.image_type'.tr(),
            style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          ExamImageTypeSelector(
            selectedType: _selectedType,
            onSelected: (type) => setState(() => _selectedType = type),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ExamPickerSourceButton(
                  onTap: () => _pickImage(ImageSource.camera),
                  icon: Icons.camera_alt_outlined,
                  label: 'examination.pick_camera'.tr(),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ExamPickerSourceButton(
                  onTap: () => _pickImage(ImageSource.gallery),
                  icon: Icons.photo_library_outlined,
                  label: 'examination.pick_gallery'.tr(),
                ),
              ),
            ],
          ),
          if (_selectedPaths.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              '${_selectedPaths.length} صور مختارة',
              style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _descController,
              style: AppTypography.bodySmall,
              decoration: InputDecoration(
                hintText: 'examination.image_desc_hint'.tr(),
                isDense: true,
                filled: true,
                fillColor: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onUpload(
                  _selectedPaths,
                  _selectedType,
                  _descController.text.trim().isEmpty ? null : _descController.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('examination.upload_btn'.tr()),
            ),
          ],
        ],
      ),
    );
  }
}
