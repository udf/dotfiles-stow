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
user_pref("ui.systemUsesDarkTheme", 1);

// lazy-load tabs on startup
user_pref("browser.sessionstore.restore_on_demand", true);

// kill Pocket
user_pref("extensions.pocket.enabled", false);

// remove the full screen warning
user_pref("full-screen-api.warning.timeout", 0);

// tracking shit
user_pref("security.ssl.disable_session_identifiers", true);

// mozilla is my favourite ad company
user_pref("dom.private-attribution.submission.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.ping-centre.telemetry", false);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.sessions.current.clean", true);
user_pref("devtools.onboarding.telemetry.logged", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.hybridContent.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.prompted", 2);
user_pref("toolkit.telemetry.rejected", true);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.server", "");
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.unifiedIsOptIn", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);

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

// why
user_pref("browser.quitShortcut.disabled", true);

// im already deaf
user_pref("media.default_volume", 0.07);

// increase history retention
user_pref("places.history.expiration.max_pages", 999999999);

// change ctrl+f colours to the best ones
user_pref("ui.textHighlightBackground", "#F5A9B8");
user_pref("ui.textHighlightForeground", "#000000");
user_pref("ui.textSelectAttentionBackground", "#5BCEFA");
user_pref("ui.textSelectAttentionForeground", "#000000");
