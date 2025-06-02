import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('id'),
    Locale('it'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// App title for the root app
  ///
  /// In en, this message translates to:
  /// **'Create invoice'**
  String get appTitle;

  /// A text for currency section label
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// A title for language settings page
  ///
  /// In en, this message translates to:
  /// **'Language settings'**
  String get languageSettings;

  /// A title for English list tile
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// A title for Indonesian list tile
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// A title for German list tile
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// A title for Spanish list tile
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// A title for French list tile
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// A title for Italian list tile
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italian;

  /// A title for Dutch list tile
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutch;

  /// A title for Norwegian list tile
  ///
  /// In en, this message translates to:
  /// **'Norwegian'**
  String get norwegian;

  /// A title for Polish list tile
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get polish;

  /// A title for Portuguese list tile
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// A title for Turkish list tile
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkish;

  /// A title for add item page
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// A title for item name text field
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemName;

  /// A title for price text field
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// A title for discount text field
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// A hint text for discount text field
  ///
  /// In en, this message translates to:
  /// **'Use percentage'**
  String get usePercentage;

  /// A title for recipient page
  ///
  /// In en, this message translates to:
  /// **'Add recipient'**
  String get addRecipient;

  /// A title for name text field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// A title for address text field
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// A thank note for invoice
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business! Please complete the remaining balance by the due date to avoid late fees. If you have any questions, feel free to contact us.'**
  String get thankNote;

  /// A title for select currency page
  ///
  /// In en, this message translates to:
  /// **'Select currency'**
  String get selectCurrency;

  /// A title for edit currency page
  ///
  /// In en, this message translates to:
  /// **'Edit currency'**
  String get editCurrency;

  /// An action text for continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get cont;

  /// A title for edit item page
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItem;

  /// An action text for save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// A title for edit recipient page
  ///
  /// In en, this message translates to:
  /// **'Edit recipient'**
  String get editRecipient;

  /// A title for edit store info page
  ///
  /// In en, this message translates to:
  /// **'Edit store info'**
  String get editStore;

  /// A title for store name text field
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get storeName;

  /// A leading text for recipient
  ///
  /// In en, this message translates to:
  /// **'Billed to'**
  String get billedTo;

  /// An action text for delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// An action text for manage store button
  ///
  /// In en, this message translates to:
  /// **'Manage store'**
  String get manageStore;

  /// A title for recipient page
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// A text to explain load failure
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get failedToLoad;

  /// A text to explain no data
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// An action text for fill invoice details button
  ///
  /// In en, this message translates to:
  /// **'Fill invoice details'**
  String get fillInvoiceDetails;

  /// A text to explain permission was denied
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// A title for invoice details form
  ///
  /// In en, this message translates to:
  /// **'Invoice details'**
  String get invoiceDetails;

  /// A title for paid text field
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// A text divider for payment details section
  ///
  /// In en, this message translates to:
  /// **'Payment details'**
  String get paymentDetails;

  /// A title for account number text field
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get accountNumber;

  /// A title for account holder name text field
  ///
  /// In en, this message translates to:
  /// **'Account holder name'**
  String get accountHolderName;

  /// A title for swift code text field
  ///
  /// In en, this message translates to:
  /// **'Swift code'**
  String get swiftCode;

  /// A title for tax text field
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// A text helper for tax text field
  ///
  /// In en, this message translates to:
  /// **'In percent'**
  String get inPercent;

  /// A text for due date range text field
  ///
  /// In en, this message translates to:
  /// **'Due date range'**
  String get dueDateRange;

  /// A text for no purchase item message
  ///
  /// In en, this message translates to:
  /// **'Can\'t proceed, there\'s no purchase item'**
  String get noPurchaseItem;

  /// A text for qty cell
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// A title for preview page
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// An action text for back to home button
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// A title for invoice
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// A title for amount cell
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// A leading text for date info
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// A leading text for due date info
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// A leading text for subtotal info
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// A leading text for total discount info
  ///
  /// In en, this message translates to:
  /// **'Total discount'**
  String get totalDiscount;

  /// A leading text for grand total info
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get grandTotal;

  /// A leading text for left over info
  ///
  /// In en, this message translates to:
  /// **'Left over'**
  String get leftOver;

  /// A leading text for bank info
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// A message after file successfully downloaded
  ///
  /// In en, this message translates to:
  /// **'File successfully downloaded'**
  String get successfullyDownloaded;

  /// A title for logo section
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get logo;

  /// An action text for update button
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// An action text for remove button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// A title for main section
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// A leading text for thank note text field
  ///
  /// In en, this message translates to:
  /// **'Thank note'**
  String get leadingThankNote;

  /// A hint text for thank note text field
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business!'**
  String get hintThankNote;

  /// A partial text for logo helper
  ///
  /// In en, this message translates to:
  /// **'For the best results, please choose a '**
  String get logoHelp1;

  /// A partial text for logo helper
  ///
  /// In en, this message translates to:
  /// **'square (1:1 ratio) '**
  String get logoHelp2;

  /// A partial text for logo helper
  ///
  /// In en, this message translates to:
  /// **'image.'**
  String get logoHelp3;

  /// A plural item text
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Item} =1{1 Item} other{{count} Items}}'**
  String nItem(num count);

  /// Random person name for placeholder
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get randomPerson;

  /// Random phone number for placeholder
  ///
  /// In en, this message translates to:
  /// **'+1 555-123-4567'**
  String get randomPhone;

  /// A text label for phone number text field
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// A text for edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// A leading text for version number
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// A leading text for build number
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// A title for privacy policy list tile
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'id',
    'it',
    'nl',
    'no',
    'pl',
    'pt',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
