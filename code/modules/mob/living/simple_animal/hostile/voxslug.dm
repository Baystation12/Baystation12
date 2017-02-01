/*VOX SLUG
Small, little HP, poisonous.
*/

/mob/living/simple_animal/hostile/voxslug
	name = "slug"
	desc = "A viscious little creature, it has a mouth of too many teeth and a penance for blood."
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
	min_oxy = 0
	mob_size = MOB_MINISCULE
	pass_flags = PASSTABLE
	melee_damage_lower = 5
	melee_damage_upper = 10
	holder_type = /obj/item/weapon/holder/voxslug
	faction = "Vox"

/mob/living/simple_animal/hostile/voxslug/ListTargets(var/dist = 7)
	var/list/L = list()
	for(var/a in hearers(src, dist))
		if(istype(a,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = a
			if(H.species.get_bodytype() == "Vox")
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

/mob/living/simple_animal/hostile/voxslug/MouseDrop(atom/over_object)
	if(!Adjacent(over_object))
		return ..()
	if(istype(over_object,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = over_object
		if(H.species.get_bodytype() == "Vox")
			get_scooped(H)
			return
	to_chat(over_object, "<span class='warning'>\The [src] wriggles out of your hands before you can pick it up!</span>")
	return ..()

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
	if(!stat && istype(src.loc, /obj/item/weapon/holder)) //We in somebody
		var/mob/living/carbon/human/H = src.loc.loc
		if(prob(1))
			to_chat(H, "<span class='warning'>You feel strange as \the [src] pulses...</span>")
		var/datum/reagents/R = H.reagents
		R.add_reagent("synaptizine", 0.5)
		return 1
	return ..() //only do generic stuff if we not in somebody

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