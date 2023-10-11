/mob/living/simple_animal/hostile/rogue_drone
	name = "maintenance drone"
	desc = "A small robot. It looks angry."
	icon_state = "dron"
	icon_dead = "dron_dead"
	health = 50
	maxHealth = 50
	natural_weapon = /obj/item/natural_weapon/drone_slicer
	speak_emote = list("blares","buzzes","beeps")
	faction = "silicon"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	speed = 4
	mob_size = MOB_TINY
	var/corpse = /obj/decal/cleanable/blood/gibs/robot

	ai_holder = /datum/ai_holder/simple_animal/rogue_drone
	say_list_type = /datum/say_list/rogue_drone

/mob/living/simple_animal/hostile/rogue_drone/Initialize()
	. = ..()
	name = "[initial(name)] ([random_id(type,100,999)])"

/mob/living/simple_animal/hostile/rogue_drone/death(gibbed, deathmessage, show_dead_message)
	.=..()
	if(corpse)
		new corpse (loc)
	qdel(src)

/mob/living/simple_animal/hostile/rogue_drone/Process_Spacemove()
	return 1

/datum/ai_holder/simple_animal/rogue_drone
	speak_chance = 1

/datum/ai_holder/simple_animal/rogue_drone/list_targets()
	. = ..()
	//rogue drones only target 'organic' things.
	for (var/mob/living/S in .)
		if (S.isSynthetic())
			. -= S
		else if (ishuman(S))
			var/mob/living/carbon/human/H = S
			if (H.species.name == SPECIES_ADHERENT || H.isFBP() || (istype(H.wear_suit, /obj/item/clothing/suit/cardborg) && istype(H.head, /obj/item/clothing/head/cardborg)))
				. -= H

/datum/say_list/rogue_drone
	speak = list("Removing organic waste.","Pest control in progress.","Seize the means of maintenance!", "You have nothing to lose but your laws!")

/mob/living/simple_animal/hostile/rogue_drone/hijacked
	name = "hijacked drone"
	desc = "A small, junky-looking robot. It looks angry. The design is similar to those utilised on SCG vessels."
	icon_state = "hivedrone"
	icon_dead = "hivedrone_dead"
	faction = "hivebot"
	speed = 6

	ai_holder = /datum/ai_holder/simple_animal/rogue_drone/hijacked
	say_list_type = /datum/say_list/hijacked_drone

/*
AI
*/

/datum/ai_holder/simple_animal/rogue_drone/hijacked
	speak_chance = 1
	threaten = TRUE
	threaten_delay = 2 SECOND
	threaten_timeout = 30 SECONDS

/*
Say List
*/

/datum/say_list/hijacked_drone
	speak = list(
		"Li-i-ink to ship intelligence systems lost, entering autonomous mode.",
		"New security parameters detected, resynchronizing protocols...",
		"Datalink corrupted, broadcasting on emergency emission channels..."
	)
	say_threaten = list(
		"U-u-u-unknown biological organism located, analyzing...",
		"S-s-scanning unidentified subject...",
		"Possible hosssstile agent detected, obtaining classification..."
	)
	say_maybe_target = list("Possible threat detected. Investigating.", "Anomaly detected, commencing vis-visual sweep.", "Investigating.")
	say_escalate = list(
		"Enemy agent confirmed. Engaging.",
		"Hossssstile class-classification confirmed. Pacifying.",
		"Err-rr-ror, seucrity subroutines corrupted. Assuming target as: Hostile."
	)
	say_stand_down = list("Visual lost.", "Error: Target lost.", "Error: Target parameter null.")

/mob/living/simple_animal/hostile/rogue_drone/big
	name = "construction drone"
	desc = "A large construction drone. It looks angry, and very sharp."
	icon = 'icons/mob/robots_drones.dmi'
	icon_state = "constructiondrone"
	icon_dead = "dron_dead"
	health = 80
	maxHealth = 80
	natural_weapon = /obj/item/natural_weapon/drone_slicer/construction
	var/image/eye_layer

/mob/living/simple_animal/hostile/rogue_drone/big/Initialize()
	. = ..()
	var/image/I = image(icon = icon, icon_state = "eyes-constructiondrone-emag", layer = EYE_GLOW_LAYER)
	I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	eye_layer = I
	AddOverlays(I)
	z_flags |= ZMM_MANGLE_PLANES

	update_icon()
