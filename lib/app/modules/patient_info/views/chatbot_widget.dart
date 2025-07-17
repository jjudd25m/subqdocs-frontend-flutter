import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs/app/models/audio_wave.dart';
import 'package:subqdocs/utils/app_colors.dart';
import 'package:subqdocs/utils/app_fonts.dart';
import 'package:subqdocs/utils/imagepath.dart';
import 'package:get/get.dart';
import 'package:subqdocs/app/core/common/global_controller.dart';

import '../../../../widget/base_image_view.dart';

class ChatBotWidget extends StatefulWidget {
  const ChatBotWidget({Key? key}) : super(key: key);

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  bool _isMinimized = false;
  bool _isRecording = false;
  bool _isPaused = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  int _recordSeconds = 0;
  String _voiceToTextResult = '';
  late AnimationController _glowController;

  // Add state for settings screen and preferred talkback
  bool _showSettings = false;
  String _preferredTalkback = 'voice_to_voice';

  // Demo static messages
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'bot', 'text': 'Good Morning 👋'},
    {'sender': 'bot', 'text': 'How does GPT use AI?'},
    {'sender': 'user', 'text': 'Tell me more!'},
  ];

  Timer? _waveSimTimer;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200), lowerBound: 0.7, upperBound: 1.0)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _toggleChat() => setState(() => _isOpen = !_isOpen);

  void _minimizeChat() => setState(() => _isMinimized = !_isMinimized);

  void _closeChat() => setState(() {
    _isOpen = false;
    _isMinimized = false;
  });

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
      _voiceToTextResult = '';
    });
    // Simulate amplitude data for demo/testing
    _waveSimTimer?.cancel();
    _waveSimTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      print('WaveSimTimer tick:  [32m${timer.tick} [0m'); // DEBUG
      bool isSpeaking = true; // Set to false to simulate silence
      if (isSpeaking) {
        setState(() {
          // _localWaveBars = List.generate(30, (i) => AudioWaveBar(heightFactor: 0.2 + 0.7 * (i % 2 == 0 ? (0.5 + 0.5 * (timer.tick % 3)) : (0.2 + 0.2 * (timer.tick % 5))), color: const Color(0xFF7C3AED)));
        });
      } else {
        setState(() {
          // _localWaveBars = List.generate(30, (i) => AudioWaveBar(heightFactor: 0.08, color: const Color(0xFF7C3AED)));
        });
      }
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _recordSeconds++;
        });
      }
    });
  }

  void _cancelRecording() {
    _timer?.cancel();
    _waveSimTimer?.cancel();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
      _voiceToTextResult = '';
      // _localWaveBars.clear();
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    _waveSimTimer?.cancel();
    setState(() {
      _isRecording = false;
      _voiceToTextResult = 'This is a sample voice to text message.';
      _controller.text = _voiceToTextResult;
      _recordSeconds = 0;
      // _localWaveBars.clear();
    });
    _focusNode.requestFocus();
  }

  void _pauseResumeRecording() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _sendRecording() {
    _timer?.cancel();
    _waveSimTimer?.cancel();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
      _voiceToTextResult = '';
      _isPaused = false;
      // _localWaveBars.clear();
    });
  }

  void _deleteRecording() {
    _timer?.cancel();
    _waveSimTimer?.cancel();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
      _voiceToTextResult = '';
      _isPaused = false;
      // _localWaveBars.clear();
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': _controller.text.trim()});
      _controller.clear();
      _voiceToTextResult = '';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
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
        decoration: BoxDecoration(color: isUser ? const Color(0xFF7C3AED) : Colors.grey[100], borderRadius: BorderRadius.circular(16), boxShadow: [if (!isUser) const BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Text(msg['text'] ?? '', style: TextStyle(color: isUser ? Colors.white : const Color(0xFF7C3AED), fontSize: 15)),
      ),
    );
  }

  double get _keyboardPadding => MediaQuery.of(context).viewInsets.bottom;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Floating button
        if (!_isOpen) Positioned(bottom: 24, right: 24, child: FloatingActionButton(backgroundColor: const Color(0xFF7C3AED), onPressed: _toggleChat, child: const Icon(Icons.chat_bubble_outline, color: Colors.white))),
        // Chat window
        if (_isOpen && !_isMinimized)
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
                  height: 480,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black26.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 8))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // HEADER SECTION
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        child: Row(
                          children: [
                            // Avatar and text
                            SvgPicture.asset(ImagePath.robot, height: 25, width: 25),
                            const SizedBox(width: 10),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Chatbot', style: AppFonts.medium(17, AppColors.black))]),
                            const Spacer(),
                            // Minimize and close buttons
                            IconButton(padding: EdgeInsets.zero, icon: Icon(Icons.remove, color: AppColors.black.withValues(alpha: 0.5)), onPressed: _minimizeChat, tooltip: 'Minimize'),
                            IconButton(padding: EdgeInsets.zero, icon: Icon(Icons.close, color: AppColors.black.withValues(alpha: 0.5)), onPressed: _closeChat, tooltip: 'Close'),
                          ],
                        ),
                      ),
                      Divider(height: 0.3, color: AppColors.black.withValues(alpha: 0.1)),
                      // User info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        child: Row(
                          children: [
                            GestureDetector(onTap: () async {}, child: ClipRRect(borderRadius: BorderRadius.circular(22), child: BaseImageView(imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDNH4yV8JgBa6G2XMCXzDJB6zP2edr2_VYPEp3QIkGLaUbswx_K5agwBAGP-zAowzoerw&usqp=CAU", width: 44, height: 44, nameLetters: "Kishan"))),
                            const SizedBox(width: 12),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Good Morning 👋', style: AppFonts.medium(17, AppColors.black)), const Text('Dr. Adrian Tinajero', style: TextStyle(fontSize: 13, color: Colors.black54))]),
                            const Spacer(),
                            GestureDetector(onTap: () => setState(() => _showSettings = true), child: SvgPicture.asset(ImagePath.setting_mobile, height: 25, width: 25)),
                          ],
                        ),
                      ),

                      Expanded(child: ListView.builder(controller: _scrollController, reverse: true, padding: const EdgeInsets.only(top: 8, bottom: 8), itemCount: _messages.length, itemBuilder: (context, i) => _buildMessage(_messages[_messages.length - 1 - i]))),
                      // AUDIO RECORDING BAR
                      if (_isRecording)
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
                                  Text(_formatDuration(_recordSeconds), style: const TextStyle(fontSize: 16, color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 12),
                                  // AudioWave visualization
                                  // Expanded(
                                  //   child: AudioWave(bars: _localWaveBars),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Bottom row: Delete, Pause/Resume, Send
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Delete
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                                    onPressed: _deleteRecording,
                                    tooltip: 'Delete',
                                  ),
                                  // Pause/Resume
                                  IconButton(
                                    icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause, color: const Color(0xFF7C3AED), size: 32),
                                    onPressed: _pauseResumeRecording,
                                    tooltip: _isPaused ? 'Resume' : 'Pause',
                                  ),
                                  // Send
                                  IconButton(
                                    icon: const Icon(Icons.send, color: Color(0xFF7C3AED), size: 28),
                                    onPressed: _sendRecording,
                                    tooltip: 'Send',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      // Input bar
                      if (!_isRecording)
                        Container(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(color: Color(0xFFD8DCE4), width: 1.5), borderRadius: BorderRadius.circular(15), color: Colors.white),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Expanded(child: TextField(controller: _controller, focusNode: _focusNode, decoration: const InputDecoration(hintText: 'Type Something...', border: InputBorder.none), onSubmitted: (_) => _sendMessage())), GestureDetector(onTap: _startRecording, child: SvgPicture.asset(ImagePath.micRecordingModel, height: 27, width: 27)), const SizedBox(width: 5)],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // sendMessage
                              GestureDetector(child: SvgPicture.asset(ImagePath.sendMessage, height: 45, width: 45)),
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
        if (_isOpen && _isMinimized)
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
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: Colors.black26.withOpacity(0.08), blurRadius: 8)]),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.chat_bubble_outline, color: Color(0xFF7C3AED)), SizedBox(width: 10), Text('Chat', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold))]),
                ),
              ),
            ),
          ),
        // In the main build, show settings screen if _showSettings is true
        if (_showSettings)
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
                  height: 340,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black26.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 8))]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Back button and title
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 8, right: 8, bottom: 8),
                        child: Row(children: [IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF7C3AED)), onPressed: () => setState(() => _showSettings = false), tooltip: 'Back'), const SizedBox(width: 8), const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF7C3AED)))]),
                      ),
                      const Divider(height: 1),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), child: Text('Preferred Talkback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey[800]))),
                      // Radio buttons
                      _buildRadioOption('Voice to Voice', 'voice_to_voice'),
                      _buildRadioOption('Voice to Text', 'voice_to_text'),
                      _buildRadioOption('Text to Text', 'text_to_text'),
                      _buildRadioOption('Text to Voice', 'text_to_voice'),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Widget _buildRadioOption(String label, String value) {
    return RadioListTile<String>(title: Text(label, style: const TextStyle(fontSize: 15)), value: value, groupValue: _preferredTalkback, activeColor: const Color(0xFF7C3AED), onChanged: (val) => setState(() => _preferredTalkback = val!), contentPadding: const EdgeInsets.symmetric(horizontal: 20));
  }
}
