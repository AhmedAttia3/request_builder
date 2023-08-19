import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:request_builder/src/extensions.dart';
import 'package:request_builder/src/flash_toast_helper.dart';
import 'package:request_builder/request_builder.dart';
import 'package:request_builder/src/request_builder_widget.dart';

import 'state_renderer.dart';

abstract class FlowState<T> extends Equatable {
  final String title;
  final String message;

  T? get type;

  const FlowState({
    this.title = "",
    this.message = "",
  });
}

class InitialState extends FlowState<NormalRendererType> {
  const InitialState();

  @override
  List<Object?> get props => [];

  @override
  NormalRendererType? get type => NormalRendererType.content;
}

class LoadingState extends FlowState<LoadingRendererType> {
  const LoadingState({required this.type, super.title, super.message});

  @override
  final LoadingRendererType type;

  @override
  String get title =>
      super.title.isEmpty ? RequestBuilder.appContext.tr!.loading : "";

  @override
  List<Object?> get props => [type, title];
}

class ErrorState extends FlowState<ErrorRendererType> {
  const ErrorState({required this.type, super.title, required super.message});

  @override
  String get title =>
      super.title.isEmpty ? RequestBuilder.appContext.tr!.error : "";
  @override
  final ErrorRendererType type;

  @override
  List<Object?> get props => [type, title];
}

class ContentState<T> extends FlowState<NormalRendererType> {
  const ContentState({this.data, this.randomInt, this.isLastPage = false});

  final int? randomInt;

  final T? data;

  final bool isLastPage;

  @override
  NormalRendererType? get type => NormalRendererType.content;

  @override
  List<Object?> get props => [randomInt, data];
}

class EmptyState extends FlowState<EmptyRendererType> {
  const EmptyState({ super.title,required super.message});

  @override
  String get title =>
      super.title.isEmpty ? RequestBuilder.appContext.tr!.noDate : "";

  @override
  final EmptyRendererType type = EmptyRendererType.content;

  @override
  List<Object?> get props => [title];
}

class SuccessState extends FlowState<SuccessRendererType> {
  const SuccessState({required this.type, super.title, super.message});

  @override
  String get title =>
      super.title.isEmpty ? RequestBuilder.appContext.tr!.success : "";
  @override
  final SuccessRendererType type;

  @override
  List<Object?> get props => [type, title];
}

extension FlowStateExtension on FlowState {
  Widget flowStateBuilder(
    BuildContext context, {
    required Widget screenContent,
    required Function retry,
    Widget? loadingView,
    Widget? errorView,
    Widget? emptyView,
    Widget? successView,
    double? maxContentHeight,
    bool? isSliver = false,
    bool? withScaffold = false,
  }) {
    switch (runtimeType) {
      case InitialState:
        Widget w = const Center();
        if (isSliver!) {
          w = SliverToBoxAdapter(
            child: w,
          );
        }
        return w;

      case ContentState:
        {
          return screenContent;
        }

      case LoadingState:
        {
          if (type == LoadingRendererType.content) {
            // full screen loading state
            return loadingView ??RequestBuilderInitializer.instance.loadingView??
                StateRenderer(
                    state: this,
                    retryActionFunction: retry,
                    maxContentHeight: maxContentHeight,
                    isSliver: isSliver,
                    withScaffold: withScaffold);
          } else {
            // show content ui of the screen
            return screenContent;
          }
        }
      case ErrorState:
        {
          if (type == ErrorRendererType.content) {
            // full screen error state
            return errorView ??RequestBuilderInitializer.instance.errorView??
                StateRenderer(
                    state: this,
                    retryActionFunction: retry,
                    maxContentHeight: maxContentHeight,
                    isSliver: isSliver,
                    withScaffold: withScaffold);
          } else {
            return screenContent;
          }
        }
      case EmptyState:
        {
          return emptyView ??RequestBuilderInitializer.instance.emptyView??
              StateRenderer(
                  state: this,
                  retryActionFunction: () {},
                  maxContentHeight: maxContentHeight,
                  isSliver: isSliver,
                  withScaffold: withScaffold);
        }
      case SuccessState:
        {
          // i should check if we are showing loading popup to remove it before showing success popup
          if (type == SuccessRendererType.content) {
            // full screen success state
            return successView ??RequestBuilderInitializer.instance.successView??
                StateRenderer(
                    state: this,
                    retryActionFunction: retry,
                    maxContentHeight: maxContentHeight,
                    isSliver: isSliver,
                    withScaffold: withScaffold);
          } else {
            return screenContent;
          }
        }
      default:
        {
          return screenContent;
        }
    }
  }

  void flowStateListener(
    BuildContext context, {
    Function? retry,
    Widget? popUpLoadingView,
    Widget? popUpErrorView,
    Widget? popUpSuccessView,
    double? maxContentHeight,
  }) {
    dismissDialog(context);
    switch (runtimeType) {
      case LoadingState:
        {
          if (type == LoadingRendererType.popup) {
            // show popup loading
            showPopup(
                context,
                popUpLoadingView ??RequestBuilderInitializer.instance.popUpLoadingView??
                    StateRenderer(
                        state: this,
                        retryActionFunction: () {},
                        maxContentHeight: maxContentHeight),
                dismiss: false);
          }
        }
        break;
      case ErrorState:
        {
          if (type == ErrorRendererType.popup) {
            // show popup error
            showPopup(
                context,
                popUpErrorView ??RequestBuilderInitializer.instance.popUpErrorView??
                    StateRenderer(
                        state: this,
                        retryActionFunction: () {},
                        maxContentHeight: maxContentHeight));
          } else if (type == ErrorRendererType.toast) {
            FToast.showCustomToast(
                context: context,
                title: title,
                message: message,
                color: RequestBuilderInitializer.instance.errorColor);
          }
        }
        break;
      case SuccessState:
        {
          // i should check if we are showing loading popup to remove it before showing success popup
          if (type == SuccessRendererType.popup) {
            // show popup error
            showPopup(
                context,
                popUpSuccessView ??RequestBuilderInitializer.instance.popUpSuccessView??
                    StateRenderer(
                        state: this,
                        retryActionFunction: () {},
                        maxContentHeight: maxContentHeight));
          } else if (type == SuccessRendererType.toast) {
            FToast.showCustomToast(
                context: context,
                message: message,
                title: title,
                color: RequestBuilderInitializer.instance.mainColor);
          }
        }
        break;
      case EmptyState:
      case ContentState:
        break;
    }
  }

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing) {
      _isCurrentDialogShowing = false;
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
    BuildContext context,
    Widget widget, {
    bool dismiss = true,
  }) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isCurrentDialogShowing = true;
      await showDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          barrierDismissible: dismiss,
          context: context,
          builder: (BuildContext context) => BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: widget,
              ));
      _isCurrentDialogShowing = false;
    });
  }

// showErrorToast(
//     BuildContext context, String message,
//     {String title = ""}) {
//   WidgetsBinding.instance.addPostFrameCallback((_) =>
//       FToast.showError(
//           context: RequestBuilderInitializer.instance.navigatorKey!.currentContext!,
//           content: message,));
// }
//
// showSuccessToast(
//     BuildContext context, String message,
//     {String title = ""}) {
//   if (message.isEmpty) return;
//   WidgetsBinding.instance.addPostFrameCallback((_) =>
//       FToast.showSuccess(
//           context: RequestBuilderInitializer.instance.navigatorKey!.currentContext!,
//           content: message,));
// }
}

bool _isCurrentDialogShowing = false;
