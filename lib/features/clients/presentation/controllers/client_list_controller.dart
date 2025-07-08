import 'package:get/get.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/client_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/get_clients_by_goal.dart';

class ClientListController extends GetxController {
  final GetClientsByGoal getClientsByGoal;
  final clients = <ClientModel>[].obs;
  final filteredClients = <ClientModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  ClientListController()
      : getClientsByGoal = GetClientsByGoal(
          ClientRepositoryImpl(service: FirestoreClientService()),
        );

  @override
  void onInit() {
    super.onInit();
    filteredClients.assignAll(clients);
  }

  Future<void> fetchClients(String goal) async {
    isLoading.value = true;
    error.value = '';
    try {
      print('ClientListController: Fetching clients for goal: $goal');
      final fetchedClients = await getClientsByGoal(goal);
      clients.assignAll(fetchedClients);
      filteredClients.assignAll(fetchedClients);
      print(
          'ClientListController: Fetched ${clients.length} clients for $goal');
    } catch (e) {
      error.value = 'Failed to load clients: $e';
      print('ClientListController: Error fetching clients for goal "$goal": $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterClients(String query, String goal) {
    if (query.isEmpty) {
      filteredClients.assignAll(clients);
    } else {
      filteredClients.assignAll(
        clients
            .where((client) =>
                client.name.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
    print(
        'ClientListController: Filtered ${filteredClients.length} clients for query: $query');
  }
}