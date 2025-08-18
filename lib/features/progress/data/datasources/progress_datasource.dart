import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProgressService {
  final FirebaseFirestore firestore;

  FirestoreProgressService(this.firestore);

  Future<Map<String, dynamic>?> getDailyProgress({
    required String uid,
    required String category,
    required String subcategory,
    required String date,
  }) async {
    if (category == 'food' && subcategory == 'daily_goals') {
      // Aggregate calories from food/food/{date}/meals collection
      double totalCalories = 0;
      try {
        final mealsSnapshot = await firestore
            .collection('users')
            .doc(uid)
            .collection('progress')
            .doc('food')
            .collection('food')
            .doc(date)
            .collection('meals')
            .get();

        for (var doc in mealsSnapshot.docs) {
          final data = doc.data();
          if (data['calories'] is num) {
            totalCalories += (data['calories'] as num).toDouble();
          }
        }
      } catch (e) {
        print('Error fetching food data for $uid/$date: $e');
        return {
          'goalCalories': 2000.0,
          'currentCalories': 0.0,
          'error': 'Failed to fetch food data: $e',
        };
      }

      // Fetch goalCalories from the diets collection
      try {
        final dietSnapshot = await firestore
            .collection('users')
            .doc(uid)
            .collection('diets')
            .where('userId', isEqualTo: uid)
            .where('type', isEqualTo: 'diet')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

        final goalCalories = dietSnapshot.docs.isNotEmpty
            ? (dietSnapshot.docs.first.data()['totalCalories'] as num?)?.toDouble() ?? 2000.0
            : 2000.0;

        print('Food progress for $uid/$date: goalCalories=$goalCalories, currentCalories=$totalCalories');
        return {
          'goalCalories': goalCalories,
          'currentCalories': totalCalories,
        };
      } catch (e) {
        print('Error fetching diet data for $uid: $e');
        return {
          'goalCalories': 2000.0,
          'currentCalories': totalCalories,
          'error': 'Failed to fetch diet data: $e',
        };
      }
    }

    // Handle other progress categories
    final docRef = firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc(category)
        .collection(subcategory)
        .doc(date);

    try {
      final doc = await docRef.get();
      print('Fetching progress for path: ${docRef.path}, exists: ${doc.exists}, data: ${doc.data()}');
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error fetching progress for ${docRef.path}: $e');
      return null;
    }
  }
}