import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../cubits/walk_in_cubit.dart';
import '../cubits/walk_in_state.dart';

class WalkInBottomBar extends StatelessWidget {
  const WalkInBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkInCubit, WalkInState>(
      builder: (context, state) {
        final cubit = context.read<WalkInCubit>();

        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                if (state.stage > 1) ...[
                  Expanded(
                    child: SizedBox(
                      height: AppSizes.minTouchTarget,
                      child: OutlinedButton(
                        onPressed: state.isSubmitting ? null : cubit.prevStage,
                        child: Text('reception_booking.back_action'.tr()),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  flex: state.stage > 1 ? 2 : 1,
                  child: SizedBox(
                    height: AppSizes.minTouchTarget,
                    child: _buildActionButton(context, state, cubit),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WalkInState state,
    WalkInCubit cubit,
  ) {
    if (state.stage == 1) {
      return ElevatedButton(
        onPressed: state.isStage1Valid ? cubit.nextStage : null,
        child: Text('reception_booking.continue_action'.tr()),
      );
    }

    if (state.stage == 2) {
      return ElevatedButton(
        onPressed: state.isStage2Valid ? cubit.nextStage : null,
        child: Text('reception_booking.continue_action'.tr()),
      );
    }

    // Stage 3
    if (state.isSubmitting) {
      return Container(
        height: AppSizes.minTouchTarget,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Center(
          child: AppShimmer(
            child: AppShimmerBox(
              width: 140,
              height: 20,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: state.isStage3Valid ? cubit.submit : null,
      child: Text('reception_booking.confirm_walk_in_action'.tr()),
    );
  }
}
