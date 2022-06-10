import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';

import '../hero_transition_handler/custom_rect_tween.dart';
import '../hero_transition_handler/hero_dialog_route.dart';
import '../widgets/animated_date_time_picker.dart';

class TaskCreationPage extends StatefulWidget {
  final String tag;
  const TaskCreationPage(this.tag, {Key? key}) : super(key: key);

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  bool scheduleButtonClicked = false;
  final _searchFieldController = TextEditingController();
  var _groupValue = -1;
  bool _isScheduleSelected = false, _isTaskWritten = false;
  var selectedColor = "0xfff7a221";

  @override
  void initState() {
    _searchFieldController.addListener(() {
      setState(() {
        _searchFieldController.text.isNotEmpty
            ? _isTaskWritten = true
            : _isTaskWritten = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);
    double saveCardSize = size.width * .055;

    GestureDetector roundedColorPalette(int color) {
      return GestureDetector(
        onTap: () {
          setState(() {
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
      setState(() {
        print(
            newTime.hourOfPeriod.toString() + ":" + newTime.minute.toString());
      });
    }

    promptDateTimePicker() {
      setState(() {
        scheduleButtonClicked = !scheduleButtonClicked;
      });
      print(scheduleButtonClicked);
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

    bool isPortraitMode() {
      return size.height > size.width ? true : false;
    }

    double skyHeight = isPortraitMode() ? size.height * .17 : size.width * .17,
        imageSize = isPortraitMode() ? size.height * .045 : size.width * .045;

    return Hero(
      tag: widget.tag,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF8F0E3),
        body: SafeArea(
          child: Container(
            width: size.width,
            decoration: const BoxDecoration(
              color: Color(0xffF8F0E3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Center(
                        child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                roundedColorPalette(0xffe78848),
                                roundedColorPalette(0xffb44c4b),
                                roundedColorPalette(0xffd2ad7e),
                                roundedColorPalette(0xfff7a221),
                                roundedColorPalette(0xff02708b),
                              ],
                            )),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(11),
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.note,
                                size: 15,
                                color: Color(int.parse(selectedColor)),
                              ),
                            ),
                            const TextSpan(
                                text: "  what's on your mind?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Rounded_Elegance",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ]),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 355),
                        decoration: BoxDecoration(
                            color: Color(int.parse(selectedColor)),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Material(
                            color: Colors.transparent,
                            child: TextField(
                              controller: _searchFieldController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Rounded_Elegance",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Rounded_Elegance",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "write task here..."),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(11, 11, 5.5, 11),
                            child: Visibility(
                              maintainAnimation: true,
                              maintainState: true,
                              visible: _isTaskWritten,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(context)
                                      .push(HeroDialogRoute(
                                    builder: (context) => const Center(
                                      child: AnimatedDateTimePicker("000"),
                                      // child: AnimatedDateTimePicker(),
                                    ),
                                    // settings: const RouteSettings(),
                                  ));
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 355),
                                  decoration: BoxDecoration(
                                      color: Color(int.parse(selectedColor))
                                          .withOpacity(.15),
                                      borderRadius: BorderRadius.circular(21)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.alarm_on_outlined,
                                          size: imageSize,
                                          color: Color(int.parse(selectedColor))
                                              .withOpacity(1),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 11.0),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: const Text(
                                              "scheduled task",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Rounded_Elegance",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5.5, 11, 11, 11),
                            child: Visibility(
                              maintainAnimation: true,
                              maintainState: true,
                              visible: _isTaskWritten,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 355),
                                decoration: BoxDecoration(
                                    color: Color(int.parse(selectedColor))
                                        .withOpacity(.15),
                                    borderRadius: BorderRadius.circular(21)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.alarm_off,
                                        size: imageSize,
                                        color: Color(int.parse(selectedColor))
                                            .withOpacity(1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 11.0),
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: const Text(
                                            "non-scheduled",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Rounded_Elegance",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
