import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:request_builder/request_builder.dart';
import 'package:request_builder/src/assets.dart';
import 'package:request_builder/src/extensions.dart';

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
  final String? errorImage, successImage, loadingImage, emptyImage;
  final String? errorTitle, successTitle, loadingTitle, emptyTitle;
  final String? errorMessage, successMessage, loadingMessage, emptyMessage;
  final String? successActionTitle;
  final Function? successAction;

  const StateRenderer({
    Key? key,
    required this.state,
    this.maxContentHeight,
    required this.retryActionFunction,
    this.isSliver = false,
    this.withScaffold = false,
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
              context,
              _defaultPopUpLoadingWidget(
                context,
                loadingTitle,
                loadingImage,
                loadingMessage,
              ),
            );
          case LoadingRendererType.content:
            return _defaultLoadingWidget(
              context,
              loadingTitle,
              loadingImage,
              loadingMessage,
            );
        }
        break;
      case ErrorState:
        switch (state.type) {
          case ErrorRendererType.popup:
            return _getPopUpDialog(
              context,
              _defaultPopUpErrorWidget(
                context,
                errorTitle,
                errorImage,
                errorMessage,
                successActionTitle,
                successAction,
              ),
            );
          case ErrorRendererType.content:
            return _defaultErrorWidget(
              context,
              errorTitle,
              errorImage,
              errorMessage,
            );
        }
        break;
      case SuccessState:
        switch (state.type) {
          case SuccessRendererType.popup:
            return _getPopUpDialog(
              context,
              _defaultPopUpSuccessWidget(
                context,
                successTitle,
                successImage,
                successMessage,
                successActionTitle,
                successAction,
              ),
            );
          case SuccessRendererType.content:
            return _defaultSuccessWidget(
              context,
              successTitle,
              successImage,
              successMessage,
              successActionTitle,
              successAction,
            );
        }
      case EmptyState:
        switch (state.type) {
          case EmptyRendererType.content:
            return _defaultEmptyView(
              context,
              emptyTitle,
              emptyImage,
              emptyMessage,
            );
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
            ),
          ],
        ),
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
      height: 15.h,
      width: 15.h,
      child: Lottie.asset(animationName),
    );
  }

  static Widget defaultLoading(String? image) {
    return SizedBox(
      height: 15.h,
      width: 15.h,
      child: Lottie.asset(image ?? JsonAssets.loading),
    );
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: RequestBuilderInitializer.instance.messageTextStyle,
        ),
      ),
    );
  }

  Widget _getTitle(String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message ?? "",
          textAlign: TextAlign.center,
          style: RequestBuilderInitializer.instance.titleTextStyle,
        ),
      ),
    );
  }

  Widget _getRetryButton(
    String buttonTitle,
    BuildContext context,
    Function() onPress,
  ) {
    return Center(
      child: ElevatedButton(
        onPressed: onPress,
        child: Text(
          buttonTitle,
        ),
      ),
    );
  }

  Widget _defaultPopUpLoadingWidget(
    BuildContext context,
    String? title,
    String? image,
    String? message,
  ) {
    return _getDialogContent([
      _getAnimatedImage(image ?? JsonAssets.loading),
      _getTitle(state.title ?? title),
      _getMessage(state.message ?? message ?? ""),
    ]);
  }

  Widget _defaultPopUpErrorWidget(
    BuildContext context,
    String? title,
    String? image,
    String? message,
    String? actionTitle,
    Function? action,
  ) {
    return _getDialogContent([
      _getAnimatedImage(image ?? JsonAssets.error),
      _getTitle(state.title ?? title),
      _getMessage(state.message ?? message ?? ""),
      _getRetryButton(
        actionTitle ?? (context.isEnLanguage ? "Ok" : "حسنا"),
        context,
        () {
          if (action != null) {
            action();
          } else {
            Navigator.pop(context);
          }
        },
      )
    ]);
  }

  Widget _defaultLoadingWidget(
    BuildContext context,
    String? title,
    String? image,
    String? message,
  ) {
    return _getItemsColumn([
      _getAnimatedImage(image ?? JsonAssets.loading),
      _getTitle(state.title ?? title),
      _getMessage(state.message ?? message ?? ""),
    ]);
  }

  Widget _defaultErrorWidget(
    BuildContext context,
    String? title,
    String? image,
    String? message,
  ) {
    return _getItemsColumn([
      _getAnimatedImage(image ?? JsonAssets.error),
      _getTitle(state.title ?? title),
      _getMessage(state.message ?? message ?? ""),
      _getRetryButton(
        context.isEnLanguage ? "Retry" : "اعد المحاولة",
        context,
        () => retryActionFunction.call(),
      )
    ]);
  }

  Widget _defaultSuccessWidget(
    BuildContext context,
    String? title,
    String? image,
    String? message,
    String? actionTitle,
    Function? action,
  ) {
    return _getItemsColumn([
      _getAnimatedImage(image ?? JsonAssets.success),
      _getTitle(state.title ?? title),
      _getMessage(state.message ?? message ?? ""),
      _getRetryButton(
        actionTitle ?? (context.isEnLanguage ? "Ok" : "حسنا"),
        context,
        () {
          if (action != null) {
            action();
          } else {
            Navigator.pop(context);
          }
        },
      )
    ]);
  }

  Widget _defaultEmptyView(
    BuildContext context,
    String? title,
    String? image,
    String? message,
  ) {
    return _getItemsColumn([
      _getAnimatedImage(image ?? JsonAssets.empty),
      _getTitle(state.title ?? title),
      _getMessage(state.message ?? message ?? ""),
    ]);
  }

  Widget _defaultPopUpSuccessWidget(
    BuildContext context,
    String? title,
    String? image,
    String? message,
    String? actionTitle,
    Function? action,
  ) {
    return _getDialogContent([
      _getAnimatedImage(image ?? JsonAssets.success),
      _getTitle(state.title ?? title),
      _getMessage(state.message ?? message ?? ""),
      _getRetryButton(
        actionTitle ?? (context.isEnLanguage ? "Ok" : "حسنا"),
        context,
        () {
          if (action != null) {
            action();
          } else {
            Navigator.pop(context);
          }
        },
      )
    ]);
  }
}
