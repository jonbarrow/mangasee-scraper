import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mangasee_scraper/src/search_result.dart';
import 'package:mangasee_scraper/src/manga.dart';

final String apiBase = 'https://mangasee123.com';
final String apiSearch = '$apiBase/_search.php';
final String apiDetails = '$apiBase/manga';

Future<List<SearchResult>> search(String query) async {
	final response = await http.get(apiSearch);
	if (response.statusCode == 200) {
		final List<dynamic> data = json.decode(response.body);
		final List<SearchResult> results = data.map((i) => SearchResult.fromJson(i)).toList();
		final List<SearchResult> filtered = results
			.where((i) => i.title.contains(query)).toList();
		
		return filtered;
	} else {
		throw Exception('Failed to load manga search data');
	}
}

Future<Manga> details(String slug) async {
	final response = await http.get('$apiDetails/$slug');
	if (response.statusCode == 200) {
		return Manga.fromHTML(response.body);
	} else {
		throw Exception('Failed to load manga data');
	}
}