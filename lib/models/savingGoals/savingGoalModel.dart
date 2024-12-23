class GoalModel {
  final int id;
  final int userId;
  final String goalName;
  final String targetAmount;
  final String currentAmount;
  final String deadline;
  final String createdAt;
  final String updatedAt;

  GoalModel({
    required this.id,
    required this.userId,
    required this.goalName,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method for parsing JSON
  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      userId: json['user_id'],
      goalName: json['goal_name'],
      targetAmount: json['target_amount'],
      currentAmount: json['current_amount'],
      deadline: json['deadline'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Method to convert the GoalModel back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'goal_name': goalName,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'deadline': deadline,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
