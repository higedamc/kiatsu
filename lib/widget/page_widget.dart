import 'package:flutter/material.dart';

Widget buildPage({
    required Color color,
    required Color textColor,
    required String urlImage,
    required String title,
    required String subtitle,
  }) =>
      Container(
        color: const Color.fromRGBO(248, 248, 248, 0.01),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Flexible(
            flex: 10,
            child: Image.asset(
              urlImage,
              fit: BoxFit.cover,
              width: double.infinity,
              // height: double.infinity,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 52),
              child: SizedBox(
                height: 40,
                child: Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      );