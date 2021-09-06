
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/classes/notificacoes/strategies/i_push_strategy.dart';

class PromocoesStrategy implements IPushNotificationStrategy
{
  @override
  void execute(Map<String, dynamic> payload)
  {
    Modular.to.pushNamed("/promocoes", arguments: payload['url']);
  }

}