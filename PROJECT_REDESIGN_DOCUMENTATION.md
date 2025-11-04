# Project Redesign Documentation

## Overview
This document outlines the comprehensive redesign of the Vendor App project structure, focusing on modern design principles, code reusability, and maintainability.

## Changes Summary

### 1. Shared Widgets System ✅

#### Created: `lib/core/widgets/shared_image_picker.dart`
- **Purpose**: Unified image picker widget used throughout the application
- **Features**:
  - Supports network images, local files, and base64 strings
  - Automatic image type detection
  - Built-in error handling and placeholders
  - Customizable dimensions, borders, and styling
  - Remove button support
  - Change image button overlay

**Usage Example**:
```dart
SharedImagePicker(
  imagePath: selectedImagePath,
  onPickImage: () async {
    final path = await AppImagePicker.pickImageWithSource(context: context);
    // Handle image path
  },
  height: 200.h,
  placeholderText: 'اختر صورة',
)
```

**Replaces**: 
- ✅ `MealImagePicker` (lib/features/food_menu/presentation/widgets/meal_image_picker.dart) - **DELETED**
- ✅ Duplicate image picker code in `update_category.dart` - **REMOVED**
- ✅ Duplicate image picker code in `update_addon.dart` - **REMOVED**
- ✅ Image picker code in `add_food.dart` - **UPDATED**
- ✅ Image picker code in `update_food.dart` - **UPDATED**

### 2. Unified Dialog/Bottom Sheet System ✅

#### Created: `lib/core/widgets/unified_bottom_sheet.dart`
- **Purpose**: Modern bottom sheet system replacing traditional dialogs
- **Features**:
  - Confirmation bottom sheets
  - Info bottom sheets
  - Custom content bottom sheets
  - Modern design with drag handles
  - Smooth animations and transitions
  - RTL support

**Methods**:
1. `showConfirmation()` - For yes/no confirmations
2. `showInfo()` - For informational messages
3. `showCustom()` - For custom content

**Usage Example**:
```dart
// Confirmation
await UnifiedBottomSheet.showConfirmation(
  context: context,
  title: 'حذف الفئة؟',
  message: 'هل أنت متأكد؟',
  onConfirm: () {
    // Delete action
  },
);

// Info
await UnifiedBottomSheet.showInfo(
  context: context,
  title: 'نجاح',
  message: 'تم الحفظ بنجاح',
);
```

**Replaces**: 
- ✅ `AppDialog.showAlertDialog()` - Still available but bottom sheets preferred
- ✅ Inline dialog code in `categories_screen.dart` - **UPDATED**
- ✅ Inline dialog code in `addons_screen.dart` - **UPDATED**
- ✅ Image source selection dialog in `image_picker_service.dart` - **UPDATED to bottom sheet**

### 3. Modern Design Standards

#### Design Principles Applied:
- **Material Design 3** guidelines
- **Rounded corners** (24r radius for bottom sheets)
- **Elevation and shadows** for depth
- **Smooth animations** and transitions
- **Consistent spacing** using ScreenUtil
- **Color consistency** through AppColor constants
- **Typography hierarchy** through AppSize constants

### 4. Code Cleanup Required

#### Files to Remove/Refactor:
1. **Remove**: `lib/features/food_menu/presentation/widgets/meal_image_picker.dart`
   - Replace with `SharedImagePicker`

2. **Refactor**: `lib/core/widgets/app_dialog.dart`
   - Migrate to use `UnifiedBottomSheet` where appropriate
   - Keep only essential methods

3. **Clean**: Duplicate image display logic
   - In `update_category.dart` → Use `SharedImagePicker`
   - In `update_addon.dart` → Use `SharedImagePicker`

## Implementation Plan

### Phase 1: Core Components ✅
- [x] Create shared image picker widget
- [x] Create unified bottom sheet system
- [x] Add missing string constants

### Phase 2: Update Categories Screen
- [ ] Replace inline image picker with `SharedImagePicker`
- [ ] Replace delete dialog with `UnifiedBottomSheet.showConfirmation`
- [ ] Modernize UI design

### Phase 3: Update Addons Screen
- [ ] Replace inline image picker with `SharedImagePicker`
- [ ] Replace dialogs with bottom sheets
- [ ] Modernize UI design

### Phase 4: Code Cleanup
- [ ] Remove duplicate widgets
- [ ] Remove unused imports
- [ ] Consolidate similar code

### Phase 5: Documentation
- [ ] Update README
- [ ] Add code comments
- [ ] Create usage examples

## Design Rationale

