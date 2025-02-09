enum Currency { usd, idr }

String getName(Currency currency) {
  switch (currency) {
    case Currency.idr:
      return 'IDR';
    default:
      return 'USD';
  }
}

Currency getCurrency(String locale) {
  switch (locale) {
    case 'id_ID':
      return Currency.idr;
    default:
      return Currency.usd;
  }
}

String getLocale(Currency currency) {
  switch (currency) {
    case Currency.idr:
      return 'id_ID';
    default:
      return 'en_US';
  }
}

String getSymbol(Currency currency) {
  switch (currency) {
    case Currency.idr:
      return 'Rp';
    default:
      return '\$';
  }
}
