import 'package:vcid/app/classes/notificacoes/strategies/i_push_strategy.dart';
import 'package:vcid/app/classes/notificacoes/strategies/pagina_strategy.dart';
import 'package:vcid/app/classes/notificacoes/strategies/promocoes_strategy.dart';

class PushNotificationFactory
{
  Map<String, dynamic> payload;
  IPushNotificationStrategy strategy;

  PushNotificationFactory.create(this.payload)
  {
    switch(payload["type"])
    {
      case "paginas":
        strategy = PaginaStrategy();
        break;
      case "promoções":
        strategy = PromocoesStrategy();
        break;
      case "global":
        print("global");
        break;
      default:
        print("Não adicionado");
    }
  }

  void execute()
  {
    strategy.execute(payload);
  }

}