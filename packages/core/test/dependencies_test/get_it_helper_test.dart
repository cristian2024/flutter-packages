import 'package:core/dependency_injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('addIt function tests', () {
    final String itemToAdd = 'Item to add';
    setUpAll(() {
      addIt<String>(itemToAdd);
    });

    test('Reads correct the added item', () {
      final String itemAdded = readIt<String>();
      expect(itemAdded, itemToAdd);
    });
    test(
      'Throws exception when trying to add an instance of existing type',
      () {
        try {
          addIt<String>('Extra added');
        } catch (e) {
          expect(e.runtimeType, AlreadyExistsException);
        }
      },
    );
    test('Allows to add object of existing type if different name given', () {
      addIt<String>('Extra added', name: 'new');
      final String newString = readIt<String>(name: 'new');

      expect(newString, 'Extra added');
    });
    test(
      'Does not allow to add object of existing type if different name given two times(or more)',
      () {
        try {
          addIt<String>('Extra added', name: 'new');
          final String newString = readIt<String>(name: 'new');
          expect(newString, 'Extra added');

          addIt<String>('new added', name: 'new');
        } catch (e) {
          expect(e.runtimeType, AlreadyExistsException);
        }
      },
    );
  });
  group('readIt function tests', () {
    setUp(() {
      resetIt();
    });

    test('Returns existing instance when registered without name', () {
      addIt<int>(42);
      final result = readIt<int>();
      expect(result, 42);
    });

    test('Returns existing named instance', () {
      addIt<String>('named instance', name: 'special');
      final result = readIt<String>(name: 'special');
      expect(result, 'named instance');
    });

    test(
      'Creates, registers and returns instance if not registered and createIfDontExist is true',
      () {
        final result = readIt<String>(
          createIfDontExist: true,
          onCreate: () => 'created value',
        );

        // Verifica valor retornado
        expect(result, 'created value');

        // Verifica que quedó registrado
        final reread = readIt<String>();
        expect(reread, 'created value');
      },
    );

    test(
      'Creates and registers named instance if not registered and name is provided',
      () {
        final result = readIt<double>(
          name: 'double-special',
          createIfDontExist: true,
          onCreate: () => 3.14,
        );

        expect(result, 3.14);

        final reread = readIt<double>(name: 'double-special');
        expect(reread, 3.14);
      },
    );

    test(
      'Throws NotFunctionForInjectionException when createIfDontExist is true and onCreate is null',
      () {
        expect(
          () => readIt<String>(createIfDontExist: true),
          throwsA(isA<NotFunctionForInjectionException>()),
        );
      },
    );

    test(
      'Throws NotInjectedException when instance is not registered and createIfDontExist is false',
      () {
        expect(() => readIt<bool>(), throwsA(isA<NotInjectedException>()));
      },
    );

    test('Can retrieve multiple named instances of the same type', () {
      addIt<int>(1, name: 'one');
      addIt<int>(2, name: 'two');

      final one = readIt<int>(name: 'one');
      final two = readIt<int>(name: 'two');

      expect(one, 1);
      expect(two, 2);
    });

    test(
      'Throws NotInjectedException if reading a named instance that does not exist',
      () {
        addIt<String>('only this one');
        expect(
          () => readIt<String>(name: 'other'),
          throwsA(isA<NotInjectedException>()),
        );
      },
    );
  });
}
