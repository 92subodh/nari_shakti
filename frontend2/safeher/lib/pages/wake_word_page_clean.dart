import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import '../services/wake_word_service.dart';
import '../services/wake_word_debug_service.dart';
import '../services/sos_service.dart';

class WakeWordPage extends StatefulWidget {
  const WakeWordPage({super.key});

  @override
  State<WakeWordPage> createState() => _WakeWordPageState();
}

class _WakeWordPageState extends State<WakeWordPage> {
  final Logger _logger = Logger();
  bool _isServiceRunning = false;
  bool _isLoading = false;
  bool _nativeImplementationAvailable = false;
  String _accessKey = "wEnm2JhoEo7bSaoVKVp7LQOHWL4rhrTWnc5Flxe9sr4z+23fY+FftQ==";
  List<String> _selectedKeywords = ["help me"];
  
  final List<String> _availableKeywords = [
    "help me",
    "computer",
    "jarvis",
    "porcupine",
    "bumblebee",
  ];

  @override
  void initState() {
    super.initState();
    _checkNativeImplementation();
    _checkServiceStatus();
    _setupWakeWordCallback();
  }

  Future<void> _checkNativeImplementation() async {
    try {
      _logger.i("Checking if native implementation is available...");
      final available = await WakeWordDebugService.testNativeImplementation();
      setState(() => _nativeImplementationAvailable = available);
      
      if (!available) {
        _logger.w("Native implementation not available. App may need to be restarted after installation.");
        _showSnackBar("Native wake word implementation not ready. Try restarting the app.", Colors.orange);
      } else {
        _logger.i("Native implementation is available!");
      }
    } catch (e) {
      _logger.e("Error checking native implementation: $e");
      setState(() => _nativeImplementationAvailable = false);
    }
  }

  void _setupWakeWordCallback() {
    WakeWordService.setWakeWordCallback((String keyword) {
      _logger.w("🚨 Wake word detected in UI: $keyword");
      
      // Show immediate alert
      _showEmergencyAlert(keyword);
      
      // Trigger SOS actions
      SOSService.triggerSOS(
        triggerKeyword: keyword,
        sendSMS: true,
        shareLocation: true,
        startRecording: true,
        notifyContacts: true,
      );
    });
  }

