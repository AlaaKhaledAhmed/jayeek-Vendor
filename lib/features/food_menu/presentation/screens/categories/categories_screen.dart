import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jayeek_vendor/core/constants/app_size.dart';
import 'package:jayeek_vendor/core/constants/app_string.dart';
import 'package:jayeek_vendor/core/routing/app_routes_methods.dart';
import 'package:jayeek_vendor/core/widgets/app_buttons.dart';
import 'package:jayeek_vendor/core/widgets/app_text.dart';
import 'package:jayeek_vendor/core/widgets/custom_load.dart';
import 'package:jayeek_vendor/core/widgets/data_view_builder.dart';
import 'package:jayeek_vendor/core/widgets/app_snack_bar.dart';
import 'package:jayeek_vendor/core/error/handel_post_response.dart';

import '../../../providers/categories/categories_provider.dart';
import '../../widgets/category_item_card.dart';
import '../../widgets/category_empty_state.dart';
import 'update_category.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends ConsumerState<CategoriesScreen> {
  @override
  void initState() {
    super.initState();

    /// Load categories when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoriesProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoriesProvider);
    final notifier = ref.read(categoriesProvider.notifier);

    return DataViewBuilder(
      dataHandle: state.categoriesData,
      emptyBuilder: () => const CategoryEmptyState(),
      onReload: () async => notifier.loadData(refresh: true),
      loadingBuilder: () => CustomLoad().loadVerticalList(context: context),
      isDataEmpty: () => state.categoriesData.data?.data?.isEmpty ?? true,
      successBuilder: (categories) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount: categories.data?.length ?? 0,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final categoryList = categories.data ?? [];
            if (index >= categoryList.length) return const SizedBox();
            final category = categoryList[index];
            return CategoryItemCard(
              category: category,
              onEdit: () async {
                notifier.loadCategoryForEdit(category);
                AppRoutes.pushTo(
                  context,
                  UpdateCategory(
                    category: category,
                    fromUpdate: true,
                  ),
                );
              },
              onDelete: () => _showDeleteDialog(
                context: context,
                notifier: notifier,
                state: state,
                id: category.id!,
              ),
            );
          },
        ),
      ),
    );
  }
}

void _showDeleteDialog({
  required BuildContext context,
  required notifier,
  required state,
  required int id,
}) {
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(builder: (context, set) {
      return AlertDialog(
        title: AppText(
          text: AppMessage.deleteCategoryConfirm,
          fontSize: AppSize.heading3,
          fontWeight: FontWeight.bold,
        ),
        content: AppText(
          text: AppMessage.deleteCategoryMessage,
          fontSize: AppSize.normalText,
        ),
        actions: [
          AppButtons(
            text: AppMessage.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          AppButtons(
            showLoader: state.isLoading,
            text: AppMessage.delete,
            onPressed: () {
              set(() => state = state.copyWith(isLoading: true));
              HandelPostRequest.handlePostRequest(
                context: context,
                formKey: null,
                request: () => notifier.deleteCategory(id),
                onSuccess: (data) {
                  /// Show success message
                  Navigator.pop(context);
                  AppSnackBar.show(
                    message: AppMessage.categoryDeleted,
                    type: ToastType.success,
                  );
                },
                onFailure: (v) {
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      );
    }),
  );
}

