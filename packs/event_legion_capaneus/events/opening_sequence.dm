/proc/event_opening_sequence()
	set waitfor = FALSE
	message_admins("Opening sequence has begun.")

	config.allow_random_events = FALSE
	message_admins("Random events have been disabled.")

	// Set event text
	config.event = {"The SEV Torch is preparing for it's final stretch of bluespace jumps before it will arrive at Outpost E14-b. While your current position is still technically outside of Sol controlled space, you've finally made it. Only a few more jumps before you're home..."}
	to_world("<h1 class='alert'>Event</h1>")
	to_world("<h2 class='alert'>An event is starting. OOC Info:</h2>")
	to_world(SPAN_CLASS("alert", "[config.event]"))
	to_world("<br>")
//	SSwebhooks.send(WEBHOOK_CUSTOM_EVENT, list("text" = config.event))

	// Initial sequence of bluespace jump announcements
	// 05 minutes - Jump prep phase 1
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in 10 minutes."\
		),\
		5 MINUTES\
	)
	// 10 minutes - Jump prep phase 2
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately 5 minutes."\
		),\
		10 MINUTES\
	)
	// 13 minutes - Jump aborted
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"Attention all hands: Jump sequence aborted. Printing error log to Command Program terminals."\
		),\
		13 MINUTES\
	)
	// 14 minutes - Something's been hacked
	addtimer(\
		new Callback(\
			GLOBAL_PROC,\
			/proc/event_system_hack\
		),\
		14 MINUTES\
	)

	// Oh god oh fuck moment
	// 20 minutes - Torpedo warnings
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"WARNING. Multiple minor-class collision tracks detected. Brace for impact.",\
			"SFV Arrow Sensors",\
			'packs/event_legion_capaneus/sounds/torpedo_incoming.ogg'\
		),\
		20 MINUTES\
	)

	// 25 minutes - Capaneus docks
	addtimer(\
		new Callback(\
			priority_announcement,\
			/datum/announcement/proc/Announce,\
			"WARNING. Medium-class interception track detected. Vessel designation - SFV Capanaeus. Unauthorised docking procedures at Aft Starboard EVA, Deck Four",\
			"SFV Arrow Sensors",\
			'packs/event_legion_capaneus/sounds/legion_boarding.ogg'\
		),\
		25 MINUTES\
	)
