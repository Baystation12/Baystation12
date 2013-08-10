/mob/living/captive_brain
	name = "host brain"
	real_name = "host brain"

/mob/living/captive_brain/say(var/message)

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (muted)."
			return
		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if(istype(src.loc,/mob/living/simple_animal/borer))
		var/mob/living/simple_animal/borer/B = src.loc
		src << "You whisper silently, \"[message]\""
		B.host << "The captive mind of [src] whispers, \"[message]\""

/mob/living/captive_brain/emote(var/message)
	return

/mob/living/simple_animal/borer
	name = "cortical borer"
	real_name = "cortical borer"
	desc = "A small, quivering sluglike creature."
	speak_emote = list("chirrups")
	emote_hear = list("chirrups")
	response_help  = "pokes the"
	response_disarm = "prods the"
	response_harm   = "stomps on the"
	icon_state = "brainslug"
	icon_living = "brainslug"
	icon_dead = "brainslug_dead"
	speed = 5
	a_intent = "harm"
	stop_automated_movement = 1
	status_flags = CANPUSH
	attacktext = "nips"
	friendly = "prods"
	wander = 0

	var/chemicals = 10                      // Chemicals used for reproduction and spitting neurotoxin.
	var/mob/living/carbon/human/host        // Human host for the brain worm.
	var/truename                            // Name used for brainworm-speak.
	var/bonded                              // Var for full bonding with the host brain.
	var/mob/living/captive_brain/host_brain // Used for swapping control of the body back and forth.
	var/controlling                         // Used in human death check.

/mob/living/simple_animal/borer/Life()

	..()
	if(host)
		if(!stat && !host.stat && chemicals < 250)
			chemicals++

/mob/living/simple_animal/borer/New()
	..()
	truename = "[pick("Primary","Secondary","Tertiary","Quaternary")] [rand(1000,9999)]"
	host_brain = new/mob/living/captive_brain(src)

	for(var/mob/M in player_list)
		if(istype(M,/mob/dead/observer))
			var/mob/dead/observer/O = M
			if(O.client)
				if(O.client.prefs.be_special & BE_ALIEN)
					src.ckey = O.ckey
					break


/mob/living/simple_animal/borer/say(var/message)

	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	message = capitalize(message)

	if(!message)
		return

	if (stat == 2)
		return say_dead(message)

	if (stat)
		return

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (muted)."
			return
		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	/*if (copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	if (copytext(message, 1, 2) == ";") //Brain borer hivemind.
		return borer_speak(message)*/

	if(!host)
		src << "You have no host to speak to."
		return //No host, no audible speech.

	src << "You drop words into [host]'s mind: \"[message]\""
	host << "Your own thoughts speak: \"[message]\""

/mob/living/simple_animal/borer/proc/borer_speak(var/message)
	if(!message)
		return

	for(var/mob/M in mob_list)
		if(M.mind && (istype(M, /mob/living/simple_animal/borer) || istype(M, /mob/dead/observer)))
			M << "<i>Cortical link, <b>[truename]:</b> [copytext(message, 2)]</i>"

/mob/living/simple_animal/borer/verb/bond_brain()
	set category = "Alien"
	set name = "Assume Control"
	set desc = "Fully connect to the brain of your host."

	if(!host)
		src << "You are not inside a host body."
		return

	if(src.stat)
		src << "You cannot do that in your current state."
		return

	src << "You begin delicately adjusting your connection to the host brain..."

	spawn(100)

		if(!host || !src) return

		else
			src << "\red <B>You plunge your probosci deep into the cortex of the host brain, interfacing directly with their nervous system.</B>"
			host << "\red <B>You feel a strange shifting sensation behind your eyes as an alien consciousness displaces yours.</B>"

			host_brain.ckey = host.ckey
			host.ckey = src.ckey
			controlling = 1

			host.verbs += /mob/living/carbon/human/proc/release_control
			host.verbs += /mob/living/carbon/human/proc/punish_host
			host.verbs += /mob/living/carbon/human/proc/spawn_larvae

mob/living/simple_animal/borer/verb/release_host()
	set category = "Alien"
	set name = "Release Host"
	set desc = "Slither out of your host."

	if(!host)
		src << "You are not inside a host body."
		return

	if(stat)
		src << "You cannot leave your host in your current state."


	if(!host || !src) return

	src << "You begin disconnecting from [host]'s synapses and prodding at their internal ear canal."
	bonded = 0

	if(!host.stat)
		host << "An odd, uncomfortable pressure begins to build inside your skull, behind your ear..."

	spawn(200)

		if(!host || !src) return

		if(src.stat)
			src << "You cannot infest a target in your current state."
			return

		src << "You wiggle out of [host]'s ear and plop to the ground."
		if(!host.stat)
			host << "Something slimy wiggles out of your ear and plops to the ground!"

		detatch()

mob/living/simple_animal/borer/proc/detatch()

	if(!host) return

	var/datum/organ/external/head = host.get_organ("head")
	head.implants -= src
	src.loc = get_turf(host)
	controlling = 0

	host.verbs -= /mob/living/carbon/human/proc/release_control
	host.verbs -= /mob/living/carbon/human/proc/punish_host
	host.verbs -= /mob/living/carbon/human/proc/spawn_larvae

	if(host_brain.ckey)
		src.ckey = host.ckey
		host.ckey = host_brain.ckey
		host_brain.ckey = null
		host_brain.name = "host brain"
		host_brain.real_name = "host brain"

	host = null

/mob/living/simple_animal/borer/verb/infest(var/mob/living/carbon/human/H)
	set category = "Alien"
	set name = "Infest"
	set desc = "Infest a suitable humanoid host."

	if(host)
		src << "You are already within a host."
		return

	if(stat)
		src << "You cannot infest a target in your current state."
		return

	var/list/choices = list()
	for(var/mob/living/C in view(1,src))
		if(istype(C,/mob/living/carbon/human) && C.stat != 2)
			choices += C

	var/mob/living/carbon/human/M = input(src,"Who do you wish to infest?") in null|choices

	if(!M || !src) return

	M << "Something slimy begins probing at the opening of your ear canal..."
	src << "You slither up [M] and begin probing at their ear canal..."

	if(!do_after(src,50))
		src << "As [M] moves away, you are dislodged and fall to the ground."
		return

	if(!M || !src) return

	if(src.stat)
		src << "You cannot infest a target in your current state."
		return

	if(M.stat == 2)
		src << "That is not an appropriate target."
		return

	if(M in view(1, src))
		src << "You wiggle into [M]'s ear."
		if(!M.stat)
			M << "Something disgusting and slimy wiggles into your ear!"

		src.host = M
		var/datum/organ/external/head = M.get_organ("head")
		head.implants += src
		src.loc = M
		bonded = 0

		host_brain.name = M.name
		host_brain.real_name = M.real_name

		return
	else
		src << "They are no longer in range!"
		return