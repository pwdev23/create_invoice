// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Crear factura';

  @override
  String get currency => 'Moneda';

  @override
  String get languageSettings => 'Configuración de idioma';

  @override
  String get english => 'Inglés';

  @override
  String get indonesian => 'Indonesio';

  @override
  String get german => 'Alemán';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get italian => 'Italiano';

  @override
  String get dutch => 'Neerlandés';

  @override
  String get norwegian => 'Noruego';

  @override
  String get polish => 'Polaco';

  @override
  String get portuguese => 'Portugués';

  @override
  String get turkish => 'Turco';

  @override
  String get addItem => 'Agregar artículo';

  @override
  String get itemName => 'Nombre del artículo';

  @override
  String get price => 'Precio';

  @override
  String get discount => 'Descuento';

  @override
  String get usePercentage => 'Usar porcentaje';

  @override
  String get addRecipient => 'Agregar destinatario';

  @override
  String get name => 'Nombre';

  @override
  String get address => 'Dirección';

  @override
  String get thankNote =>
      '¡Gracias por su negocio! Por favor, complete el saldo restante antes de la fecha de vencimiento para evitar cargos por mora. Si tiene alguna pregunta, no dude en contactarnos.';

  @override
  String get selectCurrency => 'Seleccionar moneda';

  @override
  String get editCurrency => 'Editar moneda';

  @override
  String get cont => 'Continuar';

  @override
  String get editItem => 'Editar artículo';

  @override
  String get save => 'Guardar';

  @override
  String get editRecipient => 'Editar destinatario';

  @override
  String get editStore => 'Editar información de la tienda';

  @override
  String get storeName => 'Nombre de la tienda';

  @override
  String get billedTo => 'Facturado a';

  @override
  String get delete => 'Eliminar';

  @override
  String get manageStore => 'Administrar tienda';

  @override
  String get recipient => 'Destinatario';

  @override
  String get failedToLoad => 'Error al cargar';

  @override
  String get noData => 'Sin datos';

  @override
  String get fillInvoiceDetails => 'Llenar detalles de la factura';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String get invoiceDetails => 'Detalles de la factura';

  @override
  String get paid => 'Pagado';

  @override
  String get paymentDetails => 'Detalles de pago';

  @override
  String get accountNumber => 'Número de cuenta';

  @override
  String get accountHolderName => 'Nombre del titular de la cuenta';

  @override
  String get swiftCode => 'Código Swift';

  @override
  String get tax => 'Impuesto';

  @override
  String get inPercent => 'En porcentaje';

  @override
  String get dueDateRange => 'Rango de fecha de vencimiento';

  @override
  String get noPurchaseItem =>
      'No se puede proceder, no hay ningún artículo de compra';

  @override
  String get qty => 'Cant.';

  @override
  String get preview => 'Vista previa';

  @override
  String get backToHome => 'Volver a inicio';

  @override
  String get invoice => 'Factura';

  @override
  String get amount => 'Monto';

  @override
  String get date => 'Fecha';

  @override
  String get dueDate => 'Fecha de vencimiento';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get totalDiscount => 'Descuento total';

  @override
  String get grandTotal => 'Total general';

  @override
  String get leftOver => 'Sobrante';

  @override
  String get bank => 'Banco';

  @override
  String get successfullyDownloaded => 'Archivo descargado con éxito';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Actualizar';

  @override
  String get remove => 'Eliminar';

  @override
  String get main => 'Principal';

  @override
  String get leadingThankNote => 'Nota de agradecimiento';

  @override
  String get hintThankNote => '¡Gracias por su negocio!';

  @override
  String get logoHelp1 => 'Para obtener los mejores resultados, elija una ';

  @override
  String get logoHelp2 => 'imagen cuadrada (relación 1:1)';

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
      other: '$countString Artículos',
      one: '1 Artículo',
      zero: 'Artículo',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'Juan Pérez';

  @override
  String get randomPhone => '+34 600 123 456';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get edit => 'Editar';

  @override
  String get version => 'Versión';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Política de privacidad';
}
