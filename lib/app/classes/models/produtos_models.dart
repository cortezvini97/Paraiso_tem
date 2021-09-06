class Produto
{
  String _id;
  String _idempresa;
  String _codigobarras;
  String _produto;
  String _marca;
  String _cor;
  String _modelo;
  String _tamanho;
  String _fornecedor;
  String _descricao;
  String _estoque;
  String _estoque_max;
  String _estoque_min;
  String _unidade;
  num _preco_custo;
  num _preco_venda;
  num _preco_promocao;
  int _promocao;
  String _imagem;

  Produto();


  int get promocao => _promocao;

  set promocao(int value) {
    _promocao = value;
  }

  num get preco_promocao => _preco_promocao;

  set preco_promocao(num value) {
    _preco_promocao = value;
  }

  num get preco_venda => _preco_venda;

  set preco_venda(num value) {
    _preco_venda = value;
  }

  num get preco_custo => _preco_custo;

  set preco_custo(num value) {
    _preco_custo = value;
  }

  String get unidade => _unidade;

  set unidade(String value) {
    _unidade = value;
  }

  String get estoque_min => _estoque_min;

  set estoque_min(String value) {
    _estoque_min = value;
  }

  String get estoque_max => _estoque_max;

  set estoque_max(String value) {
    _estoque_max = value;
  }

  String get estoque => _estoque;

  set estoque(String value) {
    _estoque = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get fornecedor => _fornecedor;

  set fornecedor(String value) {
    _fornecedor = value;
  }

  String get tamanho => _tamanho;

  set tamanho(String value) {
    _tamanho = value;
  }

  String get modelo => _modelo;

  set modelo(String value) {
    _modelo = value;
  }

  String get cor => _cor;

  set cor(String value) {
    _cor = value;
  }

  String get marca => _marca;

  set marca(String value) {
    _marca = value;
  }

  String get produto => _produto;

  set produto(String value) {
    _produto = value;
  }

  String get codigobarras => _codigobarras;

  set codigobarras(String value) {
    _codigobarras = value;
  }

  String get idempresa => _idempresa;

  set idempresa(String value) {
    _idempresa = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get imagem => _imagem;

  set imagem(String value) {
    _imagem = value;
  }

}