package com.enya.gitarre_leicht

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbConstants
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Build
import android.os.Handler
import android.os.HandlerThread
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.concurrent.atomic.AtomicBoolean

class MainActivity : FlutterActivity() {

    companion object {
        private const val METHOD_CHANNEL = "com.enya.gitarre_leicht/audio_input"
        private const val AUDIO_EVENT_CHANNEL = "com.enya.gitarre_leicht/audio_input/stream"
        private const val USB_EVENT_CHANNEL = "com.enya.gitarre_leicht/usb/events"
    }

    private val mainHandler = Handler(Looper.getMainLooper())

    private var captureThread: HandlerThread? = null
    private var captureHandler: Handler? = null
    private var audioRecord: AudioRecord? = null
    private val isCapturing = AtomicBoolean(false)

    private var audioEventSink: EventChannel.EventSink? = null
    private var usbEventSink: EventChannel.EventSink? = null

    private var usbReceiver: BroadcastReceiver? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(AudioInputPlugin())

        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "isUsbAudioConnected" -> result.success(isUsbAudioConnected())
                    "getUsbAudioDeviceInfo" -> result.success(getUsbAudioDeviceInfo())
                    "startAudioCapture" -> {
                        val sampleRate = (call.argument<Int>("sampleRate")) ?: 44100
                        val bufferSize = (call.argument<Int>("bufferSize")) ?: 1024
                        val sourceType = call.argument<String>("sourceType") ?: "mic"
                        startAudioCapture(sampleRate, bufferSize, sourceType)
                        result.success(true)
                    }
                    "stopAudioCapture" -> {
                        stopAudioCapture()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Throwable) {
                result.error("NATIVE_ERROR", e.message, null)
            }
        }

        EventChannel(messenger, AUDIO_EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                audioEventSink = events
            }
            override fun onCancel(arguments: Any?) {
                audioEventSink = null
            }
        })

        EventChannel(messenger, USB_EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                usbEventSink = events
                registerUsbReceiver()
            }
            override fun onCancel(arguments: Any?) {
                usbEventSink = null
                unregisterUsbReceiver()
            }
        })
    }

    // ---------- USB detection ----------

    private fun isAudioDevice(device: UsbDevice): Boolean {
        for (i in 0 until device.interfaceCount) {
            val iface = device.getInterface(i)
            if (iface.interfaceClass == UsbConstants.USB_CLASS_AUDIO) {
                return true
            }
        }
        return false
    }

    private fun isUsbAudioConnected(): Boolean {
        val manager = getSystemService(Context.USB_SERVICE) as? UsbManager ?: return false
        val devices = manager.deviceList ?: return false
        return devices.values.any { isAudioDevice(it) }
    }

    private fun deviceToMap(device: UsbDevice): Map<String, Any?> {
        val map = HashMap<String, Any?>()
        map["vendorId"] = device.vendorId
        map["productId"] = device.productId
        map["deviceName"] = device.deviceName
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            map["productName"] = device.productName
            map["manufacturerName"] = device.manufacturerName
        } else {
            map["productName"] = null
            map["manufacturerName"] = null
        }
        return map
    }

    private fun getUsbAudioDeviceInfo(): Map<String, Any?>? {
        val manager = getSystemService(Context.USB_SERVICE) as? UsbManager ?: return null
        val devices = manager.deviceList ?: return null
        val audio = devices.values.firstOrNull { isAudioDevice(it) } ?: return null
        return deviceToMap(audio)
    }

    // ---------- USB broadcast ----------

    private fun registerUsbReceiver() {
        if (usbReceiver != null) return
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val action = intent?.action ?: return
                val device = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    intent.getParcelableExtra(UsbManager.EXTRA_DEVICE, UsbDevice::class.java)
                } else {
                    @Suppress("DEPRECATION")
                    intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
                }
                when (action) {
                    UsbManager.ACTION_USB_DEVICE_ATTACHED -> {
                        val map = HashMap<String, Any?>()
                        map["connected"] = true
                        map["device"] = device?.let { deviceToMap(it) }
                        mainHandler.post { usbEventSink?.success(map) }
                    }
                    UsbManager.ACTION_USB_DEVICE_DETACHED -> {
                        val map = HashMap<String, Any?>()
                        map["connected"] = false
                        map["device"] = device?.let { deviceToMap(it) }
                        mainHandler.post { usbEventSink?.success(map) }
                    }
                }
            }
        }
        val filter = IntentFilter().apply {
            addAction(UsbManager.ACTION_USB_DEVICE_ATTACHED)
            addAction(UsbManager.ACTION_USB_DEVICE_DETACHED)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(receiver, filter)
        }
        usbReceiver = receiver
    }

    private fun unregisterUsbReceiver() {
        usbReceiver?.let {
            try { unregisterReceiver(it) } catch (_: Throwable) {}
        }
        usbReceiver = null
    }

    // ---------- Audio capture ----------

    private fun startAudioCapture(sampleRate: Int, bufferSize: Int, sourceType: String) {
        if (isCapturing.get()) return

        val audioSource = if (sourceType == "mic") {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                MediaRecorder.AudioSource.UNPROCESSED
            } else {
                MediaRecorder.AudioSource.VOICE_RECOGNITION
            }
        } else {
            // USB-Audio: AudioRecord uses system default which becomes USB when attached.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                MediaRecorder.AudioSource.UNPROCESSED
            } else {
                MediaRecorder.AudioSource.MIC
            }
        }

        val channelConfig = AudioFormat.CHANNEL_IN_MONO
        val encoding = AudioFormat.ENCODING_PCM_16BIT
        val minBuffer = AudioRecord.getMinBufferSize(sampleRate, channelConfig, encoding)
        if (minBuffer == AudioRecord.ERROR || minBuffer == AudioRecord.ERROR_BAD_VALUE) {
            mainHandler.post {
                audioEventSink?.error("AUDIO_INIT", "Invalid AudioRecord configuration", null)
            }
            return
        }
        val nativeBuffer = maxOf(minBuffer, bufferSize * 2 * 4)

        val record = try {
            AudioRecord(audioSource, sampleRate, channelConfig, encoding, nativeBuffer)
        } catch (e: Throwable) {
            mainHandler.post {
                audioEventSink?.error("AUDIO_INIT", e.message, null)
            }
            return
        }

        if (record.state != AudioRecord.STATE_INITIALIZED) {
            record.release()
            mainHandler.post {
                audioEventSink?.error("AUDIO_INIT", "AudioRecord not initialized", null)
            }
            return
        }

        audioRecord = record

        val thread = HandlerThread("AudioCaptureThread")
        thread.start()
        captureThread = thread
        captureHandler = Handler(thread.looper)

        isCapturing.set(true)
        record.startRecording()

        captureHandler?.post {
            try {
                val shortBuf = ShortArray(bufferSize)
                val byteBuffer = ByteBuffer.allocateDirect(bufferSize * 4).order(ByteOrder.LITTLE_ENDIAN)
                while (isCapturing.get()) {
                    val read = record.read(shortBuf, 0, bufferSize)
                    if (read <= 0) continue
                    byteBuffer.clear()
                    for (i in 0 until read) {
                        byteBuffer.putFloat(shortBuf[i] / 32768.0f)
                    }
                    byteBuffer.flip()
                    val outBytes = ByteArray(byteBuffer.remaining())
                    byteBuffer.get(outBytes)
                    mainHandler.post {
                        audioEventSink?.success(outBytes)
                    }
                }
            } catch (e: Throwable) {
                mainHandler.post {
                    audioEventSink?.error("AUDIO_CAPTURE", e.message, null)
                }
            }
        }
    }

    private fun stopAudioCapture() {
        if (!isCapturing.getAndSet(false)) {
            // ensure cleanup anyway
        }
        try {
            audioRecord?.stop()
        } catch (_: Throwable) {}
        try {
            audioRecord?.release()
        } catch (_: Throwable) {}
        audioRecord = null

        captureThread?.quitSafely()
        captureThread = null
        captureHandler = null
    }

    override fun onDestroy() {
        try { stopAudioCapture() } catch (_: Throwable) {}
        try { unregisterUsbReceiver() } catch (_: Throwable) {}
        super.onDestroy()
    }
}
