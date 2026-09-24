import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

class DoctorChatFab extends StatelessWidget {
  final bool isExtended;

  const DoctorChatFab({
    super.key,
    this.isExtended = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isExtended) {
      return FloatingActionButton(
        heroTag: 'doctor_chat_fab',
        onPressed: () => context.push(AppRoutes.doctorChat),
        backgroundColor: AppColors.primary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        tooltip: 'chat.title'.tr(),
        child: const Icon(
          AppIcons.receptionChat,
          color: AppColors.onPrimary,
          size: 24,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        heroTag: 'doctor_chat_fab',
        onPressed: () => context.push(AppRoutes.doctorChat),
        backgroundColor: AppColors.primary,
        elevation: 0,
        highlightElevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        icon: const Icon(
          AppIcons.receptionChat,
          color: AppColors.onPrimary,
          size: 22,
        ),
        label: Text(
          'chat.title'.tr(),
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
