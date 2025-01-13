import 'package:flutter/material.dart';

/// Enum defining different types of text patterns that can be parsed
/// - email: For email addresses
/// - phone: For phone numbers
/// - url: For web URLs
/// - custom: For custom patterns
/// - copyable: For text that can be copied
/// - shareable: For text that can be shared
enum ParsedType { email, phone, url, custom, copyable, shareable }

/// Enum defining supported social media platforms
/// Includes common platforms like Twitter, Facebook, Instagram, LinkedIn
/// and a generic 'other' option for custom platforms
enum SocialPlatform { twitter, facebook, instagram, linkedin, other }

/// Configuration class for text interaction features
/// Handles various interaction options like copying, sharing, and social media integration
class TextInteractions {
  /// Whether to enable copy functionality
  final bool enableCopy;

  /// Whether to enable share functionality
  final bool enableShare;

  /// Whether to enable social profile interaction
  final bool enableSocialProfile;

  /// Selected social media platform
  final SocialPlatform? platform;

  /// Username for social media profile
  final String? username;

  /// Custom widget for copy icon
  final Widget? copyIcon;

  /// Custom widget for share icon
  final Widget? shareIcon;

  /// Custom widget for social media icon
  final Widget? socialIcon;

  /// Whether to show the social media icon
  final bool showsocialIcon;

  /// Whether to show social icon at the start of text
  final bool showsocialIconATStart;

  /// Creates a TextInteractions instance with customizable properties
  ///
  /// All boolean parameters default to false except [showsocialIcon] which defaults to true
  const TextInteractions({
    this.enableCopy = false,
    this.enableShare = false,
    this.enableSocialProfile = false,
    this.platform,
    this.username,
    this.copyIcon,
    this.shareIcon,
    this.socialIcon,
    this.showsocialIcon = true,
    this.showsocialIconATStart = false,
  });
}

/// Class for handling pattern matching and text styling in SmartActionsText widget
///
/// Provides structure for pattern matching, styling, and interaction handling
class MatchText {
  /// The type of pattern to match (email, phone, url, etc.)
  final ParsedType type;

  /// Custom regex pattern string for matching
  /// Required if [type] is ParsedType.custom
  final String? pattern;

  /// Custom TextStyle to apply to matched text
  final TextStyle? style;

  /// Callback function triggered when matched text is tapped
  final Function(String)? onTap;

  /// Configuration for text interactions (copy, share, social)
  final TextInteractions? interactions;

  /// Function to customize how matched text is rendered
  ///
  /// Parameters:
  /// - str: The matched text string
  /// - pattern: The pattern used for matching
  ///
  /// Returns a Map with 'display' and 'value' strings
  final Map<String, String> Function({
    required String str,
    required String pattern,
  })? renderText;

  /// Function to render a custom widget for matched text
  ///
  /// Parameters:
  /// - text: The matched text string
  /// - pattern: The pattern used for matching
  ///
  /// Returns a Widget to be displayed
  final Widget Function({
    required String text,
    required String pattern,
  })? renderWidget;

  /// Creates a MatchText instance
  ///
  /// [type] defaults to ParsedType.custom
  /// [pattern] is required if using custom type
  MatchText({
    this.type = ParsedType.custom,
    this.pattern,
    this.style,
    this.onTap,
    this.renderText,
    this.renderWidget,
    this.interactions,
  });
}
