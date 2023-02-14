/mob/living/simple_animal/hostile/hijacked_drone
	name = "hijacked drone"
	desc = "A small, junky-looking robot. It looks angry. The design feels very familiar to you."
	icon_state = "hivedrone"
	icon_dead = "hivedrone_dead"
	health = 50
	maxHealth = 50
	natural_weapon = /obj/item/natural_weapon/drone_slicer
	speak_emote = list("blares","buzzes","beeps")
	faction = "hivebot"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	speed = 4
	mob_size = MOB_TINY
	var/corpse = /obj/effect/decal/cleanable/blood/gibs/robot

	ai_holder = /datum/ai_holder/simple_animal/rogue_drone
	say_list_type = /datum/say_list/hijacked_drone

/mob/living/simple_animal/hostile/hijacked_drone/death(gibbed, deathmessage, show_dead_message)
	.=..()
	if(corpse)
		new corpse (loc)
	qdel(src)

/datum/ai_holder/simple_animal/hijacked_drone
	speak_chance = 1
	threaten = TRUE
	threaten_delay = 2 SECOND
	threaten_timeout = 30 SECONDS

/datum/ai_holder/simple_animal/hijacked_drone/list_targets()
	. = ..()
	//rogue drones only target 'organic' things.
	for (var/mob/living/S in .)
		if (S.isSynthetic())
			. -= S
		else if (ishuman(S))
			var/mob/living/carbon/human/H = S
			if (H.species.name == SPECIES_ADHERENT || H.isFBP() || (istype(H.wear_suit, /obj/item/clothing/suit/cardborg) && istype(H.head, /obj/item/clothing/head/cardborg)))
				. -= H

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
