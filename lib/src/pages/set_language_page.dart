import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common.dart';
import '../providers.dart';

enum LangOption { de, en, es, fr, id, it, nl, no, pl, pt, tr }

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
      appBar: AppBar(title: Text(l10n.languageSettings)),
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
    var opt = LangOption.en;

    for (var e in LangOption.values) {
      if (e.name == code) {
        opt = e;
        break;
      }
    }

    return opt;
  }

  Locale _getLocale(LangOption opt) => Locale(opt.name);

  String _getName(LangOption opt) {
    final l10n = AppLocalizations.of(context)!;

    switch (opt) {
      case LangOption.de:
        return l10n.german;
      case LangOption.es:
        return l10n.spanish;
      case LangOption.fr:
        return l10n.french;
      case LangOption.id:
        return l10n.indonesian;
      case LangOption.it:
        return l10n.italian;
      case LangOption.nl:
        return l10n.dutch;
      case LangOption.no:
        return l10n.norwegian;
      case LangOption.pl:
        return l10n.polish;
      case LangOption.pt:
        return l10n.portuguese;
      case LangOption.tr:
        return l10n.turkish;
      default:
        return l10n.english;
    }
  }
}

class SetLanguageArgs {
  const SetLanguageArgs(this.langCode);

  final String langCode;
}
