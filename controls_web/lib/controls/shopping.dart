import 'package:flutter/material.dart';

enum MainImagePosition { left, rigth, top, bottom }

class ShoppingStatus extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String value;
  final Color valueColor;
  final Color color;
  final double width;
  final Function onPressed;
  const ShoppingStatus({
    Key key,
    this.title,
    this.titleColor = Colors.indigo,
    this.value,
    this.valueColor = Colors.blue,
    this.color,
    this.width,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          width: width,
          color: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (value != null)
                Text(value, style: TextStyle(color: valueColor, fontSize: 18)),
              if (title != null)
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
            ],
          ),
        ),
        onTap: onPressed);
  }
}

class ShoppingDescriptionPage extends StatelessWidget {
  final Widget image;
  final Widget icon;
  final String title;
  final Color titleColor;
  final Color baseColor;
  final String subTitle;
  final String price;
  final String rank;
  final Widget stars;
  final List<Widget> items;
  final String description;
  final String buttonText;
  final Color buttonColor;
  final Function onPressed;
  final Function onClose;
  final Widget button;
  final BoxDecoration decoration;
  final String fontFamily;
  const ShoppingDescriptionPage(
      {this.image,
      this.icon,
      this.title,
      this.fontFamily = 'Sans',
      this.titleColor = Colors.indigo,
      this.baseColor = Colors.blue,
      this.subTitle,
      this.price,
      this.rank,
      this.stars,
      this.decoration,
      this.items,
      this.description,
      this.buttonText,
      this.buttonColor = Colors.red,
      this.onPressed,
      this.onClose,
      this.button,
      Key key})
      : super(key: key);

  @override
  Widget build(context) {
    return Container(
      decoration: decoration,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          if (image != null) image,
          if (icon != null)
            Container(alignment: Alignment.centerRight, child: icon),
          if (title != null)
            SizedBox(
              height: 5,
            ),
          if (title != null)
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                softWrap: true,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ),
          if (subTitle != null)
            SizedBox(
              height: 8,
            ),
          if (subTitle != null)
            Container(
              alignment: Alignment.topLeft,
              child: Text(subTitle ?? '',
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w300)),
            ),
          SizedBox(
            height: 8,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              price ?? '',
              style: TextStyle(
                fontFamily: fontFamily,
                color: baseColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Container(
                height: 52,
                child: Row(
                  children: <Widget>[
                    Text(rank ?? '',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: baseColor)),
                    stars ?? Container(),
                  ],
                )),
          ]),
          if (items != null)
            Wrap(
              //alignment: WrapAlignment.start,
              runSpacing: 3,
              runAlignment: WrapAlignment.start,
              direction: Axis.horizontal,
              spacing: 8,
              children: items,
            ),
          SizedBox(
            height: 8,
          ),
          if (description != null)
            Text(description,
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w300)),
          SizedBox(
            height: 32,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (onClose != null)
              ShoppingButton(
                minWidth: 32,
                maxWidth: 50,
                child: Text('X'),
                onPressed: () {
                  onClose();
                },
              ),
            SizedBox(
              width: 5,
            ),
            if (buttonText != null && onPressed != null)
              ShoppingButton(
                minWidth: 90,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    //fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (onPressed != null) onPressed();
                },
              ),
            SizedBox(
              width: 5,
            ),
            if (button != null) button
          ]),
        ],
      ),
    );
  }
}

class ShoppingCard extends StatelessWidget {
  const ShoppingCard({
    Key key,
    @required this.child,
    this.color = Colors.white,
    this.minWidth,
    this.maxWidth,
    this.decoration,
    this.height,
    this.width,
    this.elevation = 0,
  }) : super(key: key);
  final double elevation;
  final Widget child;
  final double minWidth;
  final double maxWidth;
  final double width;
  final double height;
  final Color color;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    var ctn = Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        constraints: (maxWidth != null && minWidth != null)
            ? BoxConstraints(maxWidth: maxWidth, minWidth: minWidth ?? 1)
            : null,
        decoration: decoration ??
            BoxDecoration(
                color: color,
                gradient: buildLinearGradient(context, colors: [
                  color,
                  color.withAlpha(200),
                  color.withAlpha(200),
                  color
                ]),
                borderRadius: BorderRadius.circular(10)),
        child: child);

    if (elevation > 0) return Card(elevation: elevation, child: ctn);
    return ctn;
  }
}

class ShoppingScrollView extends StatelessWidget {
  final appBar;
  final List<Widget> topBars;
  final Widget body;
  final List<Widget> children;
  final List<Widget> grid;
  final List<Widget> bottomBars;
  final double topBarsHeight;
  final EdgeInsetsGeometry padding;
  const ShoppingScrollView(
      {Key key,
      this.appBar,
      this.topBars,
      this.padding,
      this.topBarsHeight = 90,
      this.body,
      this.children,
      this.grid,
      this.bottomBars})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cols = MediaQuery.of(context).size.width ~/ 150;
    if (cols < 2) cols = 2;
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: CustomScrollView(
        slivers: <Widget>[
          if (appBar != null) appBar,
          if (topBars != null)
            SliverToBoxAdapter(
                child: Container(
                    height: topBarsHeight,
                    child: CustomScrollView(slivers: [
                      for (var item in topBars ?? [])
                        SliverToBoxAdapter(child: item)
                    ], scrollDirection: Axis.horizontal))),
          if (body != null) SliverToBoxAdapter(child: body),
          SliverList(
            delegate: SliverChildListDelegate(
              [for (var item in children ?? []) item],
            ),
          ),
          SliverGrid.count(
            crossAxisCount: cols,
            children: grid ?? [],
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [for (var item in bottomBars ?? []) item],
            ),
          ),
        ],
      ),
    );
  }
}

