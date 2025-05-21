// screens/grades_screen.dart
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(  // Added SingleChildScrollView to prevent overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Learning Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.school, color: Colors.grey),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Grade 3',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '2024-2025',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'CBC Learning Achievement',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSubjectRow('Mathematics', 'Exceeding Expectations'),
                _buildDivider(),
                _buildSubjectRow('Literacy Activities', 'Meeting Expectations'),
                _buildDivider(),
                _buildSubjectRow('Environmental Activities', 'Approaching Expectations'),
                _buildDivider(),
                _buildSubjectRow('Creative Activities', 'Exceeding Expectations'),
                _buildDivider(),
                _buildSubjectRow('Hygiene & Nutrition', 'Meeting Expectations'),
                const SizedBox(height: 16),
                const Text(
                  'Rubric Levels Guide',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildRubricGuide('Exceeding Expectations', 'Demonstrates exceptional competence', Colors.green),
                const SizedBox(height: 4),
                _buildRubricGuide('Meeting Expectations', 'Demonstrates adequate competence', Colors.blue),
                const SizedBox(height: 4),
                _buildRubricGuide('Approaching Expectations', 'Demonstrates developing competence', Colors.orange),
                const SizedBox(height: 4),
                _buildRubricGuide('Below Expectations', 'Requires additional support', Colors.red),
                const SizedBox(height: 16), // Added padding at bottom
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 1),
    );
  }

  Widget _buildSubjectRow(String subject, String level) {
    Color levelColor;
    switch (level) {
      case 'Exceeding Expectations':
        levelColor = Colors.green;
        break;
      case 'Meeting Expectations':
        levelColor = Colors.blue;
        break;
      case 'Approaching Expectations':
        levelColor = Colors.orange;
        break;
      case 'Below Expectations':
        levelColor = Colors.red;
        break;
      default:
        levelColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(  // Added Expanded to prevent text overflow
            child: Text(
              subject,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: levelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  level,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: levelColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      height: 1,
    );
  }
  
  Widget _buildRubricGuide(String level, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,  // Aligned to start for better wrap behavior
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(  // Added Expanded to ensure wrapping of long text
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: level,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: ' - $description',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}