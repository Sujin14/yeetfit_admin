import 'package:get/get.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/client_model.dart';
import '../../data/models/progress_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/get_client_details.dart';
import '../../domain/usecases/get_client_progress.dart';

class ClientDetailsController extends GetxController {
  final GetClientDetails getClientDetails;
  final GetClientProgress getClientProgress;
  final selectedClient = Rxn<ClientModel>();
  final progress = <ProgressModel>[].obs;
  final uid = ''.obs;
  final clientName = Rxn<String>();
  final isInvalidUid = false.obs;
  final isLoading = false.obs;
  final error = ''.obs;

  ClientDetailsController()
    : getClientDetails = GetClientDetails(
        ClientRepositoryImpl(service: FirestoreClientService()),
      ),
      getClientProgress = GetClientProgress(
        ClientRepositoryImpl(service: FirestoreClientService()),
      );

  @override
  void onInit() {
    super.onInit();
    print('ClientDetailsController: onInit called');
    ever(selectedClient, (client) {
      clientName.value = client?.name;
      print(
        'ClientDetailsController: Client name updated to ${clientName.value}',
      );
    });
  }

  void _initialize() {
    final args = Get.arguments;
    print('ClientDetailsController: Arguments received: $args');
    final argsUid = args?['uid'] as String?;
    if (argsUid == null || argsUid.isEmpty) {
      isInvalidUid.value = true;
      error.value = 'Invalid or missing client ID';
      print('ClientDetailsController: Invalid or missing UID');
      return;
    }
    isInvalidUid.value = false;
    if (uid.value != argsUid) {
      uid.value = argsUid;
      print('ClientDetailsController: UID set to ${uid.value}');
      fetchClientDetails(uid.value);
    } else {
      print('ClientDetailsController: UID unchanged, skipping fetch');
    }
  }

  Future<void> fetchClientDetails(String uid) async {
    if (uid.isEmpty) {
      error.value = 'Invalid client ID';
      isLoading.value = false;
      isInvalidUid.value = true;
      print('fetchClientDetails: UID is empty');
      return;
    }
    isLoading.value = true;
    error.value = '';
    try {
      print('fetchClientDetails: Fetching details for UID: $uid');
      final client = await getClientDetails(uid);
      if (client != null) {
        print(
          'fetchClientDetails: Client found - Name: ${client.name}, Email: ${client.email}',
        );
        selectedClient.value = client;
        final clientProgress = await getClientProgress(uid);
        print(
          'fetchClientDetails: Progress fetched - ${clientProgress.length} entries',
        );
        progress.assignAll(clientProgress);
        isInvalidUid.value = false;
      } else {
        error.value = 'Client not found for UID: $uid';
        print('fetchClientDetails: Client not found for UID: $uid');
        progress.clear();
        isInvalidUid.value = true;
      }
    } catch (e) {
      error.value = 'Failed to load client details: $e';
      print('fetchClientDetails: Error for UID: $uid - $e');
      isInvalidUid.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void reinitialize() {
    print('ClientDetailsController: Reinitializing');
    _initialize();
  }

  void navigateToAddDietPlan() {
    if (!isInvalidUid.value) {
      print(
        'ClientDetailsController: Navigating to /home/plan-form with type: diet',
      );
      Get.toNamed(
        '/home/plan-form',
        arguments: {'uid': uid.value, 'mode': 'add', 'type': 'diet'},
      );
    }
  }

  void navigateToManageDietPlans() {
    if (!isInvalidUid.value) {
      print(
        'ClientDetailsController: Navigating to /home/diet-plan-management',
      );
      Get.toNamed(
        '/home/diet-plan-management',
        arguments: {'uid': uid.value, 'type': 'diet'},
      );
    }
  }

  void navigateToAddWorkoutPlan() {
    if (!isInvalidUid.value) {
      print(
        'ClientDetailsController: Navigating to /home/plan-form with type: workout',
      );
      Get.toNamed(
        '/home/plan-form',
        arguments: {'uid': uid.value, 'mode': 'add', 'type': 'workout'},
      );
    }
  }

  void navigateToManageWorkoutPlans() {
    if (!isInvalidUid.value) {
      print(
        'ClientDetailsController: Navigating to /home/workout-plan-management',
      );
      Get.toNamed(
        '/home/workout-plan-management',
        arguments: {'uid': uid.value, 'type': 'workout'},
      );
    }
  }
}
