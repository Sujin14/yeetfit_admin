import 'package:get/get.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/client_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/get_client_details.dart';
import '../../../../core/theme/theme.dart';

class ClientDetailsController extends GetxController {
  final GetClientDetails getClientDetails;
  final client = Rxn<ClientModel>();
  final clientName = ''.obs;
  final uid = ''.obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final selectedClient = Rxn<ClientModel>();
  final isInvalidUid = false.obs;

  ClientDetailsController()
    : getClientDetails = GetClientDetails(
        ClientRepositoryImpl(FirestoreClientService()),
      );

  @override
  @override
  void onInit() {
    super.onInit();
    print('ClientDetailsController: onInit called');

    final args = Get.arguments;
    print('ClientDetailsController: Arguments received: $args');

    if (args != null &&
        args['uid'] != null &&
        (args['uid'] as String).isNotEmpty) {
      uid.value = args['uid'] as String;
      print('ClientDetailsController: UID set to ${uid.value}');
      fetchClientDetails();
    } else {
      error.value = 'Client ID is empty.';
      isInvalidUid.value = true;
      print('ClientDetailsController: Error - Client ID is empty.');
    }
  }

  Future<void> fetchClientDetails([String? customUid]) async {
    isLoading.value = true;
    error.value = '';
    isInvalidUid.value = false;

    final idToUse = customUid ?? uid.value;

    if (idToUse.isEmpty) {
      error.value = 'Client ID is empty.';
      isInvalidUid.value = true;
      isLoading.value = false;
      return;
    }

    try {
      print('fetchClientDetails: Fetching details for UID: $idToUse');
      final clientData = await getClientDetails(idToUse);

      if (clientData != null) {
        client.value = clientData;
        selectedClient.value = clientData;
        clientName.value = clientData.name;
      } else {
        selectedClient.value = null;
        error.value = 'Client not found.';
      }
    } catch (e) {
      error.value = 'Failed to load client details: $e';
      print('fetchClientDetails: Error - $e');
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToManageDietPlans() {
    print('Navigating to diet plan management for UID: ${uid.value}');
    Get.toNamed(
      '/home/plan-list',
      arguments: {'uid': uid.value, 'type': 'diet'},
    );
  }

  void navigateToManageWorkoutPlans() {
    print('Navigating to workout plan management for UID: ${uid.value}');
    Get.toNamed(
      '/home/plan-list',
      arguments: {'uid': uid.value, 'type': 'workout'},
    );
  }
}
