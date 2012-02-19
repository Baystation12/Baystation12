Baystation 12

Website: http://baystation12.net/
Code: https://github.com/Baystation12/Baystation12
IRC: irc://irc.sorcery.net/bs12

based on the code of tgstation13, itself based on the code of goonstation13.
tgstation13 - http://code.google.com/p/tgstation13

================================================================================
INSTALLATION
================================================================================

1. Install BYOND and create an account at  http://www.byond.com/  
2. Checkout the source using Git (http://git-scm.com/) or download it directly from the "ZIP" button on Github (https://github.com/Baystation12/Baystation12/zipball/master) and extract it into a folder of your choosing.
3. Open "baystation12.dme".
4. In the menu at the top, select Build > Compile.
5. Compile time depends on your computer specs. Expect to wait between 2-10 minutes. You will see the following message: 

saving baystation12.dmb (DEBUG mode)

baystation12.dmb - 0 errors, 0 warnings

If you see any errors or warnings, something has gone wrong - possibly a corrupt download or the files extracted wrong.  

6. Browse into the /config folder.  You'll want to edit config.txt to set the probabilities for different gamemodes in Secret and to set your server location so that all your players don't get disconnected at the end of each round.  It's recommended you don't turn on the gamemodes with probability 0, except Extended, as they have various issues and aren't currently being tested,
so they may have unknown and bizarre bugs.  Extended is essentially no mode, and isn't in the Secret rotation by default.

7. You'll also want to edit admins.txt to remove the default admins and add your own.  Some available levels (from highest to lowest) are:

Game Master
Game Admin
Moderator

The admins.txt format is:

byondkey - Rank

...where the BYOND key must be in lowercase and the admin rank must be properly
capitalised.  Additional levels and specific commands accessable by each level can be seen in /code/modules/admin/admin_verbs.dm.

8. To start the server, run the BYOND client, log in, and select File > "Start Dream Daemon..." from the menu. 
9. At the bottom of Dream Daemon, enter the path to your compiled baystation12.dmb file.  
10. Set "Port" to the one you specified in the config.txt.
 - Note: If you are running it locally for testing, the port can be empty and one will be selected for you. However, choosing a port will prevent needing to edit your bookmark (below). A example "testing" port is 50000.
11. Set "Security" to "Safe".
 - Note: If you are running it locally for testing, Security can be "Trusted".
 12. Press the green "GO" button in the bottom-right. This step may take up to 10 minutes to complete as the world loads. If your Dream Daemon stops responding, simply wait longer.

================================================================================
LOG IN TO YOUR SERVER
================================================================================
Assuming the Dream Daemon is running on the same computer as your BYOND client:
1. In the BYOND client's menu, select Bookmarks > Add...
2. URL: 127.0.0.1:12345
 ...where "12345" is the port that you edited in config.txt, or, if testing, the port you chose in step #10 above.
3. Name: Test Server (or whatever you want to call it)
4. Click "OK" 
5. Find your new "Test Sever" bookmark in the Bookmarks menu and select it to start playing.
 
================================================================================
UPDATING
================================================================================

To update an existing installation: 
1. Back up your /config and /data folders.
 ...these store your server configuration, player preferences and banlist.
2. Extract the new files (preferably into a clean directory, but replacing existing files should work fine).
3. Copy your /config and /data folders back into the new install, overwriting when prompted except if we've specified otherwise
4. Re-compile the game.

================================================================================
SQL Setup
================================================================================

The SQL backend for the library, karma system and stats tracking requires a 
MySQL server.  Your server details go in /config/dbconfig.txt, and the SQL 
schema is in /SQL/tgstation_schema.sql.  More detailed setup instructions are
coming soon, for now ask in our IRC channel.