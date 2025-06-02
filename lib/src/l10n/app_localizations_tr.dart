// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Fatura oluştur';

  @override
  String get languageSettings => 'Dil ayarları';

  @override
  String get english => 'İngilizce';

  @override
  String get indonesian => 'Endonezce';

  @override
  String get german => 'Almanca';

  @override
  String get spanish => 'İspanyolca';

  @override
  String get french => 'Fransızca';

  @override
  String get italian => 'İtalyanca';

  @override
  String get dutch => 'Flemenkçe';

  @override
  String get norwegian => 'Norveççe';

  @override
  String get polish => 'Lehçe';

  @override
  String get portuguese => 'Portekizce';

  @override
  String get turkish => 'Türkçe';

  @override
  String get addItem => 'Öğe ekle';

  @override
  String get itemName => 'Öğe adı';

  @override
  String get price => 'Fiyat';

  @override
  String get discount => 'İndirim';

  @override
  String get usePercentage => 'Yüzde kullan';

  @override
  String get addRecipient => 'Alıcı ekle';

  @override
  String get name => 'İsim';

  @override
  String get address => 'Adres';

  @override
  String get thankNote =>
      'İşletmemizi tercih ettiğiniz için teşekkür ederiz! Gecikme ücretlerinden kaçınmak için lütfen kalan bakiyenizi vade tarihinden önce tamamlayın. Sorularınız varsa bizimle iletişime geçmekten çekinmeyin.';

  @override
  String get selectCurrency => 'Para birimi seç';

  @override
  String get editCurrency => 'Para birimini düzenle';

  @override
  String get cont => 'Devam et';

  @override
  String get editItem => 'Öğeyi düzenle';

  @override
  String get save => 'Kaydet';

  @override
  String get editRecipient => 'Alıcıyı düzenle';

  @override
  String get editStore => 'Mağaza bilgilerini düzenle';

  @override
  String get storeName => 'Mağaza adı';

  @override
  String get billedTo => 'Faturalandırılan kişi';

  @override
  String get delete => 'Sil';

  @override
  String get manageStore => 'Mağazayı yönet';

  @override
  String get recipient => 'Alıcı';

  @override
  String get failedToLoad => 'Yüklenemedi';

  @override
  String get noData => 'Veri yok';

  @override
  String get fillInvoiceDetails => 'Fatura detaylarını doldurun';

  @override
  String get permissionDenied => 'İzin reddedildi';

  @override
  String get invoiceDetails => 'Fatura detayları';

  @override
  String get paid => 'Ödendi';

  @override
  String get paymentDetails => 'Ödeme detayları';

  @override
  String get accountNumber => 'Hesap numarası';

  @override
  String get accountHolderName => 'Hesap sahibi adı';

  @override
  String get swiftCode => 'Swift kodu';

  @override
  String get tax => 'Vergi';

  @override
  String get inPercent => 'Yüzde olarak';

  @override
  String get dueDateRange => 'Son ödeme tarihi aralığı';

  @override
  String get noPurchaseItem => 'Devam edilemiyor, satın alma öğesi yok';

  @override
  String get qty => 'Adet';

  @override
  String get preview => 'Önizleme';

  @override
  String get backToHome => 'Ana sayfaya dön';

  @override
  String get invoice => 'Fatura';

  @override
  String get amount => 'Tutar';

  @override
  String get date => 'Tarih';

  @override
  String get dueDate => 'Son ödeme tarihi';

  @override
  String get subtotal => 'Ara toplam';

  @override
  String get totalDiscount => 'Toplam indirim';

  @override
  String get grandTotal => 'Genel toplam';

  @override
  String get leftOver => 'Artan';

  @override
  String get bank => 'Banka';

  @override
  String get successfullyDownloaded => 'Dosya başarıyla indirildi';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Güncelle';

  @override
  String get remove => 'Kaldır';

  @override
  String get main => 'Ana';

  @override
  String get leadingThankNote => 'Teşekkür notu';

  @override
  String get hintThankNote => 'İşiniz için teşekkür ederiz!';

  @override
  String get logoHelp1 => 'En iyi sonuçlar için, ';

  @override
  String get logoHelp2 => 'kare (1:1 oranlı)';

  @override
  String get logoHelp3 => 'bir resim seçin.';

  @override
  String nItem(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Öğe',
      one: '1 Öğe',
      zero: 'Öğe',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'Ali Yılmaz';

  @override
  String get randomPhone => '+90 532 123 45 67';

  @override
  String get phoneNumber => 'Telefon numarası';

  @override
  String get edit => 'Düzenle';

  @override
  String get version => 'Sürüm';

  @override
  String get build => 'Derleme';

  @override
  String get privacyPolicy => 'Gizlilik politikası';
}
