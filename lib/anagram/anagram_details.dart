import 'package:anagrammatic/anagram/anagram.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

double _padding = 16.0;

typedef ExpansionItemBodyBuilder = Widget Function(ExpansionItem item);

class AnagramDetails extends StatefulWidget {
  final Anagram anagram;
  final String characters;

  AnagramDetails({
    @required this.anagram,
    @required this.characters,
  });

  @override
  _AnagramDetailsState createState() => _AnagramDetailsState();
}

class _AnagramDetailsState extends State<AnagramDetails> {
  List<ExpansionItem> _expansionItems = List<ExpansionItem>();

  @override
  void initState() {
    super.initState();
    _expansionItems.addAll(
      [
        ExpansionItem(
          isExpanded: false,
          header: 'Unused characters',
          body: _buildTable(_countUnusedCharacters()),
        ),
        ExpansionItem(
          isExpanded: false,
          header: 'Used characters',
          body: _buildTable(_countUsedCharacters()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(
          _padding,
        ),
        child: Column(
          children: <Widget>[
            _anagramTitle(),
            _anagramDetails(),
            _actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _anagramTitle() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: _padding,
      ),
      child: Text(
        widget.anagram.word,
        style: Theme.of(context).textTheme.display1,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _anagramDetails() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          _InfoRow(
            label: 'Length',
            value: widget.anagram.word.length.toString(),
          ),
          ExpansionPanelList(
            expansionCallback: (
              int index,
              bool isExpanded,
            ) {
              setState(() {
                _expansionItems[index].isExpanded =
                    !_expansionItems[index].isExpanded;
              });
            },
            children: _expansionItems.map(_createExpansionPanel).toList(),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        OutlineButton(
          child: Text(
            'BACK',
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        RaisedButton(
          child: Text('DEFINE'),
          onPressed: () {
            _launchURL(widget.anagram.word);
          },
        ),
      ],
    );
  }

  void _launchURL(String word) async {
    String url = 'https://www.google.com/search?q=define+' + word;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ExpansionPanel _createExpansionPanel(ExpansionItem item) {
    return ExpansionPanel(
      body: item.body,
      headerBuilder: (
        BuildContext context,
        bool isExpanded,
      ) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 24.0,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.header,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      isExpanded: item.isExpanded,
    );
  }

  String _findUnusedCharacters() {
    String unusedLetters = widget.characters;

    for (int i = 0; i < widget.anagram.word.length; i++) {
      unusedLetters = unusedLetters.replaceFirst(widget.anagram.word[i], '');
    }

    return unusedLetters;
  }

  Map<String, int> _countCharacters(String string) {
    List<String> characterArray = string.split('')..sort();

    Map<String, int> characterCounts = Map<String, int>();
    for (int j = 0; j < characterArray.length; j++) {
      String character = characterArray[j];
      if (characterCounts.containsKey(character)) {
        characterCounts[character]++;
      } else {
        characterCounts[character] = 1;
      }
    }

    return characterCounts;
  }

  Map<String, int> _countUnusedCharacters() {
    return _countCharacters(_findUnusedCharacters());
  }

  Map<String, int> _countUsedCharacters() {
    return _countCharacters(widget.anagram.word);
  }

  DataTable _buildTable(Map<String, int> characterCounts) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: const Text(
            'Character',
          ),
        ),
        DataColumn(
          label: const Text(
            'Occurrences',
          ),
        ),
      ],
      rows: _buildRows(characterCounts),
    );
  }

  List<DataRow> _buildRows(Map<String, int> characterCounts) {
    List<DataRow> rows = List<DataRow>();

    if (characterCounts.length == 0) {
      rows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text(
                '-',
              ),
            ),
            DataCell(
              Text(
                '-',
              ),
            ),
          ],
        ),
      );
    } else {
      characterCounts.forEach((String character, int count) {
        rows.add(
          DataRow(
            cells: <DataCell>[
              DataCell(
                Text(
                  character,
                ),
              ),
              DataCell(
                Text(
                  '$count',
                ),
              ),
            ],
          ),
        );
      });
    }

    return rows;
  }
}

class ExpansionItem {
  bool isExpanded;
  final String header;
  final Widget body;

  ExpansionItem({
    this.isExpanded,
    this.header,
    this.body,
  });
}

class _InfoText extends StatelessWidget {
  final String text;

  _InfoText({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.title,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  _InfoRow({
    @required this.label,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: _padding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _InfoText(
            text: label,
          ),
          _InfoText(
            text: value,
          ),
        ],
      ),
    );
  }
}
