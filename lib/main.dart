import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(
  home: QuoteList(),
));

class QuoteList extends StatefulWidget {
  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {

  File jsonFile;
  Directory dir;
  String fileName = "myJSONFile.json";
  bool fileExist = false;
  Map<String, dynamic> fileContent;
  final List<Quotes> quotes = [
    Quotes(author: "Info",text: "Placeholder",done: false),
  ];
  final textInput = TextEditingController();
  final authorInput = TextEditingController();
  bool authorValid = false;
  bool textValid = false;

  void validate ()
  {
    setState(() {
      textInput.text.isEmpty ? textValid = true : textValid = false;
      authorInput.text.isEmpty ? authorValid = true : authorValid = false;
    });
  }

  @override
  void initState()
  {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExist = jsonFile.existsSync();
      if (fileExist)
        {
          this.setState(() {
            fileContent = jsonDecode(jsonFile.readAsStringSync());
          });
        }
    });
  }
  void createFile(Map <String,dynamic> content, Directory dir,String fileName)
  {
    print ("Create file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExist = true;
    file.writeAsStringSync(jsonEncode(content));
  }
  void writeToFile(String key,dynamic value)
  {
    print ("Write");
    print (key);
    print (value.toString());
    Map<String,dynamic> content = {key: value};
    if (fileExist)
      {
        print("File Exist");
        Map<String, dynamic> jsonContent = json.decode(jsonFile.readAsStringSync());
        jsonContent.addAll(content);
        jsonFile.writeAsStringSync(json.encode(jsonContent));
      }
    else
      {
        createFile(content, dir, fileName);
      }
  }
  void addQuote ()
  {
      validate();
      if (textValid == false && authorValid == false)
      {
        setState(() {
          Quotes newQuote = new Quotes(author: authorInput.text, text: textInput.text,done: false);
          quotes.add(newQuote);
          writeToFile(authorInput.text, newQuote);
          print(jsonDecode(jsonFile.readAsStringSync()));
        });
      }
      textInput.clear();
      authorInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        title: Text(
          "To-do Today",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: (14),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: quotes.map((quote) => QuoteCard(
                    quote: quote,
                    delete: () {
                      setState(() {
                        quotes.remove(quote);
                      });
                    },
                    tick: (){
                      setState(() {
                        quote.done = ! quote.done;
                      });
                    }
                )).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: textInput,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent, width: 2.0),),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan, width: 2.0),),
                  hintText: 'Add Reminder',
                  errorText: textValid ? 'Text Can\'t Be Empty' : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: authorInput,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent, width: 2.0),),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan, width: 2.0),),
                hintText: 'Important Information',
                errorText: authorValid ? 'Subject Can\'t Be Empty' : null,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.amber,),
        onPressed: addQuote,
      ),
    );
  }
}


