class AppStrings {
  static const String appbarText = 'Busca CEP';

  //Bottom navigation bar
  static const String navigationBarLabel01 = 'Home';
  static const String navigationBarLabel02 = 'Procurar';
  static const String navigationBarLabel03 = 'Salvos';

  //Counter Page
  static const String greetingsText = 'Olá,\nseja bem vindo!';
  static const String successfulSearchedZipsText = 'CEPs prcurados com sucesso';
  static const String successfulSavedZipsText = 'CEPs salvos';

  //Favorites page
  static const String initialZipPageText = 'Nenhum CEP foi favoritado!';
  static const String emptyComplementText = 'Não possui complemento';
  static const String dialogTitleText = 'Apagar endereço?';
  static const String dialogContentText = 'Esta ação não poderá ser desfeita.';
  static const String okText = 'OK';

  //Search page
  static const String textFieldText = 'Somente números =)';
  static const String searchPageMessage =
      'Digite o CEP que você deseja procurar:';
  static const String searchPagebuttonText = 'Buscar CEP!';
  static const String addressText = 'Endereço:';
  static const String addToFavoritesButton = 'Adicionar aos favoritos';

  //Cubit messages

  //Search zip cubit
  static const zipCodeEmptyErrorMessageText =
      'Parece não foi digitado nenhum CEP!';
  static const zipCodeInvalidErrorMessageText = 'CEP digitado não é válido.';

  static const alreadyFavoritedZipCodeText = 'Ops! Esse cep já foi favoritado';
  static const successZipFavoriteText = 'CEP favoritado com sucesso!';

  //Favorites cubit
  static const deletedFavoriteZipText = 'CEP deletado com sucesso!';
}
