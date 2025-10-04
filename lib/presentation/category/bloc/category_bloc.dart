import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:take_home/domain/entities/category.dart';
import 'package:take_home/domain/usecases/get_categories.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;

  CategoryBloc({required this.getCategories}) : super(CategoryInitial()) {
    on<FetchCategoriesEvent>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(FetchCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());

    try {
      final categories = await getCategories();
      emit(CategoryLoadedState(categories: categories));
    } catch (e) {
      emit(CategoryErrorState(message: e.toString()));
    }
  }
}
