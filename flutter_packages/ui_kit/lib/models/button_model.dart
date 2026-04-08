class ButtonModel {
  final String? semantics;
  final String? label;
  final bool isEnabled;
  final bool isLoading;

  final void Function()? onPressed;

  ButtonModel({
    this.isLoading = false,
    this.isEnabled = true,
    this.semantics,
    this.label,
    this.onPressed,
  });
}
