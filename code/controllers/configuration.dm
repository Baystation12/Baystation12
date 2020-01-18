var/list/gamemode_cache = list()

/datum/configuration
	var/server_name = null				// server name (for world name / status)
	var/server_suffix = 0				// generate numeric suffix based on server port

	var/log_ooc = 0						// log OOC channel
	var/log_access = 0					// log login/logout
	var/log_say = 0						// log client say
	var/log_admin = 0					// log admin actions
	var/log_debug = 1					// log debug output
	var/log_game = 0					// log game events
	var/log_vote = 0					// log voting
	var/log_whisper = 0					// log client whisper
	var/log_emote = 0					// log emotes
	var/log_attack = 0					// log attack messages
	var/log_adminchat = 0				// log admin chat messages
	var/log_adminwarn = 0				// log warnings admins get about bomb construction and such
	var/log_pda = 0						// log pda messages
	var/log_hrefs = 0					// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/log_runtime = 0					// logs world.log to a file
	var/log_world_output = 0			// log world.log << messages
	var/allow_admin_ooccolor = 0		// Allows admins with relevant permissions to have their own ooc colour
	var/allow_vote_restart = 0 			// allow votes to restart
	var/ert_admin_call_only = 0
	var/allow_vote_mode = 0				// allow votes to change mode
	var/allow_admin_jump = 1			// allows admin jumping
	var/allow_admin_spawning = 1		// allows admin item spawning
	var/allow_admin_rev = 1				// allows admin revives
	var/vote_delay = 6000				// minimum time between voting sessions (deciseconds, 10 minute default)
	var/vote_period = 600				// length of voting period (deciseconds, default 1 minute)
	var/vote_autotransfer_initial = 108000 // Length of time before the first autotransfer vote is called
	var/vote_autotransfer_interval = 18000 // length of time before next sequential autotransfer vote
	var/vote_autogamemode_timeleft = 100 //Length of time before round start when autogamemode vote is called (in seconds, default 100).
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)
	var/vote_no_dead_crew_transfer = 0	// dead people can't vote on crew transfer votes
