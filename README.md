# 🚀 Smart Actions Text

A Flutter package that transforms plain text into **interactive elements** by automatically detecting and styling patterns like **URLs**, **emails**, **phone numbers**, and **social media handles**.

✨ Make your text content more engaging with **tap interactions**, **copying capabilities**, **sharing options**, and **direct social media profile access**—all with customizable styling and behavior!

<img src="https://raw.githubusercontent.com/DevCodeSpace/smart_actions_text/main/assets/banner.jpg" />

## 🌟 Features

- 🔍 **Automatic detection of:**
  - 📧 **Email addresses**
  - 📞 **Phone numbers**
  - 🌐 **URLs**
  - 🤳 **Social media user handles**

- ✨ **Customizable styling** for matched patterns
- 📱 **Interactive features:**
  - 📋 **Copy to clipboard**
  - 🔗 **Share text**
  - 🧑‍💻 **Open social media profiles**

- 🎨 **Custom icon support**
- 📐 **Flexible text positioning**
- 🔧 **Configurable regex patterns**

<br/>

## 📥 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  smart_actions_text: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## 💻 Usage

### 📝 Basic Usage

<div align="left">
  <img src="https://raw.githubusercontent.com/DevCodeSpace/smart_actions_text/main/assets/call_example.gif" width="300" height="200">
  <img src="https://raw.githubusercontent.com/DevCodeSpace/smart_actions_text/main/assets/email_example.gif" width="300" height="200">
</div>

```dart
SmartActionsText(
  // The text that will be parsed for patterns
  text: "Contact me at user@example.com or call +1234567890",
  
  // Default style applied to all text
  style: TextStyle(fontSize: 14),
  parse: [
    // Configure email pattern detection
    MatchText(
      type: ParsedType.email,
      style: TextStyle(color: Colors.blue),
      onTap: (email) => print('Tapped on $email'),
    ),
    
    // Configure phone number pattern detection
    MatchText(
      type: ParsedType.phone,
      style: TextStyle(color: Colors.green),
      onTap: (phone) => print('Tapped on $phone'),
    ),
  ],
)

```

### 🤳 Social Media Integration

<div align="left">
  <img src="https://raw.githubusercontent.com/DevCodeSpace/smart_actions_text/main/assets/twitter_example.gif" width="300" height="200">
</div>

```dart
SmartActionsText(
  // Text containing social media handle
  text: "Follow me @username on Twitter!",
  
  parse: [
    MatchText(
      // Regex pattern to match @username format
      pattern: r"@\w+",
      style: TextStyle(color: Colors.blue),
      
      // Configure social media interactions
      interactions: TextInteractions(
        enableSocialProfile: true,  // Enable profile opening
        platform: SocialPlatform.twitter,  // Specify platform
        username: "username",  // User's profile name
        showsocialIcon: true,  // Show platform icon
        showsocialIconATStart: false,  // Icon position (start/end)
      ),
    ),
  ],
)
```

### 🛠️ Custom Interaction Buttons
<div align="left">
  <img src="https://raw.githubusercontent.com/DevCodeSpace/smart_actions_text/main/assets/share_example.gif" width="300" height="200">
  <img src="https://raw.githubusercontent.com/DevCodeSpace/smart_actions_text/main/assets/copy_example.gif" width="300" height="200">
</div>
<br/>

```dart
SmartActionsText(
  text: "Share this message with others!",
  parse: [
    MatchText(
      // Pattern to match entire sharing text
      pattern: r"Share this message",
      
      // Configure interaction options
      interactions: TextInteractions(
        enableCopy: true,    // Enable copy functionality
        enableShare: true,   // Enable share functionality
        copyIcon: Icon(Icons.copy_all),  // Custom icon for copy
        shareIcon: Icon(Icons.share),    // Custom icon for share
      ),
    ),
  ],
)
```

### 🔍 Regex Options
<div align="left">
  <img src="https://raw.githubusercontent.com/DevCodeSpace/smart_actions_text/main/assets/url_example.gif" width="300" height="200">
</div>
<br/>

```dart
SmartActionsText(
  // Multi-line text with URL
  text: "Multi-line\ntext with URLs: https://example.com",
  
  // Configure regex matching options
  regexOptions: RegexOptions(
    multiLine: true,      // Enable multi-line matching
    caseSensitive: false, // Ignore case when matching
  ),
  
  parse: [
    // Configure URL pattern detection
    MatchText(
      type: ParsedType.url,
      style: TextStyle(color: Colors.blue),
    ),
  ],
)
```

## ⚙️ Configuration Options

### 📋 Properties

| 🔧 **Property** | 📚 **Type** | 📄 **Description** |
|-----------------|-------------|-------------------|
| **text** | `String` | The text to be parsed |
| **parse** | `List<MatchText>` | List of patterns to match and configure |
| **style** | `TextStyle?` | Default text style |
| **alignment** | `TextAlign` | Text alignment |
| **selectable** | `bool` | Make text selectable |
| **softWrap** | `bool` | Enable/disable text wrapping |
| **maxLines** | `int?` | Maximum number of lines |

### 🔧 TextInteractions Properties

| 🔧 **Property** | 📚 **Type** | 📄 **Description** |
|-----------------|-------------|-------------------|
| **enableCopy** | `bool` | Enable copy functionality |
| **enableShare** | `bool` | Enable share functionality |
| **enableSocialProfile** | `bool` | Enable social media profile access |
| **platform** | `SocialPlatform?` | Social media platform (e.g., Twitter) |
| **username** | `String?` | Social media username |
| **showsocialIcon** | `bool` | Show/hide social media icon |
| **showsocialIconATStart** | `bool` | Position icon at the start |

## 🤝 Contributing

[![](https://raw.githubusercontent.com/DevCodeSpace/smart_actions_text/main/assets/contributors.png)](https://raw.githubusercontent.com/DevCodeSpace/smart_actions_text/graphs/contributors)

<div align="center">
  <strong>Built with ❤️ by the <a href="#">DevCodeSpace</a></strong>
</div>