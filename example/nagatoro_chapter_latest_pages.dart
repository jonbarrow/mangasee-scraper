import 'package:mangasee_scraper/mangasee.dart' as mangasee;

void main() async {
	final List<mangasee.SearchResult> search = await mangasee.search('Nagatoro-san');
	final mangasee.Manga details = await mangasee.details(search[0].slug);
	final mangasee.Chapter chapter = details.chapters[0];
	await chapter.loadPages();

	print(chapter.pages);
}
