class AppStrings {
  static const String appbarText = 'Busca CEP';

  //Bottom navigation bar
  static const String navigationBarLabel01 = 'Home';
  static const String navigationBarLabel02 = 'Procurar';
  static const String navigationBarLabel03 = 'Favoritos';

  //Counter Page
  static const String greetingsText = 'Olá!\nSeja bem-vindo!';
  static const String successfulSearchedZipsText =
      'CEPs procurados com sucesso';
  static const String successfulSavedZipsText = 'CEPs totais favoritados';

  //Favorites page
  static const String initialZipPageText = 'Nenhum CEP foi favoritado!';
  static const String emptyComplementText = 'Não possui complemento';
  static const String dialogTitleText = 'Apagar endereço?';
  static const String dialogContentText = 'Esta ação não poderá ser desfeita.';
  static const String okText = 'OK';
  static const String cancelText = 'Cancelar';
  static const String modalTitle =
      'Olá! Estou compartilhando com você esse endereço!';
  static const String addTagSuccessText = 'Tag adicionada com sucesso!';
  static const String removeTagSuccessText = 'Tag removida com sucesso!';
  static const String addTagText = 'Adicionar tag!';

  //Search page
  static const String textFieldText = 'Somente números =)';
  static const String searchPageMessage =
      'Selecione de qual maneira você quer procurar o endereço:';
  static const String searchPagebuttonText = 'Buscar CEP!';
  static const String addressText = 'Endereço';
  static const String addToFavoritesButton = 'Adicionar aos favoritos';
  static const String zipText = 'CEP';
  static const String resultsAppBarText = 'Resultados';
  static const String favoritedAddressList = 'Se dirija a tela de favoritos para remover um endereço';

  //Welcome page
  static const String welcomePageItemTitle01 = 'Seja bem vindo ao Busca CEP!';
  static const String welcomePageItemMessage01 =
      'Primeiramente gostaria de agradecer pelo download!\n'
      'Espero que o app seja útil no seu dia a dia.';

  static const String welcomePageItemTitle02 = 'Home Page';
  static const String welcomePageItemMessage02 =
      'Nessa tela temos os dois contadores.'
      '\n• Primeiro representando a quantidade total de CEPs procurados.'
      '\n• Segundo representando a quantidade total de CEPs que foram favoritados.';

  static const String welcomePageItemTitle03 = 'Tela de Busca';
  static const String welcomePageItemMessage03 =
      'Essa é a tela principal do app!'
      '\nAqui você pode realizar suas consultas e caso deseje, '
      'é possível favoritar o endereço e depois consultá-los na tela de favoritos.';

  static const String welcomePageItemTitle04 = 'Tela de Favoritos';
  static const String welcomePageItemMessage04 =
      'Nessa tela temos todos os seus CEPs favoritados!'
      'Caso seja desejado, também é possível apagar o endereço favoritado.';
  static const String goToHomeButton = 'Ir para home';

  //Create tag page
  static const String createTagPageTitleText = 'Qual o nome da nova tag?';
  static const String createTagPageButtonText = 'Adicionar tag';

  //Search zip cubit
  static const zipCodeEmptyErrorMessageText =
      'Parece que não foi digitado nenhum CEP!';
  static const zipCodeInvalidErrorMessageText = 'CEP digitado não é válido.';

  static const alreadyFavoritedZipCodeText = 'Ops! Esse CEP já foi favoritado';
  static const successZipFavoriteText = 'CEP favoritado com sucesso!';

  //Favorites cubit
  static const deletedFavoriteZipText = 'CEP deletado com sucesso!';

  //SnackBar text
  static const snackBarOkText = 'OK';

  //Logs texts
  static const seachedZipLog = 'CEP procurado:';
}
