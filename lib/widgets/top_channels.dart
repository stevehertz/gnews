import 'package:flutter/material.dart';
import 'package:gnews/bloc/get_sorces_bloc.dart';
import 'package:gnews/elements/error_element.dart';
import 'package:gnews/elements/loader_element.dart';
import 'package:gnews/model/source.dart';
import 'package:gnews/model/source_response.dart';

class TopChannels extends StatefulWidget {
  const TopChannels({super.key});

  @override
  State<TopChannels> createState() => _TopChannelsState();
}

class _TopChannelsState extends State<TopChannels> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSourcesBloc..getSources();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourcesBloc.subject.stream,
      builder: (context, AsyncSnapshot<SourceResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null && snapshot.data!.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data!.error);
          }
          SourceResponse? data = snapshot.data;
          return _buildTopChannels(data!);
        } else if (snapshot.hasError) {
          var StringError = snapshot.error.toString();
          return buildErrorWidget(StringError);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildTopChannels(SourceResponse data) {
    List<SourceModel> sources = data.sources;
    if (sources.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              "No sources",
            )
          ],
        ),
      );
    } else {
      return Container(
        height: 115.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sources.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              width: 80.0,
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: sources[index].id!,
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/logos/${sources[index]}.png"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      sources[index].name!,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        height: 1.4,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      sources[index].category!,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 9.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
