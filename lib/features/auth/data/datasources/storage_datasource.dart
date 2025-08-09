import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage(String userId, File file) async {
    try {
      // Validate file size (e.g., max 5MB)
      if (file.lengthSync() > 5 * 1024 * 1024) {
        throw Exception('Image size exceeds 5MB limit');
      }

      // Create a reference for the image
      final ref = _storage.ref().child('users/$userId/profile.jpg');

      // Upload the file
      await ref.putFile(file);

      // Get the download URL
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }
}