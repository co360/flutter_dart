import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'strap_widgets.dart';

import 'paginated_data_table_ext.dart';
import 'dialogs_widgets.dart';

class PaginatedGridSample extends StatefulWidget {
  const PaginatedGridSample({Key key}) : super(key: key);

  @override
  _PaginatedGridSampleState createState() => _PaginatedGridSampleState();
}

class _PaginatedGridSampleState extends State<PaginatedGridSample> {
  getSource() async {
    double v = 10;
    return [
      {'id': 1, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 2, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 3, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 4, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 5, 'dcto': '123', 'nome': 'nome', 'total': v++},
      {'id': 6, 'dcto': '123', 'nome': 'nome', 'total': v++},
      for (var i = 0; i < 20; i++)
        {'id': i, 'dcto': '123', 'nome': 'nome', 'total': v++},
    ];
  }

  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginatedGrid(
          header: Text('PaginatedGrid - Title'),
          futureSource: getSource(),
          currentPage: page,
          onPageSelected: (x) {
            setState(() {
              page = x;
            });
          },
          columns: [
            PaginatedGridColumn(
              name: 'id',
              label: '',
            ),
            PaginatedGridColumn(
              name: 'dcto',
              label: 'NFe',
            ),
            PaginatedGridColumn(
              name: 'nome',
            ),
            PaginatedGridColumn(
                name: 'total',
                label: 'Valor Bruto',
                numeric: true,
                onGetValue: (x) {
                  if (x is double) return x.toStringAsFixed(2);
                  return x;
                }),
          ]),
    );
  }
}

class PaginatedGridColumn {
  final String name;
  String label;
  String editInfo;
  TextStyle style;
  Alignment align;
  bool sort;
  bool required;
  bool readOnly;
  bool isPrimaryKey;
  DataColumnSortCallback onSort;
  bool visible;
  double width;
  double editWidth;
  double editHeight;
  Function(dynamic) onFocusChanged;
  String Function(dynamic) onGetValue;
  dynamic Function(dynamic) onSetValue;
  String Function(dynamic) onValidate;
  Widget Function(int, Map<String, dynamic>) builder;
  String tooltip;
  Widget Function(PaginatedGridController, PaginatedGridColumn, dynamic,
      Map<String, dynamic>) editBuilder;

  Function(PaginatedGridController) onEditIconPressed;
  bool autofocus;
  int maxLines;
  int maxLength;
  int minLength;
  bool placeHolder;
  bool folded;
  Color color;
  PaginatedGridColumn({
    this.onEditIconPressed,
    this.numeric = false,
    this.autofocus = false,
    this.visible = true,
    this.maxLines,
    this.color,
    this.maxLength,
    this.minLength,
    this.width,
    this.tooltip,
    this.editWidth,
    this.editHeight,
    this.onFocusChanged,
    this.align,
    this.style,
    this.name,
    this.required = false,
    this.readOnly = false,
    this.isPrimaryKey = false,
    this.onSort,
    this.placeHolder = false,
    this.label,
    this.editInfo = '{label}',
    this.sort = true,
    this.builder,
    this.editBuilder,
    this.isVirtual = false,
    this.onGetValue,
    this.onSetValue,
    this.onValidate,
    this.folded,
  });
  bool numeric;
  bool isVirtual;
  int index;
}

enum PaginatedGridChangeEvent { insert, update, delete }

class PaginatedGrid extends StatefulWidget {
  final Future<dynamic> futureSource;
  final int Function(dynamic, dynamic) onSort;

  /// dados a serem apresentados
  final List<dynamic> source;
  final bool oneRowAutoEdit;

  /// colunas de apresentação dos dados
  final List<PaginatedGridColumn> columns;

  /// controle de navegação dos dados
  final PaginatedGridController controller;

  final Widget header;
  final double headerHeight;

  final List<Widget> actions;
  final int currentPage;
  final double elevation;
  final bool canSort;

  /// [onPageSelected] evento de mudança de pagina para recarregar novos dados
  /// requer recarregar novos dados para a pagina solicitada
  final Function(int) onPageSelected;
  final Function(bool) onSelectAll;
  final int sortColumnIndex;
  final bool sortAscending;
  final TextStyle columnStyle;

