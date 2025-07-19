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
        ClientRepositoryImpl(FirestoreClientService()),
      );

  @override
  void onInit() {
    super.onInit();
    _bindClientsStream();
  }

  void _bindClientsStream() {
    isLoading.value = true;
    error.value = '';
    getClientsByGoal(goal).listen(
      (fetchedClients) {
        clients.assignAll(fetchedClients);
        filteredClients.assignAll(fetchedClients);
        isLoading.value = false;
      },
      onError: (e) {
        error.value = 'Failed to load clients: $e';
        isLoading.value = false;
      },
    );
  }

  void retryFetchClients() {
    _bindClientsStream();
  }

  void toggleSearchBar() {
    showSearchBar.value = !showSearchBar.value;

    if (!showSearchBar.value) {
      searchController.clear();
      searchQuery.value = '';
      filteredClients.assignAll(clients);
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    filterClients(value);
  }

  void filterClients(String query) {
    if (query.isEmpty) {
      filteredClients.assignAll(clients);
    } else {
      filteredClients.assignAll(
        clients
            .where(
              (client) =>
                  client.name.toLowerCase().contains(query.toLowerCase()),
            )
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
