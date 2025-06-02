// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Criar fatura';

  @override
  String get languageSettings => 'Configurações de idioma';

  @override
  String get english => 'Inglês';

  @override
  String get indonesian => 'Indonésio';

  @override
  String get german => 'Alemão';

  @override
  String get spanish => 'Espanhol';

  @override
  String get french => 'Francês';

  @override
  String get italian => 'Italiano';

  @override
  String get dutch => 'Holandês';

  @override
  String get norwegian => 'Norueguês';

  @override
  String get polish => 'Polonês';

  @override
  String get portuguese => 'Português';

  @override
  String get turkish => 'Turco';

  @override
  String get addItem => 'Adicionar item';

  @override
  String get itemName => 'Nome do item';

  @override
  String get price => 'Preço';

  @override
  String get discount => 'Desconto';

  @override
  String get usePercentage => 'Usar porcentagem';

  @override
  String get addRecipient => 'Adicionar destinatário';

  @override
  String get name => 'Nome';

  @override
  String get address => 'Endereço';

  @override
  String get thankNote =>
      'Obrigado pelo seu negócio! Por favor, complete o saldo restante antes da data de vencimento para evitar taxas de atraso. Se tiver alguma dúvida, não hesite em nos contatar.';

  @override
  String get selectCurrency => 'Selecionar moeda';

  @override
  String get editCurrency => 'Editar moeda';

  @override
  String get cont => 'Continuar';

  @override
  String get editItem => 'Editar item';

  @override
  String get save => 'Salvar';

  @override
  String get editRecipient => 'Editar destinatário';

  @override
  String get editStore => 'Editar informações da loja';

  @override
  String get storeName => 'Nome da loja';

  @override
  String get billedTo => 'Faturado para';

  @override
  String get delete => 'Excluir';

  @override
  String get manageStore => 'Gerenciar loja';

  @override
  String get recipient => 'Destinatário';

  @override
  String get failedToLoad => 'Falha ao carregar';

  @override
  String get noData => 'Sem dados';

  @override
  String get fillInvoiceDetails => 'Preencher detalhes da fatura';

  @override
  String get permissionDenied => 'Permissão negada';

  @override
  String get invoiceDetails => 'Detalhes da fatura';

  @override
  String get paid => 'Pago';

  @override
  String get paymentDetails => 'Detalhes do pagamento';

  @override
  String get accountNumber => 'Número da conta';

  @override
  String get accountHolderName => 'Nome do titular da conta';

  @override
  String get swiftCode => 'Código Swift';

  @override
  String get tax => 'Imposto';

  @override
  String get inPercent => 'Em porcentagem';

  @override
  String get dueDateRange => 'Intervalo de datas de vencimento';

  @override
  String get noPurchaseItem =>
      'Não é possível continuar, não há item de compra';

  @override
  String get qty => 'Qtd';

  @override
  String get preview => 'Visualizar';

  @override
  String get backToHome => 'Voltar para início';

  @override
  String get invoice => 'Fatura';

  @override
  String get amount => 'Valor';

  @override
  String get date => 'Data';

  @override
  String get dueDate => 'Data de vencimento';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get totalDiscount => 'Desconto total';

  @override
  String get grandTotal => 'Total geral';

  @override
  String get leftOver => 'Sobra';

  @override
  String get bank => 'Banco';

  @override
  String get successfullyDownloaded => 'Arquivo baixado com sucesso';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Atualizar';

  @override
  String get remove => 'Remover';

  @override
  String get main => 'Principal';

  @override
  String get leadingThankNote => 'Nota de agradecimento';

  @override
  String get hintThankNote => 'Obrigado pelo seu negócio!';

  @override
  String get logoHelp1 => 'Para obter os melhores resultados, escolha uma ';

  @override
  String get logoHelp2 => 'imagem quadrada (proporção 1:1)';

  @override
  String get logoHelp3 => '.';

  @override
  String nItem(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Itens',
      one: '1 Item',
      zero: 'Item',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'João Silva';

  @override
  String get randomPhone => '+351 912 345 678';

  @override
  String get phoneNumber => 'Número de telefone';

  @override
  String get edit => 'Editar';

  @override
  String get version => 'Versão';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Política de privacidade';
}
