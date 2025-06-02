import '../enumerations.dart';

Currency getCurrency(String locale) {
  switch (locale) {
    case 'id_ID':
      return Currency.idr;
    case 'en_US':
      return Currency.usd;
    case 'en_GB':
      return Currency.gbp;
    case 'en_EU':
      return Currency.eur;
    case 'nb_NO':
    case 'nn_NO':
      return Currency.nok;
    case 'pl_PL':
      return Currency.pln;
    case 'tr_TR':
      return Currency.try_;
    default:
      return Currency.usd;
  }
}

String getLocale(Currency currency) {
  switch (currency) {
    case Currency.eur:
      return 'en_EU';
    case Currency.gbp:
      return 'en_GB';
    case Currency.idr:
      return 'id_ID';
    case Currency.nok:
      return 'nb_NO';
    case Currency.pln:
      return 'pl_PL';
    case Currency.try_:
      return 'tr_TR';
    default:
      return 'en_US';
  }
}

const Map<Currency, String> symbols = {
  Currency.eur: '€',
  Currency.usd: '\$',
  Currency.gbp: '£',
  Currency.idr: 'Rp',
  Currency.nok: 'kr',
  Currency.pln: 'zł',
  Currency.try_: '₺',
};
