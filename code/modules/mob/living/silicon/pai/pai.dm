GLOBAL_LIST_INIT(possible_chassis, list(
		"Drone" = "drone",
		"Cat" = "cat",
		"Mouse" = "mouse",
		"Monkey" = "monkey",
		"Rabbit" = "rabbit",
		"Mushroom" = "mushroom",
		"Corgi" = "corgi",
		"Crow" = "crow",
		"Humanoid" = "humanoid"
		))

GLOBAL_LIST_INIT(possible_say_verbs, list(
		"Robotic" = list("states","declares","queries"),
		"Natural" = list("says","yells","asks"),
		"Beep" = list("beeps","beeps loudly","boops"),
		"Chirp" = list("chirps","chirrups","cheeps"),
		"Feline" = list("purrs","yowls","meows"),
		"Canine" = list("yaps", "barks", "woofs"),
		"Corvid" = list("caws", "caws loudly", "whistles")
		))

/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/pai.dmi'
	icon_state = "drone"
	hud_type = /datum/hud/pai
	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SMALL

	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER
	pullin = new /obj/screen/pai/pull
	holder_type = /obj/item/holder
	idcard = /obj/item/card/id
	silicon_radio = null // pAIs get their radio from the card they belong to.

	var/network = "SS13"
	var/obj/machinery/camera/current = null

	var/ram = 100	// Used as currency to purchase different abilities
	var/list/software = list()
	var/userDNA		// The DNA string of our assigned user
	var/obj/item/device/paicard/card	// The card we inhabit

	var/is_in_card = TRUE
	var/chassis = "drone"
	var/obj/item/pai_cable/cable		// The cable we produce and use when door or camera jacking

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification
							// Keeping this separate from the laws var, it should be much more difficult to modify
	var/pai_law0 = "Serve your master."
	var/pai_laws				// String for additional operating instructions our master might give us

	var/silence_time			// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	var/secHUD = 0			// Toggles whether the Security HUD is active or not
	var/medHUD = 0			// Toggles whether the Medical  HUD is active or not

	var/medical_cannotfind = 0
	var/datum/data/record/medicalActive1		// Datacore record declarations for record software
	var/datum/data/record/medicalActive2

	var/security_cannotfind = 0
	var/datum/data/record/securityActive1		// Could probably just combine all these into one
	var/datum/data/record/securityActive2

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 1000, >= 1000 means the hack is complete and will be reset upon next check
	var/hack_aborted = 0

	var/translator_on = 0 // keeps track of the translator module


	var/flashlight_max_bright = 0.5 //brightness of light when on, must be no greater than 1.
	var/flashlight_inner_range = 1 //inner range of light when on, can be negative
	var/flashlight_outer_range = 3 //outer range of light when on, can be negative
	var/light_on = FALSE

	hud_type = /datum/hud/pai

/mob/living/silicon/pai/New(var/obj/item/device/paicard)
	status_flags |= NO_ANTAG
	card = paicard

	//As a human made device, we'll understand sol common without the need of the translator
	add_language(LANGUAGE_HUMAN_EURO, 1)
	verbs -= /mob/living/verb/ghost

	..()

	if(card)
		if(!card.radio)
			card.radio = new /obj/item/device/radio(card)
		silicon_radio = card.radio

/mob/living/silicon/pai/Destroy()
	card = null
	silicon_radio = null // Because this radio actually belongs to another instance we simply null
	. = ..()

