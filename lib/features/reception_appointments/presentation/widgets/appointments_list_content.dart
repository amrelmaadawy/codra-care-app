import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/entities/appointment_entity.dart';
import 'appointment_card.dart';
import 'appointment_empty_view.dart';

class AppointmentsListContent extends StatelessWidget {
  final List<AppointmentEntity> items;
  final bool isPaginating;
  final ScrollController scrollController;
  final ValueChanged<AppointmentEntity> onCancelAppointment;
  final VoidCallback? onNewAppointment;

  const AppointmentsListContent({
    super.key,
    required this.items,
    required this.isPaginating,
    required this.scrollController,
    required this.onCancelAppointment,
    this.onNewAppointment,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return AppointmentEmptyView(onNewAppointment: onNewAppointment);
    }

    return ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        top: AppSpacing.sm,
        bottom: AppSpacing.xxl * 2,
      ),
      itemCount: items.length + (isPaginating ? 1 : 0),
      itemBuilder: (ctx, index) {
        if (index == items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: AppShimmer(
              child: AppShimmerBox(
                width: double.infinity,
                height: 80,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          );
        }

        final appt = items[index];
        return AppointmentCard(
          key: ValueKey(appt.id),
          appointment: appt,
          onCancel: appt.canCancel ? () => onCancelAppointment(appt) : null,
        );
      },
    );
  }
}
