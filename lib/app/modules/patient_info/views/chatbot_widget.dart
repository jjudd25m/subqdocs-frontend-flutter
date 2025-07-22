import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../widget/base_image_view.dart';

class ChatBotWidget extends StatefulWidget {
  const ChatBotWidget({super.key});

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> with SingleTickerProviderStateMixin {
  RxBool isOpen = RxBool(false);
  RxBool isMinimized = RxBool(false);
  RxBool isRecording = RxBool(false);

  String? path;
  String? musicFile;
  RxBool _isRecording = RxBool(false);
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;
  Timer? _chunkTimer;

  String? recordedFilePath;
  final RecorderController recorderController = RecorderController();

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  Timer? timer;
  RxInt recordSeconds = RxInt(0);
  RxString voiceToTextResult = RxString('');
  late AnimationController glowController;

  Rxn<Duration> currentAudioDuration = Rxn();

  // Add state for settings screen and preferred talkback
  RxBool showSettings = RxBool(false);
  RxString preferredTalkback = RxString('voice_to_voice');

  // Demo static messages
  RxList<Map<String, dynamic>> messages = RxList([
    {'sender': 'bot', 'text': 'Good Morning 👋'},
    {'sender': 'bot', 'text': 'How does GPT use AI?'},
    {'sender': 'user', 'text': 'Tell me more!'},
  ]);

  @override
  void initState() {
    super.initState();

    currentAudioDuration.value = Duration.zero;
    glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200), lowerBound: 0.7, upperBound: 1.0)..repeat(reverse: true);
    recorderController.checkPermission();