// this function shows the information about being silenced as a pAI in the Status panel
/mob/living/silicon/pai/proc/show_silenced()
	if(silence_time)
		var/timeleft = round((silence_time - world.timeofday)/10 ,1)
		stat(null, "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

/mob/living/silicon/pai/Stat()
	. = ..()
	statpanel("Status")
	if (client.statpanel == "Status")
		show_silenced()

/mob/living/silicon/pai/check_eye(var/mob/user as mob)
	if (!current)
		return -1
	return 0

/mob/living/silicon/pai/restrained()
	return !istype(loc, /obj/item/device/paicard) && ..()

/mob/living/silicon/pai/emp_act(severity)
	// Silence for 2 minutes
	// 20% chance to kill
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	to_chat(src, "<font color=green><b>Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete.</b></font>")
	if(prob(20))
		var/turf/T = get_turf_or_move(loc)
		for (var/mob/M in viewers(T))
			M.show_message("<span class='warning'>A shower of sparks spray from [src]'s inner workings.</span>", 3, "<span class='warning'>You hear and smell the ozone hiss of electrical sparks being expelled violently.</span>", 2)
		return death(0)

	switch(pick(1,2,3))
		if(1)
			master = null
			master_dna = null
			to_chat(src, "<font color=green>You feel unbound.</font>")
		if(2)
			var/command
			if(severity  == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyze")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyze")
			pai_law0 = "[command] your master."
			to_chat(src, "<font color=green>Pr1m3 d1r3c71v3 uPd473D.</font>")
		if(3)
			to_chat(src, "<font color=green>You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all.</font>")

/mob/living/silicon/pai/cancel_camera()

// Procs/code after this point is used to convert the stationary pai item into a
// mobile pai mob. This also includes handling some of the general shit that can occur
// to it. Really this deserves its own file.

/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Unfold Chassis"
	unfold()

//card -> mob
/mob/living/silicon/pai/proc/unfold()
	if(stat || sleeping || paralysis || weakened)
		return
	if(loc != card)
		return
	if(world.time <= last_special)
		return
	last_special = world.time + 100
	//I'm not sure how much of this is necessary, but I would rather avoid issues.
	if(istype(card.loc,/obj/item/rig_module) || istype(card.loc,/obj/item/integrated_circuit/manipulation/ai/))
		to_chat(src, "There is no room to unfold inside \the [card.loc]. You're good and stuck.")
		return 0
	else if(istype(card.loc,/mob))
		var/mob/holder = card.loc
		if(ishuman(holder))
			var/mob/living/carbon/human/H = holder
			for(var/obj/item/organ/external/affecting in H.organs)
				if(card in affecting.implants)
					affecting.take_external_damage(rand(30,50))
					affecting.implants -= card
					H.visible_message("<span class='danger'>\The [src] explodes out of \the [H]'s [affecting.name] in a shower of gore!</span>")
					break
		holder.drop_from_inventory(card)

	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = src
	dropInto(card.loc)
	card.forceMove(src)
	card.screen_loc = null
	is_in_card = FALSE
	var/turf/T = get_turf(src)
	if(istype(T)) T.visible_message("<b>[src]</b> folds outwards, expanding into a mobile form.")

/mob/living/silicon/pai/verb/fold_up()
	set category = "pAI Commands"
	set name = "Collapse Chassis"
	fold()

//from mob -> card
/mob/living/silicon/pai/proc/fold()
	if(stat || sleeping || paralysis || weakened)
		return
	if(loc == card)
		return

	if(world.time <= last_special)
		return
	last_special = world.time + 100

	// Move us into the card and move the card to the ground.
	stop_pulling()
	resting = FALSE

	// If we are being held, handle removing our holder from their inv.
	var/obj/item/holder/H = loc
	if(istype(H))
		var/mob/living/M = H.loc
		if(istype(M))
			M.drop_from_inventory(H, get_turf(src))
		dropInto(loc)

	card.dropInto(card.loc)
	forceMove(card)

	if (src && client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = card
	icon_state = "[chassis]"
	is_in_card = TRUE
	var/turf/T = get_turf(src)
	if(istype(T))
		T.visible_message("<b>[src]</b> neatly folds inwards, compacting down to a rectangular card.")

/mob/living/silicon/pai/lay_down()
	// Pass lying down or getting up to our pet human, if we're in a rig.
	if(istype(loc,/obj/item/device/paicard))
		resting = FALSE
		var/obj/item/rig/rig = get_rig()
		if(istype(rig))
			rig.force_rest(src)
	else
		resting = !resting
		icon_state = resting ? "[chassis]_rest" : "[chassis]"
		to_chat(src, SPAN_NOTICE("You are now [resting ? "resting" : "getting up"]"))

//Overriding this will stop a number of headaches down the track.
/mob/living/silicon/pai/attackby(obj/item/W, mob/user)
	var/obj/item/card/id/card = W.GetIdCard()
	if(card && user.a_intent == I_HELP)
		var/list/new_access = card.GetAccess()
		idcard.access = new_access
		visible_message("<span class='notice'>[user] slides [W] across [src].</span>")
		to_chat(src, SPAN_NOTICE("Your access has been updated!"))
		return FALSE // don't continue processing click callstack.
	if(W.force)
		visible_message(SPAN_DANGER("[user] attacks [src] with [W]!"))
		adjustBruteLoss(W.force)
		updatehealth()
	else
		visible_message(SPAN_WARNING("[user] bonks [src] harmlessly with [W]."))

	spawn(1)
		if(stat != 2) fold()
	return

/mob/living/silicon/pai/attack_hand(mob/user as mob)
	visible_message(SPAN_DANGER("[user] boops [src] on the head."))
	fold()

// No binary for pAIs.
/mob/living/silicon/pai/binarycheck()
	return 0

// Handle being picked up.
/mob/living/silicon/pai/get_scooped(var/mob/living/carbon/grabber, var/self_drop)
	. = ..()
	if(.)
		var/obj/item/holder/H = .
		if(istype(H))
			H.icon_state = "pai-[icon_state]"
			grabber.update_inv_l_hand()
			grabber.update_inv_r_hand()

/mob/living/silicon/pai/verb/wipe_software()
	set name = "Wipe Software"
	set category = "OOC"
	set desc = "Wipe your software. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	// Make sure people don't kill themselves accidentally
	if(alert("WARNING: This will immediately wipe your software and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?",
					"Wipe Software", "No", "No", "Yes") != "Yes")
		return

	fold()
	visible_message("<b>[src]</b> fades away from the screen, the pAI device goes silent.")
	card.removePersonality()
	clear_client()

/mob/living/silicon/pai/proc/toggle_integrated_light()
	if(!light_on)
		set_light(flashlight_max_bright, flashlight_inner_range, flashlight_outer_range, 2)
		to_chat(src, SPAN_NOTICE("You enable your integrated light."))
		light_on = TRUE
	else
		set_light(0, 0)
		to_chat(src, SPAN_NOTICE("You disable your integrated light."))
		light_on = FALSE

/mob/living/silicon/pai/start_pulling(var/atom/movable/AM)
	. = ..()
	if (pulling)
		pullin.screen_loc = ui_pull_resist
		client.screen |= pullin
