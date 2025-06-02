// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get appTitle => 'Opprett faktura';

  @override
  String get currency => 'Valuta';

  @override
  String get languageSettings => 'Språkinnstillinger';

  @override
  String get english => 'Engelsk';

  @override
  String get indonesian => 'Indonesisk';

  @override
  String get german => 'Tysk';

  @override
  String get spanish => 'Spansk';

  @override
  String get french => 'Fransk';

  @override
  String get italian => 'Italiensk';

  @override
  String get dutch => 'Nederlandsk';

  @override
  String get norwegian => 'Norsk';

  @override
  String get polish => 'Polsk';

  @override
  String get portuguese => 'Portugisisk';

  @override
  String get turkish => 'Tyrkisk';

  @override
  String get addItem => 'Legg til vare';

  @override
  String get itemName => 'Varenavn';

  @override
  String get price => 'Pris';

  @override
  String get discount => 'Rabatt';

  @override
  String get usePercentage => 'Bruk prosent';

  @override
  String get addRecipient => 'Legg til mottaker';

  @override
  String get name => 'Navn';

  @override
  String get address => 'Adresse';

  @override
  String get thankNote =>
      'Takk for handelen! Vennligst betal det gjenværende beløpet før forfallsdatoen for å unngå ekstra gebyrer. Ta kontakt hvis du har spørsmål.';

  @override
  String get selectCurrency => 'Velg valuta';

  @override
  String get editCurrency => 'Rediger valuta';

  @override
  String get cont => 'Fortsett';

  @override
  String get editItem => 'Rediger vare';

  @override
  String get save => 'Lagre';

  @override
  String get editRecipient => 'Rediger mottaker';

  @override
  String get editStore => 'Rediger butikkinformasjon';

  @override
  String get storeName => 'Butikknavn';

  @override
  String get billedTo => 'Fakturert til';

  @override
  String get delete => 'Slett';

  @override
  String get manageStore => 'Administrer butikk';

  @override
  String get recipient => 'Mottaker';

  @override
  String get failedToLoad => 'Kunne ikke lastes inn';

  @override
  String get noData => 'Ingen data';

  @override
  String get fillInvoiceDetails => 'Fyll inn fakturadetaljer';

  @override
  String get permissionDenied => 'Tillatelse nektet';

  @override
  String get invoiceDetails => 'Fakturadetaljer';

  @override
  String get paid => 'Betalt';

  @override
  String get paymentDetails => 'Betalingsdetaljer';

  @override
  String get accountNumber => 'Kontonummer';

  @override
  String get accountHolderName => 'Kontoeier navn';

  @override
  String get swiftCode => 'Swift-kode';

  @override
  String get tax => 'Skatt';

  @override
  String get inPercent => 'I prosent';

  @override
  String get dueDateRange => 'Forfallsdatoområde';

  @override
  String get noPurchaseItem => 'Kan ikke fortsette, ingen kjøpsvare';

  @override
  String get qty => 'Antall';

  @override
  String get preview => 'Forhåndsvisning';

  @override
  String get backToHome => 'Tilbake til start';

  @override
  String get invoice => 'Faktura';

  @override
  String get amount => 'Beløp';

  @override
  String get date => 'Dato';

  @override
  String get dueDate => 'Forfallsdato';

  @override
  String get subtotal => 'Delsum';

  @override
  String get totalDiscount => 'Total rabatt';

  @override
  String get grandTotal => 'Totalsum';

  @override
  String get leftOver => 'Til overs';

  @override
  String get bank => 'Bank';

  @override
  String get successfullyDownloaded => 'Fil lastet ned vellykket';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Oppdater';

  @override
  String get remove => 'Fjern';

  @override
  String get main => 'Hoved';

  @override
  String get leadingThankNote => 'Takkebrev';

  @override
  String get hintThankNote => 'Takk for din handel!';

  @override
  String get logoHelp1 => 'For best resultat, velg et ';

  @override
  String get logoHelp2 => 'kvadratisk bilde (1:1-forhold)';

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
      other: '$countString Varer',
      one: '1 Vare',
      zero: 'Vare',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'Ola Nordmann';

  @override
  String get randomPhone => '+47 912 34 567';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get edit => 'Rediger';

  @override
  String get version => 'Versjon';

  @override
  String get build => 'Bygg';

  @override
  String get privacyPolicy => 'Personvernerklæring';
}
