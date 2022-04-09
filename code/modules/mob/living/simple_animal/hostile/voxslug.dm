/*VOX SLUG
Small, little HP, poisonous.
*/

/mob/living/simple_animal/hostile/voxslug
	name = "slug"
	desc = "A viscious little creature, it has a mouth of too many teeth and a penchant for blood."
	icon_state = "voxslug"
	icon_living = "voxslug"
	item_state = "voxslug"
	icon_dead = "voxslug_dead"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	destroy_surroundings = 0
	health = 15
	maxHealth = 15
	speed = 0
	move_to_delay = 0
	density = TRUE
	min_gas = null
	mob_size = MOB_MINISCULE
	can_escape = TRUE
	pass_flags = PASS_FLAG_TABLE
	natural_weapon = /obj/item/natural_weapon/bite

	ai_holder = /datum/ai_holder/hostile/melee/voxslug

/datum/ai_holder/hostile/melee/voxslug/list_targets()
	. = ..()

	for (var/mob/living/carbon/human/H in .)
		if (H.species.get_bodytype() == SPECIES_VOX)
			. -= H

/datum/ai_holder/hostile/melee/voxslug/engage_target()
	if (isliving(holder.loc.loc))
		return

	. = ..()

	var/mob/living/simple_animal/hostile/voxslug/V = holder
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(prob(H.getBruteLoss()/2))
			V.attach(H)

/mob/living/simple_animal/hostile/voxslug/get_scooped(var/mob/living/carbon/grabber)
	if(grabber.species.get_bodytype() != SPECIES_VOX)
		to_chat(grabber, "<span class='warning'>\The [src] wriggles out of your hands before you can pick it up!</span>")
		return
	else return ..()

/mob/living/simple_animal/hostile/voxslug/proc/attach(var/mob/living/carbon/human/H)
	var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(BP_CHEST)
	if(istype(S) && !length(S.breaches))
		S.create_breaches(BRUTE, 20)
		if(!length(S.breaches)) //unable to make a hole
			return
	var/obj/item/organ/external/chest = H.organs_by_name[BP_CHEST]
	var/obj/item/holder/voxslug/slug_holder = new(get_turf(src))
	src.forceMove(slug_holder)
	chest.embed(slug_holder,0,"\The [src] latches itself onto \the [H]!")
	slug_holder.sync(src)


/mob/living/simple_animal/hostile/voxslug/Life()
	. = ..()
	if(. && istype(src.loc, /obj/item/holder) && isliving(src.loc.loc)) //We in somebody
		var/mob/living/L = src.loc.loc
		if(src.loc in L.get_visible_implants(0))
			if(prob(1))
				to_chat(L, "<span class='warning'>You feel strange as \the [src] pulses...</span>")
			var/datum/reagents/R = L.reagents
			R.add_reagent(/datum/reagent/cryptobiolin, 0.5)

/obj/item/holder/voxslug/attack(var/mob/target, var/mob/user)
	var/mob/living/simple_animal/hostile/voxslug/V = contents[1]
	if(!V.stat && istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(!do_after(user, 3 SECONDS, H))
			return
		V.attach(H)
		qdel(src)
		return
	..()
