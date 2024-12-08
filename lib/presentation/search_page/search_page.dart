import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/core/commons/messages.dart';
import 'package:zip_search/presentation/favorite_page/cubit/favorite_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_cubit.dart';
import 'package:zip_search/presentation/search_page/cubit/search_state.dart';
import 'package:zip_search/presentation/search_page/widgets/address_list_widget.dart';
import 'package:zip_search/presentation/search_page/widgets/initial_widget.dart';
import 'package:zip_search/presentation/search_page/widgets/success_widget.dart';

import '../../core/di/setup_locator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _HomeState();
}

class _HomeState extends State<SearchPage> {
  SearchCubit get searchZipCubit => context.read<SearchCubit>();
  FavoriteCubit get favoriteCubit => context.read<FavoriteCubit>();
  final analytics = getIt<FirebaseAnalytics>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocConsumer<SearchCubit, SearchState>(
          bloc: searchZipCubit,
          listener: listener,
          builder: builder,
        ),
      );

  void listener(BuildContext context, SearchState state) {
    if (state is ErrorSearchZipState) {
      Messages.of(context).showError(state.errorMessage);
    } else if (state is ErrorEmptyZipState) {
      Messages.of(context).showError(state.errorEmptyMessage);
    } else if (state is ErrorAlreadyFavotiteZipState) {
      Messages.of(context).showError(state.errorMessage);
    } else if (state is FavoriteAddressState) {
      Messages.of(context).showSuccess(state.message);
    } else if (state is SuccessAddressesSearchState) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: favoriteCubit),
              BlocProvider.value(value: searchZipCubit),
            ],
            child: AddressListWidget(
              addressList: state.addressList,
            ),
          ),
        ),
      );
    }
  }

  Widget builder(BuildContext context, SearchState state) {
    if (state is SuccessSearchState) {
      return SuccessWidget(
        address: state.address,
        analytics: analytics,
      );
    } else {
      return InitialWidget(analytics: analytics);
    }
  }
}
