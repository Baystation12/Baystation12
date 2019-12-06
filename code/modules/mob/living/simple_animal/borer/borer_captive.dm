/mob/living/captive_brain
	name = "host brain"
	real_name = "host brain"
	universal_understand = TRUE

	meat_type = null
	meat_amount = 0
	skin_material = null
	skin_amount = 0
	bone_material = null
	bone_amount = 0

/mob/living/captive_brain/say(var/message)

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot speak in IC (muted)."))
			return

	if(istype(src.loc,/mob/living/simple_animal/borer))

		message = sanitize(message)
		if (!message)
			return
		log_say("[key_name(src)] : [message]")
		if (stat == 2)
			return say_dead(message)

		var/mob/living/simple_animal/borer/B = src.loc
		to_chat(src, "You whisper silently, \"[message]\"")
		to_chat(B.host, "The captive mind of [src] whispers, \"[message]\"")

		for (var/mob/M in GLOB.player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == DEAD && M.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH)
				to_chat(M, "The captive mind of [src] whispers, \"[message]\"")

/mob/living/captive_brain/process_resist()
	//Resisting control by an alien mind.
	if(istype(src.loc,/mob/living/simple_animal/borer))
		var/mob/living/simple_animal/borer/B = src.loc
		var/mob/living/captive_brain/H = src

		to_chat(H, "<span class='danger'>You begin doggedly resisting the parasite's control (this will take approximately sixty seconds).</span>")
		to_chat(B.host, "<span class='danger'>You feel the captive mind of [src] begin to resist your control.</span>")

		spawn(rand(200,250)+B.host.getBrainLoss())
			if(!B || !B.controlling) return

			B.host.adjustBrainLoss(rand(0.1,0.5))
			to_chat(H, "<span class='danger'>With an immense exertion of will, you regain control of your body!</span>")
			to_chat(B.host, "<span class='danger'>You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you.</span>")
			B.detatch()
			verbs -= /mob/living/carbon/proc/release_control
			verbs -= /mob/living/carbon/proc/punish_host
			verbs -= /mob/living/carbon/proc/spawn_larvae

		return

	..()
