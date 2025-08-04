import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/location.dart';
import '../../provider/review_provider.dart';
import 'package:intl/intl.dart';

class ReviewPage extends ConsumerWidget {
  final Location location;
  const ReviewPage({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsState = ref.watch(reviewProvider(location));
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(location.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: reviewsState.isEmpty
                ? const Center(child: Text('아직 리뷰가 없습니다.\n첫 리뷰를 작성해 보세요!',
                textAlign: TextAlign.center,))
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: reviewsState.length,
                    itemBuilder: (context, index) {
                      final review = reviewsState[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), 
                        ),
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                              Text(
                                review.content, 
                                style: const TextStyle(fontSize: 18,
                                fontWeight: FontWeight.bold,),
                                
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('yyyy-MM-dd HH:mm').format(review.createdAt),
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: '리뷰를 작성해주세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ref.read(reviewProvider(location).notifier).addReview(controller.text);
                      controller.clear();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  mini: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}