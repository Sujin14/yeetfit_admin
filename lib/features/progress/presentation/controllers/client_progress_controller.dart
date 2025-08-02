import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../clients/data/datasources/firestore_client_service.dart';
import '../../../clients/data/models/client_model.dart';
import '../../../clients/data/repositories/client_repository_impl.dart';
import '../../../clients/domain/usecases/get_client_details.dart';
import '../../data/datasources/progress_datasource.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/usecases/get_dailoy_progress.dart';

class ClientProgressController extends GetxController {
  final GetClientDetails getClientDetails;
  final GetDailyProgress getDailyProgress;

  final client = Rxn<ClientModel>();
  final uid = ''.obs;
  final selectedDate = DateTime.now().obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final progressData = <String, dynamic>{}.obs;

  ClientProgressController()
    : getClientDetails = GetClientDetails(ClientRepositoryImpl(FirestoreClientService())),
      getDailyProgress = GetDailyProgress(ProgressRepositoryImpl(FirestoreProgressService(FirebaseFirestore.instance)));

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['uid'] != null && (args['uid'] as String).isNotEmpty) {
      uid.value = args['uid'] as String;
      fetchClientDetails();
      fetchProgressData();
    } else {
      error.value = 'Client ID is empty.';
    }
  }

  Future<void> fetchClientDetails() async {
    try {
      final clientData = await getClientDetails(uid.value);
      if (clientData != null) {
        client.value = clientData;
      } else {
        error.value = 'Client not found.';
      }
    } catch (e) {
      error.value = 'Failed to load client details: $e';
      Get.snackbar('Error', error.value,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface']);
    }
  }

  Future<void> fetchProgressData([DateTime? date]) async {
    isLoading.value = true;
    error.value = '';
    final dateToFetch = date ?? selectedDate.value;
    final dateStr = DateFormat('yyyy-MM-dd').format(dateToFetch);

    try {
      final data = await getDailyProgress(uid.value, dateStr);
      progressData.assignAll(data);
    } catch (e) {
      error.value = 'Failed to load progress data: $e';
      Get.snackbar('Error', error.value,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface']);
    } finally {
      isLoading.value = false;
    }
  }

  void pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AdminTheme.colors['primary']!,
              onPrimary: AdminTheme.colors['onPrimary']!,
              surface: AdminTheme.colors['surface']!,
              onSurface: AdminTheme.colors['textPrimary']!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      fetchProgressData(pickedDate);
    }
  }
}
