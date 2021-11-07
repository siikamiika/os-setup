How to set up Windows 10

Copy win_test.img and vfio-start-test from backup
optional:
    qemu-img resize win.img +140G
    (and then extend in windows)
Start VM
Install updates

copy files over

Admin PowerShell: Set-Execution-Policy RemoteSigned

run scripts from SCRIPTS

Settings
    locale
        (W10 style) Region & language
            Country or region
            Languages: Add a language
                Language --> Options --> Keyboards
        Control Panel --> Clock, Language and Region --> Language
            Advanced settings
                Override for Windows display language
                Override for default input method
                Let me set a different input method for each app
                Change language bar hot keys
                    Advanced Key Settings --> Between Input Languages: OFF
            Change date, time, or number formats
                Format
                Location
                Change system locale
    hostname
        Control Panel --> System --> Computer name, domain and workgroup -->
        Change settings --> Computer Name --> Change
    gpedit
        Administrative Templates --> Windows Components
            !!! since 1803, a separate script is required (found in SCRIPTS) !!!
            --> Search
                Allow Cortana:           Disabled
                Do not allow web search: Enabled
            !!! -----------------------------------------------------------  !!!
            --> Windows Defender Antivirus
                Turn off Windows Defender Antivirus: Enabled
                --> Real-time Protection
                    Turn on behavioral monitoring:                                     Disabled
                    Monitor file and program activity on your computer:                Disabled
                    Turn on process scanning whenever real-time protection is enabled: Disabled
    explorer
        Folder Options
            General
                Open File Explorer to: This PC
                Show recently used files in Quick access OFF
                Show frequently used folders in Quick access OFF
            View
                Hide extensions for known file types OFF
    performance options
        Animate windows when minimizing and maximizing OFF
        Fade etc. OFF
        Slide open combo boxes OFF
        Smooth-scroll list boxes OFF
    accessibility
        Control Panel --> Ease of Access --> Ease of Access Center --> Make the keyboard easier to use
            All checkboxes off
    (W10 style) System
        Notifications & actions
            Show me the Windows welcome experience after updates OFF
            Get tips, tricks, suggestions OFF
        Power & sleep
            Sleep Never
        Multitasking
            When I snap a window, show what I can snap next to it OFF
        About
            See details in Windows Defender
                App & browser control
                    Check apps and files OFF
                    SmartScreen yada yada OFF
    (W10 style) Devices
        Mouse
            Additional mouse options
                Pointer options
                    Enhance pointer precision OFF
        Typing
            all OFF
        Pen & Windows Ink
            Recommendations OFF
    (W10 style) Network & Internet
        Ethernet
            Change advanced sharing options
                Turn off password protected sharing
    (W10 style) Personalization
        Lock screen
            Background: Picture
            Get fun facts OFF
        Start
            Show recently added apps OFF
            Occasionally show suggestions OFF
    (W10 style) Time & language
        Set time/zone automatically
    (W10 style) Gaming
        Game bar OFF
    (W10 style) Ease of Access
        Magnifier
            Zoom level increments 25%
        5x shift --> disable sticky keys
    (W10 style) Privacy
        fucking disable everything
    (W10 style) Update & security
        For developers
            Developer Mode
                --> Optional Features --> Add feature --> OpenSSH client

Install python
pip install tornado pyperclip

Add C:\bin to system PATH (and mpv)

Add scheduled task from C:\Scheduler\layout.xml

reboot
