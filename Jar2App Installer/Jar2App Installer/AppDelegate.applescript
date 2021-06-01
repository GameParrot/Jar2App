--
--  AppDelegate.applescript
--  Jar2App Installer
--
--  Created by GameParrot on 5/20/21.
--  
--

script AppDelegate
	property parent : class "NSObject"
	
	-- IBOutlets
	property theWindow : missing value
	
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened 
	end applicationWillFinishLaunching_
	on install_(sender)
        try
            -- Checks if Jar2App is already installed, updates it if it is.
            do shell script "cd /Applications/Jar2App.app"
            do shell script "echo 'cp -R /Applications/Jar2App.app/Contents/Resources/Java /tmp/Java
            rm -rf /Applications/Jar2App.app
            curl -L https://drive.google.com/uc?id=1rD43tVVrfb7dab7QzADCH_LkjwlXniv4 > /tmp/jar2app.zip
            unzip /tmp/jar2app.zip -d /Applications/
            rm -rf /tmp/jar2app.zip
            cp -R /tmp/Java /Applications/Jar2App.app/Contents/Resources/Java
            rm -rf /tmp/Java' | bash" with administrator privileges
            on error
            try
                -- Checks if Java is installed and lets you choose the JRE/JDK to bundle it with.
                do shell script "/usr/bin/java --version"
                display dialog "Do you want to use the recommended version of Java?"
                do shell script "mkdir /tmp/Java
                mkdir /tmp/Java/Contents
                jlink --add-modules java.se --compress=2 --output /tmp/Java/Contents/Home"
                set theJavaRoot to "/tmp/Java/"
            on error
                set theJavaRoot to choose folder with prompt "Please choose Java folder (likely JDK-version.jdk)"
            end try
            try
            -- Installs Jar2App to your tmp folder, then moves it to your Applications folder.
            do shell script "curl -L https://drive.google.com/uc?id=1rD43tVVrfb7dab7QzADCH_LkjwlXniv4 > /tmp/jar2app.zip
            unzip /tmp/jar2app.zip -d /tmp/
            rm -rf /tmp/jar2app.zip
            cp -R '" & the POSIX Path of theJavaRoot & "' /tmp/Jar2App.app/Contents/Resources/Java"
            do shell script "mv /tmp/Jar2App.app /Applications/Jar2App.app" with administrator privileges
            on error
            display alert "Install failed"
            quit
            end try
        end try
        do shell script "rm -rf /tmp/Java"
        display alert "Install success!"
        end install_
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    on applicationShouldTerminateAfterLastWindowClosed_(sender)
        return true
    end applicationShouldTerminateAfterLastWindowClosed_
end script
