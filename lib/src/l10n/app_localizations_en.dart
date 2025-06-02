// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Create invoice';

  @override
  String get languageSettings => 'Language settings';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get german => 'German';

  @override
  String get spanish => 'Spanish';

  @override
  String get french => 'French';

  @override
  String get italian => 'Italian';

  @override
  String get dutch => 'Dutch';

  @override
  String get norwegian => 'Norwegian';

  @override
  String get polish => 'Polish';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get turkish => 'Turkish';

  @override
  String get addItem => 'Add item';

  @override
  String get itemName => 'Item name';

  @override
  String get price => 'Price';

  @override
  String get discount => 'Discount';

  @override
  String get usePercentage => 'Use percentage';

  @override
  String get addRecipient => 'Add recipient';

  @override
  String get name => 'Name';

  @override
  String get address => 'Address';

  @override
  String get thankNote =>
      'Thank you for your business! Please complete the remaining balance by the due date to avoid late fees. If you have any questions, feel free to contact us.';

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get editCurrency => 'Edit currency';

  @override
  String get cont => 'Continue';

  @override
  String get editItem => 'Edit item';

  @override
  String get save => 'Save';

  @override
  String get editRecipient => 'Edit recipient';

  @override
  String get editStore => 'Edit store info';

  @override
  String get storeName => 'Store name';

  @override
  String get billedTo => 'Billed to';

  @override
  String get delete => 'Delete';

  @override
  String get manageStore => 'Manage store';

  @override
  String get recipient => 'Recipient';

  @override
  String get failedToLoad => 'Failed to load';

  @override
  String get noData => 'No data';

  @override
  String get fillInvoiceDetails => 'Fill invoice details';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get invoiceDetails => 'Invoice details';

  @override
  String get paid => 'Paid';

  @override
  String get paymentDetails => 'Payment details';

  @override
  String get accountNumber => 'Account number';

  @override
  String get accountHolderName => 'Account holder name';

  @override
  String get swiftCode => 'Swift code';

  @override
  String get tax => 'Tax';

  @override
  String get inPercent => 'In percent';

  @override
  String get dueDateRange => 'Due date range';

  @override
  String get noPurchaseItem => 'Can\'t proceed, there\'s no purchase item';

  @override
  String get qty => 'Qty';

  @override
  String get preview => 'Preview';

  @override
  String get backToHome => 'Back to home';

  @override
  String get invoice => 'Invoice';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get dueDate => 'Due date';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get totalDiscount => 'Total discount';

  @override
  String get grandTotal => 'Grand total';

  @override
  String get leftOver => 'Left over';

  @override
  String get bank => 'Bank';

  @override
  String get successfullyDownloaded => 'File successfully downloaded';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Update';

  @override
  String get remove => 'Remove';

  @override
  String get main => 'Main';

  @override
  String get leadingThankNote => 'Thank note';

  @override
  String get hintThankNote => 'Thank you for your business!';

  @override
  String get logoHelp1 => 'For the best results, please choose a ';

  @override
  String get logoHelp2 => 'square (1:1 ratio) ';

  @override
  String get logoHelp3 => 'image.';

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
  String get randomPerson => 'John Doe';

  @override
  String get randomPhone => '+1 555-123-4567';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get edit => 'Edit';

  @override
  String get version => 'Version';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Privacy policy';
}
