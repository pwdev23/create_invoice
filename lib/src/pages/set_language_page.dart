import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common.dart';
import '../providers.dart';

enum LangOption { en, id }

class SetLanguagePage extends ConsumerStatefulWidget {
  static const routeName = '/languages';

  const SetLanguagePage({super.key, required this.langCode});

  final String langCode;

  @override
  ConsumerState<SetLanguagePage> createState() => _SetLanguagePageState();
}

class _SetLanguagePageState extends ConsumerState<SetLanguagePage> {
  late LangOption _opt;

  @override
  void initState() {
    super.initState();
    _opt = _getLangOption(widget.langCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          var opt = LangOption.values[index];
          var locale = _getLocale(opt);

          return RadioListTile.adaptive(
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text(_getName(opt)),
            value: opt,
            groupValue: _opt,
            onChanged: (v) => _onChanged(v, locale),
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 0.0),
        itemCount: LangOption.values.length,
      ),
    );
  }

  void _onChanged(LangOption? opt, Locale locale) {
    setState(() => _opt = opt!);
    ref.read(localeProvider).setLocale(locale);
  }

  LangOption _getLangOption(String code) {
    switch (code) {
      case 'id':
        return LangOption.id;
      default:
        return LangOption.en;
    }
  }

  Locale _getLocale(LangOption opt) {
    switch (opt) {
      case LangOption.id:
        return const Locale('id');
      default:
        return const Locale('en');
    }
  }

  String _getName(LangOption opt) {
    final l10n = AppLocalizations.of(context)!;

    switch (opt) {
      case LangOption.id:
        return l10n.indonesian;
      default:
        return l10n.english;
    }
  }
}

class SetLanguageArgs {
  const SetLanguageArgs(this.langCode);

  final String langCode;
}
