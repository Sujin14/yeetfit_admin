import 'package:get/get.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/client_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/get_clients_by_goal.dart';

class ClientListController extends GetxController {
  final GetClientsByGoal getClientsByGoal;
  final clients = <ClientModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  ClientListController()
    : getClientsByGoal = GetClientsByGoal(
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
}
