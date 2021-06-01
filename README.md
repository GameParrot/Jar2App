# Jar2App
Jar2App will let you turn any JAR File into a macOS Application

Building from source:
1. Copy your Java folder to main/Jar2App/Java. The path of your Java executable should be main/Jar2App/Java/Contents/Home/bin/java. When you are done building, you may delete this folder.
2. Open the Jar2App Xcode project and archive it. If building fails, make sure the correct team is set in Signing and Capibilities.
3. Export the archived application to your applications folder
4. Make sure the path to Jar2App is /Applications/Jar2App.app.

  Downloading the installer:
  1. Open the dmg file and run the installer (you may have to right click and choose open to open it).
  2. If it asks you if you want to use the recomended version of Java, the recomended version of Java will use the version of openJDK (Java JDK SE is not recomended for this) on your system to create a version of Java that only takes up about 55MB. If you need other things like JavaFX, you will have to not used the recomended version and choose a Java folder that supports it.
  When choosing a Java folder, make sure the Java executable is {chosen_folder}/Contents/Home/bin/java. Then, installation will begin.
  To create your app, click Start Conversion and follow the steps. You can configure update settings in the main menu.
  Note: The apps generated work best on macOS Big Sur or newer.

Please report any bugs that you find so I can fix them.
