import '../Constants/routine.dart';

Map<String, dynamic> getDecodedSettings({
  required String mode,
  required String subMode,
}) {
  Map<String, dynamic> wom = RoutineModes().getProp(mode);
  List<Map<String, dynamic>> womSub = wom['sub'];
  Map<String, dynamic> womSubSettings = womSub.singleWhere((sub) {
    return sub['key'] == subMode;
  });
  return womSubSettings;
}
