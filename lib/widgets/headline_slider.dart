import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gnews/bloc/get_top_headlines_bloc.dart';
import 'package:gnews/elements/error_element.dart';
import 'package:gnews/elements/loader_element.dart';
import 'package:gnews/model/article.dart';
import 'package:gnews/model/article_response.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeadlineSliderWidget extends StatefulWidget {
  const HeadlineSliderWidget({super.key});

  @override
  State<HeadlineSliderWidget> createState() => _HeadlineSliderWidgetState();
}

class _HeadlineSliderWidgetState extends State<HeadlineSliderWidget> {
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
      options: CarouselOptions(
        enlargeCenterPage: false,
        height: 200.0,
        viewportFraction: 0.9,
      ),
      items: getExpenseSliders(articles),
    );
  }

  getExpenseSliders(List<ArticleModel> articles) {
    return articles
        .map(
          (article) => GestureDetector(
            onTap: () {},
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
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: article.img == null
                            ? const NetworkImage(
                                "https://via.placeholder.com/300")
                            : NetworkImage(article.img),
                        fit: BoxFit.cover,
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
                            article.title,
                            style: TextStyle(
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
                      article.source.name,
                      style: TextStyle(
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
                        DateTime.parse(article.date),
                      ),
                      style: TextStyle(
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
