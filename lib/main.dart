import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(          // Add the 3 lines from here...
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}


/*
Notice the declaration State<RandomWords>. This indicates that we’re using the generic
State class specialized for use with RandomWords.
Most of the app’s logic and state resides here — it maintains the state for the RandomWords widget.
This class saves the generated word pairs, which grows infinitely as the user scrolls,
and favorite word pairs (in part 2), as the user adds or removes them from the list by toggling the heart icon.
 */
class RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();   // Add this line.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.contacts), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/
          //else print("ITEMS : ${i/2}");
          final index = i ~/ 2; /*3*/       //  '~/'  is Truncating division operator
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          //print("COLLECTION LENGTH: ${_suggestions.length}");
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {         //!!!  Notify the framework that the internal state of this object has changed.
          if (alreadySaved)
            _saved.remove(pair);
          else
            _saved.add(pair);
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
        new MaterialPageRoute<void>(   // Add 20 lines from here...
          //The builder property returns a Scaffold, containing the app bar for the new route, named "Saved Suggestions."
          // The body of the new route consists of a ListView containing the ListTiles rows;
          // each row is separated by a divider.
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
                return new ListTile(
                  title: new Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );
            final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
            ).toList();

            return new Scaffold(
              appBar: new AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: new ListView(children: divided),
            );
          },
        ),
    );
  }
}

// In Flutter's reactive style framework, calling setState()
// triggers a call to the build() method for the State object, resulting in an update to the UI.



class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}