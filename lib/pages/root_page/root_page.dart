import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zip_search/data/cubits/navigation/naviagtion_state.dart';
import 'package:zip_search/data/cubits/navigation/navigation_cubit.dart';
import 'package:zip_search/pages/counter_page/counter_page.dart';
import 'package:zip_search/pages/saved_zip_page/saved_zip.dart';
import 'package:zip_search/pages/search_page/search_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  NavigationCubit get cubit => context.read<NavigationCubit>();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Busca CEP concept'),
      ),
      bottomNavigationBar: _bottomNavigationWidget(),
      body: _body());

  Widget _bottomNavigationWidget() =>
      BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.index,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.one_k_outlined), label: 'Count'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_add), label: 'Saved')
            ],
            onTap: (index) {
              if (index == 0) {
                cubit.getNavBarItem(NavBarItem.counter);
              } else if (index == 1) {
                cubit.getNavBarItem(NavBarItem.search);
              } else if (index == 2) {
                cubit.getNavBarItem(NavBarItem.saved);
              }
            },
          );
        },
      );

  Widget _body() => BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          if (state.navBarItem == NavBarItem.counter) {
            return const CounterPage();
          } else if (state.navBarItem == NavBarItem.search) {
            return const SearchPage();
          } else if (state.navBarItem == NavBarItem.saved) {
            return const SavedZipPage();
          }
          return const SizedBox();
        },
      );
}
