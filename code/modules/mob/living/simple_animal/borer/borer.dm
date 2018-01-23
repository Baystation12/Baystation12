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
	universal_understand = 1
	holder_type = /obj/item/weapon/holder/borer
	mob_size = MOB_SMALL

	var/generation = 1
	var/static/list/borer_names = list(
		"Primary", "Secondary", "Tertiary", "Quaternary", "Quinary", "Senary",
		"Septenary", "Octonary", "Novenary", "Decenary", "Undenary", "Duodenary",
		)

	var/used_dominate
	var/chemicals = 10                      // Chemicals used for reproduction and spitting neurotoxin.
	var/mob/living/carbon/human/host        // Human host for the brain worm.
	var/truename                            // Name used for brainworm-speak.
	var/mob/living/captive_brain/host_brain // Used for swapping control of the body back and forth.
	var/controlling                         // Used in human death check.
	var/docile = 0                          // Sugar can stop borers from acting.
	var/has_reproduced
	var/roundstart

/mob/living/simple_animal/borer/roundstart
	roundstart = 1

/mob/living/simple_animal/borer/Login()
	..()
	if(mind)
		borers.add_antagonist(mind)

/mob/living/simple_animal/borer/New(atom/newloc, var/gen=1)
	..(newloc)

	add_language("Cortical Link")
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	generation = gen
	truename = "[borer_names[min(generation, borer_names.len)]] [random_id("borer[generation]", 1000, 9999)]"
	if(!roundstart) request_player()

/mob/living/simple_animal/borer/Life()

	..()

	if(host)

		if(!stat && !host.stat)

			if(host.reagents.has_reagent(/datum/reagent/sugar))
				if(!docile)
					if(controlling)
						to_chat(host, "<span class='notice'>You feel the soporific flow of sugar in your host's blood, lulling you into docility.</span>")
					else
						to_chat(src, "<span class='notice'>You feel the soporific flow of sugar in your host's blood, lulling you into docility.</span>")
					docile = 1
			else
				if(docile)
					if(controlling)
						to_chat(host, "<span class='notice'>You shake off your lethargy as the sugar leaves your host's blood.</span>")
					else
						to_chat(src, "<span class='notice'>You shake off your lethargy as the sugar leaves your host's blood.</span>")
					docile = 0

			if(chemicals < 250)
				chemicals++
			if(controlling)

				if(docile)
					to_chat(host, "<span class='notice'>You are feeling far too docile to continue controlling your host...</span>")
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

	host.remove_language("Cortical Link")
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

/mob/living/simple_animal/borer/proc/leave_host()

	if(!host) return

	if(host.mind)
		borers.remove_antagonist(host.mind)

	src.loc = get_turf(host)

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