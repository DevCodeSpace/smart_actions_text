import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_actions_text/smart_actions_text.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:share_plus/share_plus.dart' as share_plus;

/// A widget that parses text to create rich, interactive text elements.
///
/// This widget automatically detects and styles different types of text patterns like:
/// - Email addresses
/// - Phone numbers
/// - URLs
/// - Social media handles
///
/// Each pattern can have its own style and interaction behaviors including:
/// - Custom tap actions
/// - Copy to clipboard
/// - Share functionality
/// - Social media profile opening
class SmartActionsText extends StatelessWidget {
  /// The default text style applied to non-matched text.
  /// Can be overridden by individual [MatchText] styles.
  final TextStyle? style;

  /// List of [MatchText] objects that define patterns to match and their behaviors.
  /// Each [MatchText] can specify a pattern, style, and interactions.
  final List<MatchText> parse;

  /// The text string to be parsed and displayed.
  /// This text will be processed according to the patterns in [parse].
  final String text;

  /// Controls how the text is aligned horizontally.
  /// Defaults to [TextAlign.start].
  final TextAlign alignment;

  /// Determines the directionality of the text.
  /// Useful for RTL languages.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  /// If false, text will be rendered in a single line.
  final bool softWrap;

  /// How to handle text that doesn't fit in the available space.
  /// Defaults to [TextOverflow.clip].
  final TextOverflow overflow;

  /// Scale factor for text size.
  /// Value of 1.0 means no scaling.
  final double textScaleFactor;

  /// Maximum number of lines for the text to span.
  /// Text exceeding this will be truncated according to [overflow].
  final int? maxLines;

  /// Strut style for the text.
  /// Controls the height and leading for the text.
  final StrutStyle? strutStyle;

  /// How to measure the width of the text.
  /// Affects layout calculations.
  final TextWidthBasis textWidthBasis;

  /// Whether the text can be selected by the user.
  /// When true, enables text selection functionality.
  final bool selectable;

  /// Callback function triggered when the widget is tapped.
  /// Only called if no specific pattern is matched at tap location.
  final Function? onTap;

  /// Global regex options applied to all pattern matching.
  /// Controls case sensitivity, multiline mode, etc.
  final RegexOptions regexOptions;

  /// Default interaction options applied to all matched patterns.
  /// Can be overridden by individual [MatchText] interactions.
  final TextInteractions? defaultInteractions;

  /// Creates a SmartActionsText widget.
  ///
  /// The [text] parameter is required. All other parameters are optional.
  ///
  /// Example:
  /// ```dart
  /// SmartActionsText(
  ///   text: "Email me at example@email.com",
  ///   parse: [
  ///     MatchText(
  ///       type: ParsedType.email,
  ///       style: TextStyle(color: Colors.blue),
  ///       onTap: (email) => launchEmail(email),
  ///     )
  ///   ],
  /// )
  /// ```
  const SmartActionsText({
    super.key,
    required this.text,
    this.parse = const <MatchText>[],
    this.style,
    this.alignment = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.maxLines,
    this.onTap,
    this.selectable = false,
    this.regexOptions = const RegexOptions(),
    this.defaultInteractions,
  });

