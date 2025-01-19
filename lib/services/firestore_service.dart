import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/exam_model.dart';

Future<void> addExam(Exam exam) async {
  final firestore = FirebaseFirestore.instance;
  try {
    await firestore.collection('exams').add(exam.toMap());
    print('Exam added successfully');
  } catch (e) {
    print('Error adding exam: $e');
  }
}


Future<List<Exam>> fetchExamsForDay(DateTime date) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final startOfDay = Timestamp.fromDate(DateTime(date.year, date.month, date.day));
    final endOfDay = Timestamp.fromDate(DateTime(date.year, date.month, date.day, 23, 59, 59));

    final querySnapshot = await firestore
        .collection('exams')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .get();

    return querySnapshot.docs.map((doc) => Exam.fromMap(doc.data())).toList();
  } catch (e) {
    print('Error fetching exams: $e');
    return [];
  }
}

