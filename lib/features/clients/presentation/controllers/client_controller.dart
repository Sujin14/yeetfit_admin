import 'package:get/get.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/client_model.dart';
import '../../data/models/plan_model.dart';
import '../../data/models/progress_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/assign_plan.dart';
import '../../domain/usecases/get_client_details.dart';
import '../../domain/usecases/get_client_progress.dart';
import '../../domain/usecases/get_clients_by_goal.dart';

class ClientController extends GetxController {
  final GetClientsByGoal getClientsByGoal;
  final GetClientDetails getClientDetails;
  final GetClientProgress getClientProgress;
  final AssignPlan assignPlan;

  final clients = <ClientModel>[].obs;
  final selectedClient = Rxn<ClientModel>();
  final progress = <ProgressModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  ClientController()
    : getClientsByGoal = GetClientsByGoal(
        ClientRepositoryImpl(service: FirestoreClientService()),
      ),
      getClientDetails = GetClientDetails(
        ClientRepositoryImpl(service: FirestoreClientService()),
      ),
      getClientProgress = GetClientProgress(
        ClientRepositoryImpl(service: FirestoreClientService()),
      ),
      assignPlan = AssignPlan(
        ClientRepositoryImpl(service: FirestoreClientService()),
      );

  Future<void> fetchClients(String goal) async {
    isLoading.value = true;
    error.value = '';
    try {
      final fetchedClients = await getClientsByGoal(goal);
      clients.assignAll(fetchedClients);
    } catch (e) {
      error.value = 'Failed to load clients: $e';
      print('Error fetching clients for goal "$goal": $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClientDetails(String uid) async {
    if (uid.isEmpty) {
      error.value = 'Invalid client ID';
      isLoading.value = false;
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
      } else {
        error.value = 'Client not found for UID: $uid';
        print('fetchClientDetails: Client not found for UID: $uid');
        progress.clear();
      }
    } catch (e) {
      error.value = 'Failed to load client details: $e';
      print('fetchClientDetails: Error for UID: $uid - $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> assignClientPlan(String userId, PlanModel plan) async {
    isLoading.value = true;
    error.value = '';
    try {
      print(
        'assignClientPlan: Assigning plan for userId: $userId, type: ${plan.type}',
      );
      final success = await assignPlan(userId, plan);
      if (success) {
        print('assignClientPlan: Plan assigned successfully');
        final clientProgress = await getClientProgress(userId);
        progress.assignAll(clientProgress);
      } else {
        print('assignClientPlan: Failed to assign plan');
      }
      return success;
    } catch (e) {
      error.value = 'Failed to assign plan: $e';
      print('assignClientPlan: Error for userId: $userId - $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
