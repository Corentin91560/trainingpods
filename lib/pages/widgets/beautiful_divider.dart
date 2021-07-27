import 'package:flutter/cupertino.dart';

import '../../theme.dart';

class BeautifulDivider extends StatelessWidget {
  const BeautifulDivider({Key? key, String? text})
      : this.text = text,
        super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: <Color>[
                    CustomTheme.whiteAppBarBackground,
                    CustomTheme.black,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 1.0),
                  stops: <double>[0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
          text != null
              ? Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    'Or',
                    style: TextStyle(
                        color: CustomTheme.black,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansMedium'),
                  ),
                )
              : Container(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: <Color>[
                    CustomTheme.black,
                    CustomTheme.whiteAppBarBackground,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 1.0),
                  stops: <double>[0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            width: 100.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