  /// [beforeShow] evento beforeShow é chamado antes de apresentar os dados
  final Function(PaginatedGridController) beforeShow;
  final bool showCheckboxColumn;

  /// eventos de edição - permite criar novas janelas de edição para
  /// edição de dados -
  final Future<dynamic> Function(PaginatedGridController) onEditItem;
  final Future<dynamic> Function(PaginatedGridController) onInsertItem;
  final Future<dynamic> Function(PaginatedGridController) onDeleteItem;

  final Function(PaginatedGridController) onRefresh;

  /// mudou a linha de edição
  final Future<dynamic> Function(bool, PaginatedGridController) onSelectChanged;

  ///[onPostEvent] evento que os dados foram editados e podem ser persistidos
  final Future<dynamic> Function(
      PaginatedGridController, dynamic, PaginatedGridChangeEvent) onPostEvent;

  /// indica se é para apresentar um barra de filtro dos dados de memoria
  final bool canFilter;

  /// [canEdit] flag indicando que o registro pode ser alterado
  final bool canEdit;
  final bool canDelete;
  final bool canInsert;

  final double columnSpacing;
  final CrossAxisAlignment crossAxisAlignment;
  //final Color backgroundColor;

  /// mudou a pagina de navegação em memoria
  final Function(int) onPageChanged;

  /// [rowsPerPage] numero de linhas por pagina
  final int rowsPerPage;
  final List<int> availableRowsPerPage;
  final Function(int) onRowsPerPageChanged;
  final AppBar appBar;
  final Widget footerLeading;
  final Widget footerTrailing;
  final double footerHeight;
  final Color backgroundColor;

  final double dataRowHeight;
  final double headingRowHeight;
  final Color headingRowColor;
  final double horizontalMargin;
  final DragStartBehavior dragStartBehavior;

  /// [editSize] indica tamanho da janela de edição
  final Size editSize;
  final Color oddRowColor;
  final Color evenRowColor;
  final bool editFullPage;

  /// envento onClick na celula
  final Function(PaginatedGridController) onCellTap;
  PaginatedGrid({
    Key key,
    this.controller,
    this.dataRowHeight = kMinInteractiveDimension * .80,
    this.headingRowHeight = kMinInteractiveDimension,
    this.headingRowColor,
    this.horizontalMargin = 10,
    this.dragStartBehavior = DragStartBehavior.start,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.futureSource,
    this.editSize,
    this.elevation = 0,
    this.editFullPage = false,
    this.availableRowsPerPage,
    this.onRowsPerPageChanged,
    this.oneRowAutoEdit = false,
    this.footerLeading,
    this.footerHeight = kToolbarHeight,
    this.canSort = true,
    this.backgroundColor,
    this.columns,
    this.footerTrailing,
    this.canEdit = false,
    this.onPageChanged,
    this.oddRowColor,
    this.evenRowColor,
    this.rowsPerPage = 10,
    this.sortColumnIndex = 0,
    this.header,
    this.columnSpacing = 5,
    this.actions,
    this.onEditItem,
    this.onInsertItem,
    this.onDeleteItem,
    this.canFilter = false,
    this.onSelectChanged,
    this.currentPage = 1,
    this.onPageSelected,
    this.onRefresh,
    this.onCellTap,
    this.onSelectAll,
    this.onPostEvent,
    this.columnStyle,
    this.showCheckboxColumn = false,
    this.sortAscending = true,
    this.appBar,
    this.source,
    this.onSort,
    this.headerHeight = kToolbarHeight + 10,
    this.beforeShow,
    this.canDelete = false,
    this.canInsert = false,
  })  : assert(
            (!(canInsert || canDelete || canEdit) && (onPostEvent == null)) ||
                ((canInsert || canDelete || canEdit) && (onPostEvent != null))),
        super(key: key);

  @override
  _PaginatedGridState createState() => _PaginatedGridState();

