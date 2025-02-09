import 'package:rive/rive.dart';

class RiveModel {
  final String src, artboard, stateMachine;
  late SMIBool? status;

  RiveModel({
    required this.src,
    required this.artboard,
    required this.stateMachine,
  });

  set setStatus(SMIBool state) {
    status = state;
  }
}
