# Mangasee Scraper

Search for and scrape manga details and chapters from Mangasee

## Example

```dart
import 'package:mangasee_scraper/mangasee.dart' as mangasee;

void main() async {
	// Search for manga
	final List<mangasee.SearchResult> search = await mangasee.search('Nagatoro-san');

	// Get manga details
	final mangasee.Manga details = await mangasee.details(search[0].slug);

	// Take the latest chapter and grab it's pages
	final mangasee.Chapter chapter = details.chapters[0];
	await chapter.loadPages();

	print(chapter.pages); // List of page image URLs
}
```