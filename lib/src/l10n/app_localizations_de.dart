// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Rechnung erstellen';

  @override
  String get currency => 'Währung';

  @override
  String get languageSettings => 'Spracheinstellungen';

  @override
  String get english => 'Englisch';

  @override
  String get indonesian => 'Indonesisch';

  @override
  String get german => 'Deutsch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get french => 'Französisch';

  @override
  String get italian => 'Italienisch';

  @override
  String get dutch => 'Niederländisch';

  @override
  String get norwegian => 'Norwegisch';

  @override
  String get polish => 'Polnisch';

  @override
  String get portuguese => 'Portugiesisch';

  @override
  String get turkish => 'Türkisch';

  @override
  String get addItem => 'Artikel hinzufügen';

  @override
  String get itemName => 'Artikelname';

  @override
  String get price => 'Preis';

  @override
  String get discount => 'Rabatt';

  @override
  String get usePercentage => 'Prozent verwenden';

  @override
  String get addRecipient => 'Empfänger hinzufügen';

  @override
  String get name => 'Name';

  @override
  String get address => 'Adresse';

  @override
  String get thankNote =>
      'Vielen Dank für Ihr Geschäft! Bitte begleichen Sie den verbleibenden Betrag vor dem Fälligkeitsdatum, um Verzugsgebühren zu vermeiden. Falls Sie Fragen haben, kontaktieren Sie uns gerne.';

  @override
  String get selectCurrency => 'Währung auswählen';

  @override
  String get editCurrency => 'Währung bearbeiten';

  @override
  String get cont => 'Weiter';

  @override
  String get editItem => 'Artikel bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get editRecipient => 'Empfänger bearbeiten';

  @override
  String get editStore => 'Geschäftsinformationen bearbeiten';

  @override
  String get storeName => 'Geschäftsname';

  @override
  String get billedTo => 'Abgerechnet an';

  @override
  String get delete => 'Löschen';

  @override
  String get manageStore => 'Geschäft verwalten';

  @override
  String get recipient => 'Empfänger';

  @override
  String get failedToLoad => 'Laden fehlgeschlagen';

  @override
  String get noData => 'Keine Daten';

  @override
  String get fillInvoiceDetails => 'Rechnungsdetails ausfüllen';

  @override
  String get permissionDenied => 'Zugriff verweigert';

  @override
  String get invoiceDetails => 'Rechnungsdetails';

  @override
  String get paid => 'Bezahlt';

  @override
  String get paymentDetails => 'Zahlungsdetails';

  @override
  String get accountNumber => 'Kontonummer';

  @override
  String get accountHolderName => 'Kontoinhabername';

  @override
  String get swiftCode => 'Swift-Code';

  @override
  String get tax => 'Steuer';

  @override
  String get inPercent => 'In Prozent';

  @override
  String get dueDateRange => 'Fälligkeitsbereich';

  @override
  String get noPurchaseItem =>
      'Vorgang kann nicht fortgesetzt werden, es gibt keinen Kaufartikel';

  @override
  String get qty => 'Menge';

  @override
  String get preview => 'Vorschau';

  @override
  String get backToHome => 'Zurück zur Startseite';

  @override
  String get invoice => 'Rechnung';

  @override
  String get amount => 'Betrag';

  @override
  String get date => 'Datum';

  @override
  String get dueDate => 'Fälligkeitsdatum';

  @override
  String get subtotal => 'Zwischensumme';

  @override
  String get totalDiscount => 'Gesamtrabatt';

  @override
  String get grandTotal => 'Gesamtsumme';

  @override
  String get leftOver => 'Übrig geblieben';

  @override
  String get bank => 'Bank';

  @override
  String get successfullyDownloaded => 'Datei erfolgreich heruntergeladen';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Aktualisieren';

  @override
  String get remove => 'Entfernen';

  @override
  String get main => 'Haupt';

  @override
  String get leadingThankNote => 'Danksagung';

  @override
  String get hintThankNote => 'Vielen Dank für Ihr Geschäft!';

  @override
  String get logoHelp1 => 'Für die besten Ergebnisse wählen Sie bitte ein ';

  @override
  String get logoHelp2 => 'quadratisches (1:1 Verhältnis) ';

  @override
  String get logoHelp3 => 'Bild.';

  @override
  String nItem(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Artikel',
      one: '1 Artikel',
      zero: 'Artikel',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'Max Mustermann';

  @override
  String get randomPhone => '+49 151 23456789';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get version => 'Version';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';
}
