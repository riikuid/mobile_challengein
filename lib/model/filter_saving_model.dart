enum GoalNameCondition {
  contains,
  doesntContain,
  iss,
  isNot,
  startsWith,
  endsWith
}

class FilterSavingModel {
  final String? id;
  final String? goalName;
  final GoalNameCondition? goalNameCondition;
  final int? lowesTargetAmound;
  final int? highestTargetAmound;
  final DateTime? startTargetDate;
  final DateTime? endTargetDate;

  FilterSavingModel({
    this.id,
    this.goalName,
    this.goalNameCondition,
    this.lowesTargetAmound,
    this.highestTargetAmound,
    this.startTargetDate,
    this.endTargetDate,
  });
}
