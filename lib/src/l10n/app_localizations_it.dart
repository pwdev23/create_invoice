// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Creare fattura';

  @override
  String get languageSettings => 'Impostazioni della lingua';

  @override
  String get english => 'Inglese';

  @override
  String get indonesian => 'Indonesiano';

  @override
  String get german => 'Tedesco';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get french => 'Francese';

  @override
  String get italian => 'Italiano';

  @override
  String get dutch => 'Olandese';

  @override
  String get norwegian => 'Norvegese';

  @override
  String get polish => 'Polacco';

  @override
  String get portuguese => 'Portoghese';

  @override
  String get turkish => 'Turco';

  @override
  String get addItem => 'Aggiungi articolo';

  @override
  String get itemName => 'Nome dell\'articolo';

  @override
  String get price => 'Prezzo';

  @override
  String get discount => 'Sconto';

  @override
  String get usePercentage => 'Usa percentuale';

  @override
  String get addRecipient => 'Aggiungi destinatario';

  @override
  String get name => 'Nome';

  @override
  String get address => 'Indirizzo';

  @override
  String get thankNote =>
      'Grazie per il tuo business! Ti preghiamo di saldare il saldo rimanente prima della data di scadenza per evitare costi aggiuntivi. Se hai domande, non esitare a contattarci.';

  @override
  String get selectCurrency => 'Seleziona valuta';

  @override
  String get editCurrency => 'Modifica valuta';

  @override
  String get cont => 'Continua';

  @override
  String get editItem => 'Modifica articolo';

  @override
  String get save => 'Salva';

  @override
  String get editRecipient => 'Modifica destinatario';

  @override
  String get editStore => 'Modifica informazioni negozio';

  @override
  String get storeName => 'Nome del negozio';

  @override
  String get billedTo => 'Fatturato a';

  @override
  String get delete => 'Elimina';

  @override
  String get manageStore => 'Gestisci negozio';

  @override
  String get recipient => 'Destinatario';

  @override
  String get failedToLoad => 'Caricamento non riuscito';

  @override
  String get noData => 'Nessun dato';

  @override
  String get fillInvoiceDetails => 'Compila i dettagli della fattura';

  @override
  String get permissionDenied => 'Permesso negato';

  @override
  String get invoiceDetails => 'Dettagli della fattura';

  @override
  String get paid => 'Pagato';

  @override
  String get paymentDetails => 'Dettagli di pagamento';

  @override
  String get accountNumber => 'Numero di conto';

  @override
  String get accountHolderName => 'Nome del titolare del conto';

  @override
  String get swiftCode => 'Codice Swift';

  @override
  String get tax => 'Tassa';

  @override
  String get inPercent => 'In percentuale';

  @override
  String get dueDateRange => 'Intervallo di date di scadenza';

  @override
  String get noPurchaseItem =>
      'Impossibile procedere, nessun articolo acquistato';

  @override
  String get qty => 'Qtà';

  @override
  String get preview => 'Anteprima';

  @override
  String get backToHome => 'Torna alla home';

  @override
  String get invoice => 'Fattura';

  @override
  String get amount => 'Importo';

  @override
  String get date => 'Data';

  @override
  String get dueDate => 'Data di scadenza';

  @override
  String get subtotal => 'Subtotale';

  @override
  String get totalDiscount => 'Sconto totale';

  @override
  String get grandTotal => 'Totale generale';

  @override
  String get leftOver => 'Avanzo';

  @override
  String get bank => 'Banca';

  @override
  String get successfullyDownloaded => 'File scaricato con successo';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Aggiorna';

  @override
  String get remove => 'Rimuovi';

  @override
  String get main => 'Principale';

  @override
  String get leadingThankNote => 'Nota di ringraziamento';

  @override
  String get hintThankNote => 'Grazie per il tuo business!';

  @override
  String get logoHelp1 => 'Per ottenere i migliori risultati, scegli un\' ';

  @override
  String get logoHelp2 => 'immagine quadrata (rapporto 1:1)';

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
      other: '$countString Articoli',
      one: '1 Articolo',
      zero: 'Articolo',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'Mario Rossi';

  @override
  String get randomPhone => '+39 320 123 4567';

  @override
  String get phoneNumber => 'Numero di telefono';

  @override
  String get edit => 'Modifica';

  @override
  String get version => 'Versione';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';
}
