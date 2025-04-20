import 'package:core/dependency_injection.dart'
    show
        AlreadyExistsException,
        NotFunctionForInjectionException,
        NotInjectedException;
import 'package:get_it/get_it.dart';

final _instance = GetIt.I;

/// Reads and returns an instance of [T].
/// If [name] is provided, it will search for the specific named instance.
///
/// If the instance does not exist, there are two possible scenarios:
/// 1. If [createIfDontExist] is true and [onCreate] is not null, the instance will be created,
///    registered in GetIt, and then returned.
/// 2. If no instance is found and [createIfDontExist] is false, an exception will be thrown.
T readIt<T extends Object>({
  String? name,
  bool createIfDontExist = false,
  T Function()? onCreate,
}) {
  final bool isRegistered = _instance.isRegistered<T>(instanceName: name);
  if (isRegistered) {
    return _instance.get<T>(instanceName: name);
  } else if (createIfDontExist) {
    if (onCreate == null) {
      throw NotFunctionForInjectionException();
    } else {
      final T newItem = onCreate();
      _instance.registerSingleton(newItem, instanceName: name);
      return newItem;
    }
  }
  throw NotInjectedException();
}

/// adds a new instance of [T] object, if the instance already exists, a exception will be thrown
/// optionally, [name] will be used to name the injected instance
void addIt<T extends Object>(T item, {String? name}) {
  final bool exists = _instance.isRegistered<T>(instanceName: name);
  if (exists) {
    throw AlreadyExistsException();
  }
  _instance.registerSingleton<T>(item, instanceName: name);
}

void resetIt(){
  _instance.reset();
}
