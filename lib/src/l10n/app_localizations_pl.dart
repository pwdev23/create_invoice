// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Utwórz fakturę';

  @override
  String get languageSettings => 'Ustawienia języka';

  @override
  String get english => 'Angielski';

  @override
  String get indonesian => 'Indonezyjski';

  @override
  String get german => 'Niemiecki';

  @override
  String get spanish => 'Hiszpański';

  @override
  String get french => 'Francuski';

  @override
  String get italian => 'Włoski';

  @override
  String get dutch => 'Holenderski';

  @override
  String get norwegian => 'Norweski';

  @override
  String get polish => 'Polski';

  @override
  String get portuguese => 'Portugalski';

  @override
  String get turkish => 'Turecki';

  @override
  String get addItem => 'Dodaj pozycję';

  @override
  String get itemName => 'Nazwa pozycji';

  @override
  String get price => 'Cena';

  @override
  String get discount => 'Rabat';

  @override
  String get usePercentage => 'Użyj procentu';

  @override
  String get addRecipient => 'Dodaj odbiorcę';

  @override
  String get name => 'Imię i nazwisko';

  @override
  String get address => 'Adres';

  @override
  String get thankNote =>
      'Dziękujemy za współpracę! Prosimy o uregulowanie pozostałej kwoty przed terminem płatności, aby uniknąć dodatkowych opłat. W razie pytań prosimy o kontakt.';

  @override
  String get selectCurrency => 'Wybierz walutę';

  @override
  String get editCurrency => 'Edytuj walutę';

  @override
  String get cont => 'Kontynuuj';

  @override
  String get editItem => 'Edytuj pozycję';

  @override
  String get save => 'Zapisz';

  @override
  String get editRecipient => 'Edytuj odbiorcę';

  @override
  String get editStore => 'Edytuj informacje o sklepie';

  @override
  String get storeName => 'Nazwa sklepu';

  @override
  String get billedTo => 'Fakturowany dla';

  @override
  String get delete => 'Usuń';

  @override
  String get manageStore => 'Zarządzaj sklepem';

  @override
  String get recipient => 'Odbiorca';

  @override
  String get failedToLoad => 'Nie udało się załadować';

  @override
  String get noData => 'Brak danych';

  @override
  String get fillInvoiceDetails => 'Wypełnij szczegóły faktury';

  @override
  String get permissionDenied => 'Odmowa dostępu';

  @override
  String get invoiceDetails => 'Szczegóły faktury';

  @override
  String get paid => 'Opłacono';

  @override
  String get paymentDetails => 'Szczegóły płatności';

  @override
  String get accountNumber => 'Numer konta';

  @override
  String get accountHolderName => 'Nazwa właściciela konta';

  @override
  String get swiftCode => 'Kod Swift';

  @override
  String get tax => 'Podatek';

  @override
  String get inPercent => 'W procentach';

  @override
  String get dueDateRange => 'Zakres dat płatności';

  @override
  String get noPurchaseItem => 'Nie można kontynuować, brak artykułu do zakupu';

  @override
  String get qty => 'Ilość';

  @override
  String get preview => 'Podgląd';

  @override
  String get backToHome => 'Powrót do strony głównej';

  @override
  String get invoice => 'Faktura';

  @override
  String get amount => 'Kwota';

  @override
  String get date => 'Data';

  @override
  String get dueDate => 'Termin płatności';

  @override
  String get subtotal => 'Suma częściowa';

  @override
  String get totalDiscount => 'Łączny rabat';

  @override
  String get grandTotal => 'Suma końcowa';

  @override
  String get leftOver => 'Pozostałość';

  @override
  String get bank => 'Bank';

  @override
  String get successfullyDownloaded => 'Plik został pomyślnie pobrany';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Aktualizuj';

  @override
  String get remove => 'Usuń';

  @override
  String get main => 'Główne';

  @override
  String get leadingThankNote => 'Nota podziękowania';

  @override
  String get hintThankNote => 'Dziękujemy za współpracę!';

  @override
  String get logoHelp1 => 'Aby uzyskać najlepsze wyniki, wybierz ';

  @override
  String get logoHelp2 => 'kwadratowy obraz (proporcje 1:1)';

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
      other: '$countString Pozycje',
      one: '1 Pozycja',
      zero: 'Pozycja',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'Jan Kowalski';

  @override
  String get randomPhone => '+48 600 123 456';

  @override
  String get phoneNumber => 'Numer telefonu';

  @override
  String get edit => 'Edytuj';

  @override
  String get version => 'Wersja';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Polityka prywatności';
}
