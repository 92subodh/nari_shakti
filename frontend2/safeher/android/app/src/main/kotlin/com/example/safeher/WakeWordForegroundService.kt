package com.example.safeher

import android.app.*
import android.content.Intent
import android.os.IBinder
import android.media.AudioRecord
import android.media.MediaRecorder
import android.media.AudioFormat
import android.util.Log
import android.os.Build
import androidx.core.app.NotificationCompat
import ai.picovoice.porcupine.*
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlin.coroutines.coroutineContext

class WakeWordForegroundService : Service() {
    
    companion object {
        private const val TAG = "WakeWordService"
        private const val NOTIFICATION_ID = 1
        private const val CHANNEL_ID = "WakeWordServiceChannel"
        
        // Static variables to hold configuration
        private var accessKey: String = ""
        private var builtInKeywords: List<String> = listOf("porcupine", "hey pico")
        private var customKeywordPaths: List<String> = emptyList()
        private var isRunning = false
        
        fun setAccessKey(key: String) {
            accessKey = key
        }
        
        fun setBuiltInKeywords(keywords: List<String>) {
            builtInKeywords = keywords
        }
        
        fun setCustomKeywordPaths(paths: List<String>) {
            customKeywordPaths = paths
        }
        
        fun isServiceRunning(): Boolean {
            return isRunning
        }
    }

