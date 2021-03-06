//https://javiercbk.github.io/json_to_dart/
import 'package:controls_data/cached.dart';
import 'package:controls_data/data_model.dart';
import 'package:controls_data/odata_client.dart';
import 'package:controls_data/odata_firestore.dart';

class ProdutoItem extends DataItem {
  String codigo;
  String nome;
  double precoweb = 0;
  String unidade = "UN";
  String sinopse;
  String obs;
  double codtitulo; // codigo do atalho
  bool publicaweb = true;
  bool inservico = false;
  ProdutoItem(
      {this.codigo,
      this.nome,
      this.precoweb,
      this.unidade,
      this.sinopse,
      this.inservico,
      this.obs});

  ProdutoItem.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['precoweb'] = this.precoweb ?? 0;
    data['unidade'] = this.unidade;
    data['sinopse'] = this.sinopse;
    data['obs'] = this.obs;
    data['codtitulo'] = this.codtitulo;
    data['publicaweb'] = (this.publicaweb ?? 'S') ? 'S' : 'N';
    data['inservico'] = (this.inservico ?? 'N') ? 'S' : 'N';
    data['id'] = '$codigo';
    return data;
  }

  fullJson() {
    var r = toJson();
    r['id'] = this.codigo;
    return r;
  }

  @override
  fromMap(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nome = json['nome'];
    precoweb = toDouble(json['precoweb']);
    unidade = json['unidade'];
    try {
      sinopse = json['sinopse'] ?? '';
    } catch (e) {
      sinopse = null;
    }
    obs = json['obs'];
    codtitulo = toDouble(json['codtitulo']);
    this.publicaweb = (json['publicaweb' ?? 'S'] == 'S');
    this.inservico = (json['inservico'] ?? 'N') == 'S';
  }

  static List<String> get keys {
    List<String> k = ProdutoItem.fromJson({}).toJson().keys.toList();
    k.remove('codtitulo'); // nao pertence a tabela
    return k;
  }

  static copy(dados) {
    var d;
    if (dados is ProdutoItem)
      d = ProdutoItem.fromJson(dados.toJson());
    else
      d = ProdutoItem.fromJson(dados);
    return d.toJson();
  }
}

class ProdutoModel extends ODataModelClass<ProdutoItem> {
  static final _singleton = ProdutoModel._create();
  ProdutoModel._create() {
    collectionName = 'ctprod';
    super.API = ODataInst();
    super.CC = CloudV3().client..client.silent = true;

    columns = ProdutoItem.keys.join(',').replaceAll(',id', '');
    externalKeys = 'codtitulo,id';
  }
  factory ProdutoModel() => _singleton;

  ProdutoItem newItem() => ProdutoItem();

  listGrid({String filter, top: 20, skip: 0, String orderBy}) {
    //debugPrint('produto.listGrid');
    //return Cached.value('listGrid_$filter', builder: (key) {
    return search(
            resource: 'ctprod',
            select:
                'ctprod.codigo,ctprod.inservico, ctprod.nome,ctprod.precoweb,ctprod.unidade,ctprod.obs,cast(ctprod.sinopse as varchar(1024)) sinopse , i.codtitulo',
            filter: filter,
            join:
                ' left join ctprod_atalho_itens i on (i.codprod=ctprod.codigo)',
            orderBy: orderBy ?? 'ctprod.dtatualiz desc',
            top: top,
            skip: skip,
            cacheControl: 'no-cache')
        .then((rsp) {
      //debugPrint('$rsp');
      return rsp.asMap();
    });
    //});
  }

  clearCached() {
    Cached.clearLike('listGrid');
  }

  @override
  put(item) {
    var it = ProdutoItem.copy(item);
    atalhoUpdate(it);
    return super.put(it);
  }

  @override
  post(item) {
    var it = ProdutoItem.copy(item);
    atalhoUpdate(it);
    return super.post(it);
  }

  atalhoUpdate(item) {
    if (item != null) {
      if ((item['codtitulo'] ?? 0) == 0) return;
      // atalhoUpdate
      String upd =
          "update or insert into ctprod_atalho_itens (codtitulo,codprod) values(${item['codtitulo']},'${item['codigo']}') matching (codprod)   ";
      API.execute(upd);
    }
  }

  buscarByCodigo(String codigo) async {
    return listCached(filter: "codigo eq '$codigo'", select: columns);
  }
}
