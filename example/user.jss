// ============================================================================
// Example user.js for Firefox
// Purpose: Improve privacy, security, and performance
// ============================================================================

// -------------------- Privacy Settings --------------------

// Disable telemetry and data collection
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);

// Disable crash reports
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);

// Disable Pocket integration
user_pref("extensions.pocket.enabled", false);

// -------------------- Security Settings --------------------

// Enable HTTPS-Only Mode
user_pref("dom.security.https_only_mode", true);

// Block dangerous downloads
user_pref("browser.safebrowsing.downloads.enabled", true);

// Disable insecure TLS versions
user_pref("security.tls.version.min", 3); // TLS 1.2 minimum

// -------------------- Tracking Protection --------------------

// Enable Enhanced Tracking Protection (Strict)
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.pbmode", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);

// -------------------- Performance Tweaks --------------------

// Reduce session restore writes to disk
user_pref("browser.sessionstore.interval", 300000); // 5 minutes

// Disable prefetching to save bandwidth and improve privacy
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.predictor.enabled", false);

// -------------------- Miscellaneous --------------------

// Disable autoplay of media
user_pref("media.autoplay.default", 5); // Block all autoplay
user_pref("media.autoplay.blocking_policy", 2);

// Set a custom homepage
user_pref("browser.startup.homepage", "https://example.com");

// ============================================================================
// End of example.user.js
// ============================================================================