//	var/enable_authentication = 0		// goon authentication
	var/del_new_on_log = 1				// del's new players if they log before they spawn in
	var/feature_object_spell_system = 0 //spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/traitor_scaling = 0 			//if amount of traitors scales based on amount of players
	var/objectives_disabled = 0 			//if objectives are disabled or not
	var/protect_roles_from_antagonist = 0// If security and such can be traitor/cult/other
	var/continous_rounds = 0			// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/allow_Metadata = 0				// Metadata is supported.
	var/popup_admin_pm = 0				//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/fps = 20
	var/tick_limit_mc_init = TICK_LIMIT_MC_INIT_DEFAULT	//SSinitialization throttling
	var/list/resource_urls = null
	var/antag_hud_allowed = 0			// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/antag_hud_restricted = 0                    // Ghosts that turn on Antagovision cannot rejoin the round.
	var/list/mode_names = list()
	var/list/modes = list()				// allowed modes
	var/list/votable_modes = list()		// votable modes
	var/list/probabilities = list()		// relative probability of each mode
	var/humans_need_surnames = 0
	var/allow_random_events = 0			// enables random events mid-round when set to 1
	var/allow_ai = 1					// allow ai job
	var/hostedby = null
	var/respawn_delay = 30
	var/guest_jobban = 1
	var/usewhitelist = 0
	var/kick_inactive = 0				//force disconnect for inactive players after this many minutes, if non-0
	var/mods_can_tempban = 0
	var/mods_can_job_tempban = 0
	var/mod_tempban_max = 1440
	var/mod_job_tempban_max = 1440
	var/load_jobs_from_txt = 0
	var/jobs_have_minimal_access = 0	//determines whether jobs use minimal access or expanded access.

	var/cult_ghostwriter = 1               //Allows ghosts to write in blood in cult rounds...
	var/cult_ghostwriter_req_cultists = 10 //...so long as this many cultists are active.

	var/character_slots = 10				// The number of available character slots
	var/loadout_slots = 3					// The number of loadout slots per character

	var/max_maint_drones = 5				//This many drones can spawn,
	var/allow_drone_spawn = 1				//assuming the admin allow them to.
	var/drone_build_time = 1200				//A drone will become available every X ticks since last drone spawn. Default is 2 minutes.

	var/disable_player_mice = 0
	var/uneducated_mice = 0 //Set to 1 to prevent newly-spawned mice from understanding human speech

	var/usealienwhitelist = 0
	var/usealienwhitelistSQL = 0;
	var/limitalienplayers = 0
	var/alien_to_human_ratio = 0.5
	var/allow_extra_antags = 0
	var/guests_allowed = 1
	var/debugparanoid = 0

	var/serverurl
	var/server
	var/banappeals
	var/wikiurl
	var/forumurl
	var/githuburl
	var/issuereporturl

	var/forbid_singulo_possession = 0

	//game_options.txt configs

	var/health_threshold_dead = -100

	var/organ_health_multiplier = 0.9
	var/organ_regeneration_multiplier = 0.25
	var/organs_decay

	//Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
	//so that it's similar to PAIN. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
	var/organ_damage_spillover_multiplier = 0.5

	var/bones_can_break = 1
	var/limbs_can_break = 1

	var/revival_pod_plants = 1
	var/revival_cloning = 1
	var/revival_brain_life = -1

	var/use_loyalty_implants = 0

	var/welder_vision = 1
	var/generate_map = 0
	var/no_click_cooldown = 0

	//Used for modifying movement speed for mobs.
	//Unversal modifiers
	var/run_delay = 2
	var/walk_delay = 4
	var/creep_delay = 6
	var/minimum_sprint_cost = 0.8
	var/skill_sprint_cost_range = 0.8
	var/minimum_stamina_recovery = 1
	var/maximum_stamina_recovery = 3

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/human_delay = 0
	var/robot_delay = 0
	var/monkey_delay = 0
	var/alien_delay = 0
	var/slime_delay = 0
	var/animal_delay = 0
	var/maximum_mushrooms = 15 //After this amount alive, mushrooms will not boom boom


	var/admin_legacy_system = 0	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt
	var/ban_legacy_system = 0	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt
	var/use_age_restriction_for_jobs = 0   //Do jobs use account age restrictions?   --requires database
	var/use_age_restriction_for_antags = 0 //Do antags use account age restrictions? --requires database

	var/simultaneous_pm_warning_timeout = 100

	var/use_recursive_explosions //Defines whether the server uses recursive or circular explosions.

	var/assistant_maint = 0 //Do assistants get maint access?
	var/gateway_delay = 18000 //How long the gateway takes before it activates. Default is half an hour.
	var/ghost_interaction = 0

	var/comms_password = null
	var/ban_comms_password = null
	var/list/forbidden_versions = list() // Clients with these byond versions will be autobanned. Format: string "byond_version.byond_build"; separate with ; in config, e.g. 512.1234;512.1235
	var/minimum_byond_version = 0
	var/minimum_byond_build = 0

	var/login_export_addr = null

	var/enter_allowed = 1
	var/player_limit = 0

	var/use_irc_bot = 0
	var/irc_bot_host = ""
	var/main_irc = ""
	var/admin_irc = ""
	var/announce_shuttle_dock_to_irc = FALSE

	// Event settings
	var/expected_round_length = 3 * 60 * 60 * 10 // 3 hours
	// If the first delay has a custom start time
	// No custom time, no custom time, between 80 to 100 minutes respectively.
	var/list/event_first_run   = list(EVENT_LEVEL_MUNDANE = null, 	EVENT_LEVEL_MODERATE = null,	EVENT_LEVEL_MAJOR = list("lower" = 48000, "upper" = 60000))
	// The lowest delay until next event
	// 10, 30, 50 minutes respectively
	var/list/event_delay_lower = list(EVENT_LEVEL_MUNDANE = 6000,	EVENT_LEVEL_MODERATE = 18000,	EVENT_LEVEL_MAJOR = 30000)
	// The upper delay until next event
	// 15, 45, 70 minutes respectively
	var/list/event_delay_upper = list(EVENT_LEVEL_MUNDANE = 9000,	EVENT_LEVEL_MODERATE = 27000,	EVENT_LEVEL_MAJOR = 42000)

	var/aliens_allowed = 0
	var/alien_eggs_allowed = 0
	var/ninjas_allowed = 0
	var/abandon_allowed = 1
	var/ooc_allowed = 1
	var/looc_allowed = 1
	var/dooc_allowed = 1
	var/dsay_allowed = 1
	var/aooc_allowed = 1

	var/starlight = 0	// Whether space turfs have ambient light or not

	var/list/ert_species = list(SPECIES_HUMAN)

	var/law_zero = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

	var/aggressive_changelog = 0

	var/ghosts_can_possess_animals = 0
	var/delist_when_no_admins = FALSE

	var/allow_map_switching = 0 // Whether map switching is allowed
	var/auto_map_vote = 0 // Automatically call a map vote at end of round and switch to the selected map
	var/wait_for_sigusr1_reboot = 0 // Don't allow reboot unless it was caused by SIGUSR1

	var/radiation_decay_rate = 1 //How much radiation is reduced by each tick
	var/radiation_resistance_multiplier = 1.25
	var/radiation_material_resistance_divisor = 2 //A turf's possible radiation resistance is divided by this number, to get the real value.
	var/radiation_lower_limit = 0.15 //If the radiation level for a turf would be below this, ignore it.

	var/autostealth = 0 // Staff get automatic stealth after this many minutes

	var/error_cooldown = 600 // The "cooldown" time for each occurrence of a unique error
	var/error_limit = 50 // How many occurrences before the next will silence them
	var/error_silence_time = 6000 // How long a unique error will be silenced for
	var/error_msg_delay = 50 // How long to wait between messaging admins about occurrences of a unique error

	var/max_gear_cost = 10 // Used in chargen for accessory loadout limit. 0 disables loadout, negative allows infinite points.

	var/allow_ic_printing = TRUE //Whether players should be allowed to print IC circuits from scripts.

	var/allow_unsafe_narrates = FALSE //Whether admins can use unsanitized narration; when true, allows HTML etc.

	var/do_not_prevent_spam = FALSE //If this is true, skips spam prevention for user actions; inputs, verbs, macros, etc.
	var/max_acts_per_interval = 140 //Number of actions per interval permitted for spam protection.
	var/act_interval = 0.1 SECONDS //Interval for spam prevention.

