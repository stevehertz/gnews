import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gnews/model/article.dart';
import 'package:gnews/style/theme.dart' as Style;
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as Timeago;

class NewsDetail extends StatefulWidget {
  final ArticleModel article;
  const NewsDetail({super.key, required this.article});

  @override
  State<NewsDetail> createState() => _NewsDetailState(article);
}

class _NewsDetailState extends State<NewsDetail> {
  final ArticleModel article;

  _NewsDetailState(this.article);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () {
          // ignore: deprecated_member_use
          launch(article.url!);
        },
        child: Container(
          height: 48.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: Style.Colors.primaryGradient,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Read More",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "SFPro-Bold",
                  fontSize: 15.0,
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Style.Colors.mainColor,
        title: Text(
          article.title!,
          style: TextStyle(
            fontSize:
                Theme.of(context).platform == TargetPlatform.iOS ? 17.0 : 17.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: FadeInImage.assetNetwork(
              alignment: Alignment.topCenter,
              placeholder: "assets/img/placeholder.jpg",
              image: article.img == null
                  ? "https://via.placeholder.com/600"
                  : article.img!,
              fit: BoxFit.cover,
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 1 / 3,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      article.date!.substring(0, 10),
                      style: const TextStyle(
                        color: Style.Colors.mainColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    article.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  timeUntil(DateTime.parse(article.date!)),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Html(
                  data: article.content!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String timeUntil(DateTime date) {
    return Timeago.format(date, allowFromNow: true);
  }
}
