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
    private var builtInKeywords: List<String> = listOf("porcupine")
        private var customKeywordPaths: List<String> = emptyList()
        private var isRunning = false
        
        fun setAccessKey(key: String) {
            accessKey = key
        }
        
        fun setBuiltInKeywords(keywords: List<String>) {
            builtInKeywords = keywords
            Log.d(TAG, "Built-in keywords set: $keywords")
        }
        
        fun setCustomKeywordPaths(paths: List<String>) {
            customKeywordPaths = paths
            Log.d(TAG, "Custom keyword paths set: $paths")
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
            .setContentText("Listening for 'help me' and emergency keywords...")
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
            
            // For "help me" English keyword, use default English model
            Log.i(TAG, "Using default English model for custom/built-in keywords")

            // Combine built-in keywords and custom keywords
            val allKeywordPaths = mutableListOf<String>()
            val allBuiltInKeywords = mutableListOf<Porcupine.BuiltInKeyword>()

            // Add built-in keywords
            if (builtInKeywords.isNotEmpty()) {
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
                allBuiltInKeywords.addAll(keywords)
                Log.d(TAG, "Added ${keywords.size} built-in keywords: $builtInKeywords")
            }

            // Add custom keywords
            if (customKeywordPaths.isNotEmpty()) {
                // We may receive any of the following variants from Dart:
                // 1. assets/keywords/filename.ppn
                // 2. keywords/filename.ppn (stripped 'assets/')
                // 3. flutter_assets/assets/keywords/filename.ppn (already prefixed)
                // Porcupine Java SDK cannot read directly from Flutter's compressed assets unless we give it
                // an asset-relative path that it can open via AssetManager OR an extracted filesystem path.
                // Empirically, due to Flutter placing all declared assets under assets/flutter_assets/, providing only
                // the relative key (e.g. assets/keywords/file.ppn) fails inside the Porcupine builder.
                // To make this robust across build variants (debug/release, obfuscation, split per ABI), we will:
                //  (a) attempt to open each candidate asset path via AssetManager with several prefixes
                //  (b) copy the asset to app's internal storage (filesDir) and pass the ABSOLUTE file path to Porcupine.
                // This avoids AssetManager path ambiguity and matches Porcupine's documented allowance for filesystem paths.

                val resolvedPaths = resolveAndMaterializeCustomKeywords(customKeywordPaths)
                allKeywordPaths.addAll(resolvedPaths)
                Log.d(TAG, "Resolved ${resolvedPaths.size} custom keyword file paths: $resolvedPaths")
            }

            // Determine target language from custom keyword filenames (defaults to English)
            val targetLanguage: String = when {
                customKeywordPaths.any { it.contains("_es_") || it.contains("/es/") } -> "es"
                customKeywordPaths.any { it.contains("_fr_") || it.contains("/fr/") } -> "fr"
                customKeywordPaths.any { it.contains("_de_") || it.contains("/de/") } -> "de"
                else -> "en" // default to English for "help me" and other keywords
            }

            // For English keywords (including "help me"), use default model
            if (targetLanguage == "en") {
                Log.d(TAG, "Using default English Porcupine model for 'help me' and other English keywords")
            } else {
                // Try to resolve a language-specific model for non-English keywords
                resolveAndSetModelForLanguage(builder, targetLanguage)
            }

            // Configure the builder based on what we have
            when {
                allBuiltInKeywords.isNotEmpty() && allKeywordPaths.isEmpty() -> {
                    // Only built-in keywords
                    builder.setKeywords(allBuiltInKeywords.toTypedArray())
                    Log.i(TAG, "Using only built-in keywords: ${allBuiltInKeywords.size}")
                }
                allKeywordPaths.isNotEmpty() && allBuiltInKeywords.isEmpty() -> {
                    // Only custom keywords
                    builder.setKeywordPaths(allKeywordPaths.toTypedArray())
                    Log.i(TAG, "Using only custom keywords: ${allKeywordPaths.size}")
                }
                allBuiltInKeywords.isNotEmpty() && allKeywordPaths.isNotEmpty() -> {
                    // Mixed keywords - unfortunately Porcupine doesn't support mixing built-in and custom
                    // So we'll prioritize custom keywords and log the limitation
                    builder.setKeywordPaths(allKeywordPaths.toTypedArray())
                    Log.w(TAG, "Mixed keywords detected. Using custom keywords (${allKeywordPaths.size}), built-in keywords ignored due to Porcupine limitation")
                }
                else -> {
                    // Fallback to default keywords
                    builder.setKeywords(arrayOf(Porcupine.BuiltInKeyword.PORCUPINE, Porcupine.BuiltInKeyword.PICOVOICE))
                    Log.w(TAG, "No keywords configured, using default: PORCUPINE, PICOVOICE")
                }
            }

            porcupine = builder.build(this)
            Log.i(TAG, "Porcupine initialized successfully")
        } catch (e: PorcupineException) {
            Log.e(TAG, "Failed to initialize Porcupine", e)
            throw e
        }
    }

    /**
     * Attempts to locate each provided custom keyword asset inside the Flutter asset bundle and copy
     * it into internal storage, returning absolute filesystem paths suitable for Porcupine.
     * Accepts flexible incoming path variants (with/without 'assets/' prefix, already prefixed, etc.).
     */
    private fun resolveAndMaterializeCustomKeywords(originalPaths: List<String>): List<String> {
        val assetManager = applicationContext.assets
        val outputPaths = mutableListOf<String>()

        for (rawPath in originalPaths) {
            try {
                val candidateVariants = buildList {
                    // Normalize input
                    val trimmed = rawPath.removePrefix("/")
                    // If already contains flutter_assets prefix, keep as-is
                    if (trimmed.startsWith("flutter_assets/")) add(trimmed)
                    // Common Flutter asset key forms
                    add(trimmed)
                    if (!trimmed.startsWith("assets/")) add("assets/$trimmed")
                    // Full path inside APK assets folder
                    add("flutter_assets/${trimmed}")
                    if (!trimmed.startsWith("assets/")) add("flutter_assets/assets/${trimmed}")
                }.distinct()

                var foundStream: java.io.InputStream? = null
                var usedVariant: String? = null
                var lastError: Exception? = null

                for (variant in candidateVariants) {
                    try {
                        foundStream = assetManager.open(variant)
                        usedVariant = variant
                        Log.d(TAG, "Successfully opened keyword asset variant: $variant")
                        break
                    } catch (e: Exception) {
                        lastError = e
                    }
                }

                if (foundStream == null) {
                    Log.e(TAG, "Failed to locate custom keyword asset: $rawPath. Tried: $candidateVariants", lastError)
                    continue
                }

                // Copy to internal storage (idempotent if unchanged by comparing sizes)
                val fileName = rawPath.substringAfterLast('/')
                val outFile = java.io.File(filesDir, fileName)
                var shouldCopy = true
                if (outFile.exists()) {
                    // quick size check to skip unnecessary overwrite
                    val existingSize = outFile.length()
                    val available = foundStream.available()
                    if (existingSize == available.toLong()) {
                        shouldCopy = false
                        Log.d(TAG, "Reusing existing extracted keyword file: ${outFile.absolutePath}")
                    }
                }
                if (shouldCopy) {
                    foundStream.use { input ->
                        java.io.FileOutputStream(outFile).use { output ->
                            input.copyTo(output)
                        }
                    }
                    Log.i(TAG, "Extracted keyword '${fileName}' from '$usedVariant' to '${outFile.absolutePath}'")
                }
                outputPaths.add(outFile.absolutePath)
            } catch (e: Exception) {
                Log.e(TAG, "Error processing custom keyword asset: $rawPath", e)
            }
        }

        if (outputPaths.isEmpty()) {
            Log.e(TAG, "No custom keyword files could be resolved. Porcupine will fail to start.")
        }
        return outputPaths
    }

    /**
     * Attempts to locate and extract a Porcupine model file for the given language code (e.g., "es").
     * Expected naming convention: porcupine_params_<lang>.pv (Picovoice standard) placed in Flutter assets.
     * If found, sets the model path on the provided builder. If not found, logs detailed guidance.
     */
    private fun resolveAndSetModelForLanguage(builder: Porcupine.Builder, languageCode: String) {
        val fileName = "porcupine_params_${languageCode}.pv"
        val assetCandidates = listOf(
            // Most common locations (developer should add one of these to pubspec assets)
            fileName,
            "assets/$fileName",
            "porcupine/$fileName",
            "assets/porcupine/$fileName",
            "models/$fileName",
            "assets/models/$fileName",
            // Flutter embedded prefixes
            "flutter_assets/$fileName",
            "flutter_assets/assets/$fileName",
            "flutter_assets/porcupine/$fileName",
            "flutter_assets/assets/porcupine/$fileName",
        ).distinct()

        val extracted = extractFirstMatchingAsset(assetCandidates, fileName)
        if (extracted != null) {
            Log.i(TAG, "Using ${languageCode.uppercase()} Porcupine model at: $extracted")
            builder.setModelPath(extracted)
        } else {
            Log.e(
                TAG,
                "Could not find language model '$fileName' for language '$languageCode'. " +
                        "Add it to pubspec assets and rebuild. Falling back to default English model which may cause a language mismatch."
            )
        }
    }

    /**
     * Tries each candidate asset key, extracting the first successful one into internal storage.
     */
    private fun extractFirstMatchingAsset(candidates: List<String>, outFileName: String): String? {
        val assetManager = applicationContext.assets
        var lastError: Exception? = null
        for (variant in candidates) {
            try {
                assetManager.open(variant).use { input ->
                    val outFile = java.io.File(filesDir, outFileName)
                    // Always overwrite to avoid stale model mismatches across updates
                    java.io.FileOutputStream(outFile).use { output -> input.copyTo(output) }
                    Log.d(TAG, "Extracted model asset variant: $variant -> ${outFile.absolutePath}")
                    return outFile.absolutePath
                }
            } catch (e: Exception) {
                lastError = e
            }
        }
        Log.w(TAG, "Model asset not found. Tried variants: $candidates", lastError)
        return null
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
            // For custom keywords, map based on the filename or order
            val customPath = customKeywordPaths.getOrNull(keywordIndex)
            when {
                customPath != null && customPath.contains("help-me") -> "help me"
                customPath != null && customPath.contains("b-chao") -> "b chao"
                keywordIndex == 0 -> "help me" // Default first custom keyword
                else -> "custom_keyword_$keywordIndex"
            }
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
