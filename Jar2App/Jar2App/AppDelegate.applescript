--
--  AppDelegate.applescript
--  Jar2App
--
--  Created by GameParrot on 5/7/21.
--  
--

script AppDelegate
	property parent : class "NSObject"
	
	-- IBOutlets
	property theWindow : missing value
	
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened
        try
            -- Checks if auto check for updates is enabled
            set autoena1 to do shell script "defaults read ~/Library/Preferences/com.gameparrot.Jar2App.plist AutoUpdate"
            if autoena1 is "1" then
                -- Gets a file containing the latest version.
                set latvir to do shell script "curl -L https://drive.google.com/uc?id=15I8C127xjgOc6AQsaPIFqWFnhwlxCkmI"
                -- Checks the version of Jar2App that is being used.
                set curvir to do shell script "defaults read '" & the POSIX path of (path to current application as text) & "Contents/Info.plist' CFBundleShortVersionString"
                if latvir > curvir then
                    -- This is the code that runs if there is an update.
                    display alert "Update available! Do you want to update?" buttons {"Cancel", "OK"}
                    if button returned of result is "OK" then
                        do shell script "echo 'cp -R /Applications/Jar2App.app/Contents/Resources/Java /tmp/Java
                        rm -rf /Applications/Jar2App.app
                        curl -L https://drive.google.com/uc?id=1rD43tVVrfb7dab7QzADCH_LkjwlXniv4 > /tmp/jar2app.zip
                        unzip /tmp/jar2app.zip -d /Applications/
                        rm -rf /tmp/jar2app.zip
                        cp -R /tmp/Java /Applications/Jar2App.app/Contents/Resources/Java
                        rm -rf /tmp/Java
                        open /Applications/Jar2App.app' | bash > /dev/null 2>&1 & " with administrator privileges
                        quit
                    end if
                end if
            end if
        end try
	end applicationWillFinishLaunching_
	on createNewApp_(sender)
        -- Asks for info about the app.
        set appname to display dialog "App name" default answer ""
        set iconyes to display dialog "Do you want a custom icon?" buttons {"No", "Yes"}
        if button returned of iconyes is "yes" then
            set theIcon to the POSIX path of (choose file with prompt "Chosse an ICNS icon:" of type {"public.image"})
        end if
        set thejar to the POSIX path of (choose file with prompt "Chosse an JAR:" of type {"jar"})
        log "Creating application..."
        set uuidgener to do shell script "uuidgen"
        -- Below is the code that bundles the app. The bash script inside is the code that is run the app is opened.
        do shell script "mkdir /tmp/java2app.app
        mkdir /tmp/java2app.app/Contents
        mkdir /tmp/java2app.app/Contents/MacOS
        mkdir /tmp/java2app.app/Contents/Resources
        cp /Applications/Jar2App.app/Contents/Resources/Info.plist /tmp/java2app.app/Contents/Info.plist
        cp /Applications/Jar2App.app/Contents/Resources/PkgInfo /tmp/java2app.app/Contents/PkgInfo
        cp '" & thejar & "' /tmp/java2app.app/Contents/Resources/javajar.jar
        echo '#!/bin/bash
        curdir=$(dirname \"$0\")
        \"$curdir\"/\"" & text returned of appname & "\" -Dapple.awt.application.appearance=system -Dapple.laf.useScreenMenuBar=true -Xdock:name=\"" & text returned of appname & "\" -Xdock:icon=\"$curdir\"/../\"Resources/JavaApp.icns\" -jar \"$curdir\"/../\"Resources/javajar.jar\"' > '/tmp/java2app.app/Contents/MacOS/" & text returned of appname & "Launch'
        chmod +x '/tmp/java2app.app/Contents/MacOS/" & text returned of appname & "Launch'
        cp -R /Applications/Jar2App.app/Contents/Resources/Java /tmp/java2app.app/Contents/Resources/Java
        defaults write /tmp/java2app.app/Contents/Info.plist CFBundleName '" & text returned of appname & "'
        ln -s '../Resources/Java/Contents/Home/bin/java' '/tmp/java2app.app/Contents/MacOS/" & text returned of appname & "'
        defaults write /tmp/java2app.app/Contents/Info.plist CFBundleExecutable '" & text returned of appname & "Launch'
        defaults write /tmp/java2app.app/Contents/Info.plist CFBundleIdentifier 'com.gameparrot.Jar2App-" & uuidgener & "'"
        log "Successfully created application"
        -- Below is the code that adds the icon specified, or the default icon if none is specified.
        if button returned of iconyes is "yes" then
            do shell script "cp '" & theIcon & "' /tmp/java2app.app/Contents/Resources/JavaApp.icns"
            log "Icon added"
        else
            do shell script "cp /Applications/Jar2App.app/Contents/Resources/defaultapp.icns /tmp/java2app.app/Contents/Resources/JavaApp.icns"
            log "Default icon added"
        end if
        set folderjava to the POSIX path of (choose folder with prompt "Location of app")
        -- Moves the app to the folder specified.
        do shell script "mv -v /tmp/java2app.app '" & folderjava & text returned of appname & ".app'"
        log "Application moved"
    end createNewApp_
    on checkupdate_(sender)
        -- Gets a file containing the latest version.
        set latvir to do shell script "curl -L https://drive.google.com/uc?id=15I8C127xjgOc6AQsaPIFqWFnhwlxCkmI"
        -- Checks the version of Jar2App that is being used.
        set curvir to do shell script "defaults read '" & the POSIX path of (path to current application as text) & "Contents/Info.plist' CFBundleShortVersionString"
        if latvir > curvir then
            -- This is the code that runs if there is an update.
            display alert "Update available! Do you want to update?" buttons {"Cancel", "OK"}
            if button returned of result is "OK" then
                do shell script "echo 'cp -R /Applications/Jar2App.app/Contents/Resources/Java /tmp/Java
                rm -rf /Applications/Jar2App.app
                curl -L https://drive.google.com/uc?id=1rD43tVVrfb7dab7QzADCH_LkjwlXniv4 > /tmp/jar2app.zip
                unzip /tmp/jar2app.zip -d /Applications/
                rm -rf /tmp/jar2app.zip
                cp -R /tmp/Java /Applications/Jar2App.app/Contents/Resources/Java
                rm -rf /tmp/Java
                open /Applications/Jar2App.app' | bash > /dev/null 2>&1 & " with administrator privileges
                quit
            end if
        else
            display alert "Up to date"
        end if
    end checkupdate_
    on updatesettings_(sender)
        try
            -- Checks if auto check for updates is enabled
            set autoena to do shell script "defaults read ~/Library/Preferences/com.gameparrot.Jar2App.plist AutoUpdate"
        on error
        -- Disables auto update check if it has not been specified because it would cause a slow launch if you have slow internet.
        do shell script "defaults write ~/Library/Preferences/com.gameparrot.Jar2App.plist AutoUpdate 0"
        delay 0.5
        set autoena to do shell script "defaults read ~/Library/Preferences/com.gameparrot.Jar2App.plist AutoUpdate"
        end try
        if autoena is "0" then
            display dialog "Auto update check is off. Do you want to enable it?"
            -- Enables auto update check
            do shell script "defaults write ~/Library/Preferences/com.gameparrot.Jar2App.plist AutoUpdate 1"
        else
        display dialog "Auto update check is on. Do you want to disable it?"
        -- Disables auto update check
        do shell script "defaults write ~/Library/Preferences/com.gameparrot.Jar2App.plist AutoUpdate 0"
        end if
    end updatesettings_
    on githubpage_(sender)
        do shell script "open 'https://github.com/GameParrot/Jar2App'"
    end githubpage_
    on issuepage_(sender)
        do shell script "open 'https://github.com/GameParrot/Jar2App/issues'"
    end issuepage_
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    on applicationShouldTerminateAfterLastWindowClosed_(sender)
        return true
    end applicationShouldTerminateAfterLastWindowClosed_
	
end script
