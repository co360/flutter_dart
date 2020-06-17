import 'package:controls_web/controls/home_elements.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls/responsive.dart';

class DashboardIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  const DashboardIcon({Key key, this.icon, this.size = 32}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: Theme.of(context).primaryColor.withOpacity(0.5),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String value;
  final TextStyle valueStyle;
  final String title;
  final TextStyle titleStyle;
  final double titleHeight;
  final Color color;
  final Widget image;
  final Widget icon;
  final Widget body;
  final double width;
  final double height;
  final Widget left;
  final double borderRadius;
  final double avatarRadius;
  final Widget avatarChild;
  final Color avatarColor;
  final double avatarMargin;
  final double elevation;
  const DashboardTile(
      {Key key,
      this.value,
      this.elevation = 2,
      this.valueStyle,
      this.title,
      this.titleStyle,
      this.color,
      this.borderRadius = 15,
      this.avatarMargin = -20,
      this.image,
      this.icon,
      this.titleHeight = 25,
      this.avatarRadius = 30,
      this.avatarColor,
      this.avatarChild,
      this.width = 180,
      this.height = 80,
      this.left,
      this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color _color = color ?? theme.primaryColor;
    ResponsiveInfo responsive = ResponsiveInfo(context);
    return Theme(
        data: theme.copyWith(primaryColor: _color),
        child: Card(
            elevation: elevation,
            shape: RoundedRectangleBorder(
              //side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            color: _color.withAlpha(150),
            child: LayoutBuilder(builder: (ctx, sizes) {
              double w = (responsive.isSmall
                  ? (sizes.maxWidth)
                  : responsive.isMobile
                      ? ((width * 2) < sizes.maxWidth)
                          ? (sizes.maxWidth / 2) - 16
                          : width
                      : width ?? 180);
              //print(w);
              return Container(
                width: w,
                height: height,
                //constraints: BoxConstraints(minHeight: 80),
                child: Stack(
                  children: [
                    Positioned(
                      top: avatarMargin,
                      left: avatarMargin,
                      child: CircleAvatar(
                        backgroundColor: avatarColor ?? brighten(_color, 50),
                        radius: avatarRadius,
                        child: avatarChild,
                      ),
                    ),
                    if (image != null)
                      Positioned(
                        bottom: this.titleHeight / 2,
                        right: 4,
                        child:
                            Container(color: Colors.transparent, child: image),
                      ),
                    if (icon != null)
                      Positioned(
                        left: 10,
                        top: 10,
                        child: icon,
                      ),
                    Positioned(
                      child: Column(mainAxisSize: MainAxisSize.min,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (value != null)
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        value,
                                        style: valueStyle ??
                                            TextStyle(
                                                fontSize: 32,
                                                color: theme.primaryTextTheme
                                                    .bodyText1.color),
                                      ),
                                    ),
                                  if (left != null)
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          left,
                                          if (body != null)
                                            Expanded(child: body)
                                        ]),
                                  if (left == null)
                                    if (body != null) Expanded(child: body),
                                ],
                              ),
                            ),
                            if (title != null)
                              Container(
                                alignment: Alignment.center,
                                height: titleHeight,
                                color: _color.withOpacity(0.2),
                                child: Text(
                                  title ?? '',
                                  style: titleStyle ??
                                      TextStyle(
                                          fontSize: 18,
                                          color: theme.primaryTextTheme
                                              .bodyText1.color),
                                ),
                              ),
                          ]),
                    ),
                  ],
                ),
              );
            })));
  }
}

Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

Color brighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}
