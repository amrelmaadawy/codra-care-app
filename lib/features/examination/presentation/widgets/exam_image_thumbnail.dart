import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/entities/visit_image_entity.dart';

class ExamImageThumbnail extends StatefulWidget {
  final VisitImageEntity image;
  final ValueChanged<int> onDelete;

  const ExamImageThumbnail({
    super.key,
    required this.image,
    required this.onDelete,
  });

  @override
  State<ExamImageThumbnail> createState() => _ExamImageThumbnailState();
}

class _ExamImageThumbnailState extends State<ExamImageThumbnail> {
  Key _imageKey = UniqueKey();

  void _retry() {
    CachedNetworkImage.evictFromCache(widget.image.fullUrl);
    setState(() => _imageKey = UniqueKey());
  }

  void _showPreview(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.image.fullUrl,
                  fit: BoxFit.contain,
                  placeholder: (_, _) => const AppShimmerBox(width: 300, height: 300),
                  errorWidget: (_, _, _) => const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white70,
                    size: 48,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: AppRadius.cardRadius,
          child: GestureDetector(
            onTap: () => _showPreview(context),
            child: CachedNetworkImage(
              key: _imageKey,
              imageUrl: widget.image.fullUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => const AppShimmerBox(
                width: double.infinity,
                height: double.infinity,
              ),
              errorWidget: (_, _, _) => InkWell(
                onTap: _retry,
                child: Container(
                  color: AppColors.surfaceVariantLight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh_rounded, color: AppColors.error, size: 24),
                      const SizedBox(height: 2),
                      Text(
                        'common.retry'.tr(),
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: InkWell(
            onTap: () => _confirmDelete(context, widget.image.id),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, int imageId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('examination.delete_image_title'.tr(), style: AppTypography.titleMedium),
        content: Text('examination.delete_image_msg'.tr(), style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              widget.onDelete(imageId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
  }
}
