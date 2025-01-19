import 'package:flutter/material.dart';
import 'package:lab4/app_colors.dart';
import 'package:lab4/services/firestore_service.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/exam_model.dart';

class Calendar extends StatefulWidget{
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _chosenDay;
  List<Exam> _exams = [];


  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();

  void _addExam() async {
    if (_formKey.currentState!.validate()) {
      final subject = _subjectController.text;
      final time = _timeController.text;
      final location = _locationController.text;

      final newExam = Exam(
        subject: subject,
        date: _chosenDay ?? DateTime.now(),
        time: time,
        location: location,
      );

      await addExam(newExam);

      await _fetchExamsForDay(_chosenDay ?? DateTime.now());

      _subjectController.clear();
      _timeController.clear();
      _locationController.clear();

      Navigator.of(context).pop();
    }
  }

  Future<void> _fetchExamsForDay(DateTime date) async {
    final exams = await fetchExamsForDay(_chosenDay!);
    setState(() {
      _exams = exams;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text("CALENDAR", style: TextStyle(color: AppColors.sage, fontWeight: FontWeight.bold ),) ,
        backgroundColor: AppColors.tundora,
        centerTitle: true,
      ),
      body:Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000,1,1),
            lastDay: DateTime.utc(2050,12,12),
            focusedDay: _focusedDay,
            selectedDayPredicate:(day) => isSameDay(_chosenDay, day),
            onDaySelected: (chosenDay, focusedDay) {
              setState(() {
                _chosenDay = chosenDay;
                _focusedDay = focusedDay;
                _fetchExamsForDay(chosenDay);
              });

            },
            calendarStyle:  CalendarStyle(
                todayDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.sushi
                ),
                selectedDecoration: BoxDecoration(
                    border: Border.all(width: 4, color: AppColors.amber),
                    shape: BoxShape.circle,
                    color: AppColors.buttercup
                )
            ),
          ),
          Expanded(
            child: _exams.isEmpty ? const Center(child: Text('No exams!'),)
            : ListView.builder(
              itemCount: _exams.length,
                itemBuilder: (context, index) {
                  final exam = _exams[index];
                  return ListTile(
                    title: Text(exam.subject),
                    subtitle: Text('${exam.time} at ${exam.location}'),
                  );
                }),
          )
        ],
      ) ,
      floatingActionButton: FloatingActionButton(backgroundColor: AppColors.sushi, foregroundColor: AppColors.amber,onPressed: () {
        showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.sage,
          title: const Text('Add a new exam', style: TextStyle(color: AppColors.tundora),),
          content: Form(
            key: _formKey
          ,child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(cursorColor: AppColors.tundora,
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject', labelStyle: TextStyle(color: AppColors.tundora),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.tundora),
                    ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.tundora),
                )),
                validator: (value) => value!.isEmpty ? 'Must have a subject' : null,
              ),
              TextFormField(cursorColor: AppColors.tundora,
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time', labelStyle: TextStyle(color: AppColors.tundora),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.tundora),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.tundora)
                    )),
                validator: (value) => value!.isEmpty ? 'Must have a time chosen' : null,
              ),
              TextFormField(cursorColor: AppColors.tundora,
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location', labelStyle: TextStyle(color: AppColors.tundora),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.tundora),
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.tundora)
                    )),
                validator: (value) => value!.isEmpty ? 'Must have a location' : null,
              ),
            ],
          )),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel', style: TextStyle(color: AppColors.amber),)),
            ElevatedButton(onPressed: _addExam,
                child: const Text('Add exam', style: TextStyle(color: AppColors.greenLief),),
           )
          ],
        ));
      },
      child: const Icon(Icons.add_circle_outline_outlined, color: AppColors.amber,),),
      );
  }

}



