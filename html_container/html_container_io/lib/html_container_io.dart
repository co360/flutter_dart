library html_container_io;

import 'package:flutter/widgets.dart';
//import 'dart:ui' as ui;

import 'package:html_container_interface/html_container_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlElementContainerControllerImpls<T>
    extends HtmlElementContainerControllerInterfaced<T> {}

class HtmlDivImpls extends StatelessWidget {
  final Widget child;
  const HtmlDivImpls({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: child);
  }
}

class HtmlIFrameViewImpls extends StatelessWidget {
  final String src;
  final String width;
  final String height;
  final String allow;
  final String scrolling;
  final String style;
  final String srcdoc;
  final int border;

  HtmlIFrameViewImpls({
    this.src,
    this.width,
    this.height,
    this.allow,
    this.scrolling,
    this.style,
    this.srcdoc,
    this.border = 0,
  });

  @override
  Widget build(BuildContext context) {
    String _width = (width != null) ? ' width="$width" ' : '';
    String _height = (height != null) ? ' height="$height" ' : '';
    String _allow = (allow != null) ? ' allow="$allow" ' : '';
    String _scrolling = (scrolling != null) ? ' scrolling="$scrolling" ' : '';
    String _style = (style != null) ? ' style="$style" ' : '';
    String _srcdoc = (srcdoc != null) ? srcdoc : '';
    String _border =
        (border != null) ? ' border="$border" frameBorder="$border" ' : '';
    return Container(
        child: WebView(
      initialUrl: Uri.dataFromString(
              '<html><body><iframe $_width $_height $_scrolling $_style $_border src="$src" $_allow>$_srcdoc</iframe></body></html>',
              mimeType: 'text/html')
          .toString(),
      javascriptMode: JavascriptMode.unrestricted,
    ));
  }
}

class HtmlElementContainerImpls<T> extends StatelessWidget {
  final String viewType;
  final HtmlElementContainerControllerImpls controller;
  final double width;
  final double height;
  final Function(T) onComplete;
  final T Function(String) builder;
  const HtmlElementContainerImpls(
      {Key key,
      @required this.viewType,
      this.onComplete,
      this.width,
      this.height,
      @required this.builder,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    T elem = builder(viewType);
    if (controller != null) controller.value = elem;
    if (onComplete != null) onComplete(elem);
    return Container(
        child: FutureBuilder(
            future: getViewType(viewType, elem),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return HtmlElementView(
                viewType: viewType,
              );
            }));
  }

  getViewType(viewType, elem) async {
    // ignore: undefined_prefixed_name
    //return ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    //  return elem;
    //}
    //);
  }
}
