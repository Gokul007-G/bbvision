import 'package:flutter/material.dart';

class AppColors {
  // Core Brand Colors
  static const Color primary = Color(0xFFff8b3d); // Orange (Main Brand)
  static const Color secondary = Color(0xFFFFC107); // Amber (Accent)

  // Background Colors
  static const Color scaffoldBg = Color(0xFFFDF7F2); // Light warm background
  static const Color cardBg = Color(0xFFFFFFFF); // White cards

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Dark text
  static const Color textSecondary = Color(0xFF757575); // Grey text
  static const Color hintText = Color(0xFF9E9E9E); // Hint / placeholder

  // UI States
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFF44336); // Red
  static const Color warning = Color(0xFFFF5722); // Deep Orange
  static const Color blue = Colors.blue; // Deep Orange

  // Borders & Dividers
  static const Color border = Color(0xFFE0E0E0); // Light grey border
  static const Color divider = Color(0xFFEEEEEE);

  // Charts / Analytics (for Pie Chart, etc.)
  static const Color chartCompleted = Color(0xFF4CAF50); // Green
  static const Color chartPending = Color(0xFFFF9800); // Orange
  static const Color chartOverdue = Color(0xFFF44336); // Red

  // Buttons
  static const Color buttonPrimary = primary;
  static const Color buttonDisabled = Color(0xFFBDBDBD);

  // Drawer / AppBar
  static const Color appBar = primary;
  static const Color drawerBg = Color(0xFFFFF3E0); // Light orange shade
}
