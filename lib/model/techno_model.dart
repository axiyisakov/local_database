class Notebook {
  String? model;
  String? id;
  String? company;
  Notebook.fromJson(Map<String, dynamic> json) {
    model = json['model'];
    id = json['id'];
    company = json['company'];
  }
}
