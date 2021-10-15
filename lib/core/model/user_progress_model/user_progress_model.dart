import 'category_info_model.dart';

class UserProgressModel {
  String progressId;

  List<CategoryInfoModel> categoryInfoList = new List<CategoryInfoModel>();
  List<String> categoryTitleList = new List<String>();

  UserProgressModel(
      {this.categoryInfoList, this.categoryTitleList, this.progressId});

  UserProgressModel.fromJson(Map<String, dynamic> json) {
    this.progressId = json['progressId']?.toString();
    this.categoryTitleList = new List<String>();
    if (json['categoryTitleList'] != null) {
      json['categoryTitleList'].forEach((e) {
        this.categoryTitleList.add(e.toString());
      });
    }

    this.categoryInfoList = new List<CategoryInfoModel>();
    if (json['categoryInfoList'] != null) {
      json['categoryInfoList'].forEach((e) {
        this.categoryInfoList.add(new CategoryInfoModel.fromJson(e));
      });
    }
  }

  CategoryInfoModel getCategoryInfoModel(String categoryTitle) {
    if (categoryTitle == null) return null;
    if (this.categoryInfoList == null) return null;
    if (this.categoryInfoList.length < 1) return null;
    try {
      List<CategoryInfoModel> l = this
          .categoryInfoList
          ?.where((element) => element?.categoryTitle == categoryTitle)
          ?.toList();

      if (l.length < 1) return null;
      return l?.first;
    } catch (e) {
      return null;
    }
  }

  toJson() {
    Map<String, dynamic> map = new Map();
    map['progressId'] = this.progressId;

    map['categoryTitleList'] = this.categoryTitleList.toList();

    map['categoryInfoList'] =
        this.categoryInfoList.map((e) => e.toJson()).toList();
    return map;
  }
}
