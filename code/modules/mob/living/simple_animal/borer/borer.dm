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
	icon_living = "brainslug"
	icon_dead = "brainslug_dead"
	speed = 5
	a_intent = I_HURT
	stop_automated_movement = 1
	status_flags = CANPUSH
	attacktext = "nipped"
	friendly = "prods"
	wander = 0
	pass_flags = PASSTABLE
	universal_understand = 1
	holder_type = /obj/item/weapon/holder/borer

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

/mob/living/simple_animal/borer/New()
	..()

	add_language("Cortical Link")
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	truename = "[pick("Primary","Secondary","Tertiary","Quaternary")] [rand(1000,9999)]"
	if(!roundstart) request_player()

/mob/living/simple_animal/borer/Life()

	..()

	if(host)

		if(!stat && !host.stat)

			if(host.reagents.has_reagent("sugar"))
				if(!docile)
					if(controlling)
						host << "\blue You feel the soporific flow of sugar in your host's blood, lulling you into docility."
					else
						src << "\blue You feel the soporific flow of sugar in your host's blood, lulling you into docility."
					docile = 1
			else
				if(docile)
					if(controlling)
						host << "\blue You shake off your lethargy as the sugar leaves your host's blood."
					else
						src << "\blue You shake off your lethargy as the sugar leaves your host's blood."
					docile = 0

			if(chemicals < 250)
				chemicals++
			if(controlling)

				if(docile)
					host << "\blue You are feeling far too docile to continue controlling your host..."
					host.release_control()
					return

				if(prob(5))
					host.adjustBrainLoss(rand(1,2))

				if(prob(host.brainloss/20))
					host.say("*[pick(list("blink","blink_r","choke","aflap","drool","twitch","twitch_s","gasp"))]")

/mob/living/simple_animal/borer/Stat()
	..()
	statpanel("Status")

	if(emergency_shuttle)
		var/eta_status = emergency_shuttle.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)

	if (client.statpanel == "Status")
		stat("Chemicals", chemicals)

/mob/living/simple_animal/borer/proc/detatch()

	if(!host || !controlling) return

	if(istype(host,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = host
		var/obj/item/organ/external/head = H.get_organ("head")
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
	for(var/mob/dead/observer/O in player_list)
		if(jobban_isbanned(O, "Borer"))
			continue
		if(O.client)
			if(O.client.prefs.be_special & BE_ALIEN)
				question(O.client)

/mob/living/simple_animal/borer/proc/question(var/client/C)
	spawn(0)
		if(!C)	return
		var/response = alert(C, "A cortical borer needs a player. Are you interested?", "Cortical borer request", "Yes", "No", "Never for this round")
		if(!C || ckey)
			return
		if(response == "Yes")
			transfer_personality(C)
		else if (response == "Never for this round")
			C.prefs.be_special ^= BE_ALIEN

/mob/living/simple_animal/borer/proc/transfer_personality(var/client/candidate)

	if(!candidate || !candidate.mob || !candidate.mob.mind)
		return

	src.mind = candidate.mob.mind
	candidate.mob.mind.current = src
	src.ckey = candidate.ckey

	if(src.mind)
		src.mind.assigned_role = "Cortical Borer"
		src.mind.special_role = "Cortical Borer"

	src << "<span class='notice'>You are a cortical borer!</span> You are a brain slug that worms its way \
	into the head of its victim. Use stealth, persuasion and your powers of mind control to keep you, \
	your host and your eventual spawn safe and warm."
	src << "You can speak to your victim with <b>say</b>, to other borers with <b>say :x</b>, and use your Abilities tab to access powers."

/mob/living/simple_animal/borer/cannot_use_vents()
	return