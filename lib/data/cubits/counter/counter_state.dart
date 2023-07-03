abstract class CounterState {}

class InitialCounterState extends CounterState {
  final int count;

  InitialCounterState(this.count);
}
