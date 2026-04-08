import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:state_management/bloc/bloc_wrapper.dart' show BlocWrapper;

class CounterCubit extends Cubit<int> {
  CounterCubit([super.initialState = 0]);

  void increment() => emit(state + 1);
}

class MockCounterCubit extends Mock implements CounterCubit {}

void main() {
  setUpAll(() {
    registerFallbackValue(0);
  });

  testWidgets('builds with builder when provided', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocWrapper<CounterCubit, int>(
          create: () => CounterCubit(42),
          builder:
              (context, state) =>
                  Text('State: $state', textDirection: TextDirection.ltr),
        ),
      ),
    );

    expect(find.text('State: 42'), findsOneWidget);
  });

  testWidgets('calls listener on state change', (tester) async {
    int calledWith = -1;

    final cubit = CounterCubit(0);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocWrapper<CounterCubit, int>(
          bloc: cubit,
          listener: (context, state) {
            calledWith = state;
          },
          builder: (context, state) => Container(),
        ),
      ),
    );

    cubit.increment();
    await tester.pump();

    expect(calledWith, 1);
  });

  testWidgets('renders child if builder is null', (tester) async {
    final cubit = CounterCubit();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocWrapper<CounterCubit, int>(
          bloc: cubit,
          listener: (context, state) {},
          child: const Text('Static child', textDirection: TextDirection.ltr),
        ),
      ),
    );

    expect(find.text('Static child'), findsOneWidget);
  });

  testWidgets('throws assertion if neither bloc nor create provided', (
    _,
  ) async {
    expect(
      () => BlocWrapper<CounterCubit, int>(
        builder: (context, state) => Container(),
      ),
      throwsAssertionError,
    );
  });

  testWidgets('thrws assertion if neither builder nor child provided', (
    _,
  ) async {
    expect(
      () => BlocWrapper<CounterCubit, int>(create: () => CounterCubit()),
      throwsAssertionError,
    );
  });

  testWidgets('listenWhen prevents listener call when returns false', (
    tester,
  ) async {
    int calledWith = -1;

    final cubit = CounterCubit(0);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocWrapper<CounterCubit, int>(
          bloc: cubit,
          listener: (context, state) {
            calledWith = state;
          },
          listenWhen: (previous, current) => false,
          builder: (context, state) => Container(),
        ),
      ),
    );

    cubit.increment();
    await tester.pump();

    expect(
      calledWith,
      -1,
    ); // listener no fue llamado porque listenWhen es false
  });

  testWidgets('buildWhen prevents builder rebuild when returns false', (
    tester,
  ) async {
    final cubit = CounterCubit(0);
    int buildCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: BlocWrapper<CounterCubit, int>(
          bloc: cubit,
          builder: (context, state) {
            buildCount++;
            return Text('State: $state', textDirection: TextDirection.ltr);
          },
          buildWhen: (previous, current) => false,
        ),
      ),
    );

    expect(buildCount, 1);

    cubit.increment();
    await tester.pump();

    // buildCount no aumentó porque buildWhen impidió la reconstrucción
    expect(buildCount, 1);
  });

  testWidgets('uses BlocProvider when create is provided and bloc is null', (
    tester,
  ) async {
    final cubit = CounterCubit(10);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocWrapper<CounterCubit, int>(
          create: () => cubit,
          builder:
              (context, state) =>
                  Text('State: $state', textDirection: TextDirection.ltr),
        ),
      ),
    );

    expect(find.text('State: 10'), findsOneWidget);
  });

  testWidgets('uses bloc passed via parameter without creating another', (
    tester,
  ) async {
    final cubit = CounterCubit(5);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocWrapper<CounterCubit, int>(
          bloc: cubit,
          builder:
              (context, state) =>
                  Text('State: $state', textDirection: TextDirection.ltr),
        ),
      ),
    );

    expect(find.text('State: 5'), findsOneWidget);
  });
}
