import 'dart:ui';

const String emojiPackage = "emoji_rating_bar";

const String icSad = "assets/ic_sad.png";
const String icStrong = "assets/ic_ambitious.png";
const String icSmile = "assets/ic_smile.png";
const String icSurprised = "assets/ic_surprised.png";
const String icWorried = "assets/ic_worried.png";

const String icWorst = "assets/ic_worst.png";
const String icPoor = "assets/ic_poor.png";
const String icAverage = "assets/ic_average.png";
const String icGood = "assets/ic_good.png";
const String icExcellent = "assets/ic_excellent.png";

const ColorFilter greyscale = ColorFilter.matrix(<double>[
  0.333,
  0.333,
  0.333,
  0,
  0,
  0.333,
  0.333,
  0.333,
  0,
  0,
  0.333,
  0.333,
  0.333,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);

ColorFilter getColorFilter(Color color) {
  double red = color.red / 255.0;
  double green = color.green / 255.0;
  double blue = color.blue / 255.0;
  List<double> colorMatrix = <double>[    red, 0, 0, 0, 0,    0, green, 0, 0, 0,    0, 0, blue, 0, 0,    0, 0, 0, 1, 0  ];

  return ColorFilter.matrix(colorMatrix);
}
