
/obj/item/weapon/grenade/plasma
	name = "Type-1 Antipersonnel Grenade"
	desc = "When activated, the coating of this grenade becomes a powerful adhesive, sticking to anyone it is thrown at."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "plasmagrenade"
	throw_speed = 0.2
	throw_range = 7
	var/alt_explosion_damage_max = 500 //The amount of damage done when grenade is stuck inside someone
	var/alt_explosion_range = 1
	arm_sound = 'code/modules/halo/sounds/Plasmanadethrow.ogg'

/obj/item/weapon/grenade/plasma/activate(var/mob/living/carbon/human/h)
	if(istype(h) && istype(h.species,/datum/species/unggoy) && prob(1))
		playsound(h.loc, 'code/modules/halo/sounds/unggoy_grenade_throw.ogg', 100, 1)
	. = ..()


/obj/item/weapon/grenade/plasma/throw_impact(var/atom/A)
	. = ..()
	if(!active)
		return
	var/mob/living/L = A
	if(!istype(L))
		return
	if(prob(25))
		L.embed(src)
		A.visible_message("<span class = 'danger'>[src.name] sticks to [L.name]!</span>")

/obj/item/weapon/grenade/plasma/detonate()
	var/mob/living/carbon/human/mob_containing = loc
	if(istype(mob_containing))
		mob_containing.adjustFireLoss(alt_explosion_damage_max)
		to_chat(mob_containing,"<span class = 'danger'>[src] explodes! The immense heat burns through your flesh...</span>")

		for(var/obj/item/organ/external/o in mob_containing.bad_external_organs)
			for(var/datum/wound/w in o.wounds)
				for(var/obj/embedded in w.embedded_objects)
					if(embedded == src)
						w.embedded_objects -= embedded //Removing the embedded item from the wound
	else
		for(var/mob/living/hit_mob in range(alt_explosion_range,src))
			hit_mob.adjustFireLoss(alt_explosion_damage_max/2)
			to_chat(hit_mob,"<span class = 'danger'>[src] explodes! Heat from the explosion washes over your body...</span>")

	var/turf/epicenter = get_turf(src)
	//the custom sfx itself
	for(var/mob/M in GLOB.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			// If inside the blast radius + world.view - 2
			if(dist <= round(alt_explosion_range + world.view - 2, 1))
				M.playsound_local(epicenter, 'code/modules/halo/sounds/Plasmanadedetonate.ogg', 100, 1)

	mob_containing.contents -= src
	loc = null
	qdel(src)

/obj/item/weapon/grenade/plasma/heavy_plasma
	name = "Type-1 Antipersonnel Grenade - Modified"
	desc = "When activated, the coating of this grenade becomes a powerful adhesive, sticking to anyone it is thrown at. \
	It seems to be heavier than a normal Type-1, and you doubt you could throw it very far."

	throw_range = 1

	alt_explosion_damage_max = 150
	alt_explosion_range = 1
