import 'package:flutter/material.dart';
import 'package:story_mate/stories/start.dart';

class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double checkmarkSize = 170.0; // Initial size of the checkmark

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 170.0,
      end: 700.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _animationController.forward();

    // Wait for the animation to complete before navigating
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartPage()),
      );
    });
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
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value / 170.0, // Initial size
                  child: Icon(
                    Icons.check,
                    color: Color(0xFF2CA58D),
                  ),
                );
              },
            ),
            const SizedBox(height: 200.0),
            Text(
              'Setup finished!',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}
