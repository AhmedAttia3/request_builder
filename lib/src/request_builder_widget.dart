// ignore_for_file: must_be_immutable

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
  final Function? successAction;
  String? errorImage, successImage, loadingImage, emptyImage;
  String? errorTitle,
      successTitle,
      loadingTitle,
      emptyTitle,
      successActionTitle;
  String? errorMessage, successMessage, loadingMessage, emptyMessage;
  Color mainColor;
  Color errorColor;

  static RequestBuilderInitializer get instance {
    assert(_instance != null,
        "You must initialize [RequestBuilderInitializer] \n RequestBuilderInitializer.init()");
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
    this.loadingImage,
    this.emptyImage,
    this.errorImage,
    this.successImage,
    this.messageTextStyle,
    this.successActionTitle,
    this.successAction,
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
    String? errorImage,
    String? successImage,
    String? loadingImage,
    String? emptyImage,
    String? successActionTitle,
    Function? successAction,
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
      emptyImage: emptyImage,
      errorImage: errorImage,
      loadingImage: loadingImage,
      successImage: successImage,
      successActionTitle: successActionTitle,
      successAction: successAction,
    );
  }

  static void initStrings({
    String? errorTitle,
    String? errorMessage,
    String? successTitle,
    String? successMessage,
    String? loadingTitle,
    String? loadingMessage,
    String? emptyTitle,
    String? emptyMessage,
  }) {
    instance.errorTitle = errorTitle;
    instance.errorMessage = errorMessage;
    instance.successTitle = successTitle;
    instance.successMessage = successMessage;
    instance.loadingTitle = loadingTitle;
    instance.loadingMessage = loadingMessage;
    instance.emptyTitle = emptyTitle;
    instance.emptyMessage = emptyMessage;
  }
}

class RequestBuilder<B extends StateStreamable<FlowState>>
    extends StatelessWidget {
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
  String? errorImage, successImage, loadingImage, emptyImage;
  String? errorTitle,
      successTitle,
      loadingTitle,
      emptyTitle,
      successActionTitle;
  String? errorMessage, successMessage, loadingMessage, emptyMessage;
  final Function(BuildContext, B, FlowState)? listener;
  final Function(BuildContext, B)? onSuccess;
  final Function(BuildContext, B)? onError;
  final Function(BuildContext, B)? onContent;
  final Function? successAction;
  final bool preventDefaultListener;

  RequestBuilder({
    Key? key,
    required this.contentBuilder,
    this.retry,
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
    this.loadingImage,
    this.emptyImage,
    this.errorImage,
    this.successImage,
    this.emptyTitle,
    this.errorTitle,
    this.loadingTitle,
    this.successTitle,
    this.emptyMessage,
    this.errorMessage,
    this.loadingMessage,
    this.successMessage,
    this.successActionTitle,
    this.successAction,
    this.preventDefaultListener = false,
  }) : super(key: key) {
    RequestBuilderInitializer.instance;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, FlowState>(
      listener: (context, state) async {
        if (!preventDefaultListener) {
          state.flowStateListener(
            context,
            popUpErrorView: popUpErrorView,
            popUpLoadingView: popUpLoadingView,
            popUpSuccessView: popUpSuccessView,
            successTitle: successTitle,
            successImage: successImage,
            loadingTitle: loadingTitle,
            loadingImage: loadingImage,
            errorTitle: errorTitle,
            errorImage: errorImage,
            emptyTitle: emptyTitle,
            emptyImage: emptyImage,
            emptyMessage: emptyMessage,
            errorMessage: errorMessage,
            loadingMessage: loadingMessage,
            successMessage: successMessage,
            maxContentHeight: maxContentHeight,
            successActionTitle: successActionTitle,
            successAction: successAction,
            retry: () {
              retry?.call(context, context.read<B>());
            },
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
          successTitle: successTitle,
          successImage: successImage,
          loadingTitle: loadingTitle,
          loadingImage: loadingImage,
          errorTitle: errorTitle,
          errorImage: errorImage,
          emptyTitle: emptyTitle,
          emptyImage: emptyImage,
          emptyMessage: emptyMessage,
          errorMessage: errorMessage,
          loadingMessage: loadingMessage,
          successMessage: successMessage,
          successActionTitle: successActionTitle,
          successAction: successAction,
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
    Widget? popUpLoadingView,
    Widget? popUpErrorView,
    Widget? popUpSuccessView,
    Function(BuildContext, B)? onSuccess,
    Function(BuildContext, B)? onError,
    Function(BuildContext, B)? onContent,
    String? errorImage,
    String? successImage,
    String? loadingImage,
    String? emptyImage,
    String? errorTitle,
    String? successTitle,
    String? loadingTitle,
    String? emptyTitle,
    String? errorMessage,
    String? successMessage,
    String? loadingMessage,
    String? emptyMessage,
    String? successActionTitle,
    Function? successAction,
    double? maxContentHeight,
    bool? withScaffold,
    bool? isSliver = false,
    Function(BuildContext, B, FlowState)? listener,
    bool preventDefaultListener = false,
  }) {
    return RequestBuilder<B>(
      preventDefaultListener: preventDefaultListener,
      listener: listener,
      contentBuilder: (a, c) => this,
      retry: retry,
      popUpErrorView: popUpErrorView,
      popUpLoadingView: popUpLoadingView,
      popUpSuccessView: popUpSuccessView,
      loadingView: loadingView,
      errorView: errorView,
      emptyView: emptyView,
      successView: successView,
      onSuccess: onSuccess,
      onError: onError,
      onContent: onContent,
      successTitle: successTitle,
      successImage: successImage,
      loadingTitle: loadingTitle,
      loadingImage: loadingImage,
      errorTitle: errorTitle,
      errorImage: errorImage,
      emptyTitle: emptyTitle,
      emptyImage: emptyImage,
      emptyMessage: emptyMessage,
      errorMessage: errorMessage,
      loadingMessage: loadingMessage,
      successMessage: successMessage,
      successActionTitle: successActionTitle,
      successAction: successAction,
      withScaffold: withScaffold,
      maxContentHeight: maxContentHeight,
      isSliver: isSliver,
    );
  }
}
