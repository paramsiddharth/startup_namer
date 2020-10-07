import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RandomWords extends StatefulWidget {
	@override
	_RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
	static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
	final List<WordPair> _suggestions = <WordPair>[];
	final TextStyle _biggerFont = const TextStyle(fontSize: 18);
	final Set<WordPair> _saved = Set<WordPair>();
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: PreferredSize(
				preferredSize: Size.fromHeight(62),
				child: AppBar(
					title: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							Text(
								'Startup Name Generator',
								style: TextStyle(fontSize: 23),
							),
							RichText(
								text: TextSpan(
									style: TextStyle(fontSize: 13),
									children: [
										TextSpan(
											text: 'Made with ',
										),
										WidgetSpan(
											child: Icon(
												Icons.favorite,
												color: Colors.red[700],
												size: 16,
											),
										),
										TextSpan(
											text: ' by ',
										),
										TextSpan(
											text: 'Param',
											recognizer: TapGestureRecognizer()
											..onTap = () {
												final webs = 'http://www.paramsid.com';
												launch(webs);
											},
											style: TextStyle(
												decoration: TextDecoration.underline,
												color: Colors.blue[200]
											)
										),
									]
								),
							)
						]
					),
					backgroundColor: Colors.green[600],
					actions: [
						IconButton(
							icon: Icon(Icons.list),
							onPressed: _pushSaved,
						),
					],
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
		final alreadySaved = _saved.contains(pair);

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
			),
			trailing: IconButton(
				icon: Icon(
					alreadySaved ? Icons.favorite : Icons.favorite_border,
					color: alreadySaved ? Colors.red : null,
				),
				onPressed: () {
					setState(() {
						if (alreadySaved)
							_saved.remove(pair);
						else
							_saved.add(pair);
					});
				},
			)
		);
	}

	void _pushSaved() {
		Navigator.of(context).push(MaterialPageRoute<void>(
				builder: (BuildContext context) {
						final tiles = _saved.map(
							(WordPair pair) => ListTile(
								title: SelectableText(
									pair.asPascalCase,
									style: _biggerFont,
									onTap: () {
										final toCopy = pair.asPascalCase;
										Clipboard.setData(new ClipboardData(text: toCopy))
										.then((_) {
											final snack = SnackBar(content: Text('$toCopy copied to clipboard!'));
											_scaffoldKey.currentState.hideCurrentSnackBar();
											_scaffoldKey.currentState.showSnackBar(snack);
										});
									},
								),
								/* trailing: IconButton(
									icon: Icon(Icons.delete_forever_outlined),
									onPressed: () {
										setState(() {
											_saved.remove(pair);
											// Navigator.of(context).pop();
											// _pushSaved();
										});
										// _rePushSaved();
									},
								), */
							)
						);

						final divided = ListTile.divideTiles(
							tiles: tiles,
							context: context
						).toList();

						return Scaffold(
							key: _scaffoldKey,
							appBar: AppBar(
								title: Text('Saved Suggestions')
							),
							body: ListView(children: divided),
						);
				}
			)
		);
	}
}

/* class SavedSuggestions extends StatefulWidget {
	@override
	_SavedSuggestionsState createState() => _SavedSuggestionsState();
}

class _SavedSuggestionsState extends State<SavedSuggestions> {
	@override
	Widget build(BuildContext context) {
		final tiles = _saved.map(
			(WordPair pair) => ListTile(
				title: SelectableText(
					pair.asPascalCase,
					style: _biggerFont,
					onTap: () {
						final toCopy = pair.asPascalCase;
						Clipboard.setData(new ClipboardData(text: toCopy))
						.then((_) {
							final snack = SnackBar(content: Text('$toCopy copied to clipboard!'));
							_scaffoldKey.currentState.hideCurrentSnackBar();
							_scaffoldKey.currentState.showSnackBar(snack);
						});
					},
				),
				trailing: IconButton(
					icon: Icon(Icons.delete_forever_outlined),
					onPressed: () {
						setState(() {
							_saved.remove(pair);
						});
					},
				),
			)
		);

		final divided = ListTile.divideTiles(
			tiles: tiles,
			context: context
		).toList();

		return Scaffold(
			key: _scaffoldKey,
			appBar: AppBar(
				title: Text('Saved Suggestions')
			),
			body: ListView(children: divided),
		);
	}
} */