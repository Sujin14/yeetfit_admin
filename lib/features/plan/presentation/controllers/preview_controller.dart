import 'package:get/get.dart';

class PreviewController extends GetxController {
  final String controllerTag;
  final previewStates = <bool>[].obs;

  PreviewController(this.controllerTag);

  void initialize(int count) {
    previewStates.assignAll(List.filled(count, false));
  }

  void togglePreview(int index) {
    if (index < previewStates.length) {
      previewStates[index] = !previewStates[index];
      update([index.toString()]);
    }
  }
}