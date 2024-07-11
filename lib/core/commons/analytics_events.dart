class FirstUseEvents {
  static const String firstUseToHomePage = 'FIRST_USE_TO_HOME_PAGE';
}

class NavigationBarEvents {
  static const String navigationToHomePage = 'NAVIGATION_TO_HOME_PAGE';
  static const String navigationToSearchPage = 'NAVIGATION_TO_SEARCH_PAGE';
  static const String navigationToFavoritePage = 'NAVIGATION_TO_FAVORITE_PAGE';
}

class CounterPageEvents {
  static const String searchedZipCard = 'SEARCH_ZIP_CARD_WIDGET';
  static const String favoritedZipCard = 'FAVORITE_WIDGET_SECTION';
}

class SearchPageEvents {
  static const String searchPageButton = 'SEARCH_PAGE_BUTTON';
  static const String searchPageAddFavoriteButton =
      'SEARCH_PAGE_ADD_FAVORITE_BUTTON';
}

class FavoritesPageEvents {
  static const String favoritesPageDeleteButton =
      'FAVORITES_PAGE_DELETE_BUTTON';
  static const String favoritesPageShareButton =
      'FAVORITES_PAGE_SHARE_FAVORITE_BUTTON';
}
