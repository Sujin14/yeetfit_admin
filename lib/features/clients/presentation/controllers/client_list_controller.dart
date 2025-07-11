import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/client_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/get_clients_by_goal.dart';

class ClientListController extends GetxController {
  final String goal;
  final GetClientsByGoal getClientsByGoal;

  final clients = <ClientModel>[].obs;
  final filteredClients = <ClientModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  final RxBool showSearchBar = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  ClientListController(this.goal)
      : getClientsByGoal = GetClientsByGoal(
          ClientRepositoryImpl(service: FirestoreClientService()),
        );

  @override
  void onInit() {
    super.onInit();
    fetchClients(goal); // auto fetch on init
  }

  void toggleSearchBar() {
    showSearchBar.value = !showSearchBar.value;

    if (!showSearchBar.value) {
      searchController.clear();
      searchQuery.value = '';
      filteredClients.assignAll(clients); // show all again
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    filterClients(value);
  }

  Future<void> fetchClients(String goal) async {
    isLoading.value = true;
    error.value = '';
    try {
      final fetchedClients = await getClientsByGoal(goal);
      clients.assignAll(fetchedClients);
      filteredClients.assignAll(fetchedClients); // show all by default
    } catch (e) {
      error.value = 'Failed to load clients: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void filterClients(String query) {
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
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
