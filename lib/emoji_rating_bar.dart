export 'constant.dart';
export 'emoji_data.dart';
export 'rating_bar_type.dart';

import 'dart:async';

import 'package:emoji_rating_bar/rating_bar_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'constant.dart';
import 'emoji_data.dart';

typedef RatingChangeCallback = void Function(double rating);

/// This class is used to create a smooth animated service feedback bar and
/// mood rating bar with emoji.
///
/// It provides various properties to customize the rating bar
class EmojiRatingBar extends StatefulWidget {
  /// Provide initial rating
  final double rating;

  /// A callback function used to return the selected rating value.
  final RatingChangeCallback? onRateChange;

  /// Spacing between two item
  final double spacing;

  /// Size for unselected item
  final double size;

  /// Size for selected item
  final double selectedSize;

  /// Specifies whether the rating bar is only visible and user interaction is
  /// disabled. Defaults to false.
  final bool isReadOnly;

  /// list of custom emoji data that can be used to customize the rating bar.
  /// Each EmojiData item in the list contains an image and text for a custom emoji.
  final List<EmojiData>? list;

  /// Indicates whether the bottom title description should be shown or hidden.
  /// Defaults to true.
  final bool isShowTitle;

  /// Indicates whether a divider should be shown between each item
  /// Defaults to true.
  final bool isShowDivider;

  /// The style of the title displayed below the rating bar.
  final TextStyle titleStyle;

  /// The text style to be applied to the title of the selected item in the rating bar.
  final TextStyle selectedTitleStyle;

  /// Determines whether the rating updates on the web when the mouse hovers over it.
  /// Defaults to true.
  final bool webUpdateOnHover;

  /// The duration of the animation for rating bar items. Defaults to Duration(milliseconds: 100).
  final Duration animationDuration;

  /// Specifies the curve for the rating bar animation. Defaults to [Curves.bounceInOut].
  final Curve animationCurve;

  ///Defines the type of rating bar to display. It can be either [RatingBarType.mood]
  /// [RatingBarType.feedback].
  final RatingBarType ratingBarType;

  /// Determines whether to apply color filtering to the rating bar icons.
  /// If set to true, color filtering will be applied to the rating bar icons,
  /// If set to false, no color filtering will be applied and the rating bar icons.
  /// Default value is true.
  final bool applyColorFilter;

  /// The color filter to apply to the rating bar. If [applyColorFilter] is set to
  /// true, this filter will be applied to the rating bar.
  ///
  /// By default, it is set to [greyscale].
  final ColorFilter colorFilter;

  const EmojiRatingBar(
      {super.key,
      this.isReadOnly = false,
      this.spacing = 15.0,
      this.size = 50,
      this.selectedSize = 65,
      this.rating = 0,
      this.onRateChange,
      this.list,
      this.isShowTitle = true,
      this.isShowDivider = true,
      this.titleStyle = const TextStyle(color: Colors.grey, fontSize: 8),
      this.selectedTitleStyle =
          const TextStyle(color: Colors.black, fontSize: 10),
      this.webUpdateOnHover = false,
      this.animationDuration = const Duration(milliseconds: 100),
      this.animationCurve = Curves.bounceInOut,
      this.ratingBarType = RatingBarType.feedback,
      this.applyColorFilter = true,
      this.colorFilter = greyscale})
      : assert(rating >= 0, "Rating cannot be negative."),
        assert(
            selectedSize >= size,
            "The size of the selected emoji must be greater than or equal to "
            "the size of the normal emoji."),
        assert(spacing >= 0, "Spacing cannot be negative."),
        assert(
            (list == null) ? (rating <= 5) : rating <= (list.length),
            "If a list is provided, the rating value must be less than or equal "
            "to the length of the list and  If a list is not provided, "
            "the rating value must be less than or equal to 5.");

  @override
  EmojiRatingBarState createState() => EmojiRatingBarState();
}

class EmojiRatingBarState extends State<EmojiRatingBar> {
  ValueNotifier<double> currentRating = ValueNotifier(0);
  Timer? debounceTimer;

  ValueNotifier<double> selectedItemSpacing = ValueNotifier(0);

  List<EmojiData> itemList = [];

