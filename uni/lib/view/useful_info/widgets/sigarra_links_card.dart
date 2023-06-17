import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/generic_expansion_card.dart';
import 'package:uni/view/useful_info/widgets/link_button.dart';
import 'package:uni/generated/l10n.dart';

/// Manages the 'Current account' section inside the user's page (accessible
/// through the top-right widget with the user picture)
class SigarraLinksCard extends GenericExpansionCard {
  const SigarraLinksCard({Key? key}) : super(key: key);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(children: [
      LinkButton(
          title: S.of(context).news,
          link: 'https://sigarra.up.pt/feup/pt/noticias_geral.lista_noticias'),
      const LinkButton(
          title: 'Erasmus',
          link:
              'https://sigarra.up.pt/feup/pt/web_base.gera_pagina?P_pagina=257769'),
      LinkButton(
          title: S.of(context).geral_registration,
          link: 'https://sigarra.up.pt/feup/pt/ins_geral.inscricao'),
      LinkButton(
          title: S.of(context).class_registration,
          link: 'https://sigarra.up.pt/feup/pt/it_geral.ver_insc'),
      LinkButton(
          title: S.of(context).improvement_registration,
          link:
              'https://sigarra.up.pt/feup/pt/inqueritos_geral.inqueritos_list'),
      LinkButton(
          title: S.of(context).school_calendar,
          link:
              'https://sigarra.up.pt/feup/pt/web_base.gera_pagina?p_pagina=p%c3%a1gina%20est%c3%a1tica%20gen%c3%a9rica%20106')
    ]);
  }

  @override
  String getTitle(context) => 'Links Sigarra';
}
