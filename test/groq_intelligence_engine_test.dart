import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nenai/ai/groq/groq_intelligence_engine.dart';

void main() {
  group('GroqIntelligenceEngine Tests', () {
    test('1. analyze parses structured JSON from Groq API response', () async {
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {
              'content': jsonEncode({
                'summary': 'Dean meeting about ReadSmart AI and FC deployment.',
                'keywords': ['Dean', 'ReadSmart AI', 'FC', 'deployment'],
                'topic': 'ReadSmart AI',
                'topics': ['ReadSmart AI', 'FC'],
                'entities': [
                  {'name': 'Dean', 'type': 'person'},
                  {'name': 'ReadSmart AI', 'type': 'project'},
                  {'name': 'FC', 'type': 'project'},
                ],
                'tasks': [
                  {'description': 'Follow up on deployment', 'isCompleted': false, 'dueDate': 'tomorrow'},
                ],
                'facts': [
                  {'subject': 'Dean', 'predicate': 'discussed', 'object': 'ReadSmart AI'},
                ],
                'actions': [
                  {'action': 'discussed', 'subject': 'deployment'},
                ],
                'references': [
                  {'referenceText': 'the deployment', 'referenceType': 'definiteNounPhrase'},
                ],
                'events': ['Dean Meeting'],
                'project': 'ReadSmart AI',
              }),
            }
          }
        ]
      });

      final client = MockClient((request) async {
        expect(request.url.toString(), 'https://api.groq.com/openai/v1/chat/completions');
        expect(request.headers['Authorization'], contains('gsk_'));
        return http.Response(mockResponse, 200);
      });

      final engine = GroqIntelligenceEngine(httpClient: client);
      final analysis = await engine.analyze('I discussed ReadSmart AI deployment with Dean.');

      expect(analysis, isNotNull);
      expect(analysis!.summary, contains('Dean meeting'));
      expect(analysis.keywords.contains('deployment'), isTrue);
      expect(analysis.entities.any((e) => e.name == 'Dean' && e.type == 'person'), isTrue);
      expect(analysis.tasks.length, 1);
      expect(analysis.tasks.first.description, 'Follow up on deployment');
      expect(analysis.facts.first.subject, 'Dean');
    });

    test('2. chat returns grounded completion from Groq API', () async {
      final mockResponse = jsonEncode({
        'choices': [
          {
            'message': {
              'content': 'Based on your notes, you discussed the ReadSmart AI deployment with Dean.',
            }
          }
        ]
      });

      final client = MockClient((request) async {
        return http.Response(mockResponse, 200);
      });

      final engine = GroqIntelligenceEngine(httpClient: client);
      final reply = await engine.chat(
        'What was discussed with Dean?',
        contextMemories: ['Dean discussed ReadSmart AI deployment.'],
      );

      expect(reply, contains('ReadSmart AI deployment'));
    });

    test('3. analyze gracefully falls back to offline stub when API fails', () async {
      final client = MockClient((request) async {
        return http.Response('Rate limit exceeded', 429);
      });

      final engine = GroqIntelligenceEngine(httpClient: client);
      final analysis = await engine.analyze('Meeting with Dean about ReadSmart AI deployment.');

      // Should not throw, should fall back to offline extractive analysis
      expect(analysis, isNotNull);
      expect(analysis!.summary.isNotEmpty, isTrue);
    });
  });
}