  static show(context,
      {Widget child,
      String title,
      width,
      height,
      Alignment alignment,
      bool fullPage = false,
      String label = ''}) async {
    Size size = MediaQuery.of(context).size;
    return showGeneralDialog(
      context: context,
      barrierLabel: label,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true,
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Align(
          alignment: alignment ?? Alignment.center,
          child: Material(
              child: Container(
            width: (fullPage) ? size.width : width ?? size.width * 0.90,
            height: (fullPage) ? size.height : height ?? size.height * 0.90,
            child: child,
          )),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: anim,
          child: child,
        );
      },
    );
  }
}

extension StringExtGrid on String {
  toCapital() {
    return this.substring(0, 1).toUpperCase() + this.substring(1, this.length);
  }
}

class _PaginatedGridState extends State<PaginatedGrid> {
  PaginatedGridController controller;

  StreamController<bool> refreshEvent = StreamController<bool>.broadcast();

  int _sortColumnIndex;
  bool _sortAscending;

  String _filter;
  StreamSubscription postEvent;

  @override
  void initState() {
    controller = widget.controller ?? PaginatedGridController();
    controller.statePage = this;
    _filter = '';
    postEvent = controller.postEvent.stream.listen((x) {
      if (widget.onPostEvent != null) {
        widget.onPostEvent(controller, x.data, x.event).then((b) {
          if (b != null) {
            if (x.event == PaginatedGridChangeEvent.delete)
              controller.source.removeAt(controller.currentRow);
            else if (x.event == PaginatedGridChangeEvent.insert)
              controller.source.add(x.data);
            else
              controller.source[x.currentRow] = x.data;

            controller.changed(true);
          }
          return b;
        });
        return;
      }
      controller.source[x.currentRow] = x.data;
      controller.changed(true);
    });
    super.initState();
    _sortAscending = widget.sortAscending;
    _sortColumnIndex = widget.sortColumnIndex;
    controller.columns = widget.columns;
  }

  @override
  void dispose() {
    refreshEvent.close();
    postEvent.cancel();
    super.dispose();
  }

  createColumns(List<dynamic> source) {
    controller.createColumns(source);
    /*  controller.columns = [];
    Map<String, dynamic> row = source.first;
    if (row != null)
      row.forEach((k, v) {
        controller.columns.add(PaginatedGridColumn(
            name: k, label: k.replaceAll('_', ' ').toCapital()));
      });*/
  }

  _sort(int idx, bool ascending) {
    setState(() {
      _sortColumnIndex = idx;
      _sortAscending = ascending;
      controller.source.sort((a, b) {
        if (controller.columns[idx].numeric || a is double || a is int) {
          return a[controller.columns[idx].name]
                  .compareTo(b[controller.columns[idx].name]) *
              (ascending ? 1 : -1);
        }

        return a[controller.columns[idx].name]
                .toString()
                .compareTo(b[controller.columns[idx].name].toString()) *
            (ascending ? 1 : -1);
      });
    });
  }

  addVirtualColumn() {
    for (var i = 0; i < controller.columns.length; i++) {
      controller.columns[i].index = i;
    }
  }

  doRefresh() {
    setState(() {
      widget.onRefresh(controller);
    });
  }

