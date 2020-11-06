import 'package:flutter/material.dart';
import 'quote.dart';

class QuoteCard extends StatelessWidget {

  final Quotes quote;
  final Function delete;
  final Function tick;
  QuoteCard ({this.quote, this.delete, this.tick});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(quote.text,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 18,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5,),
            Text(
              "${quote.author}",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                  onPressed: delete,
                  label: Text('Delete Me!'),
                  icon: Icon(Icons.delete),
                    ),
                FlatButton.icon(
                  color: quote.done?  Colors.green : Colors.red,
                  onPressed: tick,
                  label: quote.done? Text('Done') : Text("Not Done"),
                  icon: Icon(Icons.check,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}