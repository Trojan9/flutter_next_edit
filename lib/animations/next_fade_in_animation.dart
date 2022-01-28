import '../flutter_next.dart';

class NextFadeInAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final AnimationController? controller;
  final bool startAnimation;
  final double initialPosition;
  final NextFadeInVariant? variant;
  const NextFadeInAnimation(
      {Key? key,
      required this.child,
      this.duration = const Duration(milliseconds: 750),
      this.delay = Duration.zero,
      this.variant,
      this.controller,
      this.startAnimation = true,
      this.initialPosition = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return variant == null
        ? SingleAnimationWrapper(
            child: (controller, value) => AnimatedOpacity(
                  opacity: value as double,
                  duration: duration,
                  child: child,
                ),
            animation: (controller) =>
                CurvedAnimation(curve: Curves.easeOut, parent: controller))
        : DoubleAnimationWrapper(
            controller: controller,
            duration: duration,
            firstAnimation: (controller) => getTween().animate(
                CurvedAnimation(parent: controller, curve: Curves.easeOut)),
            startAnimation: startAnimation,
            secondAnimation: (controller) => Tween<double>(begin: 0, end: 1)
                .animate(CurvedAnimation(
                    parent: controller, curve: const Interval(0, 0.7))),
            child: (AnimationController controller, dynamic animation,
                dynamic opacity) {
              return Transform.translate(
                  offset: getOffset(animation),
                  child: Opacity(
                    opacity: opacity,
                    child: child,
                  ));
            });
  }

  Offset getOffset(animation) {
    switch (variant) {
      case NextFadeInVariant.fadeInTop:
      case NextFadeInVariant.fadeInBottom:
        return Offset(0, animation);
      case NextFadeInVariant.fadeInLeft:
      case NextFadeInVariant.fadeInRight:
        return Offset(animation, 0);
      default:
        return const Offset(0, 0);
    }
  }

  Tween<double> getTween() {
    switch (variant) {
      case NextFadeInVariant.fadeInTop:
        return Tween<double>(begin: initialPosition * 1, end: 0);
      case NextFadeInVariant.fadeInBottom:
        return Tween<double>(begin: initialPosition * -1, end: 0);
      case NextFadeInVariant.fadeInLeft:
        return Tween<double>(begin: initialPosition * -1, end: 0);
      case NextFadeInVariant.fadeInRight:
        return Tween<double>(begin: initialPosition, end: 0);
      default:
        return Tween<double>(begin: initialPosition * -1, end: 0);
    }
  }
}