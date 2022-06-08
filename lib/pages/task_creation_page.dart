import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';

class TaskCreationPage extends StatefulWidget {
  const TaskCreationPage({Key? key}) : super(key: key);

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  bool schedule_button_clicked = false;
  @override
  Widget build(BuildContext context) {
    late Color searchBarColor;
    var size = MediaQuery.of(context).size;
    var selectedColor = "0xfff7a221";
    TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);

    GestureDetector roundedColorPalette(int color) {
      return GestureDetector(
        onTap: () {
          setState(() {
            searchBarColor = Color(color);
            selectedColor = color.toString();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: size.height * .045,
            height: size.height * .045,
            child: Center(
              child: Container(
                width: size.height * .045,
                height: size.height * .045,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(color),
                ),
              ),
            ),
            decoration: BoxDecoration(
              // border: Border.all(width: 0, color: Colors.black26),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.grey.shade100, width: 1),
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    List<BoxShadow> boxShadow(double blurRadius, double offset1, double offset2,
        Color colorBottom, Color colorTop) {
      return [
        BoxShadow(
          blurRadius: blurRadius,
          spreadRadius: 0,
          offset: Offset(offset1, offset2),
          color: colorBottom,
        ),
        BoxShadow(
          blurRadius: blurRadius,
          spreadRadius: 0,
          offset: Offset(-offset1, -offset2),
          color: colorTop,
        ),
      ];
    }


    onTimeChanged(TimeOfDay newTime) {

      setState((){

        print(newTime.hourOfPeriod.toString() + ":" + newTime.minute.toString());

      });

    }


    promptDateTimePicker() {
      setState((){
        schedule_button_clicked = !schedule_button_clicked;
      });
      print(schedule_button_clicked);
      Navigator.of(context).push(
        showPicker(
          context: context,
          value: _time,
          onChange: onTimeChanged,
          minuteInterval: MinuteInterval.FIVE,
          // Optional onChange to receive value as DateTime
          onChangeDateTime: (DateTime dateTime) {
            // print(dateTime);
          },
        ),
      );
    }


    return Scaffold(
      backgroundColor: const Color(0xffF8F0E3),
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                // mainAxisSize: schedule_button_clicked ? MainAxisSize.max : MainAxisSize.min,
                mainAxisSize:  MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: GestureDetector(
                      onTap: (){promptDateTimePicker();},
                      child: AnimatedContainer(
                        width: schedule_button_clicked ? size.width -22 : size.width * .45,
                        duration: const Duration(milliseconds: 355),
                        decoration: BoxDecoration(
                            color: Color(int.parse(selectedColor)),
                            borderRadius: BorderRadius.circular(13),),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Center(
                              child: schedule_button_clicked ?
                              const Text(
                                  "hello\nworld",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Rounded_Elegance",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
                                  :  RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.schedule,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                      text: "  schedule task",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Rounded_Elegance",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ]),
                              ),),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
