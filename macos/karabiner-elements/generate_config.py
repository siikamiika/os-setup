#!/usr/bin/env python3

import json
from typing import *

def get_code_type(code):
    code_types = [
        ("consumer_key_code", {
            "display_brightness_decrement",
            "display_brightness_increment",
            "rewind",
            "play_or_pause",
            "fastforward",
            "mute",
            "volume_decrement",
            "volume_increment",
        }),
        ("apple_vendor_top_case_key_code", {
            "keyboard_fn"
        }),
        ("pointing_button", {
            "button1",
            "button4",
            "button5",
        }),
    ]
    for code_type, codes in code_types:
        if code in codes:
            return code_type
    return "key_code"

def simple_mapping(from_, to):
    from_type = get_code_type(from_)
    to_type = get_code_type(to)
    return {
        "from": {
            from_type: from_
        },
        "to": [
            {
                to_type: to
            }
        ]
    }

Modifiers = List[str]
OptionalModifiers = List[str]
From = Tuple[str, Modifiers, OptionalModifiers]
To = Tuple[str, Modifiers]
AppMatchList = List[str]

def complex_mapping(
    from_: From,
    to: To,
    # conditions
    active_if: AppMatchList,
    active_unless: AppMatchList,
):
    res = {}
    # conditions
    conditions = []
    if active_if:
        conditions.append({
            "bundle_identifiers": active_if,
            "type": "frontmost_application_if",
        })
    if active_unless:
        conditions.append({
            "bundle_identifiers": active_unless,
            "type": "frontmost_application_unless",
        })
    if conditions:
        res["conditions"] = conditions
    # from
    code_f, modifiers_f, optional_f = from_
    if not optional_f:
        optional_f = ["caps_lock"]
    from_type = get_code_type(code_f)
    from_container: Dict[str, Any] = {from_type: code_f}
    if modifiers_f:
        modifiers_container = {}
        modifiers_container["mandatory"] = modifiers_f
        if optional_f:
            modifiers_container["optional"] = optional_f
        from_container["modifiers"] = modifiers_container
    res["from"] = from_container
    # to
    code_t, modifiers_t = to
    to_type = get_code_type(code_t)
    to_container: Dict[str, Any] = {to_type: code_t}
    if modifiers_t:
        to_container["modifiers"] = modifiers_t
    res["to"] = [to_container]
    # type
    res["type"] = "basic"
    return res

def complex_rule(
    description: str,
    manipulators: List[Tuple[From, To, AppMatchList, AppMatchList]]
):
    return {
        "description": description,
        "manipulators": [complex_mapping(f, t, i, u) for f, t, i, u in manipulators],
    }

native_key_apps = [
    "^com\\.microsoft\\.rdc$",
    "^com\\.microsoft\\.rdc\\.mac$",
    "^com\\.microsoft\\.rdc\\.macos$",
    "^com\\.microsoft\\.rdc\\.osx\\.beta$",
    "^net\\.sf\\.cord$",
    "^com\\.thinomenon\\.RemoteDesktopConnection$",
    "^com\\.itap-mobile\\.qmote$",
    "^com\\.nulana\\.remotixmac$",
    "^com\\.p5sys\\.jump\\.mac\\.viewer$",
    "^com\\.p5sys\\.jump\\.mac\\.viewer\\.web$",
    "^com\\.teamviewer\\.TeamViewer$",
    "^com\\.vmware\\.horizon$",
    "^com\\.2X\\.Client\\.Mac$",
    "^com\\.vmware\\.fusion$",
    "^com\\.vmware\\.horizon$",
    "^com\\.vmware\\.view$",
    "^com\\.parallels\\.desktop$",
    "^com\\.parallels\\.vm$",
    "^com\\.parallels\\.desktop\\.console$",
    "^org\\.virtualbox\\.app\\.VirtualBoxVM$",
    "^com\\.vmware\\.proxyApp\\.",
    "^com\\.parallels\\.winapp\\.",
    "^com\\.apple\\.Terminal$",
    "^com\\.googlecode\\.iterm2$",
    "^co\\.zeit\\.hyperterm$",
    "^co\\.zeit\\.hyper$",
    "^io\\.alacritty$",
    "^net\\.kovidgoyal\\.kitty$",
    "^com\\.blizzard\\.worldofwarcraft$",
    "^com\\.utmapp\\.UTM$",
]

