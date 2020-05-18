/mob/living/simple_animal/borer
	name = "cortical borer"
	real_name = "cortical borer"
	desc = "A small, quivering sluglike creature."
	speak_emote = list("chirrups")
	emote_hear = list("chirrups")
	response_help  = "pokes"
	response_disarm = "prods"
	response_harm   = "stomps on"
	icon_state = "brainslug"
	item_state = "voxslug" // For the lack of a better sprite...
	icon_living = "brainslug"
	icon_dead = "brainslug_dead"
	speed = 5
	a_intent = I_HURT
	stop_automated_movement = 1
	status_flags = CANPUSH
	attacktext = "nipped"
	friendly = "prods"
	wander = 0
	pass_flags = PASS_FLAG_TABLE
	universal_understand = TRUE
	holder_type = /obj/item/weapon/holder/borer
	mob_size = MOB_SMALL
	can_escape = TRUE

	bleed_colour = "#816e12"

	var/static/list/chemical_types = list(
		"bicaridine" = /datum/reagent/bicaridine,
		"hyperzine" =  /datum/reagent/hyperzine,
		"tramadol" =   /datum/reagent/tramadol
	)

	var/generation = 1
	var/static/list/borer_names = list(
		"Primary", "Secondary", "Tertiary", "Quaternary", "Quinary", "Senary",
		"Septenary", "Octonary", "Novenary", "Decenary", "Undenary", "Duodenary",
		)

	var/image/aura_image
	var/chemicals = 10                      // Chemicals used for reproduction and spitting neurotoxin.
	var/truename                            // Name used for brainworm-speak.
	var/controlling                         // Used in human death check.
	var/docile = FALSE                      // Sugar can stop borers from acting.
	var/has_reproduced                      // Whether or not the borer has reproduced, for objective purposes.
	var/roundstart                          // Whether or not this borer has been mapped and should not look for a player initially.
	var/neutered                            // 'borer lite' mode - fewer powers, less hostile to the host.
	var/mob/living/carbon/human/host        // Human host for the brain worm.
	var/mob/living/captive_brain/host_brain // Used for swapping control of the body back and forth.

/mob/living/simple_animal/borer/roundstart
	roundstart = TRUE

/mob/living/simple_animal/borer/neutered
	neutered = TRUE

/mob/living/simple_animal/borer/Login()
	. = ..()
	if(client)
		client.screen |= hud_elements
		client.screen |= hud_intent_selector
	if(mind && !neutered)
		GLOB.borers.add_antagonist(mind)

/mob/living/simple_animal/borer/Logout()
	. = ..()
	if(client)
		client.screen -= hud_elements
		client.screen -= hud_intent_selector

/mob/living/simple_animal/borer/Initialize(var/mapload, var/gen=1)

	hud_intent_selector =  new
	hud_inject_chemicals = new
	hud_leave_host =       new
	hud_elements = list(
		hud_inject_chemicals,
		hud_leave_host
	)
	if(!neutered)
		hud_toggle_control = new
		hud_elements += hud_toggle_control

	. = ..()

	add_language(LANGUAGE_BORER_GLOBAL)
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	generation = gen
	set_borer_name()

	if(!roundstart) 
		request_player()

	aura_image = create_aura_image(src)
	aura_image.color = "#aaffaa"
	aura_image.blend_mode = BLEND_SUBTRACT
	aura_image.alpha = 125
	var/matrix/M = matrix()
	M.Scale(0.33)
	aura_image.transform = M

/mob/living/simple_animal/borer/death(gibbed, deathmessage, show_dead_message)
	if(aura_image)
		destroy_aura_image(aura_image)
		aura_image = null
	. = ..()

/mob/living/simple_animal/borer/Destroy()
	if(aura_image)
		destroy_aura_image(aura_image)
		aura_image = null
	if(client)
		client.screen -= hud_elements
		client.screen -= hud_intent_selector
	QDEL_NULL_LIST(hud_elements)
	QDEL_NULL(hud_intent_selector)
	hud_toggle_control =   null
	hud_inject_chemicals = null
	hud_leave_host =       null
	. = ..()

/mob/living/simple_animal/borer/proc/set_borer_name()
	truename = "[borer_names[min(generation, borer_names.len)]] [random_id("borer[generation]", 1000, 9999)]"

