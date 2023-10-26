import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:request_builder/request_builder.dart';
import 'package:request_builder/src/extensions.dart';
import 'package:request_builder/src/flash_toast_helper.dart';

abstract class FlowState<T> extends Equatable {
  final String? message;
  final String? title;

  T? get type;

  const FlowState({this.message, this.title});
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
  List<Object?> get props => [
        type,
        super.title,
        super.message,
      ];
}

class ErrorState extends FlowState<ErrorRendererType> {
  const ErrorState({required this.type, super.title, super.message});

  @override
  final ErrorRendererType type;

  @override
  List<Object?> get props => [
        type,
        super.title,
        super.message,
      ];
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
  const EmptyState({
    super.message,
    super.title,
  });

  @override
  final EmptyRendererType type = EmptyRendererType.content;

  @override
  List<Object?> get props => [
        super.title,
        super.message,
      ];
}

class SuccessState extends FlowState<SuccessRendererType> {
  const SuccessState({required this.type, super.title, super.message});

  @override
  final SuccessRendererType type;

  @override
  List<Object?> get props => [
        type,
        super.title,
        super.message,
      ];
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
    bool? isSliver = false,
    bool? withScaffold = false,
    Function? successAction,
  }) {
    final instance = RequestBuilderInitializer.instance;
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
          String? loadingTitle0 = loadingTitle ?? instance.loadingTitle;
          final loadingImage0 = loadingImage ?? instance.loadingImage;
          final loadingMessage0 = loadingMessage ?? instance.loadingMessage;
          loadingTitle0 ??= context.lng.loading;

          if (type == LoadingRendererType.content) {
            Widget? content = loadingView;
            content ??= instance.loadingView;
            content ??= StateRenderer(
              loadingTitle: loadingTitle0,
              loadingImage: loadingImage0,
              loadingMessage: loadingMessage0,
              state: this,
              retryActionFunction: retry,
              maxContentHeight: maxContentHeight,
              isSliver: isSliver,
              withScaffold: withScaffold,
            );
            // full screen loading state
            return content;
          } else {
            // show content ui of the screen
            return screenContent;
          }
        }
      case ErrorState:
        {
          if (type == ErrorRendererType.content) {
            String? errorTitle0 = errorTitle ?? instance.errorTitle;
            final errorImage0 = errorImage ?? instance.errorImage;
            final errorMessage0 = errorMessage ?? instance.errorMessage;
            errorTitle0 ??= context.lng.error;

            Widget? content = errorView;
            content ??= instance.errorView;
            content ??= StateRenderer(
              errorTitle: errorTitle0,
              errorImage: errorImage0,
              errorMessage: errorMessage0,
              successActionTitle:
                  successActionTitle ?? instance.successActionTitle,
              successAction: successAction ?? instance.successAction,
              state: this,
              retryActionFunction: retry,
              maxContentHeight: maxContentHeight,
              isSliver: isSliver,
              withScaffold: withScaffold,
            );
            // full screen error state
            return content;
          } else {
            return screenContent;
          }
        }
      case EmptyState:
        {
          String? emptyTitle0 = emptyTitle ?? instance.emptyTitle;
          final emptyImage0 = emptyImage ?? instance.emptyImage;
          final emptyMessage0 = emptyMessage ?? instance.emptyMessage;
          emptyTitle0 ??= context.lng.noData;

          Widget? content = emptyView;
          content ??= instance.emptyView;
          content ??= StateRenderer(
            emptyTitle: emptyTitle0,
            emptyImage: emptyImage0,
            emptyMessage: emptyMessage0,
            state: this,
            retryActionFunction: () {},
            maxContentHeight: maxContentHeight,
            isSliver: isSliver,
            withScaffold: withScaffold,
          );
          return content;
        }
      case SuccessState:
        {
          // i should check if we are showing loading popup to remove it before showing success popup
          if (type == SuccessRendererType.content) {
            String? successTitle0 = successTitle ?? instance.successTitle;
            final successImage0 = successImage ?? instance.successImage;
            final successMessage0 = successMessage ?? instance.successMessage;
            successTitle0 ??= context.lng.success;

            Widget? content = successView;
            content ??= instance.successView;
            content ??= StateRenderer(
              successTitle: successTitle0,
              successImage: successImage0,
              successMessage: successMessage0,
              successActionTitle:
                  successActionTitle ?? instance.successActionTitle,
              successAction: successAction ?? instance.successAction,
              state: this,
              retryActionFunction: retry,
              maxContentHeight: maxContentHeight,
              isSliver: isSliver,
              withScaffold: withScaffold,
            );
            // full screen success state
            return content;
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
  }) {
    dismissDialog(context);
    final instance = RequestBuilderInitializer.instance;
    switch (runtimeType) {
      case LoadingState:
        {
          if (type == LoadingRendererType.popup) {
            String? loadingTitle0 = loadingTitle ?? instance.loadingTitle;
            final loadingImage0 = loadingImage ?? instance.loadingImage;
            final loadingMessage0 = loadingMessage ?? instance.loadingMessage;
            loadingTitle0 ??= context.lng.loading;

            Widget? content = popUpLoadingView;
            content ??= instance.popUpLoadingView;
            content ??= StateRenderer(
              loadingTitle: loadingTitle0,
              loadingImage: loadingImage0,
              loadingMessage: loadingMessage0,
              state: this,
              retryActionFunction: () {},
              maxContentHeight: maxContentHeight,
            );
            // show popup loading
            showPopup(context, content, dismiss: false);
          }
        }
        break;
      case ErrorState:
        {
          String? errorTitle0 = errorTitle ?? instance.errorTitle;
          final errorImage0 = errorImage ?? instance.errorImage;
          final errorMessage0 = errorMessage ?? instance.errorMessage;
          errorTitle0 ??= context.lng.error;

          if (type == ErrorRendererType.popup) {
            Widget? content = popUpErrorView;
            content ??= instance.popUpErrorView;
            content ??= StateRenderer(
              errorTitle: errorTitle0,
              errorImage: errorImage0,
              errorMessage: errorMessage0,
              successActionTitle:
                  successActionTitle ?? instance.successActionTitle,
              successAction: successAction ?? instance.successAction,
              state: this,
              retryActionFunction: () {},
              maxContentHeight: maxContentHeight,
            );
            // show popup error
            showPopup(context, content);
          } else if (type == ErrorRendererType.toast) {
            FToast.showCustomToast(
              context: context,
              title: errorTitle0,
              message: message ?? errorMessage0 ?? "",
              color: instance.errorColor,
            );
          }
        }
        break;
      case SuccessState:
        {
          String? successTitle0 = successTitle ?? instance.successTitle;
          final successImage0 = successImage ?? instance.successImage;
          final successMessage0 = successMessage ?? instance.successMessage;
          successTitle0 ??= context.lng.success;

          // i should check if we are showing loading popup to remove it before showing success popup
          if (type == SuccessRendererType.popup) {
            Widget? content = popUpSuccessView;
            content ??= instance.popUpSuccessView;
            content ??= StateRenderer(
              successTitle: successTitle0,
              successImage: successImage0,
              successMessage: successMessage0,
              successActionTitle:
                  successActionTitle ?? instance.successActionTitle,
              successAction: successAction ?? instance.successAction,
              state: this,
              retryActionFunction: () {},
              maxContentHeight: maxContentHeight,
            );
            // show popup error
            showPopup(context, content);
          } else if (type == SuccessRendererType.toast) {
            FToast.showCustomToast(
              context: context,
              title: successTitle0,
              message: message ?? successMessage0 ?? "",
              color: instance.mainColor,
            );
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
          child: Dialog(backgroundColor: Colors.transparent, child: widget, elevation: 0,),
        ),
      );
      _isCurrentDialogShowing = false;
    });
  }
}

bool _isCurrentDialogShowing = false;
