/// {@category frontend}
///
/// Style guide for the app's UI. Just constants grouped under different Classes
/// and Enums.
///
/// Things defined here:
/// - [ColorPalette] — Color Scheme of the app
/// - [WidthClass] — Screen Widths
/// - [InsetSizes] — [EdgeInsets]'s for Padding & Margins
/// - [FontStyles] — [TextStyle]'s for different text

// Flutter imports:
import 'package:flutter/material.dart';

// =========================
// ===== Color Palette =====
// =========================

/// Color palette for the app
class ColorPalette {
  /// black — background
  static const richBlack = Color(0xFF030208);

  /// grey — text
  static const lavenderGray = Color(0xFFC7C9D1);

  /// pink — negative notice accent
  static const pastelPink = Color(0xFFE6A699);

  /// blue — neutral notice accent
  static const maximumBlue = Color(0xFF58BCD5);

  /// green — good notice accent
  static const nyanzaGreen = Color(0xFFDCF6DA);
}

// =========================
// ===== Screen Widths =====
// =========================

/// Screen widths for adaptive layouts
enum WidthClass {
  /// 0px — 380px (mobiles, vertical)
  narrow,

  /// 381px — 1200px (mobiles/tablets, horizontal)
  small,

  /// 1201px — ∞px (desktops, landscape)
  wide
}

/// Identifies the Width class of a display
WidthClass getWidthClass(BuildContext context) {
  var width = MediaQuery.of(context).size.width;

  if (width < 380) {
    return WidthClass.narrow;
  } else if (width < 1200) {
    return WidthClass.small;
  } else {
    return WidthClass.wide;
  }
}

// ===================
// ===== Padding =====
// ===================

/// Edge insets for Margins and Padding
class InsetSizes {
  /// narrow — 3px
  static const narrow = EdgeInsets.all(3);

  /// medium — 5px
  static const medium = EdgeInsets.all(5);

  /// wide — 7px
  static const wide = EdgeInsets.all(7);
}

// ========================
// ===== Text Styling =====
// ========================

/// Text Styling
class FontStyles {
  /// tiny text that your really don't want people reading
  static const small = TextStyle(fontSize: 17, fontWeight: FontWeight.normal);

  /// normal text that's easily legible
  static const normal = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);

  /// sub-sub heading
  static const heading3 = TextStyle(fontSize: 25, fontWeight: FontWeight.w700);

  /// sub heading
  static const heading2 = TextStyle(fontSize: 27, fontWeight: FontWeight.w800);

  /// headings
  static const heading1 = TextStyle(fontSize: 35, fontWeight: FontWeight.w900);
}