  ThemeData theme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    controller.context = context;
    return StreamBuilder<bool>(
        stream: refreshEvent.stream,
        builder: (context, snapshot) {
          return FutureBuilder(
              initialData: widget.source,
              future: widget.futureSource,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Align(child: CircularProgressIndicator());
                controller.originalSource = snapshot.data;
                controller.widget = widget;
                if (widget.onSort != null)
                  controller.originalSource.sort((a, b) {
                    return widget.onSort(a, b);
                  });
                if ((controller.columns ?? []).length == 0)
                  createColumns(snapshot.data);
                addVirtualColumn();
                if (widget.beforeShow != null) widget.beforeShow(controller);

                if (widget.oneRowAutoEdit &&
                    (controller.originalSource.length == 1)) {
                  /// entra em edição automatico.
                  Timer.run(() {
                    controller.edit(context, controller.originalSource[0],
                        title: 'Alteração');
                  });
                }
                return Scaffold(
                  appBar: widget.appBar,
                  floatingActionButton: buildAddButton(),
                  backgroundColor: theme.scaffoldBackgroundColor,
                  body: SingleChildScrollView(
                    child: StreamBuilder<bool>(
                        initialData: true,
                        stream: controller.changedEvent.stream,
                        builder: (context, snapshot) {
                          controller.tableSource = PaginatedGridDataTableSource(
                              context, controller, _filter);
                          //debugPrint('init paginated extended');
                          return PaginatedDataTableExtended(
                            elevation: widget.elevation,
                            headingRowHeight: widget.headingRowHeight,
                            headingRowColor: widget.headingRowColor ??
                                theme.primaryColor.withAlpha(100),
                            headerHeight: (widget.header == null)
                                ? 0
                                : widget.headerHeight,

                            dataRowHeight: widget.dataRowHeight,
                            columnSpacing: 0, //widget.columnSpacing,
                            footerTrailing: widget.footerTrailing,
                            footerLeading:
                                widget.footerLeading ?? createPageNavigator(),
                            header: Column(
                                crossAxisAlignment: widget.crossAxisAlignment,
                                children: [
                                  widget.header ?? Container(),
                                  if (widget.canFilter)
                                    Container(
                                      height: 60,
                                      width: 200,
                                      child: TextFormField(
                                          initialValue: _filter,
                                          //controller: __filterController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.normal),
                                          decoration: InputDecoration(
                                            //border: InputBorder.none,
                                            labelText: 'filtro',
                                          ),
                                          onChanged: (x) {
                                            _filter = x;
                                            controller.changedEvent.sink
                                                .add(true);
                                          }),
                                    ),
                                ]),
                            actions: [
                              ...widget.actions ?? [],
                              if (widget.onRefresh != null)
                                Tooltip(
                                    message: 'Recarregar',
                                    child: InkWell(
                                      child: Icon(Icons.refresh),
                                      onTap: () {
                                        doRefresh();
                                      },
                                    )),
                            ],
                            sortColumnIndex: _sortColumnIndex,
                            sortAscending: _sortAscending,
                            horizontalMargin: widget.horizontalMargin,
                            dragStartBehavior: widget.dragStartBehavior,
                            onRowsPerPageChanged: widget.onRowsPerPageChanged,
                            color: widget.backgroundColor ??
                                theme.scaffoldBackgroundColor,
                            rowsPerPage: widget.rowsPerPage,
                            onPageChanged: widget.onPageChanged,
                            //alignment: Alignment.center,
                            crossAxisAlignment: widget.crossAxisAlignment,
                            columns: [
                              for (var i = 0;
                                  i < controller.columns.length;
                                  i++)
                                if (controller.columns[i].visible)
                                  DataColumn(
                                    onSort: (widget.canSort)
                                        ? controller.columns[i].onSort ??
                                                (controller.columns[i].sort)
                                            ? (int columnIndex,
                                                    bool ascending) =>
                                                _sort(columnIndex, ascending)
                                            : (a, b) => null
                                        : null,
                                    numeric: controller.columns[i].numeric,
                                    tooltip: controller.columns[i].tooltip,
                                    label: Align(
                                      alignment:
                                          (controller.columns[i].numeric ??
                                                  false)
                                              ? Alignment.centerRight
                                              : controller.columns[i].align ??
                                                  Alignment.centerLeft,
                                      child: Container(
                                        width: controller.columns[i].width,
                                        child: Builder(builder: (ctx) {
                                          var labels = (controller
                                                      .columns[i].label ??
                                                  '${controller.columns[i].name}'
                                                      .toCapital())
                                              .split('|');
                                          return Column(children: [
                                            if (labels.length == 1) Spacer(),
                                            for (var l in labels)
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                    child: Text(l,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: widget
                                                                .columnStyle ??
                                                            theme.textTheme
                                                                .caption
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                            ))),
                                              )
                                          ]);
                                        }),
                                      ),
                                    ),
                                  )
                            ],
                            source: controller.tableSource,
                            onSelectAll: widget.onSelectAll,
                            showCheckboxColumn: widget.showCheckboxColumn,
                          );
                        }),
                  ),
                );
              });
        });
  }

  createPageNavigator() {
    if (widget.onPageSelected == null) return null;
    int n = 0;
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 60),
      child: Container(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(children: [
            createNavButton(1),
            for (var i = widget.currentPage - 1;
                i < widget.currentPage + 4;
                i++)
              if (i > 1)
                if ((n++) < 4) createNavButton(i)
          ]),
        ),
      ),
    );
  }

  Widget createNavButton(int i) {
    return (widget.currentPage == i)
        ? CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey.withOpacity(0.3),
            child: Text('$i'),
          )
        : IconButton(
            icon: Text('$i'),
            onPressed: () {
              widget.onPageSelected(i);
            },
          );
  }

  buildAddButton() {
    if (widget.canInsert &&
        ((widget.onInsertItem != null) || (widget.onPostEvent != null))) {
      return FloatingActionButton(
        //    child: IconButton(
        child: Icon(Icons.add),
        onPressed: () {
          controller.data = {};
          if (controller.beforeChange != null)
            controller.beforeChange(
                controller.data, PaginatedGridChangeEvent.insert);

          if (widget.onInsertItem != null)
            widget.onInsertItem(controller)?.then((rsp) {
              controller.changed(rsp);
            });
          else if (widget.onPostEvent != null) {
            PaginatedGrid.show(context,
                title: 'Novo registro',
                child: PaginatedGridEditRow(
                  width: widget.editSize?.width,
                  height: widget.editSize?.height,
                  fullPage: controller.widget.editFullPage,
                  controller: controller,
                  event: PaginatedGridChangeEvent.insert,
                ));
          }
        },
        //),
      );
    } else
      return Container();
  }
}

