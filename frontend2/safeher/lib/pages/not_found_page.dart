import 'package:flutter/material.dart';
// import 'package:safeher/widgets/default_appbar.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      // appBar: DefaultAppbar(title: ""),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("images/404_cat.png"),
          Text(
            "This Page Does Not Exist",
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
