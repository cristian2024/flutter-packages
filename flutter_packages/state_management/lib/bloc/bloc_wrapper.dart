import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef BlocBuilderCondition<S> = bool Function(S previous, S current);

/// A widget that provides a [BlocProvider] if needed, and combines
/// [BlocConsumer], [BlocListener], or [BlocBuilder] functionality.
///
/// This widget accepts either an existing [bloc] instance or a [create] factory
/// function to instantiate the bloc if it doesn't exist in the widget tree.
///
/// The UI can be built with a [builder] function reacting to bloc states,
/// or a static [child] widget can be used if [builder] is null.
///
/// Additionally, it supports a [listener] callback to react to bloc state
/// changes without rebuilding the UI.
///
/// The optional [listenWhen] and [buildWhen] callbacks can be used to
/// control when the listener or builder are invoked based on state changes.
///
/// Example usage with builder and listener:
/// ```dart
/// BlocProviderConsumer<MyBloc, MyState>(
///   create: () => MyBloc(),
///   listener: (context, state) {
///     // handle side effects
///   },
///   builder: (context, state) => Text('State: $state'),
/// )
/// ```
///
/// Example usage with listener and static child:
/// ```dart
/// BlocProviderConsumer<MyBloc, MyState>(
///   bloc: existingBloc,
///   listener: (context, state) {
///     // handle side effects
///   },
///   child: Text('Static UI'),
/// )
/// ```
class BlocWrapper<B extends BlocBase<S>, S> extends StatelessWidget {
  /// An existing bloc instance to use.
  final B? bloc;

  /// Factory function to create the bloc if [bloc] is not provided.
  final B Function()? create;

  /// Builds the UI based on the bloc's state.
  ///
  /// If null, [child] is used instead.
  final BlocWidgetBuilder<S>? builder;

  /// A static widget displayed when [builder] is null.
  final Widget? child;

  /// Reacts to bloc state changes without rebuilding UI.
  final BlocWidgetListener<S>? listener;

  /// Controls when the listener is called based on previous and current state.
  final BlocListenerCondition<S>? listenWhen;

  /// Controls when the builder is called based on previous and current state.
  final BlocBuilderCondition<S>? buildWhen;

  /// Creates a [BlocWrapper].
  ///
  /// Requires either [bloc] or [create], and either [builder] or [child].
  const BlocWrapper({
    super.key,
    this.bloc,
    this.create,
    this.builder,
    this.child,
    this.listener,
    this.listenWhen,
    this.buildWhen,
  }) : assert(
         bloc != null || create != null,
         'Either provide bloc or create factory.',
       ),
       assert(
         builder != null || child != null,
         'Either provide builder or child.',
       );

  bool _effectiveBuildWhen(S previous, S current) {
    if (builder == null) return false;
    if (buildWhen == null) return true;
    return buildWhen!.call(previous, current);
  }

  @override
  Widget build(BuildContext context) {
    Widget? internChild;

    if (listener != null && builder != null) {
      internChild = BlocConsumer<B, S>(
        bloc: bloc,
        listenWhen: listenWhen,
        buildWhen: _effectiveBuildWhen,
        listener: listener!,
        builder: builder!,
      );
    } else if (listener != null) {
      internChild = BlocListener<B, S>(
        bloc: bloc,
        listenWhen: listenWhen,
        listener: listener!,
        child: child,
      );
    } else if (builder != null) {
      internChild = BlocBuilder<B, S>(
        bloc: bloc,
        buildWhen: _effectiveBuildWhen,
        builder: builder!,
      );
    }

    if (bloc == null && create != null) {
      return BlocProvider<B>(create: (_) => create!.call(), child: internChild);
    }

    return internChild ?? const SizedBox.shrink();
  }
}