/datum/configuration/New()
	var/list/L = typesof(/datum/game_mode) - /datum/game_mode
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()
		if (M.config_tag)
			gamemode_cache[M.config_tag] = M // So we don't instantiate them repeatedly.
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				log_misc("Adding game mode [M.name] ([M.config_tag]) to configuration.")
				src.modes += M.config_tag
				src.mode_names[M.config_tag] = M.name
				src.probabilities[M.config_tag] = M.probability
				if (M.votable)
					src.votable_modes += M.config_tag
	src.votable_modes += "secret"

/datum/configuration/proc/load(filename, type = "config") //the type can also be game_options, in which case it uses a different switch. not making it separate to not copypaste code - Urist
	var/list/Lines = file2list(filename)

	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		if(type == "config")
			switch (name)
				if ("resource_urls")
					config.resource_urls = splittext(value, " ")

				if ("admin_legacy_system")
					config.admin_legacy_system = 1

				if ("ban_legacy_system")
					config.ban_legacy_system = 1

				if ("use_age_restriction_for_jobs")
					config.use_age_restriction_for_jobs = 1

				if ("use_age_restriction_for_antags")
					config.use_age_restriction_for_antags = 1

				if ("jobs_have_minimal_access")
					config.jobs_have_minimal_access = 1

				if ("use_recursive_explosions")
					use_recursive_explosions = 1

				if ("log_ooc")
					config.log_ooc = 1

				if ("log_access")
					config.log_access = 1

				if ("log_say")
					config.log_say = 1

				if ("debug_paranoid")
					config.debugparanoid = 1

				if ("log_admin")
					config.log_admin = 1

				if ("log_debug")
					config.log_debug = text2num(value)

				if ("log_game")
					config.log_game = 1

				if ("log_vote")
					config.log_vote = 1

				if ("log_whisper")
					config.log_whisper = 1

				if ("log_attack")
					config.log_attack = 1

				if ("log_emote")
					config.log_emote = 1

				if ("log_adminchat")
					config.log_adminchat = 1

				if ("log_adminwarn")
					config.log_adminwarn = 1

				if ("log_pda")
					config.log_pda = 1

				if ("log_world_output")
					config.log_world_output = 1

				if ("log_hrefs")
					config.log_hrefs = 1

				if ("log_runtime")
					config.log_runtime = 1

				if ("generate_asteroid")
					config.generate_map = 1

				if ("no_click_cooldown")
					config.no_click_cooldown = 1

				if("allow_admin_ooccolor")
					config.allow_admin_ooccolor = 1

				if ("allow_vote_restart")
					config.allow_vote_restart = 1

				if ("allow_vote_mode")
					config.allow_vote_mode = 1

				if ("allow_admin_jump")
					config.allow_admin_jump = 1

				if("allow_admin_rev")
					config.allow_admin_rev = 1

				if ("allow_admin_spawning")
					config.allow_admin_spawning = 1

				if ("no_dead_vote")
					config.vote_no_dead = 1

				if ("no_dead_vote_crew_transfer")
					config.vote_no_dead_crew_transfer = 1

				if ("default_no_vote")
					config.vote_no_default = 1

				if ("vote_delay")
					config.vote_delay = text2num(value)

				if ("vote_period")
					config.vote_period = text2num(value)

				if ("vote_autotransfer_initial")
					config.vote_autotransfer_initial = text2num(value)

				if ("vote_autotransfer_interval")
					config.vote_autotransfer_interval = text2num(value)

				if ("vote_autogamemode_timeleft")
					config.vote_autogamemode_timeleft = text2num(value)

				if("ert_admin_only")
					config.ert_admin_call_only = 1

				if ("allow_ai")
					config.allow_ai = 1

