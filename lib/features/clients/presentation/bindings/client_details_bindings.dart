import 'package:get/get.dart';
import '../controllers/client_details_controller.dart';

class ClientDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClientDetailsController());
  }
}
