import 'package:core/common.dart';

class InjectionException extends CommonException {
  InjectionException({super.message = "Error comun en proceso de inyección"});
}

class NotInjectedException extends InjectionException {}
class AlreadyExistsException extends InjectionException {}
class NotFunctionForInjectionException extends InjectionException {}
