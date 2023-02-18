abstract class NewsStates {}

class NewsInitialState extends NewsStates {}

class NewsBottomNavState extends NewsStates {}

class NewsGetBusinessLoadingState extends NewsStates {}

class NewsGetBusinessSeccusState extends NewsStates {}

class NewsGetBusinessErrorState extends NewsStates {
  final String error;
  NewsGetBusinessErrorState(this.error);
}

class NewsGetSportsLoadingState extends NewsStates {}

class NewsGetSportsSeccusState extends NewsStates {}

class NewsGetSportsErrorState extends NewsStates {
  final String error;
  NewsGetSportsErrorState(this.error);
}

class NewsGetSciencesLoadingState extends NewsStates {}

class NewsGetSciencesSeccusState extends NewsStates {}

class NewsGetSciencesErrorState extends NewsStates {
  final String error;
  NewsGetSciencesErrorState(this.error);
}

class NewsGetSearchLoadingState extends NewsStates {}

class NewsGetSearchSeccusState extends NewsStates {}

class NewsGetSearchErrorState extends NewsStates {
  final String error;
  NewsGetSearchErrorState(this.error);
}
