part of 'main_bloc.dart';

abstract class MainEvent {}

class GetCategories extends MainEvent {}

class GetProductsByCategory extends MainEvent {
  final int categoryId;

  GetProductsByCategory(this.categoryId);
}

class SyncProducts extends MainEvent {
  final int categoryId;

  SyncProducts(this.categoryId);
}

class GetProductById extends MainEvent {
  final int nomer;

  GetProductById(this.nomer);
}

class GetProductsByQuery extends MainEvent {
  final String nomer;
  final String eni;
  final String boyi;
  final String narxi;
  final String marja;
  final int categoryId;

  GetProductsByQuery(
      this.nomer, this.eni, this.boyi, this.narxi, this.marja, this.categoryId);
}