class PaginatedGridController {
  var parent;

  BuildContext context;
  _PaginatedGridState statePage;
  StreamController<bool> changedEvent = StreamController<bool>.broadcast();
  List<dynamic> source;
  List<PaginatedGridColumn> columns;
  PaginatedGrid widget;
  PaginatedGridDataTableSource tableSource;
  int currentRow = 0;
  int currentColumn = 0;
  Map<String, dynamic> data;
  List<dynamic> originalSource;
  Function(dynamic, PaginatedGridChangeEvent) beforeChange;

  dispose() {
    changedEvent.close();
    postEvent.close();
  }

  get self => this;
  PaginatedGridColumn findColumn(name) {
    var index = -1;
    if (columns != null) {
      for (int i = 0; i < columns.length; i++)
        if (columns[i].name == name) index = i;
      if (index > -1) return columns[index];
    }
    return null;
  }

  editPage(
    context,
    data, {
    String title,
    double width,
    double height,
    bool inScaffold = true,
    PaginatedGridChangeEvent event = PaginatedGridChangeEvent.update,
  }) {
    if (beforeChange != null) beforeChange(this.data, event);

    return PaginatedGridEditRow(
      data: data,
      title: title,
      width: width,
      height: height,
      fullPage: false,
      controller: this,
      inScaffold: inScaffold,
      event: event,
      actions: [
        if (widget.canDelete)
          Tooltip(
              message: 'Excluir o item',
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  this.data = data;
                  widget
                      .onPostEvent(this, data, PaginatedGridChangeEvent.delete)
                      .then((rsp) {
                    Navigator.pop(context);
                  });
                },
              )),
      ],
    );
  }

  edit(BuildContext context, Map<String, dynamic> data,
      {String title,
      double width,
      double height,
      PaginatedGridChangeEvent event = PaginatedGridChangeEvent.update}) {
    return PaginatedGrid.show(context,
        title: title,
        child: editPage(context, data,
            title: title, width: width, height: height, event: event));
  }

  createColumns(List<dynamic> source) {
    columns = [];
    var row = source.first;
    if (row != null)
      row.forEach((k, v) {
        var numeric = false;
        if (v is double) numeric = true;
        columns.add(
          PaginatedGridColumn(
            name: k,
            label: '${k.replaceAll('_', ' ')}'.toCapital(),
            numeric: numeric,
            //width: 120,
          ),
        );
      });
  }

  clear() {
    originalSource.clear();
    source.clear();
    changed(true);
    _updating = 0;
  }

  int _updating = 0;
  begin([value = true]) {
    _updating += value ? 1 : -1;
  }

  end() {
    _updating--;
    changed(true);
  }

  changed([b = false]) {
    if (_updating <= 0) {
      if ((b ?? false)) changedEvent.sink.add(true);
      _updating = 0;
    }
  }

  changeTo(key, valueSearch, dadosTo) {
    //debugPrint('changeTo $key $valueSearch $dadosTo');
    begin();
    try {
      if (source != null)
        for (var i = 0; i < source.length; i++)
          if (source[i][key] == valueSearch) {
            //print([source[i], dadosTo]);
            source[i] = dadosTo;
          }
    } finally {
      end();
    }
  }

  StreamController<PaginatedGridEventData> postEvent =
      StreamController<PaginatedGridEventData>.broadcast();

  _changeRow(
      int row, Map<String, dynamic> data, PaginatedGridChangeEvent event) {
    postEvent.sink
        .add(PaginatedGridEventData(currentRow: row, event: event, data: data));
  }

  removeAt(int rowIndex) {
    source.removeAt(rowIndex);
    changed(true);
  }

  remove(item) {
    source.remove(item);
    changed(true);
  }

  removeByKey(key, row) {
    var index = indexOf(key, row);
    if (index >= 0) removeAt(index);
  }

  indexOf(key, row) {
    var v = row[key];
    for (var i = 0; i < source.length; i++) {
      if (source[i][key] == v) return i;
    }
    return -1;
  }

  add(item) {
    if (source != null) {
      source.add(item);
      changed(true);
    }
  }
}

