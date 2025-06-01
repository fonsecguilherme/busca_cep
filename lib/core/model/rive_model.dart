import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, srcLight, srcDark;
  late SMIBool? input;

  RiveAsset({
    required this.srcLight,
    required this.srcDark,
    required this.artboard,
    required this.stateMachineName,
    required this.title,
    this.input,
  });

  set setInput(SMIBool status) {
    input = status;
  }
}
