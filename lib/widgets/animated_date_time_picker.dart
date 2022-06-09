import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedDateTimePicker extends StatefulWidget {
  const AnimatedDateTimePicker({Key? key}) : super(key: key);

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
    // double movementX = size.height * .0125, movementY = size.height * .0125, sunMoonMovementWidth = size.width - 2 * (size.height * .0125);

    double setNewXCoordinate() {
      return 0.0;
    }

    bool isSkyColorDark() {
      return skyTheme == const Color(0xff334760) ? true : false;
    }

    bool isPortraitMode() {
      return size.height > size.width ? true : false;
    }

    return SafeArea(
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
                  Container(
                    // duration: const Duration(milliseconds: 555),
                    width: size.width,
                    height:
                        isPortraitMode() ? size.height * .19 : size.width * .19,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: const AssetImage('lib/assets/images/clouds.png'), opacity: .5, fit: BoxFit.cover, colorFilter: ColorFilter.mode(skyTheme, BlendMode.color)),
                        borderRadius: BorderRadius.circular(31),
                        // borderRadius: const BorderRadius.vertical(top: Radius.circular(31), bottom: Radius.circular(31)),
                        color: skyTheme
                        // color:
                        ),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Stack(
                        children: [
                          // Expanded(
                          //   child: Image.asset('lib/assets/images/clouds.png',
                          //   fit: BoxFit.fill,
                          //   ),
                          // ),
                          Positioned(
                            left: movementX,
                            bottom: movementY,
                            // right: size.height * .0125,
                            child: Image.asset(
                              image,
                              height: isPortraitMode()
                                  ? size.height * .071
                                  : size.width * .071,
                              width: size.height > size.width
                                  ? size.height * .071
                                  : size.width * .071,
                            ),
                            // duration: const Duration(milliseconds: 155)
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
                                              color: isMorning ? Colors.white : Colors.black.withOpacity(.35),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "varela-round.regular")
                                          : TextStyle(
                                              color: isMorning ? Colors.black : Colors.black.withOpacity(.35),
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
                                              color: isMorning ? Colors.black.withOpacity(.35) : Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "varela-round.regular")
                                          : TextStyle(
                                              color: isMorning ? Colors.black.withOpacity(.35) : Colors.black,
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
                                              ? skyTheme = Colors.lightBlueAccent.withOpacity(.55)
                                              : skyTheme =
                                                  const Color(0xff334760);

                                      //for x-axis movement
                                      isPortraitMode()
                                          ? movementX = (((size.width -
                                                      44 -
                                                      size.height * .071) /
                                                  23)) *
                                              (newHourValue / 10)
                                          : movementX = (((size.width -
                                                      44 -
                                                      size.width * .071) /
                                                  23)) *
                                              (newHourValue / 10);
                                      // newHourValue > 120 ? movementY = ((((size.height * .19 - 22 - size.height * .05 )/12)) * 12) - (((size.height * .19 - 22 - size.height * .05 )/12)) * ((newHourValue/10) - 11)
                                      // : movementY = (((size.height * .19 - 22 - size.height * .05 )/12)) * (newHourValue/10);

                                      //for y-axis movement
                                      isPortraitMode()
                                          ? newHourValue == 110 ||
                                                  newHourValue == 120
                                              ? movementY = (((size.height * .19 -
                                                          22 -
                                                          size.height * .071) /
                                                      10)) *
                                                  10
                                              : newHourValue > 120
                                                  ? movementY = ((((size.height * .19 - 22 - size.height * .071) / 13)) * 13) -
                                                      (((size.height * .19 - 22 - size.height * .071) / 11)) *
                                                          ((newHourValue / 10) -
                                                              12)
                                                  : movementY =
                                                      (((size.height * .19 - 22 - size.height * .071) / 10)) *
                                                          (newHourValue / 10)
                                          : newHourValue == 110 ||
                                                  newHourValue == 120
                                              ? movementY =
                                                  (((size.width * .19 - 22 - size.width * .071) / 10)) *
                                                      10
                                              : newHourValue > 120
                                                  ? movementY = ((((size.width * .19 - 22 - size.width * .071) / 13)) * 13) -
                                                      (((size.width * .19 - 22 - size.width * .071) / 11)) *
                                                          ((newHourValue / 10) - 12)
                                                  : movementY = (((size.width * .19 - 22 - size.width * .071) / 10)) * (newHourValue / 10);
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
    );
  }
}
