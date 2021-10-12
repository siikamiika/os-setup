// ---------------------
// quit protection
// ---------------------
user_pref("browser.sessionstore.warnOnQuit", true);
user_pref("browser.showQuitWarning", true);
user_pref("browser.tabs.warnOnClose", true);


// ---------------------
// ui
// ---------------------
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.uidensity", 1);
user_pref("toolkit.cosmeticAnimations.enabled", false);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("ui.prefersReducedMotion", 1);


// ---------------------
// language
// ---------------------
user_pref("intl.accept_languages", "en-US, en");
user_pref("intl.locale.requested", "ja");


// ---------------------
// fonts
// ---------------------
user_pref("font.language.group", "ja");
user_pref("font.name.monospace.ja", "Sarasa Term J");
user_pref("font.name.monospace.zh-CN", "Noto Sans Mono CJK SC");
user_pref("font.name.monospace.zh-HK", "Noto Sans Mono CJK TC");
user_pref("font.name.monospace.zh-TW", "Noto Sans Mono CJK TC");
user_pref("font.name.sans-serif.ja", "Noto Sans CJK JP");
user_pref("font.name.sans-serif.zh-CN", "Noto Sans CJK SC");
user_pref("font.name.sans-serif.zh-HK", "Noto Sans CJK TC");
user_pref("font.name.sans-serif.zh-TW", "Noto Sans CJK TC");
user_pref("font.name.serif.ja", "Noto Serif CJK JP");
user_pref("font.name.serif.zh-CN", "Noto Serif CJK SC");
user_pref("font.name.serif.zh-HK", "Noto Serif CJK TC");
user_pref("font.name.serif.zh-TW", "Noto Serif CJK TC");
user_pref("font.size.fixed.x-western", 13);


// ---------------------
// full screen
// ---------------------
user_pref("full-screen-api.approval-required", false);
user_pref("full-screen-api.transition.timeout", 0);
user_pref("full-screen-api.warning.delay", 0);
user_pref("full-screen-api.warning.timeout", 0);


// ---------------------
// spell checking
// ---------------------
user_pref("layout.spellcheckDefault", 0);


// ---------------------
// mouse
// ---------------------
// features
user_pref("middlemouse.paste", false);
user_pref("general.autoScroll", true);
user_pref("toolkit.tabbox.switchByScrolling", true);

// mouse modifier key default actions
// 0: Do nothing; 1: Scroll contents; 2: Go back or forward in the history; 3: Zoom in or out the contents
user_pref("mousewheel.with_alt.action", 1);
user_pref("mousewheel.with_shift.action", 0);
user_pref("mousewheel.with_shift.action.override_x", 1);

// scroll speed tuning
// physical mouse
// // default
// user_pref("mousewheel.default.delta_multiplier_x", 500);
// // with win key
// user_pref("mousewheel.with_win.delta_multiplier_x", 5000);
// user_pref("mousewheel.with_win.delta_multiplier_y", 1000);
// touchpad on wayland
user_pref("mousewheel.default.delta_multiplier_x", 30);
user_pref("mousewheel.default.delta_multiplier_y", 30);
user_pref("mousewheel.default.delta_multiplier_z", 30);

// smooth scrolling with wheel
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 75);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 75);


// ---------------------
// keyboard
// ---------------------
user_pref("ui.key.menuAccessKeyFocuses", false);


// ---------------------
// permissions
// ---------------------
// 0=always ask (default), 1=allow, 2=block
user_pref("permissions.default.geo", 2);


// ---------------------
// extensions
// ---------------------
user_pref("xpinstall.signatures.required", false);