class ShoppingCategory extends StatelessWidget {
  final String title;
  final String id;
  final Color color;
  final Function(String) onPressed;
  const ShoppingCategory(
      {Key key, this.id, this.color, this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShoppingButton(
        minWidth: 80,
        maxWidth: 110,
        child: Text(title),
        color: color,
        /*child: Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: color),
          alignment: Alignment.center,
          constraints: BoxConstraints(minWidth: 80, minHeight: 20),
          child: Text(title),
        ),
        */
        onPressed: () {
          onPressed(id);
        });
  }
}

class ShoppingListView extends StatelessWidget {
  final List<Widget> children;
  final Color color;
  const ShoppingListView({Key key, this.color, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            if (children != null)
              for (var item in children)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 1, right: 1, top: 5, bottom: 5),
                  child: item,
                )
          ],
        ));
  }
}

class ShoppingTile extends StatelessWidget {
  final String id;
  final MainImagePosition position;
  final Widget image;
  final String title;
  final String subTitle;
  final String price;
  final double rank;
  final double stars;
  final Function(String) onPressed;
  final double width;
  final double elevation;
  final Color color;
  const ShoppingTile({
    Key key,
    this.position = MainImagePosition.left,
    this.width,
    this.elevation = 1,
    this.color,
    this.title,
    this.subTitle,
    this.price,
    this.onPressed,
    this.id,
    this.rank,
    this.stars = 0,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _stars = (stars > 0)
        ? Icon(
            Icons.stars,
            size: 14,
          )
        : Container();
    var size = MediaQuery.of(context).size;
    var _width = width ?? size.width;
    var csize = _width * 2 / 3;
    if (csize < 20) csize = 100;

    return Card(
      elevation: elevation,
      child: InkWell(
          child: Container(
            color: color,
            width: width,
            padding: EdgeInsets.all(5),
            child: (position == MainImagePosition.left ||
                    position == MainImagePosition.rigth)
                ? Row(
                    children: <Widget>[
                      if (position == MainImagePosition.left)
                        Container(
                          child: image ?? Container(),
                        ),
                      if (position == MainImagePosition.left)
                        SizedBox(
                          width: 10,
                        ),
                      Expanded(
                          child: _ShoppingDiscriptions(
                              csize: csize,
                              title: title,
                              subTitle: subTitle,
                              rank: rank,
                              stars: _stars,
                              price: price,
                              onPressed: onPressed,
                              id: id)),
                      if (position == MainImagePosition.rigth)
                        SizedBox(
                          width: 10,
                        ),
                      if (position == MainImagePosition.rigth)
                        Container(
                          child: image ?? Container(),
                        ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      if (position == MainImagePosition.top)
                        Container(
                          child: image ?? Container(),
                        ),
                      if (position == MainImagePosition.top)
                        SizedBox(
                          height: 10,
                        ),
                      _ShoppingDiscriptions(
                          csize: size.width,
                          title: title,
                          subTitle: subTitle,
                          rank: rank,
                          stars: _stars,
                          price: price,
                          onPressed: onPressed,
                          id: id),
                      if (position == MainImagePosition.bottom)
                        SizedBox(
                          height: 10,
                        ),
                      if (position == MainImagePosition.bottom)
                        Container(
                          child: image ?? Container(),
                        ),
                    ],
                  ),
          ),
          onTap: () {
            onPressed(id);
          }),
    );
  }
}

class _ShoppingDiscriptions extends StatelessWidget {
  const _ShoppingDiscriptions({
    Key key,
    @required this.csize,
    @required this.title,
    @required this.subTitle,
    @required this.rank,
    @required StatelessWidget stars,
    @required this.price,
    @required this.onPressed,
    @required this.id,
  })  : _stars = stars,
        super(key: key);

  final double csize;
  final String title;
  final String subTitle;
  final double rank;
  final StatelessWidget _stars;
  final String price;
  final Function(String) onPressed;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: <Widget>[
        Container(
          width: csize - 20,
          child: Text(
            title ?? '',
            maxLines: 2,
            softWrap: true,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: csize - 20,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (subTitle != null)
              Text(
                subTitle,
                maxLines: 2,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
              ),
            if (rank != null)
              Row(children: [
                Text(
                  '$rank',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                ),
                _stars
              ]),
          ]),
        ),
        Container(
          width: csize - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(price ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
              if (onPressed != null)
                InkWell(
                    child: Container(
                      child: Icon(Icons.plus_one, size: 22),
                    ),
                    onTap: () {
                      onPressed(id);
                    })
            ],
          ),
        )
      ],
    );
  }
}

BoxDecoration buildBoxGradient(context) {
  return BoxDecoration(gradient: buildLinearGradient(context));
}

LinearGradient buildLinearGradient(context, {List<Color> colors}) {
  var colores = Theme.of(context).primaryColor;
  return LinearGradient(
    // Where the linear gradient begins and ends
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    // Add one stop for each color. Stops should increase from 0 to 1
    stops: [0.1, 0.3, 0.5, 0.9],
    colors: colors ??
        [
          colores.withAlpha(25),
          colores.withAlpha(25),
          colores.withAlpha(50),
          colores.withAlpha(100),
        ],
  );
}

class ShoppingButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final Color color;
  final double minWidth;
  final double maxWidth;
  const ShoppingButton(
      {Key key,
      this.color = Colors.red,
      this.child,
      this.minWidth = 90,
      this.maxWidth = 200,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ShoppingCard(
        child: child,
        color: color,
        maxWidth: maxWidth,
        minWidth: minWidth,
        height: 32,
      ),
      onTap: onPressed,
      splashColor: Theme.of(context).primaryColor,
    );
  }
}