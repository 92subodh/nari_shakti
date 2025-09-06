import 'package:flutter/material.dart';

class TextBody extends StatelessWidget {
  final String size;
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  
  const TextBody({
    super.key, 
    required this.size, 
    required this.text,
    this.color,
    this.textAlign,
  });

  factory TextBody.medium(String text, {Color? color, TextAlign? textAlign}) => 
      TextBody(size: "medium", text: text, color: color, textAlign: textAlign);
  
  factory TextBody.mediumDark(String text, {Color? color, TextAlign? textAlign}) =>
      TextBody(size: "mediumDark", text: text, color: color, textAlign: textAlign);
  
  factory TextBody.small(String text, {Color? color, TextAlign? textAlign}) => 
      TextBody(size: "small", text: text, color: color, textAlign: textAlign);
  
  factory TextBody.large(String text, {Color? color, TextAlign? textAlign}) => 
      TextBody(size: "large", text: text, color: color, textAlign: textAlign);
  
  factory TextBody.description(String text, {Color? color, TextAlign? textAlign}) => 
      TextBody(size: "description", text: text, color: color, textAlign: textAlign);

  @override
  Widget build(BuildContext context) {
    getTextStyle() {
      TextStyle? baseStyle;
      switch (size) {
        case 'large':
          baseStyle = Theme.of(context).textTheme.bodyLarge;
          break;
        case 'medium':
          baseStyle = Theme.of(context).textTheme.bodyMedium;
          break;
        case 'mediumDark':
          baseStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          );
          break;
        case 'small':
          baseStyle = Theme.of(context).textTheme.bodySmall;
          break;
        case 'description':
          baseStyle = Theme.of(context).textTheme.displaySmall;
          break;
        default:
          baseStyle = Theme.of(context).textTheme.bodyMedium;
      }
      
      return baseStyle?.copyWith(color: color) ?? baseStyle;
    }

    return Text(
      text, 
      style: getTextStyle(),
      textAlign: textAlign,
    );
  }
}
