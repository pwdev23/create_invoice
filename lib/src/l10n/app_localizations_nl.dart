// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Factuur maken';

  @override
  String get languageSettings => 'Taalinstellingen';

  @override
  String get english => 'Engels';

  @override
  String get indonesian => 'Indonesisch';

  @override
  String get german => 'Duits';

  @override
  String get spanish => 'Spaans';

  @override
  String get french => 'Frans';

  @override
  String get italian => 'Italiaans';

  @override
  String get dutch => 'Nederlands';

  @override
  String get norwegian => 'Noors';

  @override
  String get polish => 'Pools';

  @override
  String get portuguese => 'Portugees';

  @override
  String get turkish => 'Turks';

  @override
  String get addItem => 'Item toevoegen';

  @override
  String get itemName => 'Itemnaam';

  @override
  String get price => 'Prijs';

  @override
  String get discount => 'Korting';

  @override
  String get usePercentage => 'Percentage gebruiken';

  @override
  String get addRecipient => 'Ontvanger toevoegen';

  @override
  String get name => 'Naam';

  @override
  String get address => 'Adres';

  @override
  String get thankNote =>
      'Bedankt voor uw zaken! Gelieve het resterende saldo te voldoen vóór de vervaldatum om extra kosten te voorkomen. Als u vragen heeft, neem dan gerust contact met ons op.';

  @override
  String get selectCurrency => 'Valuta selecteren';

  @override
  String get editCurrency => 'Valuta bewerken';

  @override
  String get cont => 'Doorgaan';

  @override
  String get editItem => 'Item bewerken';

  @override
  String get save => 'Opslaan';

  @override
  String get editRecipient => 'Ontvanger bewerken';

  @override
  String get editStore => 'Winkelinformatie bewerken';

  @override
  String get storeName => 'Winkelnaam';

  @override
  String get billedTo => 'Gefactureerd aan';

  @override
  String get delete => 'Verwijderen';

  @override
  String get manageStore => 'Winkel beheren';

  @override
  String get recipient => 'Ontvanger';

  @override
  String get failedToLoad => 'Laden mislukt';

  @override
  String get noData => 'Geen gegevens';

  @override
  String get fillInvoiceDetails => 'Factuurgegevens invullen';

  @override
  String get permissionDenied => 'Toegang geweigerd';

  @override
  String get invoiceDetails => 'Factuurgegevens';

  @override
  String get paid => 'Betaald';

  @override
  String get paymentDetails => 'Betalingsdetails';

  @override
  String get accountNumber => 'Rekeningnummer';

  @override
  String get accountHolderName => 'Naam rekeninghouder';

  @override
  String get swiftCode => 'Swift-code';

  @override
  String get tax => 'Belasting';

  @override
  String get inPercent => 'In procent';

  @override
  String get dueDateRange => 'Vervaldatum bereik';

  @override
  String get noPurchaseItem => 'Kan niet doorgaan, er is geen aankoopartikel';

  @override
  String get qty => 'Aantal';

  @override
  String get preview => 'Voorbeeld';

  @override
  String get backToHome => 'Terug naar start';

  @override
  String get invoice => 'Factuur';

  @override
  String get amount => 'Bedrag';

  @override
  String get date => 'Datum';

  @override
  String get dueDate => 'Vervaldatum';

  @override
  String get subtotal => 'Subtotaal';

  @override
  String get totalDiscount => 'Totale korting';

  @override
  String get grandTotal => 'Eindtotaal';

  @override
  String get leftOver => 'Overgebleven';

  @override
  String get bank => 'Bank';

  @override
  String get successfullyDownloaded => 'Bestand succesvol gedownload';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Bijwerken';

  @override
  String get remove => 'Verwijderen';

  @override
  String get main => 'Hoofd';

  @override
  String get leadingThankNote => 'Bedankbrief';

  @override
  String get hintThankNote => 'Bedankt voor uw zaken!';

  @override
  String get logoHelp1 => 'Voor het beste resultaat, kies een ';

  @override
  String get logoHelp2 => 'vierkante afbeelding (1:1 verhouding)';

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
      other: '$countString Items',
      one: '1 Item',
      zero: 'Item',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'Jan Jansen';

  @override
  String get randomPhone => '+31 6 12345678';

  @override
  String get phoneNumber => 'Telefoonnummer';

  @override
  String get edit => 'Bewerken';

  @override
  String get version => 'Versie';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Privacybeleid';
}
