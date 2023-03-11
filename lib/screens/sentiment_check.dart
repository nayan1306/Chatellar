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
      backgroundColor: const Color.fromARGB(255, 196, 175, 219),
      appBar: AppBar(
        title: const Text('Sentiment Analyzer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter some text to analyze:',
              style: TextStyle(fontSize: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter text',
                ),
                maxLines: null,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Call the sentiment analysis API with the input text
                final response = await Dio().post(
                  'https://api-inference.huggingface.co/models/finiteautomata/bertweet-base-sentiment-analysis',
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

                final negScore = sentimentList[0]['score'];
                final neuScore = sentimentList[1]['score'];
                final posScore = sentimentList[2]['score'];
                // final posScore = sentimentList[2]['score'];

                var sentimentScore = -(posScore - negScore);

                final sentimentLabel =
                    sentimentScore < 1 ? 'POSITIVE' : 'NEGATIVE';

                // Update the UI with the sentiment score and label
                setState(() {
                  _sentimentScore = sentimentScore;
                  _sentimentLabel = sentimentLabel;
                });
              },
              child: const Text('Analyze'),
            ),
            const SizedBox(height: 16.0),
            if (_sentimentScore != 0.0)
              Text(
                'Sentiment score: ${_sentimentScore.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20.0),
              ),
            if (_sentimentLabel.isNotEmpty)
              Text(
                'Sentiment label: $_sentimentLabel',
                style: const TextStyle(fontSize: 20.0),
              ),
          ],
        ),
      ),
    );
  }
}
