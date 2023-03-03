# Animated feedback and mood rating bar

Smooth animated rating bar for customer and service feedback, equipped with customizable emotion and
mood bars. Create your unique rating bar with custom emojis, texts, ratings, sizes, and animations. Users
can easily change the color of unselected items, providing them with greater control over their
experience.

## Usage

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  emoji_rating_bar: <latest-version>
```

## Feedback Rating Bar
https://user-images.githubusercontent.com/25680329/222731120-c3859b46-fcc8-4c14-9ae8-d5ef286a15d0.mp4
```
EmojiRatingBar()
```

## Mood Rating Bar
https://user-images.githubusercontent.com/25680329/222731313-cd295931-ba12-46b4-9617-3a5b63b71485.mp4
```
EmojiRatingBar(
  ratingBarType: RatingBarType.mood
)
```

## Customise Rating Bar
You can customize the rating bar by providing additional properties to the widget. For example:

```
EmojiRatingBar(
  rating: 2,
  onRateChange: (rating) {
    print(rating);
  },
  isReadOnly: false,
  spacing: 15,
  size: 40,
  selectedSize: 60,
  isShowTitle: true,
  isShowDivider: true,
  titleStyle: TextStyle(
    color: Colors.grey,
    fontSize: 8,
  ),
  selectedTitleStyle: TextStyle(
    color: Colors.black,
    fontSize: 12,
  ),
  animationDuration: Duration(milliseconds: 500),
  animationCurve: Curves.easeInOut,
  ratingBarType: RatingBarType.feedback,
  applyColorFilter : true 
)
```
## Create Custom list
To create a custom emoji list with your own images, you can use the following format:

```
[
  EmojiData(icStrong, "Strong", isPackageImg: true),  // If you use package asset images, you must pass isPackageImg as true
  EmojiData(
    "assets/ic_delighted.png",   // project asset images
    "Delighted")
]
```
