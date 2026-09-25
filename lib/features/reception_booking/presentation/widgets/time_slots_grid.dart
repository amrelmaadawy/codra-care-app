import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/entities/booking_availability_entity.dart';
import '../../domain/entities/booking_slot_entity.dart';

class TimeSlotsGrid extends StatelessWidget {
  final BookingAvailabilityEntity? availability;
  final bool isLoading;
  final BookingSlotEntity? selectedSlot;
  final ValueChanged<BookingSlotEntity> onSlotSelected;

  const TimeSlotsGrid({
    super.key,
    required this.availability,
    required this.isLoading,
    required this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppShimmer(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AppShimmerBox(
              width: 80,
              height: 36,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            AppShimmerBox(
              width: 80,
              height: 36,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            AppShimmerBox(
              width: 80,
              height: 36,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            AppShimmerBox(
              width: 80,
              height: 36,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ],
        ),
      );
    }

    if (availability == null) return const SizedBox.shrink();

    if (availability!.isOnLeave || !availability!.isWorking) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                availability!.message ??
                    'reception_booking.doctor_unavailable'.tr(),
                style: AppTypography.bodySmall.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
    }

    if (!availability!.requiresTime) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.info.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.info),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'reception_booking.queue_mode_notice'.tr(
                  args: [
                    '${availability!.bookedCount}',
                    availability!.dailyLimit != null
                        ? '/${availability!.dailyLimit}'
                        : '',
                  ],
                ),
                style: AppTypography.bodySmall.copyWith(color: AppColors.info),
              ),
            ),
          ],
        ),
      );
    }

    if (availability!.slots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Text(
          'reception_booking.no_slots_available'.tr(),
          style: AppTypography.bodySmall.copyWith(color: AppColors.error),
        ),
      );
    }

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: availability!.slots.map((slot) {
        final isSelected = selectedSlot?.value == slot.value;
        return ChoiceChip(
          label: Text(slot.label),
          selected: isSelected,
          onSelected: slot.isBooked ? null : (_) => onSlotSelected(slot),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected
                ? Colors.white
                : (slot.isBooked ? context.textMutedColor : null),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            decoration: slot.isBooked ? TextDecoration.lineThrough : null,
          ),
        );
      }).toList(),
    );
  }
}
