import 'package:flutter/material.dart';

class TextTitle extends StatelessWidget {
  final String size;
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  
  const TextTitle({
    super.key, 
    required this.size, 
    required this.text,
    this.color,
    this.textAlign,
  });

  factory TextTitle.medium(String text, {Color? color, TextAlign? textAlign}) =>
      TextTitle(size: 'medium', text: text, color: color, textAlign: textAlign);

  factory TextTitle.small(String text, {Color? color, TextAlign? textAlign}) => 
      TextTitle(size: 'small', text: text, color: color, textAlign: textAlign);
  
  factory TextTitle.large(String text, {Color? color, TextAlign? textAlign}) =>
      TextTitle(size: 'large', text: text, color: color, textAlign: textAlign);
  
  factory TextTitle.greeting(String text, {Color? color, TextAlign? textAlign}) =>
      TextTitle(size: 'greeting', text: text, color: color, textAlign: textAlign);
  
  factory TextTitle.primary(String text, {Color? color, TextAlign? textAlign}) =>
      TextTitle(size: 'primary', text: text, color: color, textAlign: textAlign);

  @override
  Widget build(BuildContext context) {
    getTextStyle() {
      TextStyle? baseStyle;
      switch (size) {
        case 'large':
          baseStyle = Theme.of(context).textTheme.titleLarge;
          break;
        case 'medium':
          baseStyle = Theme.of(context).textTheme.titleMedium;
          break;
        case 'small':
          baseStyle = Theme.of(context).textTheme.titleSmall;
          break;
        case 'greeting':
          baseStyle = Theme.of(context).textTheme.headlineLarge;
          break;
        case 'primary':
          baseStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          );
          break;
        default:
          baseStyle = Theme.of(context).textTheme.titleMedium;
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
