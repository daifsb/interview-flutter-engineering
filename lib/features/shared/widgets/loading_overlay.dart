import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool canPop;
  final bool isLoading;
  final Color? barrierColor;
  final Widget child;

  const LoadingOverlay({
    super.key,
    this.canPop = true,
    required this.isLoading,
    this.barrierColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBarrierColor = isDark ? Colors.black54 : Colors.white54;
    return PopScope(
      canPop: isLoading ? false : canPop,
      child: Stack(
        children: [
          child,
          if (isLoading) ...[
            ModalBarrier(
              dismissible: false,
              color: barrierColor ?? defaultBarrierColor,
            ),
            const LoadingIndicator(),
          ],
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final double androidSize;
  final Color? androidColor;
  final double androidStrokeWidth;
  final double iosRadius;
  final Color? iosColor;

  const LoadingIndicator({
    super.key,
    this.androidSize = 32,
    this.androidColor,
    this.androidStrokeWidth = 4,
    this.iosRadius = 16,
    this.iosColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isAndroid
          ? SizedBox(
              width: androidSize,
              height: androidSize,
              child: CircularProgressIndicator(
                color: androidColor,
                strokeWidth: androidStrokeWidth,
              ),
            )
          : CupertinoActivityIndicator(radius: iosRadius, color: iosColor),
    );
  }
}
