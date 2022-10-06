import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  int delay = 0;
  bool isOnDelay = false;
  String search = '';

  Future<void> searchDelay() async {
    Future.delayed(Duration(milliseconds: delay), () {
      delay = 0;
      isOnDelay = false;
      emit(SearchDelay(search));
    });
  }

  void init(String searchText) {
    delay = 1000;
    isOnDelay = true;
    search = searchText;
    searchDelay();
  }

  void addDelay(String searchText) {
    delay = 1000;
    isOnDelay = true;
    search = searchText;
  }
}
