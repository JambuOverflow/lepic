class WordSection {
  bool isPressed = false;
  bool hasComment = false;

  final Function highlightFunction;
  final Function commentFunction;

  WordSection({this.highlightFunction, this.commentFunction});
}