import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'package:request_builder/src/extensions.dart';
import 'package:request_builder/request_builder.dart';

class FToast {
  static Future<Object?> showCustomToast({
    required BuildContext context,
    required String title,
    required String message,
    required Color color,
  }) {
    return showFlash(
      barrierDismissible: true,
      context: context,
      persistent: true,
      transitionDuration: const Duration(milliseconds: 400),
      duration: const Duration(seconds: 4),
      builder: (context, controller) {
        return Flash(
          position: FlashPosition.bottom,
          dismissDirections: const [FlashDismissDirection.vertical],
          controller: controller,
          child: Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  type: MaterialType.transparency,
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    margin: EdgeInsets.only(
                      bottom: 2.sp,
                      left: 1.sp,
                      right: 1.sp,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: color,
                        )
                      ],
                    ),
                    child: Container(
                      width: context.width * 0.9,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.sp,
                        vertical: 5.sp,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0.5.sp,
                            blurRadius: 0.5.sp,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  title,
                                  style: RequestBuilderInitializer
                                      .instance.titleTextStyle,
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    controller.dismiss();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 1.w, vertical: 1.h),
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.grey.shade300,
                                      size: 4.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey.shade100,
                              thickness: 1.sp,
                            ),
                            Text(
                              message,
                              style: RequestBuilderInitializer
                                  .instance.messageTextStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 2.h,
                            )
                          ],
                        ),
                      )
                      // .addPadding(bottom: 21.0, top: 12.0)
                      ,
                    ),
                  ),
                )
                // .addPadding(bottom: context.height * 0.07)
                ,
              ],
            ),
          ),
        );
      },
    );
  }
}
