
/obj/item/weapon/grenade/plasma
	name = "Type-1 Antipersonnel Grenade"
	desc = "When activated, the coating of this grenade becomes a powerful adhesive, sticking to anyone it is thrown at."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "plasmagrenade"
	throw_speed = 1
	var/alt_explosion_damage_max = 70 //The amount of damage done when grenade is stuck inside someone
	var/alt_explosion_range = 2
	arm_sound = 'code/modules/halo/sounds/Plasmanadethrow.ogg'

/obj/item/weapon/grenade/plasma/throw_impact(var/atom/A)
	. = ..()
	if(!active)
		return
	var/mob/living/L = A
	if(!istype(L))
		return
	L.embed(src)
	A.visible_message("<span class = 'danger'>[src.name] sticks to [L.name]!</span>")

/obj/item/weapon/grenade/plasma/detonate()
	var/mob/living/carbon/human/mob_containing = loc
	if(istype(mob_containing))
		mob_containing.adjustFireLoss(alt_explosion_damage_max)
		to_chat(mob_containing,"<span class = 'danger'>[src] explodes! The immense heat burns through your flesh...</span>")
	else
		for(var/mob/living/hit_mob in range(alt_explosion_range,src))
			hit_mob.adjustFireLoss(alt_explosion_damage_max/2)
			to_chat(hit_mob,"<span class = 'danger'>[src] explodes! Heat from the explosion washes over your body...</span>")

	//a hack to give the explosion custom sfx
	//explosion(src.loc, -1, -1, 3, 5, 0)
	var/turf/epicenter = get_turf(src)
	var/max_range = 3
	for(var/turf/T in trange(max_range, epicenter))
		var/dist = sqrt((T.x - epicenter.x)**2 + (T.y - epicenter.x)**2)

		T.ex_act(3)
		if(!T)
			T = locate(epicenter.x,epicenter.y,epicenter.z)
		for(var/atom_movable in T.contents)	//bypass type checking since only atom/movable can be contained by turfs anyway
			var/atom/movable/AM = atom_movable
			if(AM && AM.simulated && !T.protects_atom(AM))
				AM.ex_act(dist)

	//the custom sfx itself
	for(var/mob/M in GLOB.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			// If inside the blast radius + world.view - 2
			if(dist <= round(max_range + world.view - 2, 1))
				M.playsound_local(epicenter, 'code/modules/halo/sounds/Plasmanadedetonate.ogg', 100, 1)

	loc.contents -= src
	qdel(src)

/obj/item/weapon/grenade/plasma/heavy_plasma
	name = "Type-1 Antipersonnel Grenade - Modified"
	desc = "When activated, the coating of this grenade becomes a powerful adhesive, sticking to anyone it is thrown at. \
	It seems to be heavier than a normal Type-1, and you doubt you could throw it very far."

	throw_range = 1

	alt_explosion_damage_max = 100
	alt_explosion_range = 1
