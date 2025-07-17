package com.example.subqdocs

import android.annotation.TargetApi
import android.bluetooth.BluetoothDevice
import android.content.*
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val METHOD_CHANNEL = "com.subqdocs/shared"
    private val EVENT_CHANNEL = "com.subqdocs/audioEvents"
    private var eventSink: EventChannel.EventSink? = null

    private lateinit var audioManager: AudioManager
    private var receiver: BroadcastReceiver? = null
    private var inputDeviceMap: Map<String, AudioDeviceInfo> = emptyMap()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager

        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAudioInputDevices" -> result.success(getAudioInputs())
                    "getActiveMicrophoneName" -> result.success(getActiveMicrophoneName())
                    "setPreferredAudioInput" -> {
                        val name = call.arguments as? String
                        result.success(name?.let { setPreferredAudioInput(it) } ?: false)
                    }

                    "startAudioRouteListening" -> {
                        startAudioRouteListening()
                        result.success(null)
                    }

                    "stopAudioRouteListening" -> {
                        stopAudioRouteListening()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }

            EventChannel(messenger, EVENT_CHANNEL).setStreamHandler(object :
                EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    private fun getAudioInputs(): List<String> {
        val devices = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            audioManager.getDevices(AudioManager.GET_DEVICES_INPUTS)
        } else emptyArray()

        inputDeviceMap = devices
            .distinctBy { it.productName.toString() }
            .associateBy { it.productName.toString() }

        return inputDeviceMap.keys.toList()
    }

    @TargetApi(Build.VERSION_CODES.M)
    private fun getActiveMicrophoneName(): String? {
        val devices = audioManager.getDevices(AudioManager.GET_DEVICES_INPUTS)

        // Prefer SCO if Bluetooth is on
        if (audioManager.isBluetoothScoOn) {
            val bt = devices.firstOrNull {
                it.type == AudioDeviceInfo.TYPE_BLUETOOTH_SCO
            }
            if (bt != null) return bt.productName.toString()
        }

        // Fallback to first available input
        return devices.firstOrNull()?.productName?.toString()
    }

    @TargetApi(Build.VERSION_CODES.M)
    private fun setPreferredAudioInput(portName: String): Boolean {
        val device = inputDeviceMap[portName] ?: run {
            Log.w("AudioInput", "Input not found: $portName")
            return false
        }

        return try {
            Log.d("AudioInput", "Switching to: $portName (${device.type})")
            when (device.type) {
                AudioDeviceInfo.TYPE_BLUETOOTH_SCO -> switchToBluetoothMic()
                else -> switchToBuiltInMic()
            }
            true
        } catch (e: Exception) {
            Log.e("AudioInput", "Error switching input: ${e.message}")
            false
        }
    }

    private fun startAudioRouteListening() {
        if (receiver != null) return

        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                when (intent?.action) {
                    AudioManager.ACTION_HEADSET_PLUG,
                    AudioManager.ACTION_AUDIO_BECOMING_NOISY -> {
                        eventSink?.success("audioDevicesChanged")
                    }

                    BluetoothDevice.ACTION_ACL_CONNECTED -> {
                        Log.d("AudioInput", "Bluetooth connected")
                        getAudioInputs()
                        switchToBluetoothMic()
                        eventSink?.success("bluetoothAudioDevicesChanged")
                    }

                    BluetoothDevice.ACTION_ACL_DISCONNECTED -> {
                        Log.d("AudioInput", "Bluetooth disconnected")

                        getAudioInputs() // refresh map
                        switchToBuiltInMic()
                        eventSink?.success("bluetoothAudioDevicesChanged")
                    }
                }
            }
        }

        val filter = IntentFilter().apply {
            addAction(AudioManager.ACTION_HEADSET_PLUG)
            addAction(AudioManager.ACTION_AUDIO_BECOMING_NOISY)
            addAction(BluetoothDevice.ACTION_ACL_CONNECTED)
            addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED)
        }

        registerReceiver(receiver, filter)
    }

    private fun stopAudioRouteListening() {
        receiver?.let {
            unregisterReceiver(it)
            receiver = null
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    private fun switchToBluetoothMic() {
        val device = inputDeviceMap.entries.firstOrNull {
            it.value.type == AudioDeviceInfo.TYPE_BLUETOOTH_SCO
        }

        if (device != null) {
            Log.d("AudioInput", "Switching to Bluetooth SCO: ${device.key}")
            try {
                audioManager.startBluetoothSco()
                audioManager.isBluetoothScoOn = true
            } catch (e: Exception) {
                Log.e("AudioInput", "Failed to start SCO: ${e.message}")
            }
        } else {
            Log.w("AudioInput", "No Bluetooth SCO device found")
        }
    }

    private fun switchToBuiltInMic() {
        try {
            if (audioManager.isBluetoothScoOn) {
                audioManager.stopBluetoothSco()
                audioManager.isBluetoothScoOn = false
            }
            audioManager.mode = AudioManager.MODE_NORMAL
            audioManager.isSpeakerphoneOn = true
            Log.d("AudioInput", "Switched to built-in mic")
        } catch (e: Exception) {
            Log.e("AudioInput", "Error switching to built-in mic: ${e.message}")
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopAudioRouteListening()
    }
}