  /// Copies the provided text to clipboard and shows a confirmation snackbar.
  void _handleCopy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied: $text')),
    );
  }

  /// Shares the provided text using platform's native share dialog.
  Future<void> _handleShare(String text) async {
    await share_plus.Share.share(text);
  }

  /// Opens a social media profile based on platform and username.
  ///
  /// Attempts to open in native app first, falls back to web browser.
  /// Supports different URL schemes for Android and iOS.
  Future<void> _openSocialProfile(
      String username, SocialPlatform platform) async {
    String url;
    switch (platform) {
      case SocialPlatform.twitter:
        url = Platform.isAndroid || Platform.isIOS
            ? 'twitter://user?screen_name=$username'
            : 'https://twitter.com/$username';
        break;
      case SocialPlatform.facebook:
        url = Platform.isAndroid || Platform.isIOS
            ? 'fb://facewebmodal/f?href=https://facebook.com/$username'
            : 'https://facebook.com/$username';
        break;
      case SocialPlatform.instagram:
        url = 'https://instagram.com/$username';
        break;
      case SocialPlatform.linkedin:
        url = Platform.isAndroid || Platform.isIOS
            ? "https://www.linkedin.com/in/$username?utm_source=share&utm_campaign=share_via&utm_content=profile"
            : 'https://linkedin.com/in/$username';
        break;
      default:
        return;
    }

    try {
      await launcher.launchUrl(Uri.parse(url),
          mode: launcher.LaunchMode.externalApplication);
    } catch (e) {
      e.toString();
    }
  }

  /// Builds the interaction buttons (copy, share, social) for matched text.
  ///
  /// Buttons are only shown if their respective interactions are enabled.
  /// Icon sizes are matched to text size for visual consistency.
  Widget buildInteractionButtons(
      BuildContext context, String text, TextInteractions interactions) {
    // Get text size from style, default to 14 if not specified
    double textSize = style?.fontSize ?? 14.0;
    List<Widget> buttons = [];

    if (interactions.enableCopy) {
      buttons.add(GestureDetector(
        onTap: () {
          _handleCopy(context, text);
        },
        child: interactions.copyIcon ??
            Icon(
              Icons.copy,
              size: textSize,
            ),
      ));
    }

    if (interactions.enableShare) {
      buttons.add(GestureDetector(
        child: interactions.shareIcon ??
            Icon(
              Icons.share,
              size: textSize,
            ),
        onTap: () {
          _handleShare(text);
        },
      ));
    }

    if (interactions.enableSocialProfile &&
        interactions.platform != null &&
        interactions.username != null) {
      buttons.add(GestureDetector(
        onTap: () {
          _openSocialProfile(
            interactions.username!,
            interactions.platform!,
          );
        },
        child: getSocialIcon(interactions.platform!, interactions),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons,
    );
  }

  /// Creates a social media platform icon based on the platform type.
  ///
  /// Uses custom icon if provided in interactions, otherwise uses default platform icons.
  /// Icon size is slightly larger than text size for better visibility.
  Widget getSocialIcon(SocialPlatform platform, TextInteractions interactions) {
    double textSize = (style?.fontSize ?? 14.0) + 5;
    // First check if custom icon is provided
    if (interactions.socialIcon != null) {
      return interactions.socialIcon!;
    }
    switch (platform) {
      case SocialPlatform.facebook:
        return Icon(
          Icons.facebook,
          size: textSize,
        );
      case SocialPlatform.twitter:
        return Icon(
          Icons.flutter_dash,
          size: textSize,
        );
      case SocialPlatform.instagram:
        return Icon(
          Icons.photo_camera,
          size: textSize,
        );
      case SocialPlatform.linkedin:
        return Icon(
          Icons.work,
          size: textSize,
        );
      default:
        return Icon(
          Icons.link,
          size: textSize,
        );
    }
  }

  /// Main build method that processes text and creates interactive elements.
  ///
  /// The process includes:
  /// 1. Pattern matching using regex
  /// 2. Applying styles and interactions to matched text
  /// 3. Creating appropriate text spans and widget spans
  /// 4. Assembling final rich text widget
  @override
  Widget build(BuildContext context) {
    String newString = text;
    Map<String, MatchText> mapping0 = <String, MatchText>{};

    for (var e in parse) {
      if (e.type == ParsedType.email) {
        mapping0[emailPattern] = e;
      } else if (e.type == ParsedType.phone) {
        mapping0[phonePattern] = e;
      } else if (e.type == ParsedType.url) {
        mapping0[urlPattern] = e;
      } else {
        mapping0[e.pattern!] = e;
      }
    }

    final pattern = '(${mapping0.keys.toList().join('|')})';
    List<InlineSpan> widgets = [];

    newString.splitMapJoin(
      RegExp(
        pattern,
        multiLine: regexOptions.multiLine,
        caseSensitive: regexOptions.caseSensitive,
        dotAll: regexOptions.dotAll,
        unicode: regexOptions.unicode,
      ),
      onMatch: (Match match) {
        final matchText = match[0];
        final mapping = mapping0[matchText!] ??
            mapping0[mapping0.keys.firstWhere((element) {
              final reg = RegExp(
                element,
                multiLine: regexOptions.multiLine,
                caseSensitive: regexOptions.caseSensitive,
                dotAll: regexOptions.dotAll,
                unicode: regexOptions.unicode,
              );
              return reg.hasMatch(matchText);
            }, orElse: () => '')]!;

        final interactions = mapping.interactions ?? defaultInteractions;

        if (mapping.renderText != null) {
          final result = mapping.renderText!(str: matchText, pattern: pattern);
          final text = result['display'] ?? matchText;

          if (interactions != null) {
            widgets.add(
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: interactions.enableSocialProfile == true &&
                          interactions.platform != null &&
                          interactions.username != null
                      ? () => _openSocialProfile(
                            interactions.username!,
                            interactions.platform!,
                          )
                      : () => mapping.onTap?.call(matchText),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(text, style: mapping.style ?? style),
                      ),
                      interactions.showsocialIcon
                          ? buildInteractionButtons(context, text, interactions)
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            widgets.add(
              TextSpan(
                text: text,
                style: mapping.style ?? style,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    final value = result['value'] ?? matchText;
                    mapping.onTap?.call(value);
                  },
              ),
            );
          }
        } else if (mapping.renderWidget != null) {
          widgets.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () => mapping.onTap!(matchText),
                child: mapping.renderWidget!(
                  text: matchText,
                  pattern: mapping.pattern!,
                ),
              ),
            ),
          );
        } else {
          if (interactions != null) {
            widgets.add(
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: interactions.enableSocialProfile == true &&
                          interactions.platform != null &&
                          interactions.username != null
                      ? () => _openSocialProfile(
                            interactions.username!,
                            interactions.platform!,
                          )
                      : () => mapping.onTap?.call(matchText),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (interactions.showsocialIconATStart) ...[
                        interactions.showsocialIcon
                            ? buildInteractionButtons(
                                context, matchText, interactions)
                            : SizedBox(),
                      ],
                      Flexible(
                        child: Text(matchText, style: mapping.style ?? style),
                      ),
                      if (!interactions.showsocialIconATStart) ...[
                        interactions.showsocialIcon
                            ? buildInteractionButtons(
                                context, matchText, interactions)
                            : SizedBox(),
                      ],
                    ],
                  ),
                ),
              ),
            );
          } else {
            widgets.add(
              TextSpan(
                text: matchText,
                style: mapping.style ?? style,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => mapping.onTap!(matchText),
              ),
            );
          }
        }
        return '';
      },
      onNonMatch: (String text) {
        widgets.add(TextSpan(
          text: text,
          style: style,
        ));
        return '';
      },
    );

    final Widget textWidget = selectable
        ? SelectableText.rich(
            textScaler: TextScaler.linear(textScaleFactor),
            TextSpan(children: widgets, style: style),
            maxLines: maxLines,
            strutStyle: strutStyle,
            textWidthBasis: textWidthBasis,
            textAlign: alignment,
            textDirection: textDirection,
            onTap: onTap as void Function()?,
          )
        : RichText(
            softWrap: softWrap,
            overflow: overflow,
            maxLines: maxLines,
            strutStyle: strutStyle,
            textWidthBasis: textWidthBasis,
            textAlign: alignment,
            textScaler: TextScaler.linear(textScaleFactor),
            textDirection: textDirection,
            text: TextSpan(
              children: widgets,
              style: style,
            ),
          );

    return textWidget;
  }
}
