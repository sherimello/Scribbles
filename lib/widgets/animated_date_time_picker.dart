import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../hero_transition_handler/custom_rect_tween.dart';

class AnimatedDateTimePicker extends StatefulWidget {

  final String tag;

  const AnimatedDateTimePicker(this.tag, {Key? key}) : super(key: key);

  @override
  State<AnimatedDateTimePicker> createState() => _AnimatedDateTimePickerState();
}

class _AnimatedDateTimePickerState extends State<AnimatedDateTimePicker> {
  double hourValue = 0.0, minuteValue = 0.0, movementX = 0, movementY = 0;
  int hour = 0, minute = 0;
  var image = 'lib/assets/images/moonn.png';
  var skyTheme = const Color(0xff334760);
  bool isMorning = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double sunMoonMovementWidth = size.width - 2 * (size.height * .0125);


    bool isPortraitMode() {
      return size.height > size.width ? true : false;
    }


    double skyHeight = isPortraitMode() ? size.height * .17 : size.width * .17
    , imageSize = isPortraitMode()
        ? size.height * .071
        : size.width * .071;


    double setNewXCoordinate() {
      return 0.0;
    }

    bool isSkyColorDark() {
      return skyTheme == const Color(0xff334760) ? true : false;
    }

    return Hero(
      tag: widget.tag,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(31)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 355),
                      width: size.width,
                      height: skyHeight,
                      decoration: BoxDecoration(
                        // image: DecorationImage(image: const AssetImage('lib/assets/images/clouds.png'), opacity: .5, fit: BoxFit.cover, colorFilter: ColorFilter.mode(skyTheme, BlendMode.color)),
                          borderRadius: BorderRadius.circular(31),
                          color: skyTheme
                          ),
                      child: Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              left: movementX,
                              bottom: movementY,
                              // right: size.height * .0125,
                              child: Image.asset(
                                image,
                                height: imageSize,
                                width: imageSize,
                              ),
                              duration: const Duration(milliseconds: 155)
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            hour.toString().padLeft(2, '0') + ":",
                            style: TextStyle(
                                fontSize: isPortraitMode()
                                    ? size.width * .13
                                    : size.height * .13,
                                fontFamily: "varela-round.regular"),
                          ),
                          Text(
                            minuteValue.toInt().toString().padLeft(2, '0'),
                            style: TextStyle(
                                fontSize: size.height > size.width
                                    ? size.width * .13
                                    : size.height * .13,
                                fontFamily: "varela-round.regular"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 11.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 155),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: isMorning ? skyTheme : skyTheme.withOpacity(.15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 155),
                                        style: isSkyColorDark()
                                            ? TextStyle(
                                                color: isMorning ? Colors.white : Colors.black.withOpacity(.15),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "varela-round.regular")
                                            : TextStyle(
                                                color: isMorning ? Colors.black : Colors.black.withOpacity(.15),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "varela-round.regular"),
                                        child: const Text(
                                          'am',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.5),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 155),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: !isMorning ? skyTheme : skyTheme.withOpacity(.15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 155),
                                        style: isSkyColorDark()
                                            ? TextStyle(
                                                color: isMorning ? Colors.black.withOpacity(.15) : Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "varela-round.regular")
                                            : TextStyle(
                                                color: isMorning ? Colors.black.withOpacity(.15) : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "varela-round.regular"),
                                        child: const Text(
                                          'pm',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            const Text(
                              "hour:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: "varela-round.regular"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 11.0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 555),
                                  decoration: BoxDecoration(
                                      color: skyTheme,
                                      borderRadius: BorderRadius.circular(21)),
                                  child: Slider(
                                    activeColor: !isSkyColorDark()
                                        ? Colors.black
                                        : Colors.white,
                                    value: hourValue,
                                    onChanged: (newHourValue) {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        // movementX += 50;
                                        hourValue = newHourValue;

                                        hourValue >= 120 ? isMorning = false : isMorning = true;

                                        hourValue == 0
                                            ? hour = 12
                                            : (hourValue / 10) > 12
                                                ? hour = ((hourValue / 10) - 12)
                                                    .toInt()
                                                : hour = hourValue ~/ 10;

                                        newHourValue >= 60 && newHourValue <= 180
                                            ? image = 'lib/assets/images/suun.png'
                                            : image =
                                                'lib/assets/images/moonn.png';
                                        (newHourValue >= 60 &&
                                                    newHourValue <= 70) ||
                                                (newHourValue >= 170 &&
                                                    newHourValue <= 180)
                                            ? skyTheme = const Color(0xffffbf77)
                                            : newHourValue >= 70 &&
                                                    newHourValue <= 160
                                                ? skyTheme = Colors.lightBlueAccent
                                                : skyTheme =
                                                    const Color(0xff334760);

                                        //for x-axis movement
                                        isPortraitMode()
                                            ? movementX = (((size.width -
                                                        44 -
                                                        imageSize) /
                                                    23)) *
                                                (newHourValue / 10)
                                            : movementX = (((size.width -
                                                        44 -
                                            imageSize) /
                                                    23)) *
                                                (newHourValue / 10);
                                        newHourValue == 110 ||
                                                    newHourValue == 120
                                                ? movementY = (((skyHeight -
                                                            22 -
                                            imageSize) /
                                                        10)) *
                                                    10
                                                : newHourValue > 120
                                                    ? movementY = ((((skyHeight - 22 - imageSize) / 13)) * 13) -
                                                        (((skyHeight - 22 - imageSize) / 11)) *
                                                            ((newHourValue / 10) -
                                                                12)
                                                    : movementY =
                                                        (((skyHeight - 22 - imageSize) / 10)) *
                                                            (newHourValue / 10);
                                      });
                                    },
                                    divisions: 23,
                                    label: hourValue == 0
                                        ? "12"
                                        : (hourValue / 10) > 12
                                            ? ((hourValue / 10) - 12).toString()
                                            : (hourValue / 10).toString(),
                                    min: 0,
                                    max: 230,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Row(
                          children: [
                            const Text(
                              "minute:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: "varela-round.regular"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 11.0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 555),
                                  decoration: BoxDecoration(
                                      color: skyTheme,
                                      borderRadius: BorderRadius.circular(21)),
                                  child: Slider(
                                    activeColor:
                                        skyTheme != const Color(0xff334760)
                                            ? Colors.black
                                            : Colors.white,
                                    value: minuteValue,
                                    onChanged: (newMinuteValue) {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        // movementX += 50;
                                        minuteValue = newMinuteValue;
                                      });
                                    },
                                    divisions: 59,
                                    label: minuteValue.toInt().toString(),
                                    min: 0,
                                    max: 59,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
