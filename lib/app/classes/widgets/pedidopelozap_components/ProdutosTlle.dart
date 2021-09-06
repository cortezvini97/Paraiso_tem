
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/classes/helpers/format_preco.dart';
import 'package:vcid/app/classes/models/produtos_models.dart';

class ProdutosTile extends StatelessWidget
{
  ProdutosTile(this.produto, this.id_empresa);
  final Produto produto;
  final String id_empresa;

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: ()
      {
        Modular.to.pushNamed("/pedidopelozap/produto", arguments: {"produto": produto, "idempresa": id_empresa});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          height: 100,
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: Image.network('${produto.imagem}'),
              ),
              SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                        produto.modelo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'A Partir de',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400]
                        ),
                      ),
                    ),
                    produto.promocao == 1 ? Text(
                      '${FormatPreco.formataMoeda(produto.preco_venda)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor
                      ),
                    ): Row(
                      children: <Widget>[
                        Text(
                          FormatPreco.formataMoeda(produto.preco_venda),
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.lineThrough
                          ),
                        ),
                        const SizedBox(width: 12,),
                        Text(
                          'Por',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12,),
                        Text(
                          FormatPreco.formataMoeda(produto.preco_promocao),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
