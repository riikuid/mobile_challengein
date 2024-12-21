import 'package:mobile_challengein/model/savings_model.dart';
import 'package:mobile_challengein/widget/modal/menu_items.dart';

enum GoalNameCondition {
  contains,
  doesntContain,
  iss,
  isNot,
  startsWith,
  endsWith
}

class FilterModel {
  final String? id;
  final String? goalName;
  final GoalNameCondition? goalNameCondition;
  final int? lowesTargetAmound;
  final int? highestTargetAmound;
  final DateTime? startTargetDate;
  final DateTime? endTargetDate;
  final SavingType? savingType;
  final bool? isDone;
  final String? condiniton;
  final MenuItem? menuItem;
  final List<FilterModel>? nestedFilter;

  FilterModel({
    this.id,
    this.goalName,
    this.goalNameCondition,
    this.lowesTargetAmound,
    this.highestTargetAmound,
    this.startTargetDate,
    this.endTargetDate,
    this.savingType,
    this.isDone,
    this.condiniton,
    this.menuItem,
    this.nestedFilter,
  });
}
