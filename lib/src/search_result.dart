class SearchResult {
	final String title;
	final String slug;
	final List alts;
	final String cover;

	SearchResult({this.title, this.slug, this.alts, this.cover});

	factory SearchResult.fromJson(Map<String, dynamic> json) {
		return SearchResult(
			title: json['s'], // s = 'Series'
			slug:  json['i'], // i = 'Index'
			alts:  json['a'], // a = 'Alt names'
			cover: 'https://cover.mangabeast01.com/cover/${json['i']}.jpg'
		);
	}
}