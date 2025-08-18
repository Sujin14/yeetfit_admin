import 'package:get/get.dart';
import '../../../progress/presentation/controllers/client_progress_controller.dart';
import '../controllers/client_details_controller.dart';

class ClientDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClientDetailsController());
    Get.lazyPut(() => ClientProgressController());
  }
} 