### Why Bottom Sheets Instead of Dialogs?
1. **Better UX**: Bottom sheets are more accessible on mobile devices
2. **Modern Standard**: Follows Material Design 3 guidelines
3. **Better for Mobile**: Easier to reach and interact with
4. **Smooth Animations**: Better visual feedback

### Why Shared Widgets?
1. **DRY Principle**: Don't Repeat Yourself
2. **Consistency**: Same look and feel across the app
3. **Maintainability**: Single source of truth
4. **Testability**: Easier to test unified components

### Why This Structure?
1. **Separation of Concerns**: Core widgets in `core/widgets`
2. **Feature-Specific**: Feature widgets in `features/*/presentation/widgets`
3. **Reusability**: Shared components accessible to all features
4. **Scalability**: Easy to add new features

## Completed Changes ✅

### Phase 1: Core Components ✅
- [x] Created `SharedImagePicker` widget
- [x] Created `UnifiedBottomSheet` system
- [x] Added missing string constants (`confirm`)

### Phase 2: Update Categories Screen ✅
- [x] Replaced inline image picker with `SharedImagePicker`
- [x] Replaced delete dialog with `UnifiedBottomSheet.showConfirmation`
- [x] Removed duplicate image display code

### Phase 3: Update Addons Screen ✅
- [x] Replaced inline image picker with `SharedImagePicker`
- [x] Replaced delete dialog with bottom sheet
- [x] Updated image picker to use `pickImageWithSource`

### Phase 4: Update Food Items Screens ✅
- [x] Replaced `MealImagePicker` with `SharedImagePicker` in `add_food.dart`
- [x] Replaced `MealImagePicker` with `SharedImagePicker` in `update_food.dart`
- [x] Updated image picker methods to use `pickImageWithSource`
- [x] Added file size validation (1 MB limit)

### Phase 5: Code Cleanup ✅
- [x] Removed `meal_image_picker.dart` (replaced by `SharedImagePicker`)
- [x] Removed duplicate image display code from `update_category.dart`
- [x] Removed duplicate image display code from `update_addon.dart`
- [x] Updated `image_picker_service.dart` to use bottom sheet instead of dialog
- [x] Cleaned up unused imports

### Phase 6: Documentation ✅
- [x] Created comprehensive documentation

## Implementation Details

### Files Created
1. `lib/core/widgets/shared_image_picker.dart` - Unified image picker widget
2. `lib/core/widgets/unified_bottom_sheet.dart` - Modern bottom sheet system
3. `PROJECT_REDESIGN_DOCUMENTATION.md` - This documentation file

### Files Modified
1. `lib/core/services/image_picker_service.dart` - Updated to use bottom sheet
2. `lib/core/constants/app_string.dart` - Added `confirm` constant
3. `lib/features/food_menu/presentation/screens/categories/categories_screen.dart` - Uses bottom sheet
4. `lib/features/food_menu/presentation/screens/categories/update_category.dart` - Uses SharedImagePicker
5. `lib/features/food_menu/presentation/screens/addons/addons_screen.dart` - Uses bottom sheet
6. `lib/features/food_menu/presentation/screens/addons/update_addon.dart` - Uses SharedImagePicker
7. `lib/features/food_menu/presentation/screens/food/add_food.dart` - Uses SharedImagePicker
8. `lib/features/food_menu/presentation/screens/update_food.dart` - Uses SharedImagePicker
9. `lib/features/food_menu/providers/categories/categories_notifier.dart` - Added `setImagePath` method
10. `lib/features/food_menu/providers/custom_addon/custom_addon_notifier.dart` - Updated image picker
11. `lib/features/food_menu/providers/add_item_notifier.dart` - Updated image picker
12. `lib/features/food_menu/providers/update_item/update_item_notifier.dart` - Updated image picker

### Files Deleted
1. `lib/features/food_menu/presentation/widgets/meal_image_picker.dart` - Replaced by SharedImagePicker

## Notes

- All changes maintain backward compatibility where possible
- RTL support is maintained throughout
- ScreenUtil is used for responsive design
- Color and size constants are centralized
- File size validation (1 MB limit) added to all image pickers
- Image source selection (gallery vs files) now uses modern bottom sheet UI
- All image pickers now support network URLs, local files, and base64 strings automatically

## Benefits Achieved

1. **Code Reusability**: Single `SharedImagePicker` widget used across all features
2. **Consistency**: Unified UI/UX for image selection and dialogs
3. **Modern Design**: Bottom sheets instead of traditional dialogs
4. **Maintainability**: Single source of truth for image picker logic
5. **Better UX**: Modern, accessible bottom sheet interactions
6. **Code Quality**: Removed ~200+ lines of duplicate code

