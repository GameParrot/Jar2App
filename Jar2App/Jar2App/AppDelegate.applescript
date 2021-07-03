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
    property jarnametxt : missing value
    property jvmargtxt : missing value
    property jarargtxt : missing value
    property thejarpth : missing value
    property theiconpth : missing value
    property outputfolderpth : missing value
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
                    set releasenotes to do shell script "curl -L 'https://raw.githubusercontent.com/GameParrot/Jar2App/main/releasenotes/releasnotes.txt'"
                    display alert "Update available! Do you want to update?
                    " & releasenotes buttons {"Cancel", "OK"}
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
        -- Gets about the app.
        if thejarpth's stringValue as text is "defaultJar" then
            display alert "Please choose a JAR File."
            return
            nojarFound
        end if
        if outputfolderpth's stringValue as text is "outputFolder" then
            display alert "Please choose an output folder."
            return
            noFolderFound
        end if
        if jarnametxt's stringValue as text is "" then
            display alert "No name specified."
            return
            missingName
        end if
        set appname to jarnametxt's stringValue as text
            set theIcon to theiconpth's stringValue as text
        set thejar to thejarpth's stringValue as text
            set addvmargs to jvmargtxt's stringValue as text
            set addjarargs to jarargtxt's stringValue as text
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
        \"$curdir\"/\"" & appname & "\" " & addvmargs & " -Dapple.awt.application.appearance=system -Dapple.laf.useScreenMenuBar=true -Xdock:name=\"" & appname & "\" -Xdock:icon=\"$curdir\"/../\"Resources/JavaApp.icns\" -jar \"$curdir\"/../\"Resources/javajar.jar\" " & addjarargs & "' > '/tmp/java2app.app/Contents/MacOS/" & appname & "Launch'
        chmod +x '/tmp/java2app.app/Contents/MacOS/" & appname & "Launch'
        cp -R /Applications/Jar2App.app/Contents/Resources/Java /tmp/java2app.app/Contents/Resources/Java
        defaults write /tmp/java2app.app/Contents/Info.plist CFBundleName '" & appname & "'
        ln -s '../Resources/Java/Contents/Home/bin/java' '/tmp/java2app.app/Contents/MacOS/" & appname & "'
        defaults write /tmp/java2app.app/Contents/Info.plist CFBundleExecutable '" & appname & "Launch'
        defaults write /tmp/java2app.app/Contents/Info.plist CFBundleIdentifier 'com.gameparrot.Jar2App-" & uuidgener & "'"
        log "Successfully created application"
        -- Below is the code that adds the icon specified, or the default icon if none is specified.
            do shell script "cp '" & theIcon & "' /tmp/java2app.app/Contents/Resources/JavaApp.icns"
            log "Icon added"
        set folderjava to outputfolderpth's stringValue as text
        -- Moves the app to the folder specified.
        do shell script "mv -v /tmp/java2app.app '" & folderjava & appname & ".app'"
        log "Application moved"
        display alert "Successfully created application"
        set theiconpth's stringValue to "/Applications/Jar2App.app/Contents/Resources/defaultapp.icns"
        set jarnametxt's stringValue to ""
        set thejarpth's stringValue to "defaultJar"
        set jarargtxt's stringValue to ""
        set jvmargtxt's stringValue to ""
        set outputfolderpth's stringValue to "outputFolder"
    end createNewApp_
    on checkupdate_(sender)
        -- Gets a file containing the latest version.
        set latvir to do shell script "curl -L https://drive.google.com/uc?id=15I8C127xjgOc6AQsaPIFqWFnhwlxCkmI"
        -- Checks the version of Jar2App that is being used.
        set curvir to do shell script "defaults read '" & the POSIX path of (path to current application as text) & "Contents/Info.plist' CFBundleShortVersionString"
        if latvir > curvir then
            -- This is the code that runs if there is an update.
            set releasenotes to do shell script "curl -L 'https://raw.githubusercontent.com/GameParrot/Jar2App/main/releasenotes/releasnotes.txt'"
            display alert "Update available! Do you want to update?
            " & releasenotes buttons {"Cancel", "OK"}
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
    on changeexec_(sender)
        set theJavaRoot to the POSIX Path of (choose folder with prompt "Please choose Java folder (likely JDK-version.jdk)")
        do shell script "cp -R '" & theJavaRoot & "' /tmp/Jar2AppJava/"
        do shell script "rm -rf /Applications/Jar2App.app/Contents/Resources/Java
        mv -v /tmp/Jar2AppJava /Applications/Jar2App.app/Contents/Resources/Java" with administrator privileges
    end changeexec_
    on choosejar_(sender)
        set thejarpth's stringValue to the POSIX path of (choose file with prompt "Chosse an JAR:" of type {"jar"})
    end choosejar_
    on chooseicon_(sender)
        set theiconpth's stringValue to the POSIX path of (choose file with prompt "Chosse an ICNS icon:" of type {"public.image"})
    end chooseicon_
    on outputfol_(sender)
        set outputfolderpth's stringValue to the POSIX path of (choose folder with prompt "Location of app")
    end outputfol_
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    on applicationShouldTerminateAfterLastWindowClosed_(sender)
        return true
    end applicationShouldTerminateAfterLastWindowClosed_
	
end script
