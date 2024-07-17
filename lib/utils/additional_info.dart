import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  String title = '';
  String value = '';
  IconData icon;
  AdditionalInfo({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          child: Container(
            width: 100,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  
                  Icon(
                    icon,
                    size: 32,
                    color: const Color.fromARGB(255, 12, 40, 63)
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}



