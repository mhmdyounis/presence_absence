mixin DbOperation<Model> {
  Future<int?>create(Model model);
  Future<List<Model>>read();
  Future<Model?>show(Model model);
  Future<bool>update(Model model);
  Future<bool>delete(Model model);
}