/mob/living/simple_animal/borer/Life()

	sdisabilities = 0
	if(host)
		blinded = host.blinded
		eye_blind = host.eye_blind
		eye_blurry = host.eye_blurry
		if(host.sdisabilities & BLINDED)
			sdisabilities |= BLINDED
		if(host.sdisabilities & DEAFENED)
			sdisabilities |= DEAFENED
	else
		blinded =    FALSE
		eye_blind =  0
		eye_blurry = 0

	. = ..()
	if(!.)
		return FALSE

	if(host)

		if(!stat && !host.stat)

			if(host.reagents.has_reagent(/datum/reagent/sugar))
				if(!docile)
					if(controlling)
						to_chat(host, SPAN_NOTICE("You feel the soporific flow of sugar in your host's blood, lulling you into docility."))
					else
						to_chat(src, SPAN_NOTICE("You feel the soporific flow of sugar in your host's blood, lulling you into docility."))
					docile = 1
			else
				if(docile)
					if(controlling)
						to_chat(host, SPAN_NOTICE("You shake off your lethargy as the sugar leaves your host's blood."))
					else
						to_chat(src, SPAN_NOTICE("You shake off your lethargy as the sugar leaves your host's blood."))
					docile = 0

			if(chemicals < 250 && host.nutrition >= (neutered ? 200 : 50))
				host.nutrition--
				chemicals++

			if(controlling)

				if(neutered)
					host.release_control()
					return

				if(docile)
					to_chat(host, SPAN_NOTICE("You are feeling far too docile to continue controlling your host..."))
					host.release_control()
					return

				if(prob(5))
					host.adjustBrainLoss(0.1)

				if(prob(host.getBrainLoss()/20))
					host.say("*[pick(list("blink","blink_r","choke","aflap","drool","twitch","twitch_v","gasp"))]")

/mob/living/simple_animal/borer/Stat()
	. = ..()
	statpanel("Status")

	if(evacuation_controller)
		var/eta_status = evacuation_controller.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)

	if (client.statpanel == "Status")
		stat("Chemicals", chemicals)

/mob/living/simple_animal/borer/proc/detatch()

	if(!host || !controlling) return

	if(istype(host,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = host
		var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
		head.implants -= src

	controlling = 0

	host.remove_language(LANGUAGE_BORER_GLOBAL)
	host.verbs -= /mob/living/carbon/proc/release_control
	host.verbs -= /mob/living/carbon/proc/punish_host
	host.verbs -= /mob/living/carbon/proc/spawn_larvae

	if(host_brain)

		// these are here so bans and multikey warnings are not triggered on the wrong people when ckey is changed.
		// computer_id and IP are not updated magically on their own in offline mobs -walter0o

		// host -> self
		var/h2s_id = host.computer_id
		var/h2s_ip= host.lastKnownIP
		host.computer_id = null
		host.lastKnownIP = null

		src.ckey = host.ckey

		if(!src.computer_id)
			src.computer_id = h2s_id

		if(!host_brain.lastKnownIP)
			src.lastKnownIP = h2s_ip

		// brain -> host
		var/b2h_id = host_brain.computer_id
		var/b2h_ip= host_brain.lastKnownIP
		host_brain.computer_id = null
		host_brain.lastKnownIP = null

		host.ckey = host_brain.ckey

		if(!host.computer_id)
			host.computer_id = b2h_id

		if(!host.lastKnownIP)
			host.lastKnownIP = b2h_ip

	qdel(host_brain)

#define COLOR_BORER_RED "#ff5555"
/mob/living/simple_animal/borer/proc/set_ability_cooldown(var/amt)
	last_special = world.time + amt
	for(var/obj/thing in hud_elements)
		thing.color = COLOR_BORER_RED
	addtimer(CALLBACK(src, /mob/living/simple_animal/borer/proc/reset_ui_callback), amt)
#undef COLOR_BORER_RED

/mob/living/simple_animal/borer/proc/leave_host()

	for(var/obj/thing in hud_elements)
		thing.alpha =        0
		thing.invisibility = INVISIBILITY_MAXIMUM

	if(!host) return

	if(host.mind)
		GLOB.borers.remove_antagonist(host.mind)

	dropInto(host.loc)

	reset_view(null)
	machine = null

	host.reset_view(null)
	host.machine = null

	var/mob/living/H = host
	H.status_flags &= ~PASSEMOTES
	host = null
	return

//Procs for grabbing players.
/mob/living/simple_animal/borer/proc/request_player()
	var/datum/ghosttrap/G = get_ghost_trap("cortical borer")
	G.request_player(src, "A cortical borer needs a player.")

/mob/living/simple_animal/borer/flash_eyes(intensity, override_blindness_check, affect_silicon, visual, type)
	intensity *= 1.5
	. = ..()