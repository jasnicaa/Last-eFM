import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:last_efm/bloc/search/cubit/search_artists_cubit.dart';
import 'package:last_efm/data/model/artist.dart';
import 'package:last_efm/presentation/pages/artist_detail_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isWawyTextTapped = false;
  Widget _buildWavyText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 25.0,
          ),
          child: AnimatedTextKit(
            onTap: () {
              setState(() {
                isWawyTextTapped = true;
              });
            },
            animatedTexts: [
              TyperAnimatedText("Tap to find your ⭐ artist",
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                    color: Colors.teal,
                    fontSize: 18,
                  ),
                  speed: const Duration(milliseconds: 100)),
            ],
            isRepeatingAnimation: true,
            repeatForever: true,
          ),
        ),
      ),
    );
  }

  Column _showSearchBarAndBody() {
    return Column(
      children: <Widget>[_SearchBar(), _SearchBody()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Last eFM',
          style: TextStyle(color: Colors.redAccent),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
          child: isWawyTextTapped ? _showSearchBarAndBody() : _buildWavyText()),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      cursorColor: Colors.teal,
      style: const TextStyle(color: Colors.white),
      onChanged: (text) {
        if (text == "") {
          context.read<SearchArtistsCubit>().searchFieldCleared();
        }
      },
      onSubmitted: (text) {
        context.read<SearchArtistsCubit>().fetchResultsFromSearch(query: text);
      },
      decoration: InputDecoration(
          prefixIcon:
              const Icon(Icons.search_rounded, color: Colors.teal, size: 30),
          suffixIcon: GestureDetector(
            onTap: _onClearTapped,
            child: const Icon(Icons.clear, color: Colors.teal, size: 30),
          ),
          border: InputBorder.none,
          hintText: 'Find your artist ..',
          hintStyle: const TextStyle(color: Colors.white)),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    context.read<SearchArtistsCubit>().searchFieldCleared();
  }
}

class _SearchBody extends StatefulWidget {
  @override
  State<_SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<_SearchBody> {
  final _scrollController = ScrollController();
  late SearchArtistsCubit currentState;

  bool get _isBottom {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void initState() {
    _onScrollListener();
    currentState = context.read<SearchArtistsCubit>();
    super.initState();
  }

  void _onScrollListener() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            currentState.state.nextPage != null) {
          currentState.state.fetchingFeed = true;
          if (_isBottom) {
            BlocProvider.of<SearchArtistsCubit>(context).fetchResultsFromSearch(
                query: currentState.state.searchedItem!,
                page: currentState.state.currentPage + 1);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  navigateToDetailsScreen() async {
    // in live projects I am using custom Route for navigation

    await Navigator.push(
        context,
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => const ArtistDetailPage()));

    context.read<SearchArtistsCubit>().onPopResetStateToLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchArtistsCubit, SearchArtistsState>(
      listener: (context, state) {
        if (state.status == SearchArtistsStatus.artistSelected) {
          navigateToDetailsScreen();
        }

        WidgetsBinding.instance!.addPostFrameCallback(
          (_) {
            if (state.status == SearchArtistsStatus.loaded &&
                state.listOfArtists.isNotEmpty &&
                _isBottom) {
              context.read<SearchArtistsCubit>().fetchResultsFromSearch(
                  query: state.searchedItem!, page: state.nextPage!);
            }
          },
        );
      },
      builder: (context, state) {
        if (state.status == SearchArtistsStatus.loading &&
            state.currentPage == 1) {
          return const CircularProgressIndicator();
        }
        if (state is ErrorState) {
          return const Center(
            child: Text('oooooops! There"s been an error',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, color: Colors.red)),
          );
        }
        if (state.status == SearchArtistsStatus.loaded) {
          return Expanded(child: _buildSearchResults(state.listOfArtists));
        }

        return const Text('Please enter a term to begin');
      },
    );
  }

  Widget _buildSearchResults(List<Artist> items) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return index >= items.length
            ? const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: CircularProgressIndicator(),
              )
            : _SearchResultItem(
                item: items[index],
                index: index,
              );
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem({Key? key, required this.item, required this.index})
      : super(key: key);

  final Artist item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.headset, color: Colors.white),
      title: Text(
        item.name!,
        style: const TextStyle(color: Colors.teal, fontSize: 20),
      ),
      onTap: () {
        context.read<SearchArtistsCubit>().artistSelected(item.name!);
      },
    );
  }
}
