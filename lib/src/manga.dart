import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:mangasee_scraper/src/chapter.dart';

final descriptionRegExp = RegExp(r'<div class="top-5 Content">(.*?)<\/div>');
final authorsRegExp = RegExp(r"<a href='\/search\/\?author=[\w\s]*'>([\w\s]*)<\/a>");
final genresRegExp = RegExp(r"<a href='\/search\/\?genre=[\w\s]*'>([\w\s]*)<\/a>");
final releasedRegExp = RegExp(r'<a href="\/search\/\?year=\d*">(\d*)<\/a>');
final rssUrlRegExp = RegExp(r'title="RSS Feed" href="(.*?)"');

class Manga {
	String cover;
	String title;
	String description;
	List<String> authors;
	List<String> genres;
	String released;
	List<Chapter> chapters;


	Manga({this.cover, this.title, this.description, this.authors, this.genres, this.released, this.chapters});

	factory Manga._fromHTML(String body) {
		String description = descriptionRegExp.firstMatch(body).group(1);
		List<String> authors = authorsRegExp.allMatches(body).map((i) => i.group(1)).toList();
		List<String> genres = genresRegExp.allMatches(body).map((i) => i.group(1)).toList();
		String released = releasedRegExp.firstMatch(body).group(1);

		return Manga(
			description: description,
			authors: authors,
			genres: genres,
			released: released,
		);
	}

	static Future<Manga> fromHTML(String body) async {
		Manga manga = Manga._fromHTML(body);

		String rssUrl = rssUrlRegExp.firstMatch(body).group(1);
		final response = await http.get(rssUrl);
		var rss = new RssFeed.parse(response.body);

		String cover = rss.image.url;
		String title = rss.title;
		List<Chapter> chapters = rss.items.map((i) => Chapter.fromRSS(i)).toList();

		manga.cover = cover;
		manga.title = title;
		manga.chapters = chapters;

		return manga;
	}
}