    private var porcupine: Porcupine? = null
    private var audioRecord: AudioRecord? = null
    private var detectionJob: Job? = null
    private val serviceScope = CoroutineScope(Dispatchers.Default + SupervisorJob())

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, createNotification())
        Log.d(TAG, "WakeWordForegroundService created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            "START_SERVICE" -> {
                if (!isRunning) {
                    startWakeWordDetection()
                }
            }
            "STOP_SERVICE" -> {
                stopWakeWordDetection()
                stopSelf()
            }
        }
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        stopWakeWordDetection()
        serviceScope.cancel()
        Log.d(TAG, "WakeWordForegroundService destroyed")
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "SafeHer Wake Word Detection",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Listens for emergency safe words"
                setSound(null, null)
                enableVibration(false)
            }
            
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("SafeHer Protection Active")
            .setContentText("Listening for emergency keywords...")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
    }

    private fun startWakeWordDetection() {
        if (isRunning) {
            Log.w(TAG, "Wake word detection already running")
            return
        }

        if (accessKey.isEmpty()) {
            Log.e(TAG, "Access key not set. Cannot start wake word detection.")
            return
        }

        try {
            initializePorcupine()
            startAudioRecording()
            isRunning = true
            Log.i(TAG, "Wake word detection started successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start wake word detection", e)
            stopWakeWordDetection()
        }
    }

    private fun initializePorcupine() {
        try {
            val builder = Porcupine.Builder().setAccessKey(accessKey)

            if (customKeywordPaths.isNotEmpty()) {
                // Use custom keyword files
                builder.setKeywordPaths(customKeywordPaths.toTypedArray())
            } else {
                // Use built-in keywords
                val keywords = builtInKeywords.mapNotNull { keyword ->
                    when (keyword.lowercase()) {
                        "porcupine" -> Porcupine.BuiltInKeyword.PORCUPINE
                        "picovoice" -> Porcupine.BuiltInKeyword.PICOVOICE
                        "bumblebee" -> Porcupine.BuiltInKeyword.BUMBLEBEE
                        "alexa" -> Porcupine.BuiltInKeyword.ALEXA
                        "americano" -> Porcupine.BuiltInKeyword.AMERICANO
                        "blueberry" -> Porcupine.BuiltInKeyword.BLUEBERRY
                        "computer" -> Porcupine.BuiltInKeyword.COMPUTER
                        "grapefruit" -> Porcupine.BuiltInKeyword.GRAPEFRUIT
                        "grasshopper" -> Porcupine.BuiltInKeyword.GRASSHOPPER
                        "hey google" -> Porcupine.BuiltInKeyword.HEY_GOOGLE
                        "hey siri" -> Porcupine.BuiltInKeyword.HEY_SIRI
                        "jarvis" -> Porcupine.BuiltInKeyword.JARVIS
                        "ok google" -> Porcupine.BuiltInKeyword.OK_GOOGLE
                        "terminator" -> Porcupine.BuiltInKeyword.TERMINATOR
                        else -> {
                            Log.w(TAG, "Unknown built-in keyword: $keyword")
                            null
                        }
                    }
                }

                if (keywords.isNotEmpty()) {
                    builder.setKeywords(keywords.toTypedArray())
                } else {
                    // Fallback to default keywords
                    builder.setKeywords(arrayOf(Porcupine.BuiltInKeyword.PORCUPINE, Porcupine.BuiltInKeyword.PICOVOICE))
                }
            }

            porcupine = builder.build(this)
            Log.i(TAG, "Porcupine initialized successfully")
        } catch (e: PorcupineException) {
            Log.e(TAG, "Failed to initialize Porcupine", e)
            throw e
        }
    }

    private fun startAudioRecording() {
        val porcupine = this.porcupine ?: throw IllegalStateException("Porcupine not initialized")
        
        val bufferSize = porcupine.getFrameLength() * 2 // 2 bytes per sample (16-bit)
        
        audioRecord = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            porcupine.getSampleRate(),
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
            bufferSize
        )

        if (audioRecord?.state != AudioRecord.STATE_INITIALIZED) {
            throw RuntimeException("Failed to initialize AudioRecord")
        }

        audioRecord?.startRecording()
        Log.i(TAG, "Audio recording started")

        // Start detection in coroutine
        detectionJob = serviceScope.launch {
            detectWakeWords()
        }
    }

    private suspend fun detectWakeWords() {
        val porcupine = this.porcupine ?: return
        val audioRecord = this.audioRecord ?: return
        
        val buffer = ShortArray(porcupine.getFrameLength())
        
        try {
            while (isRunning && coroutineContext.isActive) {
                val bytesRead = audioRecord.read(buffer, 0, buffer.size)
                
                if (bytesRead > 0) {
                    val keywordIndex = porcupine.process(buffer)
                    
                    if (keywordIndex >= 0) {
                        Log.i(TAG, "🚨 Wake word detected! Index: $keywordIndex")
                        onWakeWordDetected(keywordIndex)
                    }
                }
                
                // Small delay to prevent excessive CPU usage
                delay(10)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in wake word detection loop", e)
        }
    }

    private fun onWakeWordDetected(keywordIndex: Int) {
        Log.i(TAG, "🔊 Processing wake word detection for index: $keywordIndex")
        
        // Determine which keyword was detected
        val detectedKeyword = if (customKeywordPaths.isNotEmpty()) {
            "custom_keyword_$keywordIndex"
        } else {
            builtInKeywords.getOrNull(keywordIndex) ?: "unknown_keyword"
        }
        
        Log.w(TAG, "🚨 EMERGENCY KEYWORD DETECTED: $detectedKeyword")
        
        // Update notification to show detection
        val notificationManager = getSystemService(NotificationManager::class.java)
        val alertNotification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("🚨 EMERGENCY DETECTED!")
            .setContentText("Safe word '$detectedKeyword' triggered")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .build()
        
        notificationManager.notify(NOTIFICATION_ID + 1, alertNotification)
        
        // TODO: Send callback to Flutter app
        // This would typically use a MethodChannel callback or broadcast
        triggerSOSActions(detectedKeyword)
    }

    private fun triggerSOSActions(keyword: String) {
        Log.i(TAG, "🚨 Triggering SOS actions for keyword: $keyword")
        
        // For now, just log the action
        // In a real implementation, this could:
        // 1. Send SMS to emergency contacts
        // 2. Share location
        // 3. Start recording
        // 4. Call emergency services
        // 5. Send push notifications
        
        // Example: Start emergency recording
        startEmergencyRecording()
        
        // Example: Send location update
        sendLocationUpdate()
    }

    private fun startEmergencyRecording() {
        Log.i(TAG, "📹 Starting emergency recording...")
        // TODO: Implement emergency recording
    }

    private fun sendLocationUpdate() {
        Log.i(TAG, "📍 Sending location update...")
        // TODO: Implement location sharing
    }

    private fun stopWakeWordDetection() {
        isRunning = false
        
        detectionJob?.cancel()
        detectionJob = null
        
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
        
        porcupine?.delete()
        porcupine = null
        
        Log.i(TAG, "Wake word detection stopped")
    }
}
