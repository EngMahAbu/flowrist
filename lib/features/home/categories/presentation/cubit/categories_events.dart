sealed class CategoriesEvents {}

class GetCategoriesEvent extends CategoriesEvents {}

class GetProductsByCategoryEvent extends CategoriesEvents {
  final String categoryId;

  GetProductsByCategoryEvent(this.categoryId);
}

class SelectCategoryEvent extends CategoriesEvents {
  final int index;

  SelectCategoryEvent(this.index);
}