import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/course_units/widgets/course_unit_card.dart';
import 'package:uni/view/lazy_consumer.dart';

class CourseUnitsPageView extends StatefulWidget {
  const CourseUnitsPageView({super.key});

  static const bothSemestersDropdownOption = '1S+2S';

  @override
  State<StatefulWidget> createState() {
    return CourseUnitsPageViewState();
  }
}

class CourseUnitsPageViewState
    extends GeneralPageViewState<CourseUnitsPageView> {
  String? selectedSchoolYear;
  String? selectedSemester;

  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<ProfileProvider>(
      builder: (context, profileProvider) {
        final courseUnits = profileProvider.profile.courseUnits;
        var availableYears = <String>[];
        var availableSemesters = <String>[];

        if (courseUnits.isNotEmpty) {
          availableYears = _getAvailableYears(courseUnits);
          if (availableYears.isNotEmpty && selectedSchoolYear == null) {
            selectedSchoolYear = availableYears.reduce(
              (value, element) =>
                  element.compareTo(value) > 0 ? element : value,
            );
          }

          availableSemesters = _getAvailableSemesters(courseUnits);

          if (availableSemesters.length == 3 && selectedSemester == null) {
            selectedSemester = availableSemesters[2];
          }
        }

        return _getPageView(
          courseUnits,
          profileProvider.status,
          availableYears,
          availableSemesters,
        );
      },
    );
  }

  Widget _getPageView(
    List<CourseUnit> courseUnits,
    RequestStatus requestStatus,
    List<String> availableYears,
    List<String> availableSemesters,
  ) {
    final filteredCourseUnits =
        selectedSemester == CourseUnitsPageView.bothSemestersDropdownOption
            ? courseUnits
                .where((element) => element.schoolYear == selectedSchoolYear)
                .toList()
            : courseUnits
                .where(
                  (element) =>
                      element.schoolYear == selectedSchoolYear &&
                      element.semesterCode == selectedSemester,
                )
                .toList();
    return Column(
      children: [
        _getPageTitleAndFilters(availableYears, availableSemesters),
        RequestDependentWidgetBuilder(
          status: requestStatus,
          builder: () =>
              _generateCourseUnitsCards(filteredCourseUnits, context),
          hasContentPredicate: courseUnits.isNotEmpty,
          onNullContent: Center(
            heightFactor: 10,
            child: Text(
              S.of(context).no_selected_courses,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getPageTitleAndFilters(
    List<String> availableYears,
    List<String> availableSemesters,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PageTitle(
          name: S.of(context).nav_title(DrawerItem.navCourseUnits.title),
        ),
        const Spacer(),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            alignment: AlignmentDirectional.centerEnd,
            disabledHint: Text(S.of(context).semester),
            value: selectedSemester,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() => selectedSemester = newValue);
            },
            items: availableSemesters
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 10),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            disabledHint: Text(S.of(context).year),
            value: selectedSchoolYear,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              setState(() => selectedSchoolYear = newValue);
            },
            items: availableYears.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _generateCourseUnitsCards(
    List<CourseUnit> courseUnits,
    BuildContext context,
  ) {
    if (courseUnits.isEmpty) {
      return Center(
        heightFactor: 10,
        child: Text(
          S.of(context).no_course_units,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: _generateCourseUnitsGridView(courseUnits),
        ),
      ),
    );
  }

  List<Widget> _generateCourseUnitsGridView(List<CourseUnit> courseUnits) {
    final rows = <Widget>[];
    for (var i = 0; i < courseUnits.length; i += 2) {
      if (i < courseUnits.length - 1) {
        rows.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(child: CourseUnitCard(courseUnits[i])),
                const SizedBox(width: 10),
                Flexible(child: CourseUnitCard(courseUnits[i + 1])),
              ],
            ),
          ),
        );
      } else {
        rows.add(
          Row(
            children: [
              Flexible(child: CourseUnitCard(courseUnits[i])),
              const SizedBox(width: 10),
              const Spacer(),
            ],
          ),
        );
      }
    }
    return rows;
  }

  List<String> _getAvailableYears(List<CourseUnit> courseUnits) {
    return courseUnits
        .map((c) => c.schoolYear)
        .whereType<String>()
        .toSet()
        .toList()
        .sorted();
  }

  List<String> _getAvailableSemesters(List<CourseUnit> courseUnits) {
    return courseUnits
            .map((c) => c.semesterCode)
            .whereType<String>()
            .toSet()
            .toList()
            .sorted() +
        [CourseUnitsPageView.bothSemestersDropdownOption];
  }

  @override
  Future<void> onRefresh(BuildContext context) {
    return Provider.of<ProfileProvider>(context, listen: false)
        .forceRefresh(context);
  }
}
