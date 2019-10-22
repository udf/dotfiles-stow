// select words when double clicking in url bar
user_pref("browser.urlbar.doubleClickSelectsAll", false);

// highlight ctrl+f searches
user_pref("findbar.highlightAll", true);

// smooth scroll
user_pref("general.smoothScroll.lines.durationMaxMS", 50);
user_pref("general.smoothScroll.lines.durationMinMS", 50);
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 250);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 50);
user_pref("general.smoothScroll.currentVelocityWeighting", 0);
user_pref("mousewheel.min_line_scroll_amount", 25);
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 128);

// disable about:config warning
user_pref("general.warnOnAboutConfig", false);

// use light gtk theme for content (fixes broken websites)
user_pref("widget.content.gtk-theme-override", "Arc");

// don't lazy-load tabs on startup
user_pref("browser.sessionstore.restore_on_demand", false);

// kill Pocket
user_pref("extensions.pocket.enabled", false);

// remove the full screen warning
user_pref("full-screen-api.warning.timeout", 0);

// tracking shit
user_pref("security.ssl.disable_session_identifiers", true);

// go fast
user_pref("gfx.webrender.all", true);
user_pref("layers.acceleration.force-enabled", true);
user_pref("gfx.canvas.azure.accelerated", true);
user_pref("gfx.xrender.enabled", false);

// enable magnet links
user_pref("network.protocol-handler.expose.magnet", false);

// sync more often (seconds)
user_pref("services.sync.scheduler.activeInterval", 60);

// disable shitty ctrl+tab carousel
user_pref("browser.ctrlTab.recentlyUsedOrder", false);

// don't ask to save logins
user_pref("signon.rememberSignons", false);

// enable user css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
