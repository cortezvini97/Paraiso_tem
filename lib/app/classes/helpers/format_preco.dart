import 'package:intl/intl.dart';

class FormatPreco
{
  static formataMoeda(num value)
  {
    var formatar = NumberFormat.simpleCurrency(locale: 'pt_BR');
    var numero = formatar.format(value);
    return numero;
  }
}