import 'dart:convert';
import 'package:http/http.dart' as http;

final chapterDataRegExp = RegExp(r'CurChapter = ({.*});');
final chapterCDNRegExp = RegExp(r'CurPathName = "(.*)"');

class Chapter {
	final String title;
	final String url;
	List<String> pages;

	Chapter({this.title, this.url, this.pages});

	Future<List<String>> loadPages() async {
		final response = await http.get(this.url);

		String cdn = chapterCDNRegExp.firstMatch(response.body).group(1);
		String chapterData = chapterDataRegExp.firstMatch(response.body).group(1);
		final Map<String, dynamic> chapterJson = json.decode(chapterData);

		String slug = this.url.split('/read-online/')[1].split('-chapter-')[0];

		String directory = chapterJson['Directory'];
		String directoryPath = directory == '' ? '' : '/$directory';

		int pageCount = int.parse(chapterJson['Page']);

		String chapterIndex = chapterJson['Chapter'];
		String chapterNumber = chapterIndex.substring(1, chapterIndex.length - 1);
		String chapterOdd = chapterIndex.substring(chapterIndex.length - 1);
		String chapterSlug = chapterOdd == '0' ? chapterNumber : '$chapterNumber.$chapterOdd';

		List<String> pages = [
			for (int i = 1; i <= pageCount; i++) 'https://$cdn/manga/$slug$directoryPath/$chapterSlug-${i.toString().padLeft(3, "0")}.png'
		];

		this.pages = pages;

		return pages;
	}

	factory Chapter.fromRSS(rssItem) {
		return Chapter(
			title: rssItem.title,
			url: rssItem.link
		);
	}
}