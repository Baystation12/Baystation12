/configuration
	var/static/list/gamemode_cache

	/// server name (for world name / status)
	var/static/server_name

	/// generate numeric suffix based on server port
	var/static/server_suffix = FALSE

	/// for topic status requests
	var/static/game_version = "Baystation12"


	/// log OOC channel
	var/static/log_ooc = FALSE

	/// log login/logout
	var/static/log_access = FALSE

	/// log client say
	var/static/log_say = FALSE

	/// log admin actions
	var/static/log_admin = FALSE

	/// log debug output
	var/static/log_debug = TRUE

	/// log game events
	var/static/log_game = FALSE

	/// log voting
	var/static/log_vote = FALSE

	/// log client whisper
	var/static/log_whisper = FALSE

	/// log emotes
	var/static/log_emote = FALSE

	/// log attack messages
	var/static/log_attack = FALSE

	/// log admin chat messages
	var/static/log_adminchat = FALSE

	/// log warnings admins get about bomb construction and such
	var/static/log_adminwarn = FALSE

	/// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/static/log_hrefs = FALSE

	/// logs world.log to a file
	var/static/log_runtime = FALSE

	/// log world.log to game log
	var/static/log_world_output = FALSE

	/// Allows admins with relevant permissions to have their own ooc colour
	var/static/allow_admin_ooccolor = FALSE

	/// allow votes to restart
	var/static/allow_vote_restart = FALSE

	var/static/ert_admin_call_only = FALSE

	/// allow votes to change mode
	var/static/allow_vote_mode = FALSE

	/// allows admin jumping
	var/static/allow_admin_jump = TRUE

	/// allows admin item spawning
	var/static/allow_admin_spawning = TRUE

	/// allows admin revives
	var/static/allow_admin_rev = TRUE

	/// minimum time between voting sessions (deciseconds, 10 minute default)
	var/static/vote_delay = 6000

	/// length of voting period (deciseconds, default 1 minute)
	var/static/vote_period = 600

	/// Length of time before the first autotransfer vote is called
	var/static/vote_autotransfer_initial = 120 MINUTES

	/// length of time before next sequential autotransfer vote
	var/static/vote_autotransfer_interval = 30 MINUTES

	/// Length of time before round start when autogamemode vote is called (in seconds, default 100).
	var/static/vote_autogamemode_timeleft = 100

	/// vote does not default to nochange/norestart (tbi)
	var/static/vote_no_default = FALSE

	/// dead people can't vote (tbi)
	var/static/vote_no_dead = FALSE

	/// dead people can't vote on crew transfer votes
	var/static/vote_no_dead_crew_transfer = FALSE

	/// if amount of traitors scales based on amount of players
	var/static/traitor_scaling = FALSE

	/// if objectives are disabled or not
	var/static/objectives_disabled = FALSE

	/// If security and such can be traitor/cult/other
	var/static/protect_roles_from_antagonist = FALSE

	/// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/static/continous_rounds = FALSE

	var/static/fps = 20

	/// SSinitialization throttling
	var/static/tick_limit_mc_init = TICK_LIMIT_MC_INIT_DEFAULT

	var/static/list/resource_urls

	/// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/static/antag_hud_allowed = FALSE

	/// Ghosts that turn on Antagovision cannot rejoin the round.
	var/static/antag_hud_restricted = FALSE

	var/static/list/mode_names = list()

	/// allowed modes
	var/static/list/modes = list()

	/// votable modes
	var/static/list/votable_modes = list()

	/// relative probability of each mode
	var/static/list/probabilities = list()

	/// Whether or not secret modes show list of possible round types
	var/static/secret_hide_possibilities = FALSE

	/// enables random events mid-round when set to 1
	var/static/allow_random_events = FALSE

	var/static/hostedby

	/// An observer must wait this many minutes before being able to return to the main menu
	var/static/respawn_delay = 30

	/// An observer that has returned to the main menu must wait this many minutes before rejoining
	var/static/respawn_menu_delay = FALSE

	var/static/guest_jobban = TRUE

	var/static/usewhitelist = FALSE

	/// force disconnect for inactive players after this many minutes, if non-0
	var/static/kick_inactive = FALSE

	/// determines whether jobs use minimal access or expanded access.
	var/static/jobs_have_minimal_access = FALSE

	var/static/minimum_player_age = 0

	/// Allows ghosts to write in blood in cult rounds...
	var/static/cult_ghostwriter = TRUE

	/// ...so long as this many cultists are active.
	var/static/cult_ghostwriter_req_cultists = 10

	/// The number of available character slots
	var/static/character_slots = 10

	/// The number of loadout slots per character
	var/static/loadout_slots = 3

	/// This many drones can spawn,
	var/static/max_maint_drones = 5

	/// assuming the admin allow them to.
	var/static/allow_drone_spawn = FALSE

	/// A drone will become available every X ticks since last drone spawn. Default is 2 minutes.
	var/static/drone_build_time = 1200

	var/static/disable_player_mice = FALSE

	/// Set to 1 to prevent newly-spawned mice from understanding human speech
	var/static/uneducated_mice = FALSE

	var/static/usealienwhitelist = FALSE

	var/static/usealienwhitelistSQL = FALSE

	var/static/allow_extra_antags = FALSE

	var/static/guests_allowed = TRUE

	var/static/debugparanoid = FALSE

	var/static/serverurl

	var/static/server

	var/static/banappeals

	var/static/wikiurl

	var/static/forumurl

	var/static/githuburl

	var/static/issuereporturl

	var/static/list/chat_markup

	var/static/forbidden_message_regex

	var/static/forbidden_message_warning = "<B>Your message matched a filter and has not been sent.</B>"

	var/static/forbidden_message_no_notifications = FALSE

	var/static/forbidden_message_hide_details = FALSE

	//game_options.txt configs

	var/static/health_threshold_dead = -100

	var/static/organ_health_multiplier = 0.9

	var/static/organ_regeneration_multiplier = 0.25

	var/static/organs_decay

	/// Modifier for shock stage contribution from organ damage amount
	var/static/organ_damage_spillover_multiplier = 0.5

	var/static/bones_can_break = TRUE

	var/static/limbs_can_break = TRUE

	var/static/revival_brain_life = -1

	var/static/use_loyalty_implants = FALSE

	var/static/welder_vision = TRUE

	var/static/generate_map = FALSE

	var/static/no_click_cooldown = FALSE

	/// optional runtime configuration of http://www.byond.com/docs/ref/#/atom/movable/var/glide_size
	var/static/glide_size

	/// Modifier for ticks between moves while running
	var/static/run_delay = 2

	/// Modifier for ticks between moves while walking
	var/static/walk_delay = 4

	/// Modifier for ticks between moves while creeping
	var/static/creep_delay = 6

	/// Modifier for base stamina cost while sprinting
	var/static/minimum_sprint_cost = 0.8

	/// Modifier for amount hauling skill can reduce stamina cost
	var/static/skill_sprint_cost_range = 0.8

	/// Modifier for minimum rate mobs can regain stamina
	var/static/minimum_stamina_recovery = 1

	/// Modifier for maximum rate mobs can regain stamina
	var/static/maximum_stamina_recovery = 3

	/// After this amount alive, mushrooms will not boom boom
	var/static/maximum_mushrooms = 15

	/// Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt
	var/static/admin_legacy_system = FALSE

	/// Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt
	var/static/ban_legacy_system = FALSE

	/// Do jobs use account age restrictions?   --requires database
	var/static/use_age_restriction_for_jobs = FALSE

	/// Do antags use account age restrictions? --requires database
	var/static/use_age_restriction_for_antags = FALSE

	/// Whether the server uses recursive or circular explosions.
	var/static/use_recursive_explosions = FALSE

	var/static/comms_password

	var/static/ban_comms_password

	/// Clients with these byond versions will be banned. "512.1234;513.2345" etc.
	var/static/list/forbidden_versions = list()

	var/static/minimum_byond_version = 512

	var/static/minimum_byond_build = 1488

	var/static/login_export_addr

	var/static/enter_allowed = TRUE

	var/static/player_limit = FALSE

	var/static/use_irc_bot = FALSE

	var/static/irc_bot_host = ""

	var/static/main_irc = ""

	var/static/admin_irc = ""

	var/static/announce_evac_to_irc = FALSE

	var/static/expected_round_length = 3 HOURS

	/// Whether the first delay per level has a custom start time
	var/static/list/event_first_run = list(EVENT_LEVEL_MUNDANE = null, EVENT_LEVEL_MODERATE = null, EVENT_LEVEL_MAJOR = list("lower" = 80 MINUTES, "upper" = 100 MINUTES))

	/// The lowest delay until next event
	var/static/list/event_delay_lower = list(EVENT_LEVEL_MUNDANE = 10 MINUTES, EVENT_LEVEL_MODERATE = 30 MINUTES, EVENT_LEVEL_MAJOR = 50 MINUTES)

	/// The upper delay until next event
	var/static/list/event_delay_upper = list(EVENT_LEVEL_MUNDANE = 15 MINUTES, EVENT_LEVEL_MODERATE = 45 MINUTES, EVENT_LEVEL_MAJOR = 70 MINUTES)

	var/static/abandon_allowed = TRUE

	var/static/ooc_allowed = TRUE

	var/static/looc_allowed = TRUE

	var/static/dooc_allowed = TRUE

	var/static/dsay_allowed = TRUE

	var/static/aooc_allowed = TRUE

	/// Whether space turfs have ambient light or not
	var/static/starlight = 0

	var/static/list/ert_species = list(SPECIES_HUMAN)

	var/static/law_zero = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

	var/static/aggressive_changelog = FALSE

	var/static/ghosts_can_possess_animals = FALSE

	var/static/delist_when_no_admins = FALSE

	/// Whether map switching is allowed
	var/static/allow_map_switching = FALSE

	/// Automatically call a map vote at end of round and switch to the selected map
	var/static/auto_map_vote = FALSE

	/// Don't allow reboot unless it was caused by SIGUSR1
	var/static/wait_for_sigusr1_reboot = FALSE

	/// How much radiation is reduced by each tick
	var/static/radiation_decay_rate = 1

	var/static/radiation_resistance_multiplier = 1.25

	/// A turf's possible radiation resistance is divided by this number, to get the real value.
	var/static/radiation_material_resistance_divisor = 2

	/// If the radiation level for a turf would be below this, ignore it.
	var/static/radiation_lower_limit = 0.15

	/// Staff get automatic stealth after this many minutes
	var/static/autostealth = FALSE

	/// The "cooldown" time for each occurrence of a unique error
	var/static/error_cooldown = 600

	/// How many occurrences before the next will silence them
	var/static/error_limit = 50

	/// How long a unique error will be silenced for
	var/static/error_silence_time = 6000

	/// How long to wait between messaging admins about occurrences of a unique error
	var/static/error_msg_delay = 50

	/// Used in chargen for accessory loadout limit. 0 disables loadout, negative allows infinite points.
	var/static/max_gear_cost = 10

	/// Whether players should be allowed to print IC circuits from scripts.
	var/static/allow_ic_printing = TRUE

	/// Whether admins can use unsanitized narration; when true, allows HTML etc.
	var/static/allow_unsafe_narrates = FALSE

	/// If this is true, skips spam prevention for user actions; inputs, verbs, macros, etc.
	var/static/do_not_prevent_spam = FALSE

	/// Number of actions per interval permitted for spam protection.
	var/static/max_acts_per_interval = 140

	/// Interval for spam prevention.
	var/static/act_interval = 0.1 SECONDS

	var/static/max_explosion_range = 14

	var/static/hub_visible = FALSE

	var/static/motd = ""

	var/static/event = ""

	/// Logs all timers in buckets on automatic bucket reset
	var/static/log_timers_on_bucket_reset = FALSE

	var/static/emojis = FALSE


