part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchDelay extends SearchState {
  final String search;

  SearchDelay(this.search);
}
