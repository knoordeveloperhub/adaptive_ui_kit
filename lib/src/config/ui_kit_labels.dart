/// Text labels used across pickers/sheets. Pass your own instance (from
/// an AppStrings/translations class) or use the default English one.
class UiKitLabels {
  final String cancel;
  final String done;
  final String am;
  final String pm;

  const UiKitLabels({
    this.cancel = 'Cancel',
    this.done = 'Done',
    this.am = 'AM',
    this.pm = 'PM',
  });

  static const UiKitLabels defaultLabels = UiKitLabels();
}