  @override
  void initState() {
    if (widget.rating != 0) {
      currentRating.value = widget.rating;
      updateRatingChange();
    }

    if (widget.list != null && widget.list?.isNotEmpty == true) {
      itemList = widget.list ?? [];
    } else {
      itemList = widget.ratingBarType == RatingBarType.mood
          ? [
              EmojiData(icWorried, "Worried", isPackageImg: true),
              EmojiData(icSad, "Sad", isPackageImg: true),
              EmojiData(icStrong, "Strong", isPackageImg: true),
              EmojiData(icSmile, "Happy", isPackageImg: true),
              EmojiData(icSurprised, "Surprised", isPackageImg: true),
            ]
          : [
              EmojiData(icWorst, "Worst", isPackageImg: true),
              EmojiData(icPoor, "Poor", isPackageImg: true),
              EmojiData(icAverage, "Average", isPackageImg: true),
              EmojiData(icGood, "Good", isPackageImg: true),
              EmojiData(icExcellent, "Excellent", isPackageImg: true),
            ];
    }
    super.initState();
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    debounceTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.isReadOnly,
      child: kIsWeb
          ? MouseRegion(
              onExit: (event) {
                if (widget.webUpdateOnHover) {
                  updateRatingChange();
                }
              },
              onHover: (event) {
                if (widget.webUpdateOnHover) {
                  calculateCurrentPosition(event.position);
                  debounceTimer?.cancel();
                  debounceTimer = Timer(const Duration(milliseconds: 400), () {
                    updateRatingChange();
                  });
                }
              },
              child: GestureDetector(
                onHorizontalDragUpdate: (dragDetails) {
                  calculateCurrentPosition(dragDetails.globalPosition);
                  debounceTimer?.cancel();
                  debounceTimer = Timer(const Duration(milliseconds: 400), () {
                    updateRatingChange();
                  });
                },
                child: buildMainUi(),
              ),
            )
          : GestureDetector(
              onHorizontalDragUpdate: (dragDetails) {
                calculateCurrentPosition(dragDetails.globalPosition);
                debounceTimer?.cancel();
                debounceTimer = Timer(const Duration(milliseconds: 400), () {
                  updateRatingChange();
                });
              },
              child: buildMainUi(),
            ),
    );
  }

  Widget buildMainUi() {
    return Stack(
      children: [
        if (widget.isShowDivider)
          Container(
            height: 1,
            margin: EdgeInsets.only(
                top: widget.selectedSize / 2,
                left: (widget.selectedSize - widget.size) / 2),
            color: Colors.grey,
            width: (widget.selectedSize * itemList.length) +
                (widget.spacing * (itemList.length - 1)) -
                ((widget.selectedSize - widget.size)),
          ),
        Wrap(
            alignment: WrapAlignment.start,
            spacing: widget.spacing,
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            children: List.generate(
                itemList.length, (index) => buildChildItem(context, index))),
        ValueListenableBuilder(
            valueListenable: selectedItemSpacing,
            builder: (_, value, child) {
              return AnimatedPositioned(
                duration: widget.animationDuration,
                left: value,
                curve: widget.animationCurve,
                child: Image.asset(
                  getSelectedImage(),
                  package: getBigImagePackage(),
                  width: widget.selectedSize,
                  height: widget.selectedSize,
                ),
              );
            })
      ],
    );
  }

  Widget buildChildItem(BuildContext context, int index) {
    Widget icon = InkWell(
      onTap: () {
        currentRating.value = index.toDouble() + 1;
        updateRatingChange();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: widget.selectedSize,
            width: widget.selectedSize,
            child: UnconstrainedBox(
              child: widget.applyColorFilter
                  ? ColorFiltered(
                      colorFilter: greyscale,
                      child: buildNormalImage(index),
                    )
                  : buildNormalImage(index),
            ),
          ),
          if (widget.isShowTitle)
            ValueListenableBuilder(
                valueListenable: currentRating,
                builder: (_, value, child) {
                  return Container(
                    width: widget.selectedSize,
                    padding: EdgeInsets.only(
                        top: (currentRating.value - 1 == index ||
                                currentRating.value == 0 && index == 0)
                            ? 10
                            : 5),
                    child: Text(
                      itemList[index].label,
                      textAlign: TextAlign.center,
                      style: (currentRating.value - 1 == index ||
                              currentRating.value == 0 && index == 0)
                          ? widget.selectedTitleStyle
                          : widget.titleStyle,
                    ),
                  );
                })
        ],
      ),
    );
    return icon;
  }

  Image buildNormalImage(index) => Image.asset(
        itemList[index].image,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        package: itemList[index].isPackageImg == true ? emojiPackage : null,
      );

  String getSelectedImage() {
    if (currentRating.value == 0) {
      return itemList[currentRating.value.toInt()].image;
    }
    return itemList[currentRating.value.toInt() - 1].image;
  }

  String? getBigImagePackage() {
    return itemList[currentRating.value == 0
                    ? currentRating.value.toInt()
                    : currentRating.value.toInt() - 1]
                .isPackageImg ==
            true
        ? emojiPackage
        : null;
  }

  void updateRatingChange() {
    if (widget.onRateChange != null) {
      widget.onRateChange?.call(currentRating.value);
    }
    selectedItemSpacing.value = currentRating.value == 0
        ? 0
        : ((currentRating.value - 1) * widget.selectedSize) +
            (widget.spacing * (currentRating.value - 1));
  }

  void calculateCurrentPosition(Offset position) {
    RenderBox box = context.findRenderObject() as RenderBox;
    var pos = box.globalToLocal(position);
    var i = (pos.dx - widget.spacing) / widget.size;
    var newRating = i.floor().toDouble();

    selectedItemSpacing.value = pos.dx - widget.spacing;

    if (newRating > itemList.length) {
      newRating = itemList.length.toDouble();
    }

    if (newRating < 0) {
      newRating = 0.0;
    }

    currentRating.value = newRating.roundToDouble().toDouble();
  }
}
