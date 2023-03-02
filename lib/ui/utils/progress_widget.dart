import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sesa/ui/utils/colors.dart';

oldcircularprogress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(kPrimary),
    ),
  );
}

loading(context) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
      backgroundBlendMode: BlendMode.darken,
      color: Colors.black45,
    ),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(kPrimary),
    ),
  );
}

loader(context) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(kPrimary),
    ),
  );
}

circularprogress() {
  return SizedBox(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.white),
    ),
    height: 20.0,
    width: 20.0,
  );
}
