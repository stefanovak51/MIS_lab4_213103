import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Exam {
  String subject;
  DateTime date;
  String time;
  String location;


  Exam({
    required this.subject,
    required this.date,
    required this.time,
    required this.location

  });

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      subject: map['subject'],
      date: map['date'].toDate(),
      time: map['time'],
      location: map['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'date': Timestamp.fromDate(date),
      'time': time,
      'location': location,
    };
  }


}

