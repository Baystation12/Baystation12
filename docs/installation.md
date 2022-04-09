### GETTING THE CODE

The simplest way to obtain the code is using Github's .zip feature.

Click [here](https://github.com/Baystation12/Baystation12/archive/dev.zip) to get the latest code as a .zip file, then unzip it to wherever you want.

The more complicated and easier to update method is using git.  You'll need to download git or some client from [here](http://git-scm.com/).  When that's installed, right click in any folder and click on "Git Bash".  When that opens, type in:

    git clone https://github.com/Baystation12/Baystation12.git

(hint: hold down ctrl and press insert to paste into git bash)

This will take a while to download, but it provides an easier method for updating.

---

### INSTALLATION

First-time installation should be fairly straightforward.  First, you'll need BYOND installed.  You can get it from [here](http://www.byond.com/).

This is a sourcecode-only release, so the next step is to compile the server files.  Open `baystation12.dme` by double-clicking it, open the Build menu, and click compile.  This'll take a little while, and if everything's done right you'll get a message like this:

    saving baystation12.dmb (DEBUG mode)
    
    baystation12.dmb - 0 errors, 0 warnings

If you see any errors or warnings, something has gone wrong - possibly a corrupt download or the files extracted wrong, or a code issue on the main repo.  Ask on IRC or discord.

---

### CONFIGURATION

Copy the contents of the `/config/examples` folder into `/config`. You will now work with everthing contained within `/config`.

Edit `config.txt` to set the probabilities for different gamemodes in Secret and to set your server location so that all your players don't get disconnected at the end of each round.  It's recommended you don't turn on the gamemodes with probability 0, as they have various issues and aren't currently being tested, they may have unknown and bizarre bugs.

Edit `admins.txt` to remove the default admins and add your own.  "Game Master" is the highest level of access, and the other recommended admin levels for now are "Game Admin" and "Moderator".  The format is:

    byondkey - Rank

where the BYOND key must be in lowercase and the admin rank must be properly capitalised.  There are a bunch more admin ranks, but these two should be enough for most servers, assuming you have trustworthy admins.

To start the server, run Dream Daemon and enter the path to your compiled `baystation12.dmb` file.  Make sure to set the port to the one you  specified in the `config.txt`, and set the Security box to 'Trusted' so you don't have to confirm access to every single configuration and storage file for the server.  Then press GO and the server should start up and be ready to join.

---

### WEBHOOKS

If you wish to use Discord webhooks, which are a way of passing information from the server to a Discord channel, you will need to copy `webhooks.json` into `config/` from `config/example/` and add definitions pointing the desired event at the desired [Discord webhook URL](https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks). Valid webhook IDs as of time of writing are as follows:
- webhook_roundend: The round has ended. Will include the mode name and summarize survivors and ghosts.
- webhook_roundstart: The master controller has finished initializing and the round will begin soon.
- webhook_submap_loaded: A submap has been loaded and placed, and is available for people to join. Includes the name of the submap.
- webhook_submap_vox: The vox submap specifically has been loaded and placed. This is distinct for the purposes of tagging vox players with a @mention.
- webhook_submap_skrell: The Skrell submap specifically has been loaded and placed. This is distinct for the purposes of tagging Skrell players with a @mention.
- webhook_custom_event: The custom event text for the round has been set or changed.

Each definition can optionally include an array of roles to mention when the webhook is called. Roles must be provided using the role ID (ex. `<@&555231866735689749>`), which can be obtained by writing `\@somerole` into the chat, in order for pinging to work correctly.

Webhooks additionally require a HTTP POST library called [byhttp](https://github.com/Lohikar/byhttp). The compiled lib, `byhttp.dll` on Windows or `libbyhttp.so` on Linux, must be placed in the lib directory by default in order for webhooks to function. The DLL location can be customized by supplying `WINDOWS_HTTP_POST_DLL_LOCATION` `UNIX_HTTP_POST_DLL_LOCATION`, or `HTTP_POST_DLL_LOCATION` as preprocessor macros containing the desired path.

---

### UPDATING

To update an existing installation, first back up your `/config` and `/data` folders
as these store your server configuration, player preferences and banlist.

If you used the zip method, you'll need to download the zip file again and unzip it somewhere else, and then copy the `/config` and `/data` folders over.

If you used the git method, you simply need to type this in to git bash:

    git pull

When this completes, copy over your `/data` and `/config` folders again, just in case.

When you have done this, you'll need to recompile the code, but then it should work fine.

---

### SQL Setup

The SQL backend for the `/library/stats` and bans requires a MySQL server.  Your server details go in `/config/dbconfig.txt`.

For initial setup and migrations refer to `/sql/README.md`
