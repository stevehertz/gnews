import 'package:gnews/model/article_response.dart';
import 'package:gnews/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetHotNewsBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject<ArticleResponse>();

  getHotNews() async {
    ArticleResponse response = await _repository.getHotNews();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;
}

final getHotNewsBloc = GetHotNewsBloc();
