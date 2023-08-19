import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:request_builder/src/assets.dart';
import 'package:request_builder/src/extensions.dart';
import 'package:request_builder/request_builder.dart';
import 'package:request_builder/src/state_renderer_impl.dart';

enum NormalRendererType { content }

enum LoadingRendererType { popup, content }

enum ErrorRendererType { popup, toast, content }

enum EmptyRendererType { content }

enum SuccessRendererType { popup, toast, content }

class RenderViewParameters {
  final String message;
  final String subMessage;
  final String errorBottomSheetButtonTitle;
  final Function retryActionFunction;
  final double? maxContentHeight;
  final bool? isSliver;
  final bool? withScaffold;

  RenderViewParameters({
    required this.message,
    this.subMessage = "",
    this.errorBottomSheetButtonTitle = "",
    this.maxContentHeight,
    required this.retryActionFunction,
    this.isSliver = false,
    this.withScaffold = false,
  });
}

class StateRenderer extends StatelessWidget {
  final FlowState state;
  final Function retryActionFunction;
  final double? maxContentHeight;
  final bool? isSliver;
  final bool? withScaffold;

  const StateRenderer({
    Key? key,
    required this.state,
    this.maxContentHeight,
    required this.retryActionFunction,
    this.isSliver = false,
    this.withScaffold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
        constraints: BoxConstraints(
          maxHeight: maxContentHeight ?? 100.h,
        ),
        child: _getStateWidget(context));
    if (isSliver!) {
      widget = SliverToBoxAdapter(
        child: widget,
      );
    }
    if (withScaffold!) {
      widget = Scaffold(
        body: widget,
      );
    }
    return widget;
  }

  Widget _getStateWidget(BuildContext context) {
    switch (state.runtimeType) {
      case LoadingState:
        switch (state.type) {
          case LoadingRendererType.popup:
            return _getPopUpLoadingDialog(
                context, _defaultPopUpLoadingWidget(context));
          case LoadingRendererType.content:
            return _defaultLoadingWidget(context);
        }
        break;
      case ErrorState:
        switch (state.type) {
          case ErrorRendererType.popup:
            return _getPopUpDialog(context, _defaultPopUpErrorWidget(context));
          case ErrorRendererType.content:
            return _defaultErrorWidget(context);
        }
        break;
      case SuccessState:
        switch (state.type) {
          case SuccessRendererType.popup:
            return _getPopUpDialog(
                context, _defaultPopUpSuccessWidget(context));
          case SuccessRendererType.content:
            return _defaultSuccessWidget(context);
        }
      case EmptyState:
        switch (state.type) {
          case EmptyRendererType.content:
            return _defaultEmptyView(context);
        }
      default:
        return Container();
    }
    return Container();
  }

  Widget _getPopUpDialog(BuildContext context, Widget widget) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      elevation: 1.5,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: Colors.black26)]),
        child: widget,
      ),
    );
  }

  Widget _getPopUpLoadingDialog(BuildContext context, Widget view) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: view,
    );
  }

  Widget _getDialogContent(List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
        height: 15.h, width: 15.h, child: Lottie.asset(animationName));
  }

  static Widget defaultLoading() {
    return SizedBox(
        height: 15.h, width: 15.h, child: Lottie.asset(JsonAssets.loading));
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: RequestBuilderInitializer.instance.messageTextStyle,
          )),
    );
  }

  Widget _getTitle(String message) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: RequestBuilderInitializer.instance.titleTextStyle,
          )),
    );
  }

  Widget _getRetryButton(
      String buttonTitle, BuildContext context, Function() onPress) {
    return Center(
      child: ElevatedButton(onPressed: onPress, child: Text(buttonTitle)),
    );
  }

  Widget _defaultPopUpLoadingWidget(BuildContext context) {
    return _getDialogContent([
      _getAnimatedImage(JsonAssets.loading),
      _getTitle(state.title),
      _getMessage(state.message),
    ]);
  }

  Widget _defaultPopUpErrorWidget(BuildContext context) {
    return _getDialogContent([
      _getAnimatedImage(JsonAssets.error),
      _getTitle(state.title),
      _getMessage(state.message),
      _getRetryButton(context.tr!.ok, context, () => Navigator.pop(context))
    ]);
  }

  Widget _defaultLoadingWidget(BuildContext context) {
    return _getItemsColumn([
      _getAnimatedImage(JsonAssets.loading),
      _getTitle(state.title),
      _getMessage(state.message),
    ]);
  }

  Widget _defaultErrorWidget(BuildContext context) {
    return _getItemsColumn([
      _getAnimatedImage(JsonAssets.error),
      _getTitle(state.title),
      _getMessage(state.message),
      _getRetryButton(
          context.tr!.retry, context, () => retryActionFunction.call())
    ]);
  }

  Widget _defaultSuccessWidget(BuildContext context) {
    return _getItemsColumn([
      _getAnimatedImage(JsonAssets.success),
      _getTitle(state.title),
      _getMessage(state.message),
      _getRetryButton(context.tr!.ok, context, () => retryActionFunction.call())
    ]);
  }

  Widget _defaultEmptyView(BuildContext context) {
    return _getItemsColumn([
      _getAnimatedImage(JsonAssets.empty),
      _getTitle(state.title),
      _getMessage(state.message),
    ]);
  }

  Widget _defaultPopUpSuccessWidget(BuildContext context) {
    return _getDialogContent([
      _getAnimatedImage(JsonAssets.success),
      _getTitle(state.title),
      _getMessage(state.message),
      _getRetryButton(context.tr!.ok, context, () => Navigator.pop(context))
    ]);
  }
}