//				if ("authentication")
//					config.enable_authentication = 1

				if ("respawn_delay")
					config.respawn_delay = text2num(value)
					config.respawn_delay = config.respawn_delay > 0 ? config.respawn_delay : 0

				if ("servername")
					config.server_name = value

				if ("serversuffix")
					config.server_suffix = 1

				if ("hostedby")
					config.hostedby = value

				if ("serverurl")
					config.serverurl = value

				if ("server")
					config.server = value

				if ("banappeals")
					config.banappeals = value

				if ("wikiurl")
					config.wikiurl = value

				if ("forumurl")
					config.forumurl = value

				if ("githuburl")
					config.githuburl = value

				if ("issuereporturl")
					config.issuereporturl = value

				if ("ghosts_can_possess_animals")
					config.ghosts_can_possess_animals = value

				if ("guest_jobban")
					config.guest_jobban = 1

				if ("guest_ban")
					config.guests_allowed = 0

				if ("disable_ooc")
					config.ooc_allowed = 0

				if ("disable_looc")
					config.looc_allowed = 0

				if ("disable_aooc")
					config.aooc_allowed = 0

				if ("disable_entry")
					config.enter_allowed = 0

				if ("disable_dead_ooc")
					config.dooc_allowed = 0

				if ("disable_dsay")
					config.dsay_allowed = 0

				if ("disable_respawn")
					config.abandon_allowed = 0

				if ("usewhitelist")
					config.usewhitelist = 1

				if ("feature_object_spell_system")
					config.feature_object_spell_system = 1

				if ("allow_metadata")
					config.allow_Metadata = 1

				if ("traitor_scaling")
					config.traitor_scaling = 1

				if ("aliens_allowed")
					config.aliens_allowed = 1

				if("alien_eggs_allowed")
					config.alien_eggs_allowed = 1

				if ("ninjas_allowed")
					config.ninjas_allowed = 1

				if ("objectives_disabled")
					if(!value)
						log_misc("Could not find value for objectives_disabled in configuration.")
						config.objectives_disabled = CONFIG_OBJECTIVE_NONE
					else
						switch(value)
							if("none")
								config.objectives_disabled = CONFIG_OBJECTIVE_NONE
							if("verb")
								config.objectives_disabled = CONFIG_OBJECTIVE_VERB
							if("all")
								config.objectives_disabled = CONFIG_OBJECTIVE_ALL
							else
								log_misc("Incorrect objective disabled definition: [value]")
								config.objectives_disabled = CONFIG_OBJECTIVE_NONE
				if("protect_roles_from_antagonist")
					config.protect_roles_from_antagonist = 1

				if ("probability")
					var/prob_pos = findtext(value, " ")
					var/prob_name = null
					var/prob_value = null

					if (prob_pos)
						prob_name = lowertext(copytext(value, 1, prob_pos))
						prob_value = copytext(value, prob_pos + 1)
						if (prob_name in config.modes)
							config.probabilities[prob_name] = text2num(prob_value)
						else
							log_misc("Unknown game mode probability configuration definition: [prob_name].")
					else
						log_misc("Incorrect probability configuration definition: [prob_name]  [prob_value].")

				if("allow_random_events")
					config.allow_random_events = 1

				if("kick_inactive")
					config.kick_inactive = text2num(value)

				if("mods_can_tempban")
					config.mods_can_tempban = 1

				if("mods_can_job_tempban")
					config.mods_can_job_tempban = 1

				if("mod_tempban_max")
					config.mod_tempban_max = text2num(value)

				if("mod_job_tempban_max")
					config.mod_job_tempban_max = text2num(value)

				if("load_jobs_from_txt")
					load_jobs_from_txt = 1

				if("forbid_singulo_possession")
					forbid_singulo_possession = 1

				if("popup_admin_pm")
					config.popup_admin_pm = 1

				if("allow_holidays")
					Holiday = 1

				if("use_irc_bot")
					use_irc_bot = 1

				if("ticklag")
					var/ticklag = text2num(value)
					if(ticklag > 0)
						fps = 10 / ticklag

				if("fps")
					fps = text2num(value)

				if("tick_limit_mc_init")
					tick_limit_mc_init = text2num(value)

				if("allow_antag_hud")
					config.antag_hud_allowed = 1
				if("antag_hud_restricted")
					config.antag_hud_restricted = 1

				if("humans_need_surnames")
					humans_need_surnames = 1

				if("usealienwhitelist")
					usealienwhitelist = 1
				if("usealienwhitelist_sql") // above need to be enabled as well
					usealienwhitelistSQL = 1;
				if("alien_player_ratio")
					limitalienplayers = 1
					alien_to_human_ratio = text2num(value)

				if("assistant_maint")
					config.assistant_maint = 1

				if("gateway_delay")
					config.gateway_delay = text2num(value)

				if("continuous_rounds")
					config.continous_rounds = 1

				if("ghost_interaction")
					config.ghost_interaction = 1

				if("disable_player_mice")
					config.disable_player_mice = 1

				if("uneducated_mice")
					config.uneducated_mice = 1

				if("comms_password")
					config.comms_password = value

				if("ban_comms_password")
					config.ban_comms_password = value

				if("forbidden_versions")
					config.forbidden_versions = splittext(value, ";")

				if("minimum_byond_version")
					config.minimum_byond_version = text2num(value)

				if("minimum_byond_build")
					config.minimum_byond_build = text2num(value)

				if("login_export_addr")
					config.login_export_addr = value

				if("irc_bot_host")
					config.irc_bot_host = value

				if("main_irc")
					config.main_irc = value

				if("admin_irc")
					config.admin_irc = value

				if("announce_shuttle_dock_to_irc")
					config.announce_shuttle_dock_to_irc = TRUE

				if("allow_cult_ghostwriter")
					config.cult_ghostwriter = 1

				if("req_cult_ghostwriter")
					config.cult_ghostwriter_req_cultists = text2num(value)

				if("character_slots")
					config.character_slots = text2num(value)

				if("loadout_slots")
					config.loadout_slots = text2num(value)

				if("allow_drone_spawn")
					config.allow_drone_spawn = text2num(value)

				if("drone_build_time")
					config.drone_build_time = text2num(value)

				if("max_maint_drones")
					config.max_maint_drones = text2num(value)

				if("expected_round_length")
					config.expected_round_length = MinutesToTicks(text2num(value))

				if("disable_welder_vision")
					config.welder_vision = 0

				if("disable_circuit_printing")
					config.allow_ic_printing = FALSE

				if("allow_extra_antags")
					config.allow_extra_antags = 1

				if("event_custom_start_mundane")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MUNDANE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_moderate")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MODERATE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_major")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MAJOR] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_delay_lower")
					var/values = text2numlist(value, ";")
					config.event_delay_lower[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config.event_delay_lower[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config.event_delay_lower[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("event_delay_upper")
					var/values = text2numlist(value, ";")
					config.event_delay_upper[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config.event_delay_upper[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config.event_delay_upper[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("starlight")
					value = text2num(value)
					config.starlight = value >= 0 ? value : 0

				if("ert_species")
					config.ert_species = splittext(value, ";")
					if(!config.ert_species.len)
						config.ert_species += SPECIES_HUMAN

				if("law_zero")
					law_zero = value

				if("aggressive_changelog")
					config.aggressive_changelog = 1

				if("delist_when_no_admins")
					config.delist_when_no_admins = TRUE

				if("map_switching")
					config.allow_map_switching = 1

				if("auto_map_vote")
					config.auto_map_vote = 1

				if("wait_for_sigusr1")
					config.wait_for_sigusr1_reboot = 1

				if("autostealth")
					config.autostealth = text2num(value)

				if("radiation_lower_limit")
					radiation_lower_limit = text2num(value)


				if("error_cooldown")
					error_cooldown = text2num(value)
				if("error_limit")
					error_limit = text2num(value)
				if("error_silence_time")
					error_silence_time = text2num(value)
				if("error_msg_delay")
					error_msg_delay = text2num(value)

				if("max_gear_cost")
					max_gear_cost = text2num(value)
					if(max_gear_cost < 0)
						max_gear_cost = INFINITY
				if("radiation_decay_rate")
					radiation_decay_rate = text2num(value)
				if("radiation_resistance_multiplier")
					radiation_resistance_multiplier = text2num(value)
				if("radiation_material_resistance_divisor")
					radiation_material_resistance_divisor = text2num(value)
				if("radiation_lower_limit")
					radiation_lower_limit = text2num(value)
				if("player_limit")
					player_limit = text2num(value)
				if("hub")
					world.update_hub_visibility()

				if ("allow_unsafe_narrates")
					config.allow_unsafe_narrates = TRUE

				if ("do_not_prevent_spam")
					config.do_not_prevent_spam = TRUE
				if ("max_acts_per_interval")
					config.max_acts_per_interval = text2num(value)
				if ("act_interval")
					config.act_interval = text2num(value) SECONDS

				else
					log_misc("Unknown setting in configuration: '[name]'")

		else if(type == "game_options")
			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			switch(name)
				if("health_threshold_dead")
					config.health_threshold_dead = value
				if("revival_pod_plants")
					config.revival_pod_plants = value
				if("revival_cloning")
					config.revival_cloning = value
				if("revival_brain_life")
					config.revival_brain_life = value
				if("organ_health_multiplier")
					config.organ_health_multiplier = value / 100
				if("organ_regeneration_multiplier")
					config.organ_regeneration_multiplier = value / 100
				if("organ_damage_spillover_multiplier")
					config.organ_damage_spillover_multiplier = value / 100
				if("organs_can_decay")
					config.organs_decay = 1
				if("bones_can_break")
					config.bones_can_break = value
				if("limbs_can_break")
					config.limbs_can_break = value

				if("run_delay")
					config.run_delay = value
				if("walk_delay")
					config.walk_delay = value
				if("creep_delay")
					config.creep_delay = value
				if("minimum_sprint_cost")
					config.minimum_sprint_cost = value
				if("skill_sprint_cost_range")
					config.skill_sprint_cost_range = value
				if("minimum_stamina_recovery")
					config.minimum_stamina_recovery = value
				if("maximum_stamina_recovery")
					config.maximum_stamina_recovery = value

				if("human_delay")
					config.human_delay = value
				if("robot_delay")
					config.robot_delay = value
				if("monkey_delay")
					config.monkey_delay = value
				if("alien_delay")
					config.alien_delay = value
				if("slime_delay")
					config.slime_delay = value
				if("animal_delay")
					config.animal_delay = value
				if("maximum_mushrooms")
					config.maximum_mushrooms = value


				if("use_loyalty_implants")
					config.use_loyalty_implants = 1

				else
					log_misc("Unknown setting in configuration: '[name]'")

	fps = round(fps)
	if(fps <= 0)
		fps = initial(fps)

/datum/configuration/proc/loadsql(filename)  // -- TLE
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		switch (name)
			if ("enabled")
				sqlenabled = TRUE
			if ("address")
				sqladdress = value
			if ("port")
				sqlport = value
			if ("database")
				sqldb = value
			if ("login")
				sqllogin = value
			if ("password")
				sqlpass = value
			if ("feedback_database")
				sqlfdbkdb = value
			if ("feedback_login")
				sqlfdbklogin = value
			if ("feedback_password")
				sqlfdbkpass = value
			else
				log_misc("Unknown setting in configuration: '[name]'")

/datum/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for (var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if (M.config_tag && M.config_tag == mode_name)
			return M

/datum/configuration/proc/get_runnable_modes()
	var/list/runnable_modes = list()
	for(var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if(M && !M.startRequirements() && !isnull(config.probabilities[M.config_tag]) && config.probabilities[M.config_tag] > 0)
			runnable_modes[M.config_tag] = config.probabilities[M.config_tag]
	return runnable_modes

/datum/configuration/proc/load_event(filename)
	var/event_info = file2text(filename)

	if (event_info)
		custom_event_msg = event_info
