class Content {
  final String title;
  final String description;

  Content(this.title, this.description);

  Content.fromJson(Map<String, dynamic> dataJson)
    : this.title = dataJson['title'],
      this.description = dataJson['description'];
}