import 'dart:math' as math;

import 'package:anagrammatic/app_flow/app.dart';
import 'package:anagrammatic/options/options.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

const double frontHeadingHeight = 32.0; // front layer rounded rectangle
const double _frontClosedHeight = 92.0; // front layer height when closed
const double _backAppBarHeight = 56.0; // back layer (options) appbar height

class _TappableWhileStatusIs extends StatefulWidget {
  const _TappableWhileStatusIs(
    this.status, {
    Key key,
    this.controller,
    this.child,
  }) : super(key: key);

  final AnimationController controller;
  final AnimationStatus status;
  final Widget child;

  @override
  _TappableWhileStatusIsState createState() => _TappableWhileStatusIsState();
}

class _TappableWhileStatusIsState extends State<_TappableWhileStatusIs> {
  bool _active;

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener(_handleStatusChange);
    _active = widget.controller.status == widget.status;
  }

  @override
  void dispose() {
    widget.controller.removeStatusListener(_handleStatusChange);
    super.dispose();
  }

  void _handleStatusChange(AnimationStatus status) {
    final bool value = widget.controller.status == widget.status;
    if (_active != value) {
      setState(() {
        _active = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !_active,
      child: widget.child,
    );
  }
}

class _CrossFadeTransition extends AnimatedWidget {
  final AlignmentGeometry alignment;
  final Widget child0;
  final Widget child1;

  const _CrossFadeTransition({
    Key key,
    this.alignment = Alignment.center,
    Animation<double> progress,
    this.child0,
    this.child1,
  }) : super(key: key, listenable: progress);

  @override
  Widget build(BuildContext context) {
    final Animation<double> progress = listenable;

    final double opacity1 = CurvedAnimation(
      parent: ReverseAnimation(progress),
      curve: const Interval(
        0.5,
        1.0,
      ),
    ).value;

    final double opacity2 = CurvedAnimation(
      parent: progress,
      curve: const Interval(
        0.5,
        1.0,
      ),
    ).value;

    return Stack(
      alignment: alignment,
      children: <Widget>[
        Opacity(
          opacity: opacity1,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child1,
          ),
        ),
        Opacity(
          opacity: opacity2,
          child: Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: child0,
          ),
        ),
      ],
    );
  }
}

class _BackAppBar extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget trailing;

  const _BackAppBar({
    Key key,
    this.leading = const SizedBox(width: 56.0),
    @required this.title,
    this.trailing,
  })  : assert(leading != null),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[
      Container(
        alignment: Alignment.center,
        width: 56.0,
        child: leading,
      ),
      Expanded(
        child: Center(
          child: title,
        ),
      ),
    ];

    if (trailing != null) {
      children.add(
        Container(
          alignment: Alignment.center,
          width: 56.0,
          child: trailing,
        ),
      );
    }

    final ThemeData theme = Theme.of(context);

    return IconTheme.merge(
      data: theme.primaryIconTheme,
      child: DefaultTextStyle(
        style: theme.primaryTextTheme.title,
        child: SizedBox(
          height: _backAppBarHeight,
          child: Row(
            children: children,
          ),
        ),
      ),
    );
  }
}

class Backdrop extends StatefulWidget {
  final Widget frontAction;
  final Widget frontTitle;
  final Widget frontHeading;
  final Widget frontLayer;
  final Widget backAction;
  final Widget backTitle;
  final OptionsPage backLayer;

  const Backdrop({
    this.frontAction,
    this.frontTitle,
    this.frontHeading,
    this.frontLayer,
    this.backAction,
    this.backTitle,
    this.backLayer,
  });

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _animationController;
  Animation<double> _frontOpacity;

  static final Animatable<double> _frontOpacityTween = Tween<double>(
    begin: 0.2,
    end: 1.0,
  ).chain(
    CurveTween(
      curve: const Interval(
        0.0,
        0.4,
        curve: Curves.easeInOut,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ),
      value: 1.0,
      vsync: this,
    )..addStatusListener((animationState) {
        _onToggle(animationState);
      });
    _frontOpacity = _animationController.drive(_frontOpacityTween);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _backdropHeight {
    // Warning: this can be safely called from the event handlers but it may
    // not be called at build time.
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return math.max(
      0.0,
      renderBox.size.height - _backAppBarHeight - _frontClosedHeight,
    );
  }

  void _clearFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _onToggle(AnimationStatus animationState) {
    AnagrammaticAppState appState = AnagrammaticApp.of(context);

    if (animationState == AnimationStatus.completed) {
      setState(() {
        appState.updateOptions(widget.backLayer.options);
      });
    }

    if (animationState == AnimationStatus.dismissed ||
        animationState == AnimationStatus.completed) {
      appState.options.isOpen ^= true;
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -=
        details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) {
      return;
    }

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0) {
      _animationController.fling(
        velocity: math.max(
          2.0,
          -flingVelocity,
        ),
      );
    } else if (flingVelocity > 0.0) {
      _animationController.fling(
        velocity: math.min(
          -2.0,
          -flingVelocity,
        ),
      );
    } else {
      _animationController.fling(
        velocity: _animationController.value < 0.5 ? -2.0 : 2.0,
      );
    }

    _clearFocus();
  }

  void _toggleFrontLayer() {
    _clearFocus();
    final AnimationStatus status = _animationController.status;
    final bool isOpen = status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
    _animationController.fling(
      velocity: isOpen ? -2.0 : 2.0,
    );
  }

  Widget _buildStack(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final Animation<RelativeRect> frontRelativeRect =
        _animationController.drive(
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0.0,
          constraints.biggest.height - _frontClosedHeight,
          0.0,
          0.0,
        ),
        end: const RelativeRect.fromLTRB(
          0.0,
          _backAppBarHeight,
          0.0,
          0.0,
        ),
      ),
    );

    final List<Widget> layers = <Widget>[
      // Back layer
      Column(
        children: <Widget>[
          _BackAppBar(
            leading: _CrossFadeTransition(
              progress: _animationController,
              child0: widget.frontAction,
              child1: widget.backAction,
            ),
            title: Center(
              child: _CrossFadeTransition(
                progress: _animationController,
                alignment: AlignmentDirectional.center,
                child0: widget.frontTitle,
                child1: widget.backTitle,
              ),
            ),
            trailing: IconButton(
              onPressed: _toggleFrontLayer,
              tooltip: 'Toggle options page',
              icon: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _animationController,
              ),
            ),
          ),
          Expanded(
            child: Visibility(
              child: widget.backLayer,
              visible: _animationController.status != AnimationStatus.completed,
              maintainState: true,
            ),
          ),
        ],
      ),
      // Front layer
      PositionedTransition(
        rect: frontRelativeRect,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (
            BuildContext context,
            Widget child,
          ) {
            return PhysicalShape(
              elevation: 12.0,
              color: Theme.of(context).canvasColor,
              clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(frontHeadingHeight),
                    topRight: Radius.circular(frontHeadingHeight),
                  ),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: child,
            );
          },
          child: _TappableWhileStatusIs(
            AnimationStatus.completed,
            controller: _animationController,
            child: FadeTransition(
              opacity: _frontOpacity,
              child: widget.frontLayer,
            ),
          ),
        ),
      ),
    ];

    if (widget.frontHeading != null) {
      layers.add(
        PositionedTransition(
          rect: frontRelativeRect,
          child: ExcludeSemantics(
            child: Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggleFrontLayer,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                child: widget.frontHeading,
              ),
            ),
          ),
        ),
      );
    }

    return Stack(
      key: _backdropKey,
      children: layers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: _buildStack,
    );
  }
}
