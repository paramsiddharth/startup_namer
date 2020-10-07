import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';

class RandomWords extends StatefulWidget {
	@override
	_RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
	final List<WordPair> _suggestions = <WordPair>[];
	final TextStyle _biggerFont = const TextStyle(fontSize: 18);
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Text(
							'Startup Name Generator',
							style: TextStyle(fontSize: 21),
						),
						Text(
							'Made with ❤ by Param',
							style: TextStyle(fontSize: 13),
						)
					]
				),
			),
			body: Builder(
					builder: (ctx) => _buildSuggestions(ctx),
				),
		);
	}

	Widget _buildSuggestions(BuildContext ctx) {
		return Scrollbar(
			child: ListView.builder(
				padding: EdgeInsets.all(16),
				itemBuilder: (BuildContext _content, int i) {
					if (i.isOdd)
						return Divider();
					
					final int index = i ~/ 2;
					if (index >= _suggestions.length)
						_suggestions.addAll(generateWordPairs().take(10));
					
					return _buildRow(_suggestions[index], ctx);
				},
			),
		);
	}

	Widget _buildRow(WordPair pair, BuildContext ctx) {
		return ListTile(
			title: SelectableText(
				pair.asPascalCase,
				style: _biggerFont,
				onTap: () {
					final toCopy = pair.asPascalCase;
					Clipboard.setData(new ClipboardData(text: toCopy))
					.then((_) {
						final snack = SnackBar(content: Text('$toCopy copied to clipboard!'));
						Scaffold.of(ctx).hideCurrentSnackBar();
						Scaffold.of(ctx).showSnackBar(snack);
					});
				},
			)
		);
	}
}