class PaginatedGridEventData {
  var event;
  var data;
  int currentRow;
  PaginatedGridEventData({this.currentRow, this.event, this.data});
}

class PaginatedGridDataTableSource extends DataTableSource {
  final PaginatedGridController controller;
  final String filter;
  final BuildContext context;
  PaginatedGridDataTableSource(this.context, this.controller, this.filter) {
    controller.source = [];
    if (filter != '')
      controller.originalSource.forEach((x) {
        var v = jsonEncode(x).toLowerCase();
        if (v.contains(filter.toLowerCase())) controller.source.add(x);
      });
    else {
      controller.source = controller.originalSource;
    }
  }
  setData(rowIndex, colIndex) {
    controller.currentRow = rowIndex;
    controller.currentColumn = colIndex;
    controller.data = controller.source[rowIndex];
  }

  @override
  DataRow getRow(int index) {
    ThemeData theme = Theme.of(context);
    Color rowColor = ((index % 2) == 0)
        ? controller.widget.evenRowColor ?? theme.primaryColor.withAlpha(10)
        : controller.widget.oddRowColor ?? theme.primaryColor.withAlpha(3);
    Map<String, dynamic> row = controller.source[index];
    DataRow r = DataRow(
        key: UniqueKey(),
        onSelectChanged: (controller.widget.onSelectChanged != null)
            ? (bool b) {
                setData(index, 0);
                controller.widget.onSelectChanged(b, controller);
                return b;
              }
            : (controller.widget.canEdit)
                ? (b) {
                    setData(index, 0);
                    return (controller.widget.onEditItem != null)
                        ? controller.widget.onEditItem(controller)
                        : doEditItem(index, b);
                  }
                : null,
        color: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return rowColor;
        }),
        cells: [
          for (PaginatedGridColumn col in controller.columns)
            if (col.visible)
              (col.isVirtual)
                  ? DataCell(Row(children: [
                      if (col.builder != null) col.builder(index, row),
                      if (col.builder == null)
                        if (controller.widget.canEdit)
                          if (controller.widget.onEditItem != null)
                            Tooltip(
                                message: 'Alterar o item',
                                child: InkWell(
                                  child: Icon(Icons.edit),
                                  onTap: () {
                                    setData(index, col.index);
                                    controller.changed(controller.widget
                                        .onEditItem(controller));
                                  },
                                )),
                      if (col.builder == null)
                        if (controller.widget.canDelete)
                          if (controller.widget.onDeleteItem != null)
                            Tooltip(
                                message: 'Excluir o item',
                                child: InkWell(
                                  child: Icon(Icons.delete),
                                  onTap: () {
                                    setData(index, col.index);
                                    controller.widget
                                        .onDeleteItem(controller)
                                        .then((x) {
                                      if (x) controller.removeAt(index);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ))
                    ]))
                  : DataCell(
                      Padding(
                          padding: EdgeInsets.only(
                            bottom: 1,
                            top: 0,
                          ),
                          child: Container(
                              padding: EdgeInsets.only(
                                left: controller.widget.columnSpacing / 2,
                                right: controller.widget.columnSpacing / 2,
                              ),
                              color: col.color ?? rowColor,
                              child: Align(
                                alignment: col.align ??
                                    ((col.numeric)
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft),
                                child: (col.builder != null)
                                    ? col.builder(index, row)
                                    : Text(doGetValue(col, row[col.name]) ?? '',
                                        style: col.style ??
                                            theme.textTheme.bodyText2),
                              ))),
                      onTap: ((controller.widget.onCellTap != null) ||
                              (col.onEditIconPressed != null))
                          ? () {
                              setData(index, col.index);
                              if (controller.widget.onCellTap != null)
                                controller.widget.onCellTap(controller);
                              if (col.onEditIconPressed != null)
                                col.onEditIconPressed(controller);
                            }
                          : null,
                      showEditIcon: (col.onEditIconPressed != null),
                      placeholder: col.placeHolder,
                    ),
        ]);

    return r;
  }

  doEditItem(index, bool b) {
    if (controller.beforeChange != null)
      controller.beforeChange(controller.data, PaginatedGridChangeEvent.update);

    return Dialogs.showPage(
      controller.context,
      child: PaginatedGridEditRow(
        fullPage: controller.widget.editFullPage,
        width: controller.widget.editSize?.width,
        height: controller.widget.editSize?.height,
        controller: controller,
        event: PaginatedGridChangeEvent.update,
        title: 'Alteração',
        actions: [
          if (controller.widget.canDelete)
            Tooltip(
                message: 'Excluir o item',
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (controller.widget.onDeleteItem == null)
                      controller.widget
                          .onPostEvent(controller, controller.data,
                              PaginatedGridChangeEvent.delete)
                          .then((rsp) {
                        if (rsp is bool && !rsp) return;
                        controller.removeAt(index);
                        Timer.run(() {
                          Navigator.pop(controller.context);
                        });
                        controller.changed(b);
                      });
                    else
                      controller.widget.onDeleteItem(controller).then((x) {
                        if (x) {
                          controller.removeAt(index);
                          Timer.run(() {
                            Navigator.pop(controller.context);
                          });
                          controller.changed(b);
                        }
                      });
                  },
                )),
        ],
      ),
    );
  }

  doGetValue(PaginatedGridColumn col, dynamic v) {
    if (col.onGetValue == null) return (v ?? '').toString();
    return col.onGetValue(v);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.source.length;

  @override
  int get selectedRowCount => 0;
}

