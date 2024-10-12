part of 'main_bloc.dart';

abstract class MainEvent {}

class GetCategories extends MainEvent {}

class SyncAppEvent extends MainEvent {
  final List<String> values;

  SyncAppEvent({required this.values});
}

class GetProductsByCategory extends MainEvent {
  final int categoryId;

  GetProductsByCategory(this.categoryId);
}

class GetLocalDataEvent extends MainEvent {
  final int categoryId;

  GetLocalDataEvent(this.categoryId);
}

class GetProductById extends MainEvent {
  final int nomer;
  final int selectedIndex;

  GetProductById(this.nomer, this.selectedIndex);
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
