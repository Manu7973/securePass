import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTourScreen extends StatefulWidget {
  const AppTourScreen({super.key});

  @override
  State<AppTourScreen> createState() => _AppTourScreenState();
}

class _AppTourScreenState extends State<AppTourScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> images = [
    'assets/images/tour_1.png',
    'assets/images/tour_2.png',
    'assets/images/tour_3.png',
    'assets/images/tour_4.png',
    'assets/images/tour_5.png',
    'assets/images/tour_6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'App Tour',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          /// 🖼️ IMAGE AREA (takes remaining space)
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (_, index) {
                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),

          /// 🔽 BOTTOM CONTROLS (fixed height)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ● Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? CupertinoColors.activeBlue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// ⏭️ Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CupertinoColors.activeBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        if (_currentIndex == images.length - 1) {
                          Navigator.pop(context);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      child: Text(
                        _currentIndex == images.length - 1
                            ? 'Done'
                            : 'Next',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