class PaginatedGridEditRow extends StatefulWidget {
  final Map<String, dynamic> data;
  final double width;
  final double height;
  final PaginatedGridController controller;
  final PaginatedGridChangeEvent event;
  final String title;
  final List<Widget> actions;
  final bool fullPage;
  final bool inScaffold;
  const PaginatedGridEditRow({
    Key key,
    this.event,
    this.controller,
    this.data,
    this.width,
    this.fullPage = false,
    this.inScaffold = true,
    this.height,
    this.title,
    this.actions,
  }) : super(key: key);

  @override
  _PaginatedGridEditRowState createState() => _PaginatedGridEditRowState();
}

class _PaginatedGridEditRowState extends State<PaginatedGridEditRow> {
  Map<String, dynamic> p;
  PaginatedGridChangeEvent _event;
  @override
  void initState() {
    _event = widget.event ??
        ((widget.controller.data == null)
            ? PaginatedGridChangeEvent.insert
            : PaginatedGridChangeEvent.update);
    p = widget.data ?? widget.controller.data ?? {};
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  bool canEdit(PaginatedGridColumn col) {
    if (col.readOnly) return false;
    if (col.isPrimaryKey) {
      if (_event == PaginatedGridChangeEvent.update) return false;
    }
    return true;
  }

  bool _focused = false;
  int _first = 0;
  bool canFocus(PaginatedGridColumn col) {
    if (_focused) return false;
    if (col.readOnly) return false;
    if (widget.event == PaginatedGridChangeEvent.update) if (col.isPrimaryKey)
      return false;

    if (widget.event == PaginatedGridChangeEvent.insert) {
      if (_first > 0) return false;
    }
    _first++;
    _focused = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _first = 0;

    double mh = widget.height ?? size.height * 0.95;
    double alvo =
        ((widget.controller.columns.length + 2) * kToolbarHeight) + 32.0;
    if (alvo < mh) mh = widget.height ?? alvo;
    double mw = widget.width ?? 400;

    return (!widget.inScaffold)
        ? buildPage(context)
        : Container(
            height: (widget.fullPage) ? size.height * 0.95 : mh,
            constraints: BoxConstraints(
              maxWidth: (widget.fullPage)
                  ? size.width * 0.95
                  : mw, //  widget.width ?? size.width * 0.95,
            ),
            child: Scaffold(
              appBar: AppBar(
                  title: Text(widget.title ?? ''), actions: widget.actions),
              body: SingleChildScrollView(child: buildPage(context)),
            ),
            // ),
            //),
          );
  }

  Widget buildPage(BuildContext context) {
    int col = 0;
    final int mxCol = widget.controller.columns.length;
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var item in widget.controller.columns)
                if (!item.isVirtual)
                  (item.editBuilder != null)
                      ? item.editBuilder(
                          widget.controller, item, p[item.name], p)
                      : Container(
                          alignment: Alignment.center,
                          width: 300,
                          //height: 56,
                          child: createFormField(
                            context,
                            item,
                            isLast: (mxCol == ++col),
                          ),
                        ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: 120,
                  height: kMinInteractiveDimension,
                  alignment: Alignment.center,
                  //color: Colors.blue,
                  child: StrapButton(
                    text: 'Salvar',
                    onPressed: () {
                      _save(context);
                    },
                  )),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  createFormField(BuildContext context, PaginatedGridColumn item,
      {bool isLast = false}) {
    final TextEditingController _valueController = TextEditingController(
        text: (item.onGetValue != null)
            ? item.onGetValue(p[item.name])
            : (p[item.name] ?? '').toString());
    var focusNode = FocusNode();
    return Focus(
        canRequestFocus: false,
        onFocusChange: (b) {
          if (!b) if (item.onFocusChanged != null)
            item.onFocusChanged(_valueController.text);
        },
        child: TextFormField(
            textInputAction:
                (isLast) ? TextInputAction.done : TextInputAction.next,
            focusNode: focusNode,
            onFieldSubmitted: (x) {
              if (isLast)
                _save(context);
              else
                focusNode.nextFocus();
            },
            autofocus: canFocus(item),
            maxLines: item.maxLines,
            maxLength: item.maxLength,
            enabled: canEdit(item),
            controller: _valueController,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
            decoration: InputDecoration(
              labelText: item.label ?? item.name,
            ),
            validator: (value) {
              if (item.onValidate != null) return item.onValidate(value);
              if (item.required) if (value.isEmpty) {
                return (item.editInfo
                    .replaceAll('{label}', item.label ?? item.name));
              }

              return null;
            },
            onSaved: (x) {
              if (item.onSetValue != null) {
                p[item.name] = item.onSetValue(x);
                return;
              }
              if (p[item.name] is int)
                p[item.name] = int.tryParse(x);
              else if (p[item.name] is double)
                p[item.name] = double.tryParse(x);
              else if (p[item.name] is bool)
                p[item.name] = x;
              else
                p[item.name] = x;
            }));
  }

  _save(context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.controller.widget
          .onPostEvent(widget.controller, p, _event)
          .then((rsp) {
        Navigator.pop(context);
      });
    }
  }
}
