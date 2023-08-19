import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:request_builder/src/assets.dart';

import 'state_renderer_impl.dart';

class RequestBuilderInitializer {
  static RequestBuilderInitializer? _instance;
  GlobalKey<NavigatorState>? navigatorKey;
  Widget? loadingView;
  Widget? errorView;
  Widget? emptyView;
  Widget? successView;
  Widget? popUpLoadingView;
  Widget? popUpErrorView;
  Widget? popUpSuccessView;
  TextStyle? titleTextStyle;
  TextStyle? messageTextStyle;
  Color mainColor;
  Color errorColor;

  static RequestBuilderInitializer get instance {
    assert(_instance != null,
    "You must initialize [RequestBuilderInitializer] \n ");
    return _instance!;
  }

  RequestBuilderInitializer._({
    this.navigatorKey,
    this.loadingView,
    this.errorView,
    this.emptyView,
    this.successView,
    this.popUpLoadingView,
    this.popUpErrorView,
    this.popUpSuccessView,
    this.titleTextStyle,
    this.messageTextStyle,
    required this.mainColor,
    required this.errorColor,
  });

  factory RequestBuilderInitializer.init({
    required GlobalKey<NavigatorState> navigatorKey,
    Widget? loadingView,
    Widget? errorView,
    Widget? emptyView,
    Widget? successView,
    Widget? popUpLoadingView,
    Widget? popUpErrorView,
    Widget? popUpSuccessView,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    Color mainColor = AppColors.mainColor,
    Color errorColor = AppColors.errorColor,
  }) {
    return _instance ??= RequestBuilderInitializer._(
      navigatorKey: navigatorKey,
      loadingView: loadingView,
      errorView: errorView,
      emptyView: emptyView,
      successView: successView,
      popUpLoadingView: popUpLoadingView,
      popUpErrorView: popUpErrorView,
      popUpSuccessView: popUpSuccessView,
      titleTextStyle: titleTextStyle,
      messageTextStyle: messageTextStyle,
      mainColor: mainColor,
      errorColor: errorColor,
    );
  }
}

class RequestBuilder<B extends StateStreamable<FlowState>>
    extends StatelessWidget {
  static late BuildContext appContext;

  final Widget Function(BuildContext, B) contentBuilder;
  final Function(BuildContext, B)? retry;
  final Widget? loadingView;
  final Widget? errorView;
  final Widget? emptyView;
  final Widget? successView;
  final Widget? popUpLoadingView;
  final Widget? popUpErrorView;
  final Widget? popUpSuccessView;
  final double? maxContentHeight;
  final bool? isSliver;
  final bool? withScaffold;
  final Function(BuildContext, B, FlowState)? listener;
  final Function(BuildContext, B)? onSuccess;
  final Function(BuildContext, B)? onError;
  final Function(BuildContext, B)? onContent;
  final bool preventDefaultListener;

  const RequestBuilder({
    Key? key,
    required this.contentBuilder,
    required this.retry,
    this.loadingView,
    this.errorView,
    this.emptyView,
    this.successView,
    this.popUpLoadingView,
    this.popUpErrorView,
    this.popUpSuccessView,
    this.maxContentHeight,
    this.isSliver = false,
    this.withScaffold = false,
    this.listener,
    this.onSuccess,
    this.onError,
    this.onContent,
    this.preventDefaultListener = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    appContext = context;
    RequestBuilderInitializer.instance;
    return BlocConsumer<B, FlowState>(
      listener: (context, state) async {
        if (!preventDefaultListener) {
          state.flowStateListener(
            context,
            popUpErrorView: popUpErrorView,
            popUpLoadingView: popUpErrorView,
            popUpSuccessView: popUpErrorView,
          );
        }
        if (listener != null) listener!(context, context.read<B>(), state);
        if (state is SuccessState && onSuccess != null) {
          onSuccess!(context, context.read<B>());
        }
        if (state is ErrorState && onError != null) {
          onError!(context, context.read<B>());
        }
        if (state is ContentState && onContent != null) {
          onContent!(context, context.read<B>());
        }
      },
      builder: (context, state) {
        return state.flowStateBuilder(
          context,
          screenContent: Builder(builder: (context) {
            return contentBuilder.call(context, context.read<B>());
          }),
          retry: () {
            retry?.call(context, context.read<B>());
          },
          loadingView: loadingView,
          errorView: errorView,
          emptyView: emptyView,
          successView: successView,
          maxContentHeight: maxContentHeight,
          isSliver: isSliver,
          withScaffold: withScaffold,
        );
      },
    );
  }
}

extension OnWidget on Widget {
  Widget requestBuilder<B extends StateStreamable<FlowState>>({
    Function(BuildContext, B)? retry,
    Widget? loadingView,
    Widget? errorView,
    Widget? emptyView,
    Widget? successView,
    double? maxContentHeight,
    bool? isSliver = false,
    Function(BuildContext, B, FlowState)? listener,
    bool preventDefaultListener = false,
  }) {
    return RequestBuilder<B>(
      listener: listener,
      contentBuilder: (a, c) => this,
      retry: retry,
      loadingView: loadingView,
      errorView: errorView,
      emptyView: emptyView,
      successView: successView,
      maxContentHeight: maxContentHeight,
      isSliver: isSliver,
    );
  }
}