/configuration/New()
	build_mode_cache()
	load_config()
	load_options()
	load_map()
	load_sql()
	motd = file2text("config/motd.txt") || ""
	event = file2text("config/event.txt") || ""
	fps = round(fps)
	if (fps <= 0)
		fps = initial(fps)


/configuration/proc/read_config(filename)
	var/list/result = list()
	var/list/lines = file2list(filename)
	for (var/line in lines)
		if (!line)
			continue
		line = trim(line)
		if (!line || line[1] == "#")
			continue
		var/index = findtext(line, " ")
		var/name = index ? lowertext(copytext_char(line, 1, index)) : lowertext(line)
		if (!name)
			continue
		var/value = index ? copytext_char(line, index + 1) : TRUE
		if (!result[name])
			result[name] = value
			continue
		if (!islist(result[name]))
			result[name] = list(result[name])
		result[name] += value
	return result


/configuration/proc/load_config()
	var/list/file = read_config("config/config.txt")
	for (var/name in file)
		var/value = file[name]
		switch (name)
			if ("resource_urls")
				resource_urls = splittext(value, " ")
			if ("admin_legacy_system")
				admin_legacy_system = TRUE
			if ("ban_legacy_system")
				ban_legacy_system = TRUE
			if ("use_age_restriction_for_jobs")
				use_age_restriction_for_jobs = TRUE
			if ("use_age_restriction_for_antags")
				use_age_restriction_for_antags = TRUE
			if ("jobs_have_minimal_access")
				jobs_have_minimal_access = TRUE
			if ("use_recursive_explosions")
				use_recursive_explosions = TRUE
			if ("log_ooc")
				log_ooc = TRUE
			if ("log_access")
				log_access = TRUE
			if ("log_say")
				log_say = TRUE
			if ("debug_paranoid")
				debugparanoid = TRUE
			if ("log_admin")
				log_admin = TRUE
			if ("log_debug")
				log_debug = TRUE
			if ("log_game")
				log_game = TRUE
			if ("log_vote")
				log_vote = TRUE
			if ("log_whisper")
				log_whisper = TRUE
			if ("log_attack")
				log_attack = TRUE
			if ("log_emote")
				log_emote = TRUE
			if ("log_adminchat")
				log_adminchat = TRUE
			if ("log_adminwarn")
				log_adminwarn = TRUE
			if ("log_world_output")
				log_world_output = TRUE
			if ("log_hrefs")
				log_hrefs = TRUE
			if ("log_runtime")
				log_runtime = TRUE
			if ("generate_asteroid")
				generate_map = TRUE
			if ("no_click_cooldown")
				no_click_cooldown = TRUE
			if ("allow_admin_ooccolor")
				allow_admin_ooccolor = TRUE
			if ("allow_vote_restart")
				allow_vote_restart = TRUE
			if ("allow_vote_mode")
				allow_vote_mode = TRUE
			if ("allow_admin_jump")
				allow_admin_jump = TRUE
			if ("allow_admin_rev")
				allow_admin_rev = TRUE
			if ("allow_admin_spawning")
				allow_admin_spawning = TRUE
			if ("no_dead_vote")
				vote_no_dead = TRUE
			if ("no_dead_vote_crew_transfer")
				vote_no_dead_crew_transfer = TRUE
			if ("default_no_vote")
				vote_no_default = TRUE
			if ("vote_delay")
				vote_delay = text2num(value)
			if ("vote_period")
				vote_period = text2num(value)
			if ("vote_autotransfer_initial")
				var/list/values = splittext(value, ";")
				var/len = length(values)
				if (len == 7)
					vote_autotransfer_initial = text2num(values[get_weekday_index()]) MINUTES
				else if (len == 1)
					vote_autotransfer_initial = text2num(value) MINUTES
				else
					log_misc("Invalid vote_autotransfer_initial: [value]")
			if ("vote_autotransfer_interval")
				var/list/values = splittext(value, ";")
				var/len = length(values)
				if (len == 7)
					vote_autotransfer_interval = text2num(values[get_weekday_index()]) MINUTES
				else if (len == 1)
					vote_autotransfer_interval = text2num(value) MINUTES
				else
					log_misc("Invalid vote_autotransfer_interval: [value]")
			if ("vote_autogamemode_timeleft")
				vote_autogamemode_timeleft = text2num(value)
			if ("ert_admin_only")
				ert_admin_call_only = TRUE
			if ("respawn_delay")
				respawn_delay = text2num(value)
				respawn_delay = respawn_delay > 0 ? respawn_delay : 0
			if ("respawn_menu_delay")
				respawn_menu_delay = text2num(value)
				respawn_menu_delay = respawn_menu_delay > 0 ? respawn_menu_delay : 0
			if ("servername")
				server_name = value
			if ("serversuffix")
				server_suffix = TRUE
			if ("hostedby")
				hostedby = value
			if ("serverurl")
				serverurl = value
			if ("server")
				server = value
			if ("banappeals")
				banappeals = value
			if ("wikiurl")
				wikiurl = value
			if ("forumurl")
				forumurl = value
			if ("githuburl")
				githuburl = value
			if ("issuereporturl")
				issuereporturl = value
			if ("ghosts_can_possess_animals")
				ghosts_can_possess_animals = TRUE
			if ("guest_jobban")
				guest_jobban = TRUE
			if ("guest_ban")
				guests_allowed = FALSE
			if ("disable_ooc")
				ooc_allowed = FALSE
			if ("disable_looc")
				looc_allowed = FALSE
			if ("disable_aooc")
				aooc_allowed = FALSE
			if ("disable_entry")
				enter_allowed = FALSE
			if ("disable_dead_ooc")
				dooc_allowed = FALSE
			if ("disable_dsay")
				dsay_allowed = FALSE
			if ("disable_respawn")
				abandon_allowed = FALSE
			if ("usewhitelist")
				usewhitelist = TRUE
			if ("traitor_scaling")
				traitor_scaling = TRUE
			if ("objectives_disabled")
				if (!value)
					log_misc("Could not find value for objectives_disabled in configuration")
					objectives_disabled = CONFIG_OBJECTIVE_NONE
				else
					switch (value)
						if ("none")
							objectives_disabled = CONFIG_OBJECTIVE_NONE
						if ("verb")
							objectives_disabled = CONFIG_OBJECTIVE_VERB
						if ("all")
							objectives_disabled = CONFIG_OBJECTIVE_ALL
						else
							log_misc("Incorrect objective disabled definition: [value]")
							objectives_disabled = CONFIG_OBJECTIVE_NONE
			if ("protect_roles_from_antagonist")
				protect_roles_from_antagonist = TRUE
			if ("probability")
				var/regex/flatten = new (@"\s+", "g")
				for (var/entry in value)
					var/list/parts = splittext(replacetext_char(entry, flatten, " "), " ")
					var/mode = lowertext(parts[1])
					var/chance = text2num(parts[2])
					var/reason
					if (!mode)
						reason = "Missing a tag/chance pair."
					else if (isnull(chance) || chance < 0)
						reason = "Not a valid probability."
					else if (!(mode in modes))
						reason = "Not a valid mode tag."
					if (reason)
						log_misc("Invalid probability config: '[value]' - [reason]")
					else
						probabilities[mode] = chance
			if ("allow_random_events")
				allow_random_events = TRUE
			if ("kick_inactive")
				kick_inactive = text2num(value)
			if ("use_irc_bot")
				use_irc_bot = TRUE
			if ("ticklag")
				var/ticklag = text2num(value)
				if (ticklag > 0)
					fps = 10 / ticklag
			if ("fps")
				fps = text2num(value)
			if ("tick_limit_mc_init")
				tick_limit_mc_init = text2num(value)
			if ("allow_antag_hud")
				antag_hud_allowed = TRUE
			if ("antag_hud_restricted")
				antag_hud_restricted = TRUE
			if ("secret_hide_possibilities")
				secret_hide_possibilities = TRUE
			if ("usealienwhitelist")
				usealienwhitelist = TRUE
			if ("usealienwhitelist_sql")
				usealienwhitelistSQL = TRUE
			if ("continuous_rounds")
				continous_rounds = TRUE
			if ("disable_player_mice")
				disable_player_mice = TRUE
			if ("uneducated_mice")
				uneducated_mice = TRUE
			if ("comms_password")
				comms_password = value
			if ("ban_comms_password")
				ban_comms_password = value
			if ("forbidden_versions")
				forbidden_versions = splittext(value, ";")
			if ("minimum_byond_version")
				minimum_byond_version = text2num(value)
			if ("minimum_byond_build")
				minimum_byond_build = text2num(value)
			if ("login_export_addr")
				login_export_addr = value
			if ("irc_bot_host")
				irc_bot_host = value
			if ("main_irc")
				main_irc = value
			if ("admin_irc")
				admin_irc = value
			if ("announce_evac_to_irc")
				announce_evac_to_irc = TRUE
			if ("allow_cult_ghostwriter")
				cult_ghostwriter = TRUE
			if ("req_cult_ghostwriter")
				cult_ghostwriter_req_cultists = text2num(value)
			if ("character_slots")
				character_slots = text2num(value)
			if ("loadout_slots")
				loadout_slots = text2num(value)
			if ("allow_drone_spawn")
				allow_drone_spawn = text2num(value)
			if ("drone_build_time")
				drone_build_time = text2num(value)
			if ("max_maint_drones")
				max_maint_drones = text2num(value)
			if ("expected_round_length")
				expected_round_length = MinutesToTicks(text2num(value))
			if ("disable_welder_vision")
				welder_vision = FALSE
			if ("disable_circuit_printing")
				allow_ic_printing = FALSE
			if ("allow_extra_antags")
				allow_extra_antags = TRUE
			if ("event_custom_start_mundane")
				var/values = text2numlist(value, ";")
				event_first_run[EVENT_LEVEL_MUNDANE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))
			if ("event_custom_start_moderate")
				var/values = text2numlist(value, ";")
				event_first_run[EVENT_LEVEL_MODERATE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))
			if ("event_custom_start_major")
				var/values = text2numlist(value, ";")
				event_first_run[EVENT_LEVEL_MAJOR] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))
			if ("event_delay_lower")
				var/values = text2numlist(value, ";")
				event_delay_lower[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
				event_delay_lower[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
				event_delay_lower[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])
			if ("event_delay_upper")
				var/values = text2numlist(value, ";")
				event_delay_upper[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
				event_delay_upper[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
				event_delay_upper[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])
			if ("starlight")
				value = text2num(value)
				starlight = value >= 0 ? value : 0
			if ("ert_species")
				ert_species = splittext(value, ";")
				if (!ert_species.len)
					ert_species += SPECIES_HUMAN
			if ("law_zero")
				law_zero = value
			if ("aggressive_changelog")
				aggressive_changelog = TRUE
			if ("delist_when_no_admins")
				delist_when_no_admins = TRUE
			if ("map_switching")
				allow_map_switching = TRUE
			if ("auto_map_vote")
				auto_map_vote = TRUE
			if ("wait_for_sigusr1")
				wait_for_sigusr1_reboot = TRUE
			if ("autostealth")
				autostealth = text2num(value)
			if ("radiation_lower_limit")
				radiation_lower_limit = text2num(value)
			if ("error_cooldown")
				error_cooldown = text2num(value)
			if ("error_limit")
				error_limit = text2num(value)
			if ("error_silence_time")
				error_silence_time = text2num(value)
			if ("error_msg_delay")
				error_msg_delay = text2num(value)
			if ("max_gear_cost")
				max_gear_cost = text2num(value)
				if (max_gear_cost < 0)
					max_gear_cost = INFINITY
			if ("radiation_decay_rate")
				radiation_decay_rate = text2num(value)
			if ("radiation_resistance_multiplier")
				radiation_resistance_multiplier = text2num(value)
			if ("radiation_material_resistance_divisor")
				radiation_material_resistance_divisor = text2num(value)
			if ("radiation_lower_limit")
				radiation_lower_limit = text2num(value)
			if ("player_limit")
				player_limit = text2num(value)
			if ("hub_visible")
				world.update_hub_visibility(TRUE)
			if ("allow_unsafe_narrates")
				allow_unsafe_narrates = TRUE
			if ("do_not_prevent_spam")
				do_not_prevent_spam = TRUE
			if ("max_acts_per_interval")
				max_acts_per_interval = text2num(value)
			if ("act_interval")
				act_interval = text2num(value) SECONDS
			if ("chat_markup")
				for (var/entry in value)
					var/list/line = splittext(entry, ";")
					if (length(line) != 2)
						log_error("Invalid chat_markup entry length: [value]")
					else
						var/matcher = text2regex(line[1])
						if (!matcher)
							log_error("Invalid chat_markup regex: [value]")
						else
							LAZYADD(chat_markup, list(list(matcher, line[2])))
			if ("forbidden_message_regex")
				forbidden_message_regex = text2regex(value)
				if (!forbidden_message_regex)
					log_error("Invalid forbidden_message_regex - failed to parse")
			if ("forbidden_message_warning")
				forbidden_message_warning = length(value) ? value : FALSE
			if ("forbidden_message_no_notifications")
				forbidden_message_no_notifications = TRUE
			if ("forbidden_message_hide_details")
				forbidden_message_hide_details = TRUE
			if ("disallow_votable_mode")
				votable_modes -= value
			if ("minimum_player_age")
				minimum_player_age = text2num(value)
			if ("max_explosion_range")
				max_explosion_range = text2num_or_default(value, max_explosion_range)
			if ("game_version")
				game_version = value
			if ("log_timers_on_bucket_reset")
				log_timers_on_bucket_reset = TRUE
			if ("toggle_emojis")
				emojis = TRUE
			else
				log_misc("Unknown setting in config/config.txt: '[name]'")


/configuration/proc/load_options()
	var/list/file = read_config("config/game_options.txt")
	for (var/name in file)
		var/value = file[name]
		value = text2num(value)
		if (!value)
			log_misc("Unknown value for '[name]' in config/game_options.txt")
		switch(name)
			if ("health_threshold_dead")
				health_threshold_dead = value
			if ("revival_brain_life")
				revival_brain_life = value
			if ("organ_health_multiplier")
				organ_health_multiplier = value / 100
			if ("organ_regeneration_multiplier")
				organ_regeneration_multiplier = value / 100
			if ("organ_damage_spillover_multiplier")
				organ_damage_spillover_multiplier = value / 100
			if ("organs_can_decay")
				organs_decay = TRUE
			if ("bones_can_break")
				bones_can_break = value
			if ("limbs_can_break")
				limbs_can_break = value
			if ("run_delay")
				run_delay = value
			if ("walk_delay")
				walk_delay = value
			if ("creep_delay")
				creep_delay = value
			if ("glide_size")
				glide_size = value
			if ("minimum_sprint_cost")
				minimum_sprint_cost = value
			if ("skill_sprint_cost_range")
				skill_sprint_cost_range = value
			if ("minimum_stamina_recovery")
				minimum_stamina_recovery = value
			if ("maximum_stamina_recovery")
				maximum_stamina_recovery = value
			if ("maximum_mushrooms")
				maximum_mushrooms = value
			if ("use_loyalty_implants")
				use_loyalty_implants = TRUE
			else
				log_misc("Unknown setting in config/game_options.txt: '[name]'")


/configuration/proc/load_map()
	if (!GLOB.using_map?.config_path)
		return
	var/list/file = read_config(GLOB.using_map.config_path)
	for (var/name in file)
		var/value = file[name]
		GLOB.using_map.setup_config(name, value, GLOB.using_map.config_path)


/configuration/proc/load_sql()
	var/list/file = read_config("config/dbconfig.txt")
	for (var/name in file)
		var/value = file[name]
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
				log_misc("Unknown setting in config/dbconfig.txt: '[name]'")


/configuration/proc/build_mode_cache()
	gamemode_cache = list()
	FOR_BLIND(datum/game_mode/M, subtypesof(/datum/game_mode))
		var/tag = initial(M.config_tag)
		if (!tag)
			continue
		gamemode_cache[tag] = (M = new M)
		if (tag in modes)
			continue
		modes += tag
		mode_names[tag] = M.name
		probabilities[tag] = M.probability
		if (M.votable)
			votable_modes += tag
	votable_modes += "secret"


/configuration/proc/pick_mode(mode_name)
	if (!mode_name)
		return
	for (var/tag in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[tag]
		if (M.config_tag == mode_name)
			return M


/configuration/proc/get_runnable_modes()
	var/list/result = list()
	for (var/tag in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[tag]
		if (probabilities[tag] > 0 && !M.startRequirements())
			result[tag] = probabilities[tag]
	return result
