import 'package:flutter/material.dart';

class AnimatedDateTimePicker extends StatefulWidget {
  const AnimatedDateTimePicker({Key? key}) : super(key: key);

  @override
  State<AnimatedDateTimePicker> createState() => _AnimatedDateTimePickerState();
}

class _AnimatedDateTimePickerState extends State<AnimatedDateTimePicker> {
  double value = 0.0, movementX = 0, movementY = 0;
  var image = 'lib/assets/images/moon.png';
  var skyTheme = const Color(0xff334760);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double sunMoonMovementWidth = size.width - 2 * (size.height * .0125);
    // double movementX = size.height * .0125, movementY = size.height * .0125, sunMoonMovementWidth = size.width - 2 * (size.height * .0125);


    double setNewXCoordinate(){
      return 0.0;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration:
                BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(31)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 555),
                  width: size.width,
                  height: size.height * .19,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(31),
                      // borderRadius: const BorderRadius.vertical(top: Radius.circular(31), bottom: Radius.circular(31)),
                      color: skyTheme
                    // color:
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
                                height: size.height * .06,
                                width: size.height * .06,
                              ),
                              duration: const Duration(milliseconds: 155)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(19.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 555),
                    decoration: BoxDecoration(
                      color: skyTheme.withOpacity(.35),
                      borderRadius: BorderRadius.circular(21)
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(11.0),
                          child: Text(
                           "set \"hour\" (hh):",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: "varela-round.regular"
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Slider(
                            value: value,
                            onChanged: (newValue) {
                              setState(() {
                                // movementX += 50;
                                value = newValue;


                                newValue >= 60 && newValue <= 180 ? image = 'lib/assets/images/sun.png' : image = 'lib/assets/images/moon.png';
                                (newValue >= 60 && newValue <= 70) || (newValue >= 170 && newValue <= 180) ? skyTheme = const Color(
                                    0xffffbf77) : newValue >= 70 && newValue <= 160 ? skyTheme = Colors.lightBlue : skyTheme = const Color(0xff334760);

                                //for x-axis movement
                                movementX = (((size.width - 44 - size.height * .06 )/23)) * (newValue/10);
                                // newValue > 120 ? movementY = ((((size.height * .19 - 22 - size.height * .05 )/12)) * 12) - (((size.height * .19 - 22 - size.height * .05 )/12)) * ((newValue/10) - 11)
                                // : movementY = (((size.height * .19 - 22 - size.height * .05 )/12)) * (newValue/10);


                                //for y-axis movement
                                newValue == 110 || newValue == 120?
                                movementY = (((size.height * .19 - 22 - size.height * .06 )/10)) * 10 :
                                newValue > 120 ? movementY = ((((size.height * .19 - 22 - size.height * .06 )/13)) * 13) - (((size.height * .19 - 22 - size.height * .06 )/11)) * ((newValue/10) - 12)
                                : movementY = (((size.height * .19 - 22 - size.height * .06 )/10)) * (newValue/10);
                              });
                            },
                            divisions: 23,
                            label: value == 0
                                ? "12"
                                : (value / 10) > 12
                                    ? ((value / 10) - 12).toString()
                                    : (value / 10).toString(),
                            min: 0,
                            max: 230,
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
    );
  }
}