    recorderController.onCurrentDuration.listen((duration) {
      currentAudioDuration.value = duration;
    }); // Provides currently recorded duration of audio every 50 milliseconds.
  }

  @override
  void dispose() {
    recorderController.dispose();
    timer?.cancel();
    controller.dispose();
    focusNode.dispose();
    scrollController.dispose();
    glowController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    isOpen.value = !isOpen.value;
  }

  void _minimizeChat() {
    isMinimized.value = !isMinimized.value;
  }

  void _closeChat() {
    isOpen.value = false;
    isMinimized.value = false;
  }

  void startChunkTimer() {
    _chunkTimer = Timer.periodic(const Duration(seconds: 10), (Timer timer) async {});
  }

  void _startRecording() {
    startChunkTimer();

    _isRecording.value = true;
    recordSeconds.value = 0;
    voiceToTextResult.value = '';
  }

  Future<Duration?> getAudioDuration(String filePath) async {
    final player = AudioPlayer();
    try {
      await player.setFilePath(filePath);
      return player.duration;
    } catch (e) {
      print("Error loading audio: $e");
      return null;
    } finally {
      await player.dispose();
    }
  }

  void _sendMessage() {
    if (controller.text.trim().isEmpty) return;

    messages.add({'sender': 'user', 'text': controller.text.trim()});
    controller.clear();
    voiceToTextResult.value = '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isUser = msg['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: const BoxConstraints(maxWidth: 220),
        decoration: BoxDecoration(color: isUser ? AppColors.backgroundPurple : AppColors.chatBackgroundGrey, borderRadius: BorderRadius.circular(16), boxShadow: [if (!isUser) const BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Text(msg['text'] ?? '', style: TextStyle(color: isUser ? Colors.white : AppColors.black, fontSize: 15)),
      ),
    );
  }

  double get _keyboardPadding => MediaQuery.of(context).viewInsets.bottom;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          // Floating button
          if (!isOpen.value) Positioned(bottom: 24, right: 24, child: FloatingActionButton(backgroundColor: AppColors.backgroundPurple, onPressed: _toggleChat, child: const Icon(Icons.chat_bubble_outline, color: Colors.white))),
          // Chat window
          if (isOpen.value && !isMinimized.value)
            AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: 24 + _keyboardPadding, right: 24),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 340,
                    height: 500,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black26.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 8))]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // HEADER SECTION
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                          child: Row(
                            children: [
                              // Avatar and text
                              SvgPicture.asset(ImagePath.robot, height: 25, width: 25),
                              const SizedBox(width: 10),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Chatbot', style: AppFonts.medium(17, AppColors.black))]),
                              const Spacer(),

                              // Minimize and close buttons
                              GestureDetector(
                                onTap: _minimizeChat,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    ImagePath.minus,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.black.withValues(alpha: 0.5), // your desired color
                                      BlendMode.srcIn, // ensures the color replaces the SVG content
                                    ),
                                    height: 22,
                                    width: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              GestureDetector(
                                onTap: _closeChat,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    ImagePath.cross_white,
                                    colorFilter: ColorFilter.mode(
                                      AppColors.black.withValues(alpha: 0.5), // your desired color
                                      BlendMode.srcIn, // ensures the color replaces the SVG content
                                    ),
                                    height: 15,
                                    width: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        Divider(height: 0.3, color: AppColors.black.withValues(alpha: 0.1)),
                        // Main content area: show settings or chat content in Expanded
                        Expanded(
                          child:
                              showSettings.value
                                  ? Container(decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)), boxShadow: [BoxShadow(color: Colors.black26.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 8))]), child: _buildSettingsView())
                                  : Column(
                                    children: [
                                      // User info
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                        child: Row(
                                          children: [
                                            GestureDetector(onTap: () async {}, child: ClipRRect(borderRadius: BorderRadius.circular(22), child: const BaseImageView(imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDNH4yV8JgBa6G2XMCXzDJB6zP2edr2_VYPEp3QIkGLaUbswx_K5agwBAGP-zAowzoerw&usqp=CAU", width: 44, height: 44, nameLetters: "Kishan"))),
                                            const SizedBox(width: 12),
                                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Good Morning 👋', style: AppFonts.medium(17, AppColors.black)), const Text('Dr. Adrian Tinajero', style: TextStyle(fontSize: 13, color: Colors.black54))]),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                showSettings.value = true;
                                              },
                                              child: SvgPicture.asset(ImagePath.setting_mobile, height: 25, width: 25),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(child: ListView.builder(controller: scrollController, reverse: true, padding: const EdgeInsets.only(top: 8, bottom: 8), itemCount: messages.length, itemBuilder: (context, i) => _buildMessage(messages[messages.length - 1 - i]))),
                                      // AUDIO RECORDING BAR
                                      if (_isRecording.value)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Top row: Timer and AudioWave
                                              Row(
                                                children: [
                                                  // Timer
                                                  SizedBox(width: 45, child: Text(formatDuration(currentAudioDuration.value!), style: AppFonts.regular(16, AppColors.black))),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: AudioWaveforms(
                                                      enableGesture: true,
                                                      size: const Size(double.maxFinite, 50),
                                                      recorderController: recorderController,
                                                      waveStyle: const WaveStyle(waveColor: AppColors.backgroundPurple, extendWaveform: true, showMiddleLine: false),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: AppColors.clear),
                                                      padding: const EdgeInsets.only(left: 18),
                                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              // Bottom row: Delete, Pause/Resume, Send
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  // Delete
                                                  GestureDetector(
                                                    onTap: () async {
                                                      String? path = await recorderController.stop();

                                                      print("audio stopped path is :- $path");
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: SvgPicture.asset(
                                                        ImagePath.audio_delete,
                                                        colorFilter: const ColorFilter.mode(
                                                          AppColors.redText, // your desired color
                                                          BlendMode.srcIn, // ensures the color replaces the SVG content
                                                        ),
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  // Pause/Resume
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (recorderController.hasPermission) {
                                                        if (recorderController.recorderState == RecorderState.paused) {
                                                          recorderController.record();
                                                        } else {
                                                          recorderController.pause();
                                                        }
                                                      }
                                                    },
                                                    child: SvgPicture.asset((recorderController.recorderState == RecorderState.paused) ? ImagePath.start_recording : ImagePath.pause_recording, height: 32, width: 32),
                                                  ),
                                                  // Send
                                                  GestureDetector(onTap: () {}, child: SvgPicture.asset(ImagePath.sendMessage, height: 32, width: 32)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      // Input bar
                                      if (!_isRecording.value)
                                        Container(
                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD8DCE4), width: 1.5), borderRadius: BorderRadius.circular(15), color: Colors.white),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Expanded(child: TextField(controller: controller, focusNode: focusNode, decoration: InputDecoration(hintText: 'Type Something...', hintStyle: AppFonts.regular(14, AppColors.textDarkGrey), border: InputBorder.none), onSubmitted: (_) => _sendMessage())),
                                                      GestureDetector(
                                                        onTap: () {
                                                          recorderController.record(); // By default saves file with datetime as name.
                                                          _startRecording();
                                                        },
                                                        child: SvgPicture.asset(ImagePath.micRecordingModel, height: 22, width: 22),
                                                      ),
                                                      const SizedBox(width: 5),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // sendMessage
                                              GestureDetector(child: SvgPicture.asset(ImagePath.sendMessage, height: 45, width: 45)),
                                            ],
                                          ),
                                        ),
                                      Center(child: Text.rich(TextSpan(children: [TextSpan(text: 'Powered by ', style: AppFonts.regular(14, AppColors.textDarkGrey)), TextSpan(text: 'chatbot.ai', style: AppFonts.semiBold(14, AppColors.black))]))),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // Minimized bar
          if (isOpen.value && isMinimized.value)
            Positioned(
              bottom: 24,
              right: 24,
              child: GestureDetector(
                onTap: _minimizeChat,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: Colors.black26.withValues(alpha: 0.08), blurRadius: 8)]),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.chat_bubble_outline, color: Color(0xFF7C3AED)), SizedBox(width: 10), Text('Chat', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold))]),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  Widget _buildSettingsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Back button and title
        const SizedBox(height: 5),
        Row(
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                showSettings.value = false;
              },
              child: Padding(padding: const EdgeInsets.only(left: 10, top: 8, right: 8, bottom: 8), child: SvgPicture.asset(ImagePath.backSvg, height: 18, width: 18)),
            ),
            const SizedBox(width: 8),
            Text('Back', style: AppFonts.regular(14, AppColors.textBlackDark.withValues(alpha: 0.8))),
          ],
        ),
        const SizedBox(height: 5),
        // const Divider(height: 1),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), child: Text('Preferred Talkback', style: AppFonts.medium(16, AppColors.black))),
        // Grouped radio buttons in a container
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.black.withValues(alpha: 0.1), width: 1.2), borderRadius: BorderRadius.circular(14)), child: Column(children: [_buildRadioOption('Voice', 'voice_to_voice'), _buildRadioOption('Text', 'text_to_text')]))),
      ],
    );
  }

  Widget _buildRadioOption(String label, String value) {
    return ListTile(title: Text(label, style: AppFonts.regular(16, AppColors.textDarkGrey)), trailing: Radio<String>(value: value, groupValue: preferredTalkback.value, activeColor: AppColors.backgroundPurple, onChanged: (val) => setState(() => preferredTalkback.value = val!)), contentPadding: const EdgeInsets.symmetric(horizontal: 20), onTap: () => setState(() => preferredTalkback.value = value));
  }
}
