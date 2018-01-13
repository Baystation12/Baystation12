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
	density = 1
	min_gas = null
	mob_size = MOB_MINISCULE
	pass_flags = PASS_FLAG_TABLE
	melee_damage_lower = 5
	melee_damage_upper = 10
	holder_type = /obj/item/weapon/holder/voxslug
	faction = SPECIES_VOX

/mob/living/simple_animal/hostile/voxslug/ListTargets(var/dist = 7)
	var/list/L = list()
	for(var/a in hearers(src, dist))
		if(istype(a,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = a
			if(H.species.get_bodytype() == SPECIES_VOX)
				continue
		if(isliving(a))
			var/mob/living/M = a
			if(M.faction == faction)
				continue
		L += a

	for (var/obj/mecha/M in mechas_list)
		if (M.z == src.z && get_dist(src, M) <= dist)
			L += M

	return L

/mob/living/simple_animal/hostile/voxslug/get_scooped(var/mob/living/carbon/grabber)
	if(grabber.species.get_bodytype() != SPECIES_VOX)
		to_chat(grabber, "<span class='warning'>\The [src] wriggles out of your hands before you can pick it up!</span>")
		return
	else return ..()

/mob/living/simple_animal/hostile/voxslug/proc/attach(var/mob/living/carbon/human/H)
	var/obj/item/organ/external/chest = H.organs_by_name["chest"]
	var/obj/item/weapon/holder/voxslug/holder = new(get_turf(src))
	src.forceMove(holder)
	chest.embed(holder,0,"\The [src] latches itself onto \the [H]!")
	holder.sync(src)

/mob/living/simple_animal/hostile/voxslug/AttackingTarget()
	. = ..()
	if(istype(., /mob/living/carbon/human))
		var/mob/living/carbon/human/H = .
		if(prob(H.getBruteLoss()/2))
			attach(H)

/mob/living/simple_animal/hostile/voxslug/Life()
	. = ..()
	if(. && istype(src.loc, /obj/item/weapon/holder) && isliving(src.loc.loc)) //We in somebody
		var/mob/living/L = src.loc.loc
		if(src.loc in L.get_visible_implants(0))
			if(prob(1))
				to_chat(L, "<span class='warning'>You feel strange as \the [src] pulses...</span>")
			var/datum/reagents/R = L.reagents
			R.add_reagent(/datum/reagent/cryptobiolin, 0.5)

/obj/item/weapon/holder/voxslug/attack(var/mob/target, var/mob/user)
	var/mob/living/simple_animal/hostile/voxslug/V = contents[1]
	if(!V.stat && istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(!do_mob(user, H, 30))
			return
		user.drop_from_inventory(src)
		V.attach(H)
		qdel(src)
		return
	..()