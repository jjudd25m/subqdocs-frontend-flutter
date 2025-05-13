// class KeyboardController extends GetxController with WidgetsBindingObserver {
//   RxBool isKeyboardVisible = RxBool(false);
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.onClose();
//   }
//
//   @override
//   void didChangeMetrics() {
//     final viewInsets = WidgetsBinding.instance.window.viewInsets.bottom ?? 0;
//     isKeyboardVisible.value = viewInsets > 0;
//   }
//
//   void checkKeyboardVisibility(BuildContext context) {
//     final viewInsets = MediaQuery.of(context).viewInsets.bottom;
//     isKeyboardVisible.value = viewInsets > 0;
//   }
// }