rules = {
    "global": {
        "check_for_updates_on_startup": True,
        "show_in_menu_bar": True,
        "show_profile_name_in_menu_bar": False,
        "unsafe_ui": False
    },
    "profiles": [
        {
            "complex_modifications": {
                "parameters": {
                    "basic.simultaneous_threshold_milliseconds": 50,
                    "basic.to_delayed_action_delay_milliseconds": 500,
                    "basic.to_if_alone_timeout_milliseconds": 1000,
                    "basic.to_if_held_down_threshold_milliseconds": 500,
                    "mouse_motion_to_scroll.speed": 100
                },
                "rules": [complex_rule(d, m) for d, m in [
                    ("PC-Style Copy/Paste/Cut", [
                        (("c", ["control"], ["any"]), ("c", ["left_command"]), [], native_key_apps),
                        (("v", ["control"], ["any"]), ("v", ["left_command"]), [], native_key_apps),
                        (("x", ["control"], ["any"]), ("x", ["left_command"]), [], native_key_apps),
                    ]),
                    ("PC-Style Undo", [
                        (("z", ["control"], ["any"]), ("z", ["left_command"]), [], native_key_apps),
                    ]),
                    ("PC-Style Redo", [
                        (("y", ["control"], ["any"]), ("z", ["left_command", "left_shift"]), [], native_key_apps),
                    ]),
                    ("PC-Style Select-All", [
                        (("a", ["control"], ["any"]), ("a", ["left_command"]), [], native_key_apps),
                    ]),
                    ("PC-Style Control+Delete/Backspace", [
                        (("delete_or_backspace", ["control"], ["any"]), ("delete_or_backspace", ["option"]), [], native_key_apps),
                    ]),
                    ("Change right_option+hjkl to arrow keys", [
                        (("h", ["right_option"], ["any"]), ("left_arrow", []), [], []),
                        (("j", ["right_option"], ["any"]), ("down_arrow", []), [], []),
                        (("k", ["right_option"], ["any"]), ("up_arrow", []), [], []),
                        (("l", ["right_option"], ["any"]), ("right_arrow", []), [], []),
                    ]),
                    ("Change right_option+p; to home/end", [
                        (("p",         ["right_option"], ["any"]), ("home", []), [], []),
                        (("semicolon", ["right_option"], ["any"]), ("end", []), [], []),
                    ]),
                    ("Change right_option+[' to page down/up", [
                        (("open_bracket", ["right_option"], ["any"]), ("page_up", []), [], []),
                        (("quote",        ["right_option"], ["any"]), ("page_down", []), [], []),
                    ]),
                    ("Change right_option+ui' to delete/insert", [
                        (("u", ["right_option"], ["any"]), ("delete_forward", []), [], []),
                        (("i", ["right_option"], ["any"]), ("insert", []), [], []),
                    ]),
                    ("Change right_option+number row' to function keys", [
                        (("1",          ["right_option"], ["any"]), ("f1", []), [], []),
                        (("2",          ["right_option"], ["any"]), ("f2", []), [], []),
                        (("3",          ["right_option"], ["any"]), ("f3", []), [], []),
                        (("4",          ["right_option"], ["any"]), ("f4", []), [], []),
                        (("5",          ["right_option"], ["any"]), ("f5", []), [], []),
                        (("6",          ["right_option"], ["any"]), ("f6", []), [], []),
                        (("7",          ["right_option"], ["any"]), ("f7", []), [], []),
                        (("8",          ["right_option"], ["any"]), ("f8", []), [], []),
                        (("9",          ["right_option"], ["any"]), ("f9", []), [], []),
                        (("0",          ["right_option"], ["any"]), ("f10", []), [], []),
                        (("hyphen",     ["right_option"], ["any"]), ("f11", []), [], []),
                        (("equal_sign", ["right_option"], ["any"]), ("f12", []), [], []),
                    ]),
                    ("Back and forward buttons in browsers", [
                        (("button4", [], []), ("left_arrow", ["left_option"]), [], []),
                        (("button5", [], []), ("right_arrow", ["left_option"]), [], []),
                    ]),
                    ("Firefox hotkeys", [
                        (f, t, ["^org\\.mozilla\\.firefox$"], []) for f, t in [
                            # focus address bar
                            (("d", ["left_option"], []),                ("l", ["left_command"])),
                            (("l", ["left_control"], []),               ("l", ["left_command"])),
                            # reload
                            (("r", ["left_control"], []),               ("r", ["left_command"])),
                            (("r", ["left_control", "left_shift"], []), ("r", ["left_command", "left_shift"])),
                            # open/close/reopen tabs
                            (("t", ["left_control"], []),               ("t", ["left_command"])),
                            (("t", ["left_control", "left_shift"], []), ("t", ["left_command", "left_shift"])),
                            (("w", ["left_control"], []),               ("w", ["left_command"])),
                            # open in new tab
                            (("return_or_enter", ["left_control"], []), ("return_or_enter", ["left_command"])),
                            # open/reopen window
                            (("n", ["left_control"], []),               ("n", ["left_command"])),
                            (("n", ["left_control", "left_shift"], []), ("n", ["left_command", "left_shift"])),
                            (("p", ["left_control", "left_shift"], []), ("p", ["left_command", "left_shift"])),
                            # history
                            (("h", ["left_control"], []),               ("h", ["left_command", "left_shift"])),
                            # navigate history
                            (("open_bracket", ["left_control"], []),    ("open_bracket", ["left_command"])),
                            (("close_bracket", ["left_control"], []),   ("close_bracket", ["left_command"])),
                            (("left_arrow", ["left_alt"], []),          ("left_arrow", ["left_command"])),
                            (("right_arrow", ["left_alt"], []),         ("right_arrow", ["left_command"])),
                            # search
                            (("f", ["left_control"], []),               ("f", ["left_command"])),
                            # dev tools
                            (("i", ["left_control", "left_shift"], []), ("i", ["left_command", "left_alt"])),
                            (("c", ["left_control", "left_shift"], []), ("c", ["left_command", "left_shift"])),
                            # view source
                            (("u", ["left_control"], []),               ("u", ["left_command"])),
                            # print, save
                            (("p", ["left_control"], []),               ("p", ["left_command"])),
                            (("s", ["left_control"], []),               ("s", ["left_command"])),
                            # zoom
                            (("equal_sign", ["left_control"], []),      ("equal_sign", ["left_command"])),
                            (("hyphen", ["left_control"], []),          ("hyphen", ["left_command"])),
                            (("0", ["left_control"], []),               ("0", ["left_command"])),
                            # downloads
                            (("j", ["left_control"], []),               ("j", ["left_command"])),
                            # page info
                            (("i", ["left_control"], []),               ("i", ["left_command"])),
                        ]
                    ]),
                    # TODO make caps_lock actually capitalize letters
                    # ("Change left_shift+escape to caps_lock", [
                    #     (("escape", ["left_shift"], []), ("caps_lock", []), [], []),
                    # ]),
                ]]
            },
            "devices": [
                # TODO might be unnecessarily duplicated with 641:1452
                # is fn the same as keyboard_fn?
                {
                    "disable_built_in_keyboard_if_exists": False,
                    "fn_function_keys": [],
                    "identifiers": {
                        "is_keyboard": True,
                        "is_pointing_device": False,
                        "product_id": 630,
                        "vendor_id": 1452
                    },
                    "ignore": False,
                    "manipulate_caps_lock_led": True,
                    "simple_modifications": [simple_mapping(f, t) for f, t in [
                        ("fn", "left_control"),
                        ("left_control", "fn"),
                        ("left_option", "left_command"),
                        ("left_command", "left_option"),
                        ("right_command", "right_option"),
                        ("right_option", "right_command"),
                        ("non_us_backslash", "grave_accent_and_tilde"),
                        ("grave_accent_and_tilde", "non_us_backslash"),
                    ]],
                    "treat_as_built_in_keyboard": False
                },
                {
                    "disable_built_in_keyboard_if_exists": False,
                    "fn_function_keys": [],
                    "identifiers": {
                        "is_keyboard": False,
                        "is_pointing_device": True,
                        "product_id": 49257,
                        "vendor_id": 1133
                    },
                    "ignore": False,
                    "manipulate_caps_lock_led": False,
                    "simple_modifications": [],
                    "treat_as_built_in_keyboard": False
                },
                {
                    "disable_built_in_keyboard_if_exists": False,
                    "fn_function_keys": [],
                    "identifiers": {
                        "is_keyboard": True,
                        "is_pointing_device": False,
                        "product_id": 641,
                        "vendor_id": 1452
                    },
                    "ignore": False,
                    "manipulate_caps_lock_led": True,
                    "simple_modifications": [simple_mapping(f, t) for f, t in [
                        ("keyboard_fn", "left_control"),
                        ("left_control", "keyboard_fn"),
                        ("left_option", "left_command"),
                        ("left_command", "left_option"),
                        ("right_command", "right_option"),
                        ("right_option", "right_command"),
                        ("non_us_backslash", "grave_accent_and_tilde"),
                        ("grave_accent_and_tilde", "non_us_backslash"),
                    ]],
                    "treat_as_built_in_keyboard": False
                },
                {
                    "disable_built_in_keyboard_if_exists": False,
                    "fn_function_keys": [],
                    "identifiers": {
                        "is_keyboard": False,
                        "is_pointing_device": True,
                        "product_id": 641,
                        "vendor_id": 1452
                    },
                    "ignore": True,
                    "manipulate_caps_lock_led": False,
                    "simple_modifications": [],
                    "treat_as_built_in_keyboard": False
                }
            ],
            "fn_function_keys": [simple_mapping(f, t) for f, t in [
                ("f1", "display_brightness_decrement"),
                ("f2", "display_brightness_increment"),
                ("f3", "mission_control"),
                ("f4", "launchpad"),
                ("f5", "illumination_decrement"),
                ("f6", "illumination_increment"),
                ("f7", "rewind"),
                ("f8", "play_or_pause"),
                ("f9", "fastforward"),
                ("f10", "mute"),
                ("f11", "volume_decrement"),
                ("f12", "volume_increment"),
            ]],
            "name": "Default profile",
            "parameters": {
                "delay_milliseconds_before_open_device": 1000
            },
            "selected": True,
            "simple_modifications": [simple_mapping(f, t) for f, t in [
                ("caps_lock", "escape"),
                ("international2", "delete_or_backspace"),
                ("japanese_pc_xfer", "right_option"),
            ]],
            "virtual_hid_keyboard": {
                "country_code": 0,
                "indicate_sticky_modifier_keys_state": True,
                "mouse_key_xy_scale": 100
            }
        }
    ]
}

print(json.dumps(rules, indent=4))
