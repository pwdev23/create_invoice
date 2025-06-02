// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Buat faktur';

  @override
  String get currency => 'Mata uang';

  @override
  String get languageSettings => 'Pengaturan bahasa';

  @override
  String get english => 'Inggris';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get german => 'Jerman';

  @override
  String get spanish => 'Spanyol';

  @override
  String get french => 'Prancis';

  @override
  String get italian => 'Italia';

  @override
  String get dutch => 'Belanda';

  @override
  String get norwegian => 'Norwegia';

  @override
  String get polish => 'Polandia';

  @override
  String get portuguese => 'Portugis';

  @override
  String get turkish => 'Turki';

  @override
  String get addItem => 'Tambah item';

  @override
  String get itemName => 'Nama item';

  @override
  String get price => 'Harga';

  @override
  String get discount => 'Diskon';

  @override
  String get usePercentage => 'Gunakan persenan';

  @override
  String get addRecipient => 'Tambah penerima';

  @override
  String get name => 'Nama';

  @override
  String get address => 'Alamat';

  @override
  String get thankNote =>
      'Terima kasih atas bisnis Anda! Silakan lunasi sisa saldo sebelum tanggal jatuh tempo untuk menghindari denda keterlambatan. Jika Anda memiliki pertanyaan, jangan ragu untuk menghubungi kami.';

  @override
  String get selectCurrency => 'Pilih mata uang';

  @override
  String get editCurrency => 'Atur mata uang';

  @override
  String get cont => 'Lanjutkan';

  @override
  String get editItem => 'Atur item';

  @override
  String get save => 'Simpan';

  @override
  String get editRecipient => 'Atur penerima';

  @override
  String get editStore => 'Atur info toko';

  @override
  String get storeName => 'Nama toko';

  @override
  String get billedTo => 'Ditagih ke';

  @override
  String get delete => 'Hapus';

  @override
  String get manageStore => 'Kelola toko';

  @override
  String get recipient => 'Penerima';

  @override
  String get failedToLoad => 'Gagal untuk memuat';

  @override
  String get noData => 'Tidak ada data';

  @override
  String get fillInvoiceDetails => 'Isi detil faktur';

  @override
  String get permissionDenied => 'Izin ditolak';

  @override
  String get invoiceDetails => 'Detil faktur';

  @override
  String get paid => 'Dibayar';

  @override
  String get paymentDetails => 'Detil pembayaran';

  @override
  String get accountNumber => 'Nomor akun';

  @override
  String get accountHolderName => 'Atas nama';

  @override
  String get swiftCode => 'Kode swift';

  @override
  String get tax => 'Pajak';

  @override
  String get inPercent => 'Dalam persen';

  @override
  String get dueDateRange => 'Jarak jatuh tempo';

  @override
  String get noPurchaseItem =>
      'Tidak dapat melanjutkan, tidak ada item pembelian';

  @override
  String get qty => 'Jml';

  @override
  String get preview => 'Pratinjau';

  @override
  String get backToHome => 'Kembali ke home';

  @override
  String get invoice => 'Faktur';

  @override
  String get amount => 'Jumlah';

  @override
  String get date => 'Tanggal';

  @override
  String get dueDate => 'Jatuh tempo';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get totalDiscount => 'Total diskon';

  @override
  String get grandTotal => 'Grand total';

  @override
  String get leftOver => 'Sisa';

  @override
  String get bank => 'Bank';

  @override
  String get successfullyDownloaded => 'Berkas berhasil diunduh';

  @override
  String get logo => 'Logo';

  @override
  String get update => 'Perbarui';

  @override
  String get remove => 'Hapus';

  @override
  String get main => 'Utama';

  @override
  String get leadingThankNote => 'Catatan terimakasih';

  @override
  String get hintThankNote => 'Terimakasih atas bisnis anda!';

  @override
  String get logoHelp1 => 'Untuk hasil yang sempurna, pilih gambar ';

  @override
  String get logoHelp2 => 'persegi (1:1 rasio)';

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
      other: '$countString Item',
      one: '1 Item',
      zero: 'Item',
    );
    return '$_temp0';
  }

  @override
  String get randomPerson => 'Wawan Setiawan';

  @override
  String get randomPhone => '+62 812-3456-7890';

  @override
  String get phoneNumber => 'Nomor telepon';

  @override
  String get edit => 'Edit';

  @override
  String get version => 'Versi';

  @override
  String get build => 'Build';

  @override
  String get privacyPolicy => 'Kebijakan privasi';
}
