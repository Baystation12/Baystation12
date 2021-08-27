/obj/item/kharmaan_egg
	name = "crystalline egg"
	desc = "A lumpy, gooey egg with a thin crystalline exterior."
	icon = 'icons/obj/ascent.dmi'
	icon_state = "egg_single"
	var/moved = FALSE

/obj/item/kharmaan_egg/Initialize()
	. = ..()
	if(prob(25))
		new /mob/living/simple_animal/hostile/retaliate/alate_nymph(get_turf(src))
		name = "crystalline eggshell"
		icon_state = "egg_broken"
		desc += " This one is broken and empty."
	else if(!moved)
		icon_state = pick("egg0", "egg1", "egg2")
	else
		icon_state = "egg_single"

/obj/item/kharmaan_egg/Move()
	. = ..()
	if(. && !moved)
		moved = TRUE
		update_icon()

/obj/item/kharmaan_egg/on_update_icon()
	if(icon_state != "egg_broken" && icon_state != "egg_single" && moved)
		icon_state = "egg_single"

/mob/living/simple_animal/hostile/retaliate/alate_nymph
	name = "alate nymph"
	desc = "A small, skittering, juvenile kharmaan alate, likely fresh from the egg."
	icon = 'icons/mob/simple_animal/ascent.dmi'
	icon_state = "larva"
	icon_living = "larva"
	icon_dead = "larva_dead"
	holder_type = /obj/item/holder
	destroy_surroundings = FALSE
	health = 10
	maxHealth = 10
	speed = 0
	move_to_delay = 0
	density = FALSE
	min_gas = list(GAS_METHYL_BROMIDE = 5)
	mob_size = MOB_MINISCULE
	can_escape = TRUE
	pass_flags = PASS_FLAG_TABLE
	natural_weapon = /obj/item/natural_weapon/bite
	faction = "kharmaani"
	var/global/list/friendly_species = list(SPECIES_MANTID_ALATE, SPECIES_MANTID_GYNE, SPECIES_MONARCH_QUEEN, SPECIES_MONARCH_WORKER)
	ai_holder_type = /datum/ai_holder/simple_animal/retaliate/alate_nymph

/datum/ai_holder/simple_animal/retaliate/alate_nymph/list_targets()
	. = list()
	var/mob/living/simple_animal/hostile/retaliate/alate_nymph/A = holder
	for(var/mob/living/M in hearers(src, vision_range))
		if(M.faction == A.faction)
			continue
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.get_bodytype() in A.friendly_species)
				continue
		. += M

/mob/living/simple_animal/hostile/retaliate/alate_nymph/get_scooped(var/mob/living/carbon/grabber)
	if(!(grabber.species.get_bodytype() in friendly_species))
		to_chat(grabber, SPAN_WARNING("\The [src] wriggles out of your hands before you can pick it up!"))
		return
	else return ..()