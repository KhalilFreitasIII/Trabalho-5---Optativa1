import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frase do Dia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DailyPhrasePage(),
    );
  }
}

class DailyPhrasePage extends StatefulWidget {
  @override
  _DailyPhrasePageState createState() => _DailyPhrasePageState();
}

class _DailyPhrasePageState extends State<DailyPhrasePage> {
  String _phrase = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadPhrase();
  }

  Future<void> _loadPhrase() async {
    try {
      // Carregar o JSON do arquivo assets
      final String response = await rootBundle.loadString('assets/frases.json');
      final List<dynamic> data = json.decode(response);
      // Verifique o conteúdo do JSON

      // Obter o dia do mês atual
      final today = DateTime.now();
      final dayOfMonth = today.day;

      // Encontrar a frase correspondente ao dia do mês atual
      final phraseData = data.firstWhere(
            (element) => element['day'] == dayOfMonth,
        orElse: () => {'phrase': 'Frase não encontrada'},
      );

      setState(() {
        _phrase = phraseData['phrase'];
      });
    } catch (e) {
      print('Erro ao carregar JSON: $e');
      setState(() {
        _phrase = 'Erro ao carregar a frase';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frase do Dia'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _phrase,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
