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
enum Width {
  /// 0px — 380px (mobiles, vertical)
  narrow,

  /// 381px — 1100px (mobiles/tablets, horizontal)
  small,

  /// 1201px — ∞px (desktops, landscape)
  wide
}

/// Identifies the Width class of a display
Width getWidthClass(BuildContext context) {
  var width = MediaQuery.of(context).size.width;

  if (width < 380) {
    return Width.narrow;
  } else if (width < 1200) {
    return Width.small;
  } else {
    return Width.wide;
  }
}

// ===================
// ===== Padding =====
// ===================

/// Edge insets for Margins and Padding
class InsetSize {
  /// narrow — 3px
  static const narrow = 3;

  /// medium — 5px
  static const medium = 5;

  /// wide — 7px
  static const wide = 7;
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
