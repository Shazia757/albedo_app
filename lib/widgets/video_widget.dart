import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class AutoPlayVideo extends StatefulWidget {
  final String url;

  const AutoPlayVideo({
    super.key,
    required this.url,
  });

  @override
  State<AutoPlayVideo> createState() => _AutoPlayVideoState();
}

class _AutoPlayVideoState extends State<AutoPlayVideo> {
  late VideoPlayerController controller;

  bool showControls = true;
  bool isMuted = true;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    )..initialize().then((_) async {
        await controller.setLooping(true);

        // start muted
        await controller.setVolume(0);

        await controller.play();

        setState(() {});
      });

    // update UI when video state changes
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void togglePlayPause() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void toggleMute() {
    if (isMuted) {
      controller.setVolume(1);
    } else {
      controller.setVolume(0);
    }

    setState(() {
      isMuted = !isMuted;
    });
  }

  Future<void> openFullScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenVideoPlayer(
          controller: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),

          /// CENTER PLAY BUTTON
          if (showControls)
            IconButton(
              onPressed: togglePlayPause,
              icon: Icon(
                controller.value.isPlaying
                    ? Icons.pause_circle
                    : Icons.play_circle,
                color: Colors.white,
                size: 60,
              ),
            ),

          /// BOTTOM CONTROLS
          if (showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                color: Colors.black54,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// SEEK BAR
                    VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                      padding: const EdgeInsets.only(bottom: 8),
                    ),

                    Row(
                      children: [
                        /// PLAY / PAUSE
                        IconButton(
                          onPressed: togglePlayPause,
                          icon: Icon(
                            controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),

                        /// MUTE
                        IconButton(
                          onPressed: toggleMute,
                          icon: Icon(
                            isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                          ),
                        ),

                        /// CURRENT TIME
                        Text(
                          formatDuration(
                            controller.value.position,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),

                        const Spacer(),

                        /// FULLSCREEN
                        IconButton(
                          onPressed: openFullScreen,
                          icon: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({
    super.key,
    required this.controller,
  });

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool showControls = true;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();

    isMuted = widget.controller.value.volume == 0;

    /// landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    /// back to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    super.dispose();
  }

  void togglePlayPause() {
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
    } else {
      widget.controller.play();
    }
  }

  void toggleMute() {
    if (isMuted) {
      widget.controller.setVolume(1);
    } else {
      widget.controller.setVolume(0);
    }

    setState(() {
      isMuted = !isMuted;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            showControls = !showControls;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),

            /// CENTER PLAY/PAUSE BUTTON
            if (showControls)
              IconButton(
                onPressed: togglePlayPause,
                icon: Icon(
                  widget.controller.value.isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: Colors.white,
                  size: 70,
                ),
              ),

            /// TOP BACK BUTTON
            if (showControls)
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

            /// BOTTOM CONTROLS
            if (showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  color: Colors.black54,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// SEEK BAR
                      VideoProgressIndicator(
                        widget.controller,
                        allowScrubbing: true,
                        padding: const EdgeInsets.only(bottom: 8),
                      ),

                      Row(
                        children: [
                          /// PLAY / PAUSE
                          IconButton(
                            onPressed: togglePlayPause,
                            icon: Icon(
                              widget.controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),

                          /// MUTE
                          IconButton(
                            onPressed: toggleMute,
                            icon: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white,
                            ),
                          ),

                          /// CURRENT POSITION
                          Text(
                            formatDuration(
                              widget.controller.value.position,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          const Text(
                            " / ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          /// TOTAL DURATION
                          Text(
                            formatDuration(
                              widget.controller.value.duration,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          const Spacer(),

                          /// EXIT FULLSCREEN
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.fullscreen_exit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
