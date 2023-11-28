import 'package:flutter/material.dart';
import 'package:gg_tv/styles.dart';

buildInfoSheet(BuildContext context,
    {required String headerText,
    required String infoText,
    Function? onActionButtonPress,
    String? actionButtonText}) {
  return showBottomSheet(
      backgroundColor: Color.fromARGB(255, 18, 17, 18),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14), topRight: Radius.circular(14))),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 275,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel_sharp,
                            color: Colors.blueGrey[900]))
                  ],
                ),
                Text(
                  headerText,
                  style: AppStyles.giga18Text,
                ),
                Text(infoText),
                if (onActionButtonPress != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: () {
                        onActionButtonPress;
                      },
                      color: Color.fromARGB(255, 202, 0, 248),
                      child: Text(
                        actionButtonText!,
                        style: AppStyles.giga18Text
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      });
}
