import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/entities/visit_image_entity.dart';
import 'exam_image_empty_state.dart';
import 'exam_image_picker_sheet.dart';
import 'exam_image_thumbnail.dart';
import 'exam_section_card.dart';

class ExamImagesSection extends StatefulWidget {
  final List<VisitImageEntity> images;
  final bool isUploading;
  final void Function(List<String> paths, String type, String? description) onUpload;
  final void Function(int imageId) onDelete;

  const ExamImagesSection({
    super.key,
    required this.images,
    required this.isUploading,
    required this.onUpload,
    required this.onDelete,
  });

  @override
  State<ExamImagesSection> createState() => _ExamImagesSectionState();
}

class _ExamImagesSectionState extends State<ExamImagesSection> {
  String _selectedTab = 'all';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = _filterImages();

    return ExamSectionCard(
      title: 'examination.images'.tr(),
      icon: Icons.photo_library_outlined,
      trailing: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ExamImagePickerSheet.show(context, onUpload: widget.onUpload),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_photo_alternate_outlined, size: 15, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'examination.add_image'.tr(),
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFilterTabs(isDark),
          const SizedBox(height: AppSpacing.md),
          if (widget.isUploading) ...[
            const AppShimmerBox(width: double.infinity, height: 80),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (filtered.isEmpty && !widget.isUploading)
            ExamImageEmptyState(onUpload: widget.onUpload)
          else
            _buildGrid(filtered),
        ],
      ),
    );
  }

  List<VisitImageEntity> _filterImages() {
    if (_selectedTab == 'all') return widget.images;
    return widget.images.where((img) => img.type == _selectedTab).toList();
  }

  Widget _buildFilterTabs(bool isDark) {
    final tabs = [
      {'key': 'all', 'label': context.locale.languageCode == 'ar' ? 'الكل' : 'All'},
      {'key': 'scan', 'label': 'examination.image_type_scan'.tr()},
      {'key': 'lab', 'label': 'examination.image_type_lab'.tr()},
      {'key': 'document', 'label': 'examination.image_type_document'.tr()},
      {'key': 'other', 'label': 'examination.image_type_other'.tr()},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((t) => _buildTabItem(t['key']!, t['label']!, isDark)).toList(),
      ),
    );
  }

  Widget _buildTabItem(String key, String label, bool isDark) {
    final isSelected = _selectedTab == key;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedTab = key),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.surfaceVariantDark : const Color(0xFFF8FAFC)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0)),
                width: isSelected ? 1.4 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check_rounded, size: 13, color: Colors.white),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.onSurfaceDark : const Color(0xFF475569)),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(List<VisitImageEntity> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: images.length,
      itemBuilder: (ctx, index) => ExamImageThumbnail(
        image: images[index],
        onDelete: widget.onDelete,
      ),
    );
  }
}
