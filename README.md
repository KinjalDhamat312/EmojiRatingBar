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
![service_feedback](https://user-images.githubusercontent.com/25680329/222745333-f2438102-7ffa-4d24-ab2c-7f85723f04f3.gif)

```
EmojiRatingBar()
```

## Mood Rating Bar
![moodbar](https://user-images.githubusercontent.com/25680329/222745105-ce228e0d-1928-4b42-9fae-f3beabefe6e9.gif)


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
