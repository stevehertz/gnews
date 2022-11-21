import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gnews/bloc/get_top_headlines_bloc.dart';
import 'package:gnews/elements/error_element.dart';
import 'package:gnews/elements/loader_element.dart';
import 'package:gnews/model/article.dart';
import 'package:gnews/model/article_response.dart';
import 'package:gnews/screens/news_detail.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeadlineSliderWidget extends StatefulWidget {
  const HeadlineSliderWidget({super.key});

  @override
  State<HeadlineSliderWidget> createState() => _HeadlineSliderWidgetState();
}

class _HeadlineSliderWidgetState extends State<HeadlineSliderWidget> {
  @override
  @override
  void initState() {
    super.initState();
    getTopHeadlinesBloc..getHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getTopHeadlinesBloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data!.error);
          }
          ArticleResponse? data = snapshot.data;
          return _buildHeadlineSlider(data!);
        } else if (snapshot.hasError) {
          var StringError = snapshot.error.toString();
          return buildErrorWidget(StringError);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHeadlineSlider(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;
    return CarouselSlider(
      items: getExpenseSliders(articles),
      options: CarouselOptions(
        enlargeCenterPage: false,
        height: 200.0,
        viewportFraction: 0.9,
      ),
    );
  }

  getExpenseSliders(List<ArticleModel> articles) {
    return articles
        .map(
          (article) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetail(article: article),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 10.0,
                bottom: 10.0,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: article.img == null
                            ? const NetworkImage(
                                "https://via.placeholder.com/600")
                            : NetworkImage(article.img!),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.1, 0.9],
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.white.withOpacity(0.0)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30.0,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      width: 250.0,
                      child: Column(
                        children: [
                          Text(
                            article.title!,
                            style: const TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    left: 10.0,
                    child: Text(
                      article.source.name!,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 9.0,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    right: 10.0,
                    child: Text(
                      timeAgo(
                        DateTime.parse(article.date!),
                      ),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 9.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  String timeAgo(DateTime date) {
    return timeago.format(
      date,
      allowFromNow: true,
      locale: 'en',
    );
  }
}
