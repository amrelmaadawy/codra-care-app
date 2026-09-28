import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/entities/service_option_entity.dart';
import '../cubits/service_options_cubit.dart';
import '../cubits/service_options_state.dart';

class AddServiceModal extends StatefulWidget {
  final void Function(int serviceId, int quantity) onConfirm;

  const AddServiceModal({super.key, required this.onConfirm});

  @override
  State<AddServiceModal> createState() => _AddServiceModalState();
}

class _AddServiceModalState extends State<AddServiceModal> {
  ServiceOptionEntity? _selectedService;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    context.read<ServiceOptionsCubit>().loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'payments.add_service_title'.tr(),
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            decoration: InputDecoration(
              hintText: 'payments.search_services'.tr(),
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            onChanged: (val) =>
                context.read<ServiceOptionsCubit>().onSearchChanged(val),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 180,
            child: BlocBuilder<ServiceOptionsCubit, ServiceOptionsState>(
              builder: (context, state) {
                if (state.status == ServiceOptionsStatus.loading) {
                  return AppShimmer(
                    child: ListView.separated(
                      itemCount: 3,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (_, _) => AppShimmerBox(
                        height: 48,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                  );
                }

                if (state.services.isEmpty) {
                  return Center(
                    child: Text(
                      'payments.no_services_found'.tr(),
                      style: AppTypography.bodySmall.copyWith(
                        color: context.textMutedColor,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: state.services.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final item = state.services[index];
                    final isSelected = _selectedService?.id == item.id;

                    return ListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : context.dividerColor,
                        ),
                      ),
                      tileColor: isSelected
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : null,
                      title: Text(item.name, style: AppTypography.bodySmall),
                      trailing: Text(
                        item.formattedPrice,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      onTap: () => setState(() => _selectedService = item),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'payments.quantity'.tr(),
                style: AppTypography.bodyMedium,
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Text('$_quantity', style: AppTypography.headlineSmall),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            labelKey: 'payments.confirm_add_service',
            onPressed: _selectedService == null
                ? null
                : () {
                    widget.onConfirm(_selectedService!.id, _quantity);
                    Navigator.of(context).pop();
                  },
          ),
        ],
      ),
    );
  }
}
