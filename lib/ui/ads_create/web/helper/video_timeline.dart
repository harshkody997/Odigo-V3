import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/ui/ads_create/web/helper/trim_settings.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';

class VideoTimeline extends ConsumerStatefulWidget {
  // final Duration videoDuration;
  final Duration trimDuration;
  // final TrimSettings? trimSettings;
  final Function(Duration startTime) onTrimChanged;
  // final Duration? currentPosition;

  const VideoTimeline({
    super.key,
    // required this.videoDuration,
    required this.trimDuration,
    required this.onTrimChanged,
    // this.trimSettings,
    // this.currentPosition,
  });

  @override
  ConsumerState<VideoTimeline> createState() => _VideoTimelineState();
}

class _VideoTimelineState extends ConsumerState<VideoTimeline> {
  double _startPosition = 0.0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _updateStartPosition();
    },);
  }

  @override
  void didUpdateWidget(VideoTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    final createAdRead = ref.watch(createAdsController);
    if (createAdRead.trimSettings != createAdRead.trimSettings) {
      _updateStartPosition();
    }
  }

  void _updateStartPosition() {
    final createAdRead = ref.watch(createAdsController);
    if (createAdRead.trimSettings != null) {
      _startPosition = createAdRead.trimSettings!.startTimePercentage;
    } else {
      _startPosition = 0.0;
    }
  }

  void _onPanUpdate(DragUpdateDetails details, double timelineWidth) {
    final createAdRead = ref.watch(createAdsController);

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    // Calculate new start position as percentage
    double newStartPosition = (localPosition.dx - AppConstants.defaultPadding) / timelineWidth;
    newStartPosition = newStartPosition.clamp(0.0, 1.0);

    // Calculate maximum start position to ensure trim duration fits
    final maxStartPosition = 1.0 - (widget.trimDuration.inMilliseconds / createAdRead.videoDuration!.inMilliseconds);
    newStartPosition = newStartPosition.clamp(0.0, maxStartPosition);

    setState(() {
      _startPosition = newStartPosition;
    });

    // Convert to Duration and notify parent
    final startTime = Duration(
      milliseconds: (newStartPosition * createAdRead.videoDuration!.inMilliseconds).round(),
    );
    widget.onTrimChanged(startTime);
  }

  @override
  Widget build(BuildContext context) {
    final createAdRead = ref.watch(createAdsController);
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0:00',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                _formatDuration(createAdRead.videoDuration ?? Duration()),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Timeline track
          LayoutBuilder(
            builder: (context, constraints) {
              final timelineWidth = constraints.maxWidth - (AppConstants.defaultPadding * 2);
              final trimWidthPercentage = widget.trimDuration.inMilliseconds / createAdRead.videoDuration!.inMilliseconds;
              final trimWidth = timelineWidth * trimWidthPercentage;
              final startOffset = timelineWidth * _startPosition;

              return GestureDetector(
                onPanUpdate: (details) => _onPanUpdate(details, timelineWidth),
                child: Container(
                  height: AppConstants.timelineHeight,
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                  child: Stack(
                    children: [
                      // Background track
                      Positioned(
                        top: (AppConstants.timelineHeight - AppConstants.timelineTrackHeight) / 2,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: AppConstants.timelineTrackHeight,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(AppConstants.timelineTrackHeight / 2),
                          ),
                        ),
                      ),

                      // Trim selection
                      Positioned(
                        top: (AppConstants.timelineHeight - AppConstants.timelineTrackHeight) / 2,
                        left: startOffset,
                        child: Container(
                          width: trimWidth,
                          height: AppConstants.timelineTrackHeight,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(AppConstants.timelineTrackHeight / 2),
                          ),
                        ),
                      ),

                      // Start thumb
                      Positioned(
                        top: (AppConstants.timelineHeight - AppConstants.timelineThumbSize) / 2,
                        left: startOffset - (AppConstants.timelineThumbSize / 2),
                        child: Container(
                          width: AppConstants.timelineThumbSize,
                          height: AppConstants.timelineThumbSize,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // End thumb
                      Positioned(
                        top: (AppConstants.timelineHeight - AppConstants.timelineThumbSize) / 2,
                        left: startOffset + trimWidth - (AppConstants.timelineThumbSize / 2),
                        child: Container(
                          width: AppConstants.timelineThumbSize,
                          height: AppConstants.timelineThumbSize,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Current position indicator
                      if (createAdRead.currentPosition != null)
                        Positioned(
                          top: 0,
                          left: timelineWidth * (createAdRead.currentPosition!.inMilliseconds / createAdRead.videoDuration!.inMilliseconds) - 1,
                          child: Container(
                            width: 2,
                            height: AppConstants.timelineHeight,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          // Trim info
          if (createAdRead.trimSettings != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start: ${_formatDuration(createAdRead.trimSettings!.startTime)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Duration: ${_formatDuration(createAdRead.trimSettings!.actualTrimDuration)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'End: ${_formatDuration(createAdRead.trimSettings!.endTime)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
