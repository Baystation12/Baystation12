//print an error message to world.log
/proc/error(msg)
	world.log << "## ERROR: [msg][world.system_type == UNIX ? ascii2text(13) :]"

//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][world.system_type == UNIX ? ascii2text(13) :]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMIN: [text][world.system_type == UNIX ? ascii2text(13) :]"


/proc/log_debug(text)
	if (config.log_debug)
		diary << "\[[time_stamp()]]DEBUG: [text][world.system_type == UNIX ? ascii2text(13) :]"

	for(var/client/C in admins)
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			C << "DEBUG: [text]"


/proc/log_game(text)
	if (config.log_game)
		diary << "\[[time_stamp()]]GAME: [text][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_vote(text)
	if (config.log_vote)
		diary << "\[[time_stamp()]]VOTE: [text][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_access(text)
	if (config.log_access)
		diary << "\[[time_stamp()]]ACCESS: [text][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_say(text)
	if (config.log_say)
		diary << "\[[time_stamp()]]SAY: [text][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_ooc(text)
	if (config.log_ooc)
		diary << "\[[time_stamp()]]OOC: [text][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_whisper(text)
	if (config.log_whisper)
		diary << "\[[time_stamp()]]WHISPER: [text][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_emote(text)
	if (config.log_emote)
		diary << "\[[time_stamp()]]EMOTE: [text][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_attack(text)
	if (config.log_attack)
		diary << "\[[time_stamp()]]ATTACK: [text][world.system_type == UNIX ? ascii2text(13) :]" //Seperate attack logs? Why?  FOR THE GLORY OF SATAN!

/proc/log_adminsay(text)
	if (config.log_adminchat)
		diary << "\[[time_stamp()]]ADMINSAY: [text][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		diary << "\[[time_stamp()]]ADMINWARN: [text][world.system_type == UNIX ? ascii2text(13) :]"

/proc/log_pda(text)
	if (config.log_pda)
		diary << "\[[time_stamp()]]PDA: [text][world.system_type == UNIX ? ascii2text(13) :]"
