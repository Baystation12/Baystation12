/proc/event_opening_sequence()
	set waitfor = FALSE
	message_admins("Opening sequence has begun.")

	config.allow_random_events = FALSE
	message_admins("Random events have been disabled.")

	// Set event text
	config.event = {"The SEV Torch is preparing for it's final bluespace jump before it will arrive at Outpost E14-b. While your current position is still technically outside of Sol-controlled space, you've finally made it. Only a few more minutes before you're home..."}
	to_world("<h1 class='alert'>Event</h1>")
	to_world("<h2 class='alert'>An event is starting. OOC Info:</h2>")
	to_world(SPAN_CLASS("alert", "[config.event]"))
	to_world("<br>")
	SSwebhooks.send(WEBHOOK_CUSTOM_EVENT, list("text" = config.event))

	// Initial sequence of bluespace jump announcements
	// 05 minutes - Jump prep phase 1
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in 10 minutes."\
		),\
		5 SECONDS\
	)
	// 10 minutes - Jump prep phase 2
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately 5 minutes."\
		),\
		10 SECONDS\
	)
	// 13 minutes - Jump aborted
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"Attention all hands: Jump sequence aborted. Undefined error. Tracing."\
		),\
		13 SECONDS\
	)
	// 14 minutes - Something's been hacked
	addtimer(\
		new Callback(\
			GLOBAL_PROC,\
			/proc/event_system_hack\
		),\
		14 SECONDS\
	)

	// Oh god oh fuck moment
	// 15 minutes - Torpedo warnings
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"Warning. Multiple torpedoes detected on intercept course. Estimated impact points: Bridge. Nacelles. Hangar. ETA 60 seconds.",\
			"SEV Torch Sensors",\
			'packs/event_legion_capaneus/sounds/torpedo_incoming.ogg'\
		),\
		15 SECONDS\
	)
	// 15.5 minutes - Capaneus appears on sensors
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"New vessel detected on intercept course. Ident: SFV Capaneus. Warning: Legion signal detected.",\
			"SEV Torch Sensors"\
		),\
		15.5 SECONDS\
	)
	// 16 minutes - Torpedo impacts (Bridge, nacelles, hangar)
	addtimer(\
		new Callback(\
			GLOBAL_PROC,\
			/proc/event_torpedo_impacts\
		),\
		16 SECONDS\
	)

	// 17 minutes - Curio appears on sensors
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"New vessel detected on intercept course. Ident: SFV Curio. Warning: Legion signal detected.",\
			"SEV Torch Sensors"\
		),\
		17 SECONDS\
	)

	// 20 minutes - Curio impacts
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"Warning. Collision course with SFV Curio detected. Brace for impact.",\
			"SEV Torch Sensors",\
			'packs/event_legion_capaneus/sounds/torpedo_incoming.ogg'\
		),\
		20 SECONDS\
	)

	// 21 minutes - Capaneus docks
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"Warning. Unauthorized vessel SFV Capaneus has attached to Deck 4 Fore Airlock.",\
			"SEV Torch Sensors"\
		),\
		21 SECONDS\
	)

	message_admins("Opening sequence complete.")
