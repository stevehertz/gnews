import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gnews/bloc/search_bloc.dart';
import 'package:gnews/elements/loader_element.dart';
import 'package:gnews/model/article.dart';
import 'package:gnews/model/article_response.dart';
import 'package:gnews/screens/news_detail.dart';
import 'package:gnews/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as Timeago;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchBloc..search("value");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            controller: _searchController,
            onChanged: (changed) {
              searchBloc..search(_searchController.text);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Color(0xFFF5F5F5),
              suffixIcon: _searchController.text.length > 0
                  ? IconButton(
                      icon: Icon(EvaIcons.backspaceOutline),
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _searchController.clear();
                          searchBloc..search(_searchController.text);
                        });
                      },
                    )
                  : const Icon(
                      EvaIcons.searchOutline,
                      color: Color(0xFF9E9E9E),
                      size: 16.0,
                    ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFFF5F5F5).withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: const Color(0xFFF5F5F5).withOpacity(0.3),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                left: 15.0,
                right: 10.0,
              ),
              labelText: "Search..",
              hintStyle: const TextStyle(
                fontSize: 14.0,
                color: Style.Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              labelStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            autocorrect: false,
          ),
        ),
        Expanded(
          child: StreamBuilder<ArticleResponse>(
            stream: searchBloc.subject.stream,
            builder: (context, AsyncSnapshot<ArticleResponse> snapshop) {
              if (snapshop.hasData) {
                if (snapshop.data!.error != null &&
                    snapshop.data!.error.length > 0) {
                  return Container();
                }
                ArticleResponse? data = snapshop.data;
                return _buildSourceNewsWidget(data!);
              } else if (snapshop.hasError) {
                return Container();
              } else {
                return buildLoadingWidget();
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildSourceNewsWidget(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;

    if (articles.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              "No more news",
              style: TextStyle(
                color: Colors.black45,
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetail(
                    article: articles[index],
                  ),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1.0,
                  ),
                ),
                color: Colors.white,
              ),
              height: 150,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 10.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          articles[index].title!,
                          maxLines: 3,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  timeUntil(
                                      DateTime.parse(articles[index].date!)),
                                  style: const TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                    ),
                    width: MediaQuery.of(context).size.width * 2 / 5,
                    height: 130,
                    child: FadeInImage.assetNetwork(
                      alignment: Alignment.topCenter,
                      placeholder: "assets/img/placeholder.jpg",
                      image: articles[index].img == null
                          ? "https://via.placeholder.com/600"
                          : articles[index].img!,
                      fit: BoxFit.fitHeight,
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 1 / 3,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  String timeUntil(DateTime date) {
    return Timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
