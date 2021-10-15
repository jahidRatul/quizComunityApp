class CategoryInfoModel {
  String categoryTitle;

  List<String> correctAnsIDList = new List<String>();

  CategoryInfoModel({this.categoryTitle, this.correctAnsIDList});

  CategoryInfoModel.fromJson(Map<String, dynamic> json) {
    this.categoryTitle = json['categoryTitle'].toString();
    this.correctAnsIDList = new List<String>();
    if (json['correctAnsIDList'] != null) {
      json['correctAnsIDList'].forEach((e) {
        this.correctAnsIDList.add(e.toString());
      });
    }
  }

  toJson() {
    Map<String, dynamic> json = new Map();

    json['categoryTitle'] = this.categoryTitle;
    json['correctAnsIDList'] =
        this.correctAnsIDList.map((e) => e.toString()).toList();

    return json;
  }
}
