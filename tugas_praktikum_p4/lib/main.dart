import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_service.dart';
import 'article_model.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Berita',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Article>> _articlesFuture;

  final ScrollController _scrollController =
      ScrollController();

  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    _articlesFuture =
        ApiService().fetchArticles();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300) {
        setState(() {
          _showButton = true;
        });
      } else {
        setState(() {
          _showButton = false;
        });
      }
    });
  }

  Future<void> _refreshNews() async {
    setState(() {
      _articlesFuture =
          ApiService().fetchArticles();
    });

    await _articlesFuture;
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(
        milliseconds: 500,
      ),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.white,
          child: Card(
            margin: const EdgeInsets.all(12),
            child: Container(
              height: 250,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(70),
        child: Container(
          decoration:
              const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff667eea),
                Color(0xff764ba2),
              ],
            ),
          ),
          child: AppBar(
            backgroundColor:
                Colors.transparent,
            elevation: 0,
            centerTitle: true,
           title: const Text(
  "Aplikasi Berita",
  style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  ),
),
          ),
        ),
      ),

      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder:
            (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return buildShimmer();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada berita",
              ),
            );
          }

          final articles =
              snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshNews,
            child: ListView.builder(
              controller:
                  _scrollController,
              itemCount:
                  articles.length,
              itemBuilder:
                  (context, index) {
                final article =
                    articles[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailPage(
                          article:
                              article,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets
                            .all(12),
                    elevation: 8,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius
                                  .vertical(
                            top:
                                Radius
                                    .circular(
                              20,
                            ),
                          ),
                          child:
                              article.urlToImage !=
                                      null
                                  ? Image.network(
                                      article
                                          .urlToImage!,
                                      height:
                                          220,
                                      width: double
                                          .infinity,
                                      fit: BoxFit
                                          .cover,
                                      errorBuilder:
                                          (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          height:
                                              220,
                                          color: Colors
                                              .grey
                                              .shade300,
                                          child:
                                              const Center(
                                            child:
                                                Icon(
                                              Icons
                                                  .image_not_supported,
                                              size:
                                                  70,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      height:
                                          220,
                                      color: Colors
                                          .grey
                                          .shade300,
                                      child:
                                          const Center(
                                        child:
                                            Icon(
                                          Icons
                                              .image_not_supported,
                                          size:
                                              70,
                                        ),
                                      ),
                                    ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets
                                  .all(
                            16,
                          ),
                          child:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                article.title,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      10),
                              Text(
                                article.description ??
                                    "Tidak ada deskripsi",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton:
          _showButton
              ? FloatingActionButton(
                  backgroundColor:
                      Colors.deepPurple,
                  onPressed:
                      _scrollToTop,
                  child: const Icon(
                    Icons
                        .keyboard_arrow_up,
                    color:
                        Colors.white,
                  ),
                )
              : null,
    );
  }
}

class DetailPage extends StatelessWidget {
  final Article article;

  const DetailPage({
    super.key,
    required this.article,
  });

  Future<void> openUrl() async {
    if (article.url == null) return;

    final Uri uri =
        Uri.parse(article.url!);

    await launchUrl(
      uri,
      mode:
          LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Detail Berita"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            article.urlToImage != null
                ? Image.network(
                    article.urlToImage!,
                  )
                : Container(
                    height: 250,
                    color: Colors.grey,
                  ),

            Padding(
              padding:
                  const EdgeInsets.all(
                      16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    article.title,
                    style:
                        const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  Text(
                    article.description ??
                        "Tidak ada deskripsi.",
                  ),

                  const SizedBox(
                      height: 30),

                  SizedBox(
                    width:
                        double.infinity,
                    child:
                        ElevatedButton
                            .icon(
                      onPressed:
                          openUrl,
                      icon:
                          const Icon(
                        Icons
                            .language,
                      ),
                      label:
                          const Text(
                        "Baca Berita Asli",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}