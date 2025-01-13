import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // For loading SVG icons
import 'package:smart_actions_text/smart_actions_text.dart'; // Main package import
import 'package:url_launcher/url_launcher.dart'; // For launching URLs, emails, and phone calls

void main() {
  runApp(const MyApp());
}

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Smart Action Text Demo'),
    );
  }
}

/// Demo page to showcase Smart Action Text features
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container with shadow and rounded corners for better presentation
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SmartActionsText(
                // Sample text containing various patterns to demonstrate functionality
                text: '''
Hey there! 👋 
              
📧 Reach out to me at contact code@gmail.com
📱 Call or WhatsApp: +1 (234) 567-8900
🔗 Check my portfolio: https://devcodespace.com
🌐 Follow me on social media:
      Twitter: @devcodespace
      LinkedIn: @devcode_space
      Instagram: @dev_code_space''',
                // Base text styling
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
                parse: [
                  // Email pattern matching and handling
                  MatchText(
                    type: ParsedType.email,
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    interactions: TextInteractions(
                      enableCopy: true, // Allow copying email
                      enableShare: false,
                      copyIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: SvgPicture.asset(
                            "assets/email.svg",
                            height: 20,
                          )),
                      showsocialIconATStart: false,
                    ),
                    // Launch email client when tapped
                    onTap: (email) async {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: email,
                      );

                      await launchUrl(emailUri);
                    },
                  ),

                  // Phone number detection and handling
                  MatchText(
                    type: ParsedType.phone,
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    interactions: TextInteractions(
                      enableCopy: true, // Allow copying phone number
                      enableShare: true, // Allow sharing phone number
                      copyIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: SvgPicture.asset(
                            "assets/call.svg",
                            height: 25,
                          )),
                      shareIcon: SvgPicture.asset(
                        "assets/share.svg",
                        height: 20,
                      ),
                      showsocialIconATStart: false,
                    ),
                    // Launch phone dialer when tapped
                    onTap: (phone) async {
                      final Uri phoneUri = Uri(
                        scheme: 'tel',
                        path: phone,
                      );

                      await launchUrl(phoneUri);
                    },
                  ),

                  // URL detection and handling
                  MatchText(
                    type: ParsedType.url,
                    style: TextStyle(
                      color: Colors.purple[700],
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    interactions: TextInteractions(
                      showsocialIconATStart: false,
                      enableCopy: true,
                      copyIcon: SvgPicture.asset(
                        "assets/copy.svg",
                        height: 18,
                      ),
                    ),
                    // Open URL in external browser
                    onTap: (url) async {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    },
                  ),

                  // Twitter handle detection and profile linking
                  MatchText(
                    pattern: r"@devcodespace",
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.w500,
                    ),
                    interactions: TextInteractions(
                      enableSocialProfile: true,
                      platform: SocialPlatform.twitter,
                      username: "allen_musk",
                      socialIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Image.asset(
                          "assets/X.png",
                          height: 18,
                        ),
                      ),
                      showsocialIconATStart: true, // Show icon before handle
                    ),
                  ),

                  // LinkedIn handle detection and profile linking
                  MatchText(
                    pattern: r"@devcode_space",
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                    ),
                    interactions: TextInteractions(
                      enableSocialProfile: true,
                      platform: SocialPlatform.linkedin,
                      username: "williamhgates",
                      socialIcon: SvgPicture.asset(
                        "assets/linkedin.svg",
                        height: 20,
                      ),
                      showsocialIconATStart: true, // Show icon before handle
                    ),
                  ),

                  // Instagram handle detection and profile linking
                  MatchText(
                    pattern: r"@dev_code_space",
                    style: TextStyle(
                      color: Colors.pink[400],
                      fontWeight: FontWeight.w500,
                    ),
                    interactions: TextInteractions(
                      enableSocialProfile: true,
                      platform: SocialPlatform.instagram,
                      username: "therock",
                      showsocialIconATStart: true, // Show icon before handle
                      socialIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: SvgPicture.asset(
                          "assets/instagram.svg",
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ],
                alignment: TextAlign.left,
                softWrap: true,
                textScaleFactor: 1.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
