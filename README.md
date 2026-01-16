# Instagram Story View

A Flutter package that provides an Instagram-like story view with hero expand animation.

## Features
- Hero expand animation from avatar to fullscreen
- Vertical drag to dismiss
- PageView support for multiple stories
- Fully customizable overlay content
- Supports any ImageProvider (Asset, Network, File)

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:instagram_story_view/instagram_story_view.dart';

InstagramStoryView(
  items: [
    StoryItem(
      image: AssetImage('assets/1.jpg'),
      builder: (context, size) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Hello story',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    ),
  ],
);
