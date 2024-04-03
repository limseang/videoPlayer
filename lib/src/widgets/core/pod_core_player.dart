part of 'package:pod_player/src/pod_player.dart';

class _PodCoreVideoPlayer extends StatelessWidget {
  final VideoPlayerController videoPlayerCtr;
  final double videoAspectRatio;
  final String tag;

  const _PodCoreVideoPlayer({
    required this.videoPlayerCtr,
    required this.videoAspectRatio,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final podCtr = Get.find<PodGetXVideoController>(tag: tag);
    return Builder(
      builder: (ctrx) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode:
              (podCtr.isFullScreen ? FocusNode() : podCtr.keyboardFocusWeb) ??
                  FocusNode(),
          onKey: (value) => podCtr.onKeyBoardEvents(
            event: value,
            appContext: ctrx,
            tag: tag,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: videoAspectRatio,
                  child: VideoPlayer(videoPlayerCtr),
                ),
              ),
              GetBuilder<PodGetXVideoController>(
                tag: tag,
                id: 'podVideoState',
                builder: (_) => GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'video-progress',
                  builder: (podCtr) {
                    if (podCtr.videoThumbnail == null) {
                      return const SizedBox();
                    }

                    if (podCtr.podVideoState == PodVideoState.paused &&
                        podCtr.videoPosition == Duration.zero) {
                      return SizedBox.expand(
                        child: TweenAnimationBuilder<double>(
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: child,
                          ),
                          tween: Tween<double>(begin: 0.7, end: 1),
                          duration: const Duration(milliseconds: 400),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              image: podCtr.videoThumbnail,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              _VideoOverlays(tag: tag),
              IgnorePointer(
                child: GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'podVideoState',
                  builder: (podCtr) {
                    final loadingWidget = podCtr.onLoading?.call(context) ??
                        const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );

                    if (kIsWeb) {
                      switch (podCtr.podVideoState) {
                        case PodVideoState.loading:
                          return loadingWidget;
                        case PodVideoState.paused:
                          return const Center(
                            child: Icon(
                              Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          );
                        case PodVideoState.playing:
                          return Center(
                            child: TweenAnimationBuilder<double>(
                              builder: (context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              ),
                              tween: Tween<double>(begin: 1, end: 0),
                              duration: const Duration(seconds: 1),
                              child: const Icon(
                                Icons.pause,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          );
                        case PodVideoState.error:
                          return const SizedBox();
                      }
                    } else {
                      if (podCtr.podVideoState == PodVideoState.loading) {
                        return loadingWidget;
                      }
                      return const SizedBox();
                    }
                  },
                ),
              ),
              if (!kIsWeb)
                GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'full-screen',
                  builder: (podCtr) => GetBuilder<PodGetXVideoController>(
                          tag: tag,
                          id: 'overlay',
                          builder: (podCtr) => podCtr.isOverlayVisible ||
                                  !podCtr.alwaysShowProgressBar
                              ?Stack(
                            children: [
                              // Positioned(
                              //   bottom: 50,
                              //   right: 50,
                              //   child:  Padding(
                              //       padding: const EdgeInsets.only(bottom: 50.0),
                              //       child: GestureDetector(
                              //         onTap: () {
                              //
                              //           podCtr.skipVideo = true;
                              //
                              //           // podCtr.changeVideo(
                              //           //   playVideoFrom: PlayVideoFrom.network(podCtr.nextUrl),
                              //           //   nextUrl: podCtr.nextUrl ??"",
                              //           // );
                              //           // podCtr.skipsVideo(
                              //           //   playVideoFrom: PlayVideoFrom.seek,
                              //           //   playerConfig: PodPlayerConfig(
                              //           //     autoPlay: true,
                              //           //   ),
                              //           // );
                              //         },
                              //         child: Container(
                              //           height: 50,
                              //           decoration: BoxDecoration(
                              //             color: Colors.black,
                              //             borderRadius: BorderRadius.circular(10),
                              //           ),
                              //           child:const Row(
                              //             mainAxisAlignment: MainAxisAlignment.center,
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(left: 40.0, right: 40),
                              //                 child: Text(
                              //                   'zoom',
                              //                   style: TextStyle(
                              //                     color: Colors.white,
                              //                     fontSize: 20,
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //   ),
                              // ),
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {podCtr.onLeftDoubleTap();
                                      },
                                      child: const Icon(
                                        Icons.replay_10,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width:200),
                                    GestureDetector(
                                      onTap: () {
                                        podCtr.seekTo(podCtr.videoPosition + const Duration(seconds: 10,),);
                                      },
                                      child: const Icon(
                                        Icons.forward_10,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                    )

                                  ],
                                ),
                              ),
                              // Positioned(
                              //   bottom: 50,
                              //   right: 50,
                              //   child:  Padding(
                              //       padding: const EdgeInsets.only(bottom: 50.0),
                              //       child: GestureDetector(
                              //         onTap: () {
                              //         podCtr.isSkipVideo = true;
                              //         },
                              //         child: Container(
                              //           height: 50,
                              //           decoration: BoxDecoration(
                              //             color: Colors.black,
                              //             borderRadius: BorderRadius.circular(10),
                              //           ),
                              //           child:const Row(
                              //             mainAxisAlignment: MainAxisAlignment.center,
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(left: 40.0, right: 40),
                              //                 child: Text(
                              //                   'zoom',
                              //                   style: TextStyle(
                              //                     color: Colors.white,
                              //                     fontSize: 20,
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //   ),
                              // ),

                            ],
                          )
                              : const SizedBox(),
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}
