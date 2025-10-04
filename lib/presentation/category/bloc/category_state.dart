part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryLoadedState extends CategoryState {
  final List<Category> categories;

  const CategoryLoadedState({required this.categories});

  @override
  List<Object> get props => [categories];
}

final class CategoryErrorState extends CategoryState {
  final String message;

  const CategoryErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
