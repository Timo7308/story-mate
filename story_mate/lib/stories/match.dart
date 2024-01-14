import 'package:flutter/material.dart';

class MatchPage extends StatefulWidget {
  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration:
          Duration(seconds: 1), // Increased duration for a smoother animation
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    // Start the animation
    _animationController.repeat(); // Repeat the animation for loading symbol
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 0),
        child: AppBar(
          automaticallyImplyLeading: false,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/SearchImage.png',
                width: 300.0, // Increased size
                height: 300.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Connecting you...',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Please wait, we are searching for a partner',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30.0),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle:
                      _animation.value * 2 * 3.14, // Full rotation in radians
                  child: Image.asset(
                    'assets/LoadingCircle.png',
                    width: 50.0, // Adjust the size as needed
                    height: 50.0,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
