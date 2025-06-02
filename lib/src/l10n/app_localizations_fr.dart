// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Créer une facture';

  @override
  String get languageSettings => 'Paramètres de langue';

  @override
  String get english => 'Anglais';

  @override
  String get indonesian => 'Indonésien';

  @override
  String get german => 'Allemand';

  @override
  String get spanish => 'Espagnol';

  @override
  String get french => 'Français';

  @override
  String get italian => 'Italien';

  @override
  String get dutch => 'Néerlandais';

  @override
  String get norwegian => 'Norvégien';

  @override
  String get polish => 'Polonais';

  @override
  String get portuguese => 'Portugais';

  @override
  String get turkish => 'Turc';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get itemName => 'Nom de l\'article';

  @override
  String get price => 'Prix';

  @override
  String get discount => 'Remise';

  @override
  String get usePercentage => 'Utiliser un pourcentage';

  @override
  String get addRecipient => 'Ajouter un destinataire';

  @override
  String get name => 'Nom';

  @override
  String get address => 'Adresse';

  @override
  String get thankNote =>
      'Merci pour votre entreprise ! Veuillez compléter le solde restant avant la date d\'échéance pour éviter les frais de retard. Si vous avez des questions, n\'hésitez pas à nous contacter.';

  @override
  String get selectCurrency => 'Sélectionner la devise';

  @override
  String get editCurrency => 'Modifier la devise';

  @override
  String get cont => 'Continuer';

  @override
  String get editItem => 'Modifier l\'article';

  @override
  String get save => 'Enregistrer';

  @override
  String get editRecipient => 'Modifier le destinataire';

  @override
  String get editStore => 'Modifier les informations du magasin';

  @override
  String get storeName => 'Nom du magasin';

  @override
  String get billedTo => 'Facturé à';

  @override
  String get delete => 'Supprimer';

  @override
  String get manageStore => 'Gérer le magasin';

  @override
  String get recipient => 'Destinataire';

  @override
  String get failedToLoad => 'Échec du chargement';

  @override
  String get noData => 'Aucune donnée';

  @override
  String get fillInvoiceDetails => 'Remplir les détails de la facture';

  @override
  String get permissionDenied => 'Permission refusée';

  @override
  String get invoiceDetails => 'Détails de la facture';

  @override
  String get paid => 'Payé';

  @override
  String get paymentDetails => 'Détails de paiement';

  @override
  String get accountNumber => 'Numéro de compte';

  @override
  String get accountHolderName => 'Nom du titulaire du compte';

  @override
  String get swiftCode => 'Code Swift';

  @override
  String get tax => 'Taxe';

  @override
  String get inPercent => 'En pourcentage';

  @override
  String get dueDateRange => 'Plage de dates d\'échéance';

  @override
  String get noPurchaseItem => 'Impossible de procéder, aucun article d\'achat';

  @override
  String get qty => 'Qté';

  @override
  String get preview => 'Aperçu';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get invoice => 'Facture';

  @override
  String get amount => 'Montant';

  @override
  String get date => 'Date';

  @override
  String get dueDate => 'Date d\'échéance';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get totalDiscount => 'Remise totale';

  @override
  String get grandTotal => 'Total général';

  @override
  String get leftOver => 'Restant';

  @override
  String get bank => 'Banque';

  @override
  String get successfullyDownloaded => 'Fichier téléchargé avec succès';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Mettre à jour';

  @override
  String get remove => 'Supprimer';

  @override
  String get main => 'Principal';

  @override
  String get leadingThankNote => 'Note de remerciement';

  @override
  String get hintThankNote => 'Merci pour votre entreprise !';

  @override
  String get logoHelp1 => 'Pour de meilleurs résultats, veuillez choisir une ';

  @override
  String get logoHelp2 => 'image carrée (ratio 1:1)';

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
      other: '$countString Articles',
      one: '1 Article',
      zero: 'Article',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'Jean Dupont';

  @override
  String get randomPhone => '+33 6 12 34 56 78';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get edit => 'Modifier';

  @override
  String get version => 'Version';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Politique de confidentialité';
}
