import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.message,
    this.size = LoadingSize.medium,
  });

  final String? message;
  final LoadingSize size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getSize(),
            height: _getSize(),
            child: CircularProgressIndicator(strokeWidth: _getStrokeWidth()),
          ),
          if (message != null) ...[
            SizedBox(height: _getSpacing()),
            Text(
              message!,
              style: TextStyle(
                fontSize: _getTextSize(),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case LoadingSize.small:
        return 24;
      case LoadingSize.medium:
        return 32;
      case LoadingSize.large:
        return 48;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2;
      case LoadingSize.medium:
        return 3;
      case LoadingSize.large:
        return 4;
    }
  }

  double _getSpacing() {
    switch (size) {
      case LoadingSize.small:
        return 8;
      case LoadingSize.medium:
        return 12;
      case LoadingSize.large:
        return 16;
    }
  }

  double _getTextSize() {
    switch (size) {
      case LoadingSize.small:
        return 12;
      case LoadingSize.medium:
        return 14;
      case LoadingSize.large:
        return 16;
    }
  }
}

enum LoadingSize { small, medium, large }