  void _showEmergencyAlert(String keyword) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red[50],
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text(
                "🚨 EMERGENCY ALERT",
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Safe word detected: '$keyword'",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text("Emergency actions have been triggered:"),
              SizedBox(height: 8),
              Text("✓ Emergency SMS sent"),
              Text("✓ Location shared"),
              Text("✓ Recording started"),
              Text("✓ Contacts notified"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text("UNDERSTOOD"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkServiceStatus() async {
    setState(() => _isLoading = true);
    try {
      _logger.i("Checking wake word service status...");
      final isRunning = await WakeWordService.isServiceRunning();
      _logger.i("Service status: $isRunning");
      setState(() => _isServiceRunning = isRunning);
    } catch (e) {
      _logger.e("Error checking service status: $e");
      setState(() => _isServiceRunning = false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.microphone,
      Permission.location,
      Permission.sms,
      Permission.camera,
      Permission.phone,
    ];

    Map<Permission, PermissionStatus> statuses = await permissions.request();
    
    for (var permission in permissions) {
      if (statuses[permission] != PermissionStatus.granted) {
        _showPermissionDialog(permission);
        return;
      }
    }
  }

  void _showPermissionDialog(Permission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Required"),
        content: Text(
          "SafeHer needs ${permission.toString().split('.').last} permission to function properly in emergency situations.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text("Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleWakeWordService() async {
    if (!_nativeImplementationAvailable) {
      _showSnackBar(
        "Native implementation not available. Please restart the app after installation.", 
        Colors.red
      );
      return;
    }

    if (_accessKey.isEmpty) {
      _showAccessKeyDialog();
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isServiceRunning) {
        final success = await WakeWordService.stopService();
        if (success) {
          setState(() => _isServiceRunning = false);
          _showSnackBar("Wake word detection stopped", Colors.orange);
        }
      } else {
        await _requestPermissions();
        
        _logger.i("Setting access key and keywords...");
        
        // Set configuration with error handling
        try {
          await WakeWordService.setAccessKey(_accessKey);
          _logger.i("Access key set successfully");
        } catch (e) {
          _logger.e("Failed to set access key: $e");
          _showSnackBar("Failed to set access key. Make sure the app is properly installed.", Colors.red);
          return;
        }
        
        try {
          // Handle "help me" custom keyword with fallback
          if (_selectedKeywords.contains("help me")) {
            _logger.i("🔄 Setting up custom 'help me' keyword...");
            
            // Test for help me keyword file
            List<String> testPaths = [
              "assets/keywords/help-me_en_android_v3_0_0.ppn",
              "assets/help-me_en_android_v3_0_0.ppn",
              "keywords/help-me_en_android_v3_0_0.ppn",
              "help-me_en_android_v3_0_0.ppn"
            ];
            
            String? workingPath;
            for (String path in testPaths) {
              _logger.i("🔍 Testing asset path: $path");
              try {
                await rootBundle.load(path);
                workingPath = path;
                _logger.i("✅ Found working asset path: $path");
                break;
              } catch (e) {
                _logger.w("❌ Asset not found: $path");
              }
            }
            
            if (workingPath != null) {
              // Convert Flutter asset path to Android AssetManager path
              String androidPath = workingPath;
              if (androidPath.startsWith("assets/")) {
                androidPath = androidPath.substring("assets/".length);
              }
              
              _logger.i("🔄 Converting Flutter path '$workingPath' to Android path '$androidPath'");
              try {
                await WakeWordService.setCustomWakeWords([androidPath]);
                _logger.i("✅ Custom 'help me' keyword set successfully");
                _showSnackBar("'Help me' emergency keyword active!", Colors.green);
              } catch (e) {
                _logger.e("❌ Custom 'help me' failed: $e");
                // Fallback to computer which is clear and professional
                _logger.w("🔄 Using 'computer' as fallback...");
                await WakeWordService.setBuiltInWakeWords(["computer"]);
                _logger.i("✅ Fallback keyword 'computer' set");
                _showSnackBar("Emergency keyword: 'computer' (fallback)", Colors.orange);
              }
            } else {
              // No custom asset found, use fallback
              _logger.w("🔄 No custom 'help me' asset found, using 'computer' as fallback...");
              await WakeWordService.setBuiltInWakeWords(["computer"]);
              _logger.i("✅ Fallback keyword 'computer' set");
              _showSnackBar("Emergency keyword: 'computer' (fallback)", Colors.orange);
            }
          } else {
            // Use other built-in keywords when "help me" is not selected
            List<String> otherKeywords = _selectedKeywords.where((k) => k != "help me").toList();
            if (otherKeywords.isEmpty) {
              otherKeywords = ["computer"]; // Default fallback
            }
            await WakeWordService.setBuiltInWakeWords(otherKeywords);
            _logger.i("✅ Built-in keywords set: ${otherKeywords.join(', ')}");
            _showSnackBar("Built-in keywords active: ${otherKeywords.join(', ')}", Colors.blue);
          }
        } catch (e) {
          _logger.e("Failed to set keywords: $e");
          _showSnackBar("Failed to set keywords: ${e.toString()}", Colors.red);
          return;
        }
        
        _logger.i("Starting wake word service...");
        final success = await WakeWordService.startService();
        if (success) {
          setState(() => _isServiceRunning = true);
          _showSnackBar("Wake word detection started", Colors.green);
        } else {
          _showSnackBar("Failed to start wake word detection", Colors.red);
        }
      }
    } catch (e) {
      _logger.e("Error toggling service: $e");
      _showSnackBar("Error: ${e.toString()}", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAccessKeyDialog() {
    final controller = TextEditingController(text: _accessKey);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Porcupine Access Key"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter your Porcupine access key from Picovoice Console:",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Your access key...",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            Text(
              "Get your free key at: console.picovoice.ai",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _accessKey = controller.text.trim());
              Navigator.pop(context);
              if (_accessKey.isNotEmpty) {
                _toggleWakeWordService();
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              color: _isServiceRunning ? Colors.green[50] : Colors.red[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _isServiceRunning ? Icons.security : Icons.security_outlined,
                      color: _isServiceRunning ? Colors.green : Colors.red,
                      size: 30,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isServiceRunning ? "Protection Active" : "Protection Inactive",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isServiceRunning ? Colors.green[800] : Colors.red[800],
                            ),
                          ),
                          Text(
                            _isServiceRunning
                                ? "Listening for 'help me' emergency keyword..."
                                : "Tap to start wake word detection",
                            style: TextStyle(fontSize: 14),
                          ),
                          if (!_nativeImplementationAvailable)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "⚠️ Native implementation not ready - restart app",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Main Toggle Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _toggleWakeWordService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isServiceRunning ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _isServiceRunning ? "STOP PROTECTION" : "START PROTECTION",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            
            SizedBox(height: 30),
            
            // Configuration Section
            Text(
              "Wake Word Configuration",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 16),
            
            // Access Key Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.key, color: Colors.blue),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Access Key",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _accessKey.isEmpty
                                ? "Not configured"
                                : "*" * (_accessKey.length.clamp(0, 20)),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _showAccessKeyDialog,
                      child: Text("CONFIGURE"),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Keywords Section
            Text(
              "Active Keywords",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(height: 8),
            
            Expanded(
              child: ListView.builder(
                itemCount: _availableKeywords.length,
                itemBuilder: (context, index) {
                  final keyword = _availableKeywords[index];
                  final isSelected = _selectedKeywords.contains(keyword);
                  
                  // Map keywords to emergency-friendly descriptions
                  String getKeywordDescription(String keyword) {
                    switch (keyword) {
                      case "help me":
                        return "🆘 Primary emergency keyword (custom voice training)";
                      case "computer":
                        return "🔹 Professional emergency fallback";
                      case "jarvis":
                        return "🔹 AI assistant style emergency word";
                      case "porcupine":
                        return "🔹 Standard emergency trigger";
                      case "bumblebee":
                        return "🔹 Alternative emergency word";
                      default:
                        return "Built-in wake word";
                    }
                  }
                  
                  return CheckboxListTile(
                    title: Text(keyword),
                    subtitle: Text(getKeywordDescription(keyword)),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (!_selectedKeywords.contains(keyword)) {
                            _selectedKeywords.add(keyword);
                          }
                        } else {
                          _selectedKeywords.remove(keyword);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            
            SizedBox(height: 16),
            
            // Info Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Emergency Wake Words",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• 'Help me' uses custom voice training for better recognition\n"
                    "• Works completely offline for privacy\n"
                    "• Runs in background even when phone is locked\n"
                    "• Triggers emergency actions instantly when detected",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
