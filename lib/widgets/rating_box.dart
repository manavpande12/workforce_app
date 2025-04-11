import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workforce_app/services/review_service.dart';
import 'package:workforce_app/theme/color.dart';
import 'package:workforce_app/widgets/custom_button.dart';
import 'package:workforce_app/widgets/custom_input.dart';
import 'package:workforce_app/widgets/custom_scaffold.dart';

class RatingBox extends StatefulWidget {
  final String otherId;
  const RatingBox({super.key, required this.otherId});

  @override
  State<RatingBox> createState() => _RatingBoxState();
}

class _RatingBoxState extends State<RatingBox> {
  double _rating = 0; // Stores the current rating
  final TextEditingController _reviewController = TextEditingController();
  bool _isLoading = false;
  final List<String> ratingLabels = [
    "🙁 Poor",
    "😐 Okay",
    "🙂 Good",
    "😊 Great",
    "🤩 Excellent"
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  String cleanInput(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  void _review() async {
    if (_rating == 0 ||
        _reviewController.text.isEmpty ||
        _reviewController.text.length <= 15) {
      context.showSnackBar(
          "Please provide a rating and write a review of at least 15 characters before submitting! ✍️",
          isError: true);
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    try {
      await submitReview(
        widget.otherId,
        _rating,
        cleanInput(_reviewController.text),
        ratingLabels[_rating.toInt() - 1],
        context,
      );
    } catch (e) {
      if (mounted) {
        context.showSnackBar(
            "An error occurred while submitting the review: $e",
            isError: true);
      }
    } finally {
      setState(() {
        _isLoading = false;
        _rating = 0;
        _reviewController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).brightness == Brightness.dark
            ? bgrey.withValues(alpha: 0.6)
            : grey.withValues(alpha: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated Star Rating
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              _rating == 0
                  ? "✨ Rate this service"
                  : ratingLabels[_rating.toInt() - 1],
              key: ValueKey(_rating),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 18, fontStyle: FontStyle.normal),
            ),
          ),

          const SizedBox(height: 10),

          // Star Rating Widget
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = (index + 1).toDouble();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    Icons.star,
                    size: 40,
                    color: _rating > index
                        ? yellow
                        : Theme.of(context).brightness == Brightness.dark
                            ? bgrey
                            : grey,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // Custom Input Field for Review
          CustomInput(
            defaultIcon: Icon(
              FontAwesomeIcons.featherPointed,
              size: 25,
              color: Theme.of(context).brightness == Brightness.dark
                  ? grey.withValues(alpha: 0.4)
                  : bgrey.withValues(alpha: 0.4),
            ),
            controller: _reviewController,
            enableSuggestions: true,
            labelText: "Write your review...",
            maxLength: 80,
            kType: TextInputType.multiline,
            maxLines: 3,
          ),

          const SizedBox(height: 10),

          // Submit Button
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: yellow,
            ),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : CustomButton(
                    fgClr: black,
                    bgClr: yellow,
                    text: "Submit",
                    onTap: _review,
                    iClr: black,
                    icon: FontAwesomeIcons.paperPlane,
                    iSize: 20,
                    fontSize: 14,
                  ),
          )
        ],
      ),
    );
  }
}
