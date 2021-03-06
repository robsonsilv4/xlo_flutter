import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blocs/home_bloc.dart';
import '../../common/custom_drawer/custom_drawer.dart';
import 'widgets/search_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _homeBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final homeBloc = Provider.of<HomeBloc>(context);

    if (homeBloc != _homeBloc) {
      _homeBloc = homeBloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    _openSearch(String currentSearch) async {
      final String search = await showDialog(
        context: context,
        builder: (context) => SearchDialog(
          currentSearch: currentSearch,
        ),
      );

      if (search != null) {
        _homeBloc.setSearch(search);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          stream: _homeBloc.outSearch,
          initialData: '',
          builder: (context, snapshot) {
            if (snapshot.data.isEmpty) {
              return Container();
            }
            return GestureDetector(
              onTap: () => _openSearch(snapshot.data),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    child: Text(snapshot.data),
                    width: constraints.biggest.width,
                  );
                },
              ),
            );
          },
        ),
        actions: <Widget>[
          StreamBuilder<String>(
            stream: _homeBloc.outSearch,
            initialData: '',
            builder: (context, snapshot) {
              if (snapshot.data.isEmpty) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _openSearch('');
                  },
                );
              }

              return IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _homeBloc.setSearch('');
                },
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
    );
  }
}
