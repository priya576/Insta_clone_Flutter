// import 'package:flutter/material.dart';
// import 'package:instagram/utils/colors.dart';
//
// class StoryWidget extends StatefulWidget {
//   final snap;
//   const StoryWidget({super.key, this.snap});
//
//   @override
//   State<StoryWidget> createState() => _StoryWidgetState();
// }
//
// class _StoryWidgetState extends State<StoryWidget> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           child: CircleAvatar(
//             radius: 35.0,
//             backgroundImage: NetworkImage(widget.snap['storyurl']),
//           ),
//
//         ),
//         SizedBox(height: 5),
//         Text(widget.snap['username'], style: TextStyle(fontSize: 12,color: primaryColor),),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class StoryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> snap;
  const StoryWidget({super.key, required this.snap});

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryViewScreen(stories: widget.snap),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(2.0), // Space between circle and border
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red, // Change this to your desired color (e.g., red or green)
                  width: 3.0, // Thickness of the border
                ),
              ),
              child: CircleAvatar(
                radius: 35.0,
                backgroundImage: NetworkImage(widget.snap[0]['storyurl']), // Display the first story's image
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(widget.snap[0]['username'], style: TextStyle(fontSize: 12, color: primaryColor)),
        ],
      ),
    );
  }
}


class StoryViewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> stories;

  const StoryViewScreen({required this.stories, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StoryController();

    List<StoryItem> storyItems = stories.map((story) {
      return StoryItem.pageImage(
        url: story['storyurl'],
        controller: controller,
        caption: Text(story['description'] ?? ''),
      );
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          StoryView(
            storyItems: storyItems,
            controller: controller,
            repeat: false,
            onComplete: () {
              Navigator.of(context).pop();
            },
          ),
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: _buildHeader(stories.first),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> story) {
    return Row(
      children: [
        const SizedBox(height: 10,),
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(story['profImg']),
        ),
        const SizedBox(width: 10),
        Text(
          story['username'],
          style: const TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}