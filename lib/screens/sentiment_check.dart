import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SentimentScreen extends StatefulWidget {
  const SentimentScreen({Key? key}) : super(key: key);

  @override
  _SentimentScreenState createState() => _SentimentScreenState();
}

class _SentimentScreenState extends State<SentimentScreen> {
  // Define a TextEditingController to get the input text from the user
  final _textController = TextEditingController();
  // Define a variable to hold the sentiment score
  double _sentimentScore = 0.0;
  // Define a variable to hold the sentiment label
  String _sentimentLabel = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 28, 28),
      appBar: AppBar(
        title: const Text('Sentiment Analyzer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter some text to analyze:',
              style: TextStyle(fontSize: 20.0, color: Colors.white70),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 90, 255, 95),
                      width: 2, // set focused border color to green
                    ),
                  ),
                  hintText: 'Enter Text',
                  filled: true,
                  fillColor: Color.fromARGB(
                      255, 121, 121, 121), // set background color to white
                ),
                maxLines: null,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Call the sentiment analysis API with the input text
                final response = await Dio().post(
                  "https://api-inference.huggingface.co/models/j-hartmann/emotion-english-distilroberta-base",
                  data: {'inputs': _textController.text},
                  options: Options(
                    headers: {
                      'Authorization':
                          'Bearer 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',
                      'Content-Type': 'application/json',
                    },
                  ),
                );

                // Get the sentiment score and label from the response
                final sentimentList = response.data[0];

                log('Sentiment list: $response');

                var outScore = sentimentList[0]['score'];
                // var posScore = sentimentList[1]['score'];

                var sentimentScore = outScore; //-(posScore - negScore);

                final sentimentLabel = sentimentList[0]['label'];
                // sentimentScore < 1 ? 'POSITIVE' : 'NEGATIVE';

                // Update the UI with the sentiment score and label
                setState(() {
                  _sentimentScore = sentimentScore;
                  _sentimentLabel = sentimentLabel;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromARGB(
                          255, 200, 233, 202); // color when pressed
                    } else if (states.contains(MaterialState.hovered)) {
                      return const Color.fromARGB(
                          255, 69, 180, 197); // color when hovered
                    } else {
                      return const Color.fromARGB(
                          255, 76, 153, 175); // default color
                    }
                  },
                ),
                // You can customize other properties of the button style here
                // such as elevation, shape, padding, textStyle, etc.
              ),
              child: const Text('Analyze'),
            ),
            const SizedBox(height: 16.0),
            if (_sentimentLabel.isNotEmpty)
              Text(
                'Sentiment label: $_sentimentLabel',
                style: const TextStyle(
                    fontSize: 20.0, color: Color.fromARGB(255, 182, 214, 237)),
              ),
            if (_sentimentScore != 0.0)
              Text(
                'Sentiment score: ${_sentimentScore.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 20.0, color: Color.fromARGB(255, 235, 203, 203)),
              ),
          ],
        ),
      ),
    );
  }
}
