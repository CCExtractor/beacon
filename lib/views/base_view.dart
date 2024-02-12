import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beacon/locator.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  const BaseView({
    required this.builder,
    this.onModelReady,
  });
  final Function(T)? onModelReady;
  final Widget Function(BuildContext, T, Widget?) builder;

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  late T
      model; // Note: Using `late` to indicate that it will be initialized in initState

  @override
  void initState() {
    super.initState();
    model = locator<T>();

    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}
