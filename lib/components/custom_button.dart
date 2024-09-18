import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract class AbstractButton extends StatelessWidget {
  final String buttonText;
  final IconData iconData;
  final Color iconColor;
  final Color textColor;
  final Color backgroundColor;
  final void Function() onTap;
  final double? width;
  final double? height;
  final double gap;
  final double iconSize;
  final double borderRadius;
  final EdgeInsets padding;

  const AbstractButton(
      {required this.buttonText,
      required this.iconData,
      required this.backgroundColor,
      required this.iconColor,
      required this.textColor,
      required this.onTap,
      this.width,
      this.height,
      this.gap = 10,
      this.iconSize = 25,
      this.borderRadius = 10,
      this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: buttonText,
      child: InkWell(
        onTap: onTap,
        child: Material(
          //  elevation: 5,
          // borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              color: Colors.white,
              //        borderRadius: BorderRadius.circular(borderRadius),
              //        color: backgroundColor
            ),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(iconData, size: iconSize, color: iconColor),
                  SizedBox(width: gap),
                  Flexible(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      buttonText,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: textColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AssignButton extends AbstractButton {
  static const Color fixedIconColor = Colors.black; // Fixed color for the icon
  static const Color fixedTextColor = Colors.black; // Fixed color for the text

  AssignButton({
    required bool isAssigned,
    // String buttonText = 'Assign',
    IconData iconData = Icons.assignment_ind_outlined,
    required void Function() onTap,
    double? width,
    double? height,
    double gap = 10,
    //  double iconSize = 16,
    double borderRadius = 10,
  }) : super(
          buttonText: isAssigned ? 'Assigned' : 'Assign',
          iconData: iconData,
          iconColor: fixedIconColor,
          textColor: fixedTextColor,
          backgroundColor: Colors.grey.shade50,
          onTap: onTap,
          width: width,
          height: height,
          gap: gap,
          //    iconSize: iconSize,
          borderRadius: borderRadius,
        );
}

class DeleteButton extends AbstractButton {
  static const Color fixedIconColor = Colors.black; // Fixed color for the icon
  static const Color fixedTextColor = Colors.black; // Fixed color for the text

  DeleteButton({
    required void Function() onTap,
    double? width,
    double? height,
    double gap = 10,
    // double iconSize = 16,
    double borderRadius = 10,
  }) : super(
          buttonText: 'Delete',
          iconData: Icons.delete_outline,
          iconColor: fixedIconColor,
          textColor: fixedTextColor,
          backgroundColor: Colors.grey.shade50,
          onTap: onTap,
          width: width,
          height: height,
          gap: gap,
          //  iconSize: iconSize,
          borderRadius: borderRadius,
        );
}

class ImageButton extends AbstractButton {
  static const Color fixedIconColor = Colors.black; // Fixed color for the icon
  static const Color fixedTextColor = Colors.black; // Fixed color for the text

  ImageButton({
    required void Function() onTap,
    double? width,
    double? height,
    double gap = 10,
    // double iconSize = 16,
    double borderRadius = 10,
  }) : super(
          buttonText: 'Image',
          iconData: Icons.image_outlined,
          iconColor: fixedIconColor,
          textColor: fixedTextColor,
          backgroundColor: Colors.grey.shade50,
          onTap: onTap,
          width: width,
          height: height,
          gap: gap,
          // iconSize: iconSize,
          borderRadius: borderRadius,
        );
}

class ApproveButton extends AbstractButton {
  static const Color fixedIconColor = Colors.black; // Fixed color for the icon
  static const Color fixedTextColor = Colors.black; // Fixed color for the text

  ApproveButton({
    required bool isApproved,
    // String buttonText = 'Assign',
    required void Function() onTap,
    double? width,
    double? height,
    double gap = 10,
    //  double iconSize = 16,
    double borderRadius = 10,
  }) : super(
          buttonText: isApproved ? 'Approved' : 'Approve',
          iconData: isApproved ? Icons.done_all : Icons.done,
          iconColor: fixedIconColor,
          textColor: fixedTextColor,
          backgroundColor: Colors.grey.shade50,
          onTap: onTap,
          width: width,
          height: height,
          gap: gap,
          //    iconSize: iconSize,
          borderRadius: borderRadius,
        );
}

class RejectButton extends AbstractButton {
  static const Color fixedIconColor = Colors.black; // Fixed color for the icon
  static const Color fixedTextColor = Colors.black; // Fixed color for the text

  RejectButton({
    required void Function() onTap,
    double? width,
    double? height,
    double gap = 10,
    // double iconSize = 16,
    double borderRadius = 10,
  }) : super(
          buttonText: 'Reject',
          iconData: Icons.close_rounded,
          iconColor: fixedIconColor,
          textColor: fixedTextColor,
          backgroundColor: Colors.grey.shade50,
          onTap: onTap,
          width: width,
          height: height,
          gap: gap,
          //    iconSize: iconSize,
          borderRadius: borderRadius,
        );
}

class StartButton extends AbstractButton {
  static const Color fixedIconColor = Colors.black; // Fixed color for the icon
  static const Color fixedTextColor = Colors.black; // Fixed color for the text

  StartButton({
    required void Function() onTap,
    double? width,
    double? height,
    double gap = 10,
    // double iconSize = 16,
    double borderRadius = 10,
  }) : super(
          buttonText: 'Take Action',
          iconData: Icons.content_paste_go_sharp,
          iconColor: fixedIconColor,
          textColor: fixedTextColor,
          backgroundColor: Colors.grey.shade50,
          onTap: onTap,
          width: width,
          height: height,
          gap: gap,
          //    iconSize: iconSize,
          borderRadius: borderRadius,
        );
}

class SimpleButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Color backgroundColor;
  final void Function() onTap;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets padding;
  final Border? border;
  final FontWeight fontWeight;
  final EdgeInsets margin;

  const SimpleButton({
    required this.buttonText,
    required this.onTap,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.width,
    this.height,
    this.borderRadius = 10,
    this.border,
    this.padding = EdgeInsets.zero,
    this.fontWeight = FontWeight.bold,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: buttonText,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: margin,
          height: height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(borderRadius),
            color: backgroundColor,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(color: textColor, fontWeight: fontWeight),
            ),
          ),
        ),
      ),
    );
  }
}
