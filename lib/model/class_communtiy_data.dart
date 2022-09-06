import 'dart:convert';

class CommuntiyData {


  int id;
  String classType;
  String status;
  String cover;
  String name;
  String startDate;
  String finishDate;
  String statusForDisplay;
  int totalMember;
  CommuntiyData({
    this.id,
    this.classType,
    this.status,
    this.cover,
    this.name,
    this.startDate,
    this.finishDate,
    this.statusForDisplay,
    this.totalMember,
  });

  CommuntiyData copyWith({
    int id,
    String classType,
    String status,
    String cover,
    String name,
    String startDate,
    String finishDate,
    String statusForDisplay,
    int totalMember,
  }) {
    return CommuntiyData(
      id: id ?? this.id,
      classType: classType ?? this.classType,
      status: status ?? this.status,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      finishDate: finishDate ?? this.finishDate,
      statusForDisplay: statusForDisplay ?? this.statusForDisplay,
      totalMember: totalMember ?? this.totalMember,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classType': classType,
      'status': status,
      'cover': cover,
      'name': name,
      'startDate': startDate,
      'finishDate': finishDate,
      'statusForDisplay': statusForDisplay,
      'totalMember': totalMember,
    };
  }

  factory CommuntiyData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CommuntiyData(
      id: map['id'],
      classType: map['classType'],
      status: map['status'],
      cover: map['cover'],
      name: map['name'],
      startDate: map['startDate'],
      finishDate: map['finishDate'],
      statusForDisplay: map['statusForDisplay'],
      totalMember: map['totalMember'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommuntiyData.fromJson(String source) => CommuntiyData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CommuntiyData(id: $id, classType: $classType, status: $status, cover: $cover, name: $name, startDate: $startDate, finishDate: $finishDate, statusForDisplay: $statusForDisplay, totalMember: $totalMember)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CommuntiyData &&
      o.id == id &&
      o.classType == classType &&
      o.status == status &&
      o.cover == cover &&
      o.name == name &&
      o.startDate == startDate &&
      o.finishDate == finishDate &&
      o.statusForDisplay == statusForDisplay &&
      o.totalMember == totalMember;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      classType.hashCode ^
      status.hashCode ^
      cover.hashCode ^
      name.hashCode ^
      startDate.hashCode ^
      finishDate.hashCode ^
      statusForDisplay.hashCode ^
      totalMember.hashCode;
  }
}
