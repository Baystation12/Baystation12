
/obj/item/weapon/grenade/plasma
	name = "Type-1 Antipersonnel Grenade"
	desc = "When activated, the coating of this grenade becomes a powerful adhesive, sticking to anyone it is thrown at."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "plasmagrenade"
	throw_speed = 0 //sleep each tick
	det_time = 50
	can_adjust_timer = 0
	arm_sound = 'code/modules/halo/sounds/Plasmanadethrow.ogg'
	alt_explosion_range = 1
	alt_explosion_damage_max = 50

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
	L.embed(src)
	A.visible_message("<span class = 'danger'>[src.name] sticks to [L.name]!</span>")

/obj/item/weapon/grenade/plasma/detonate()
	var/turf/epicenter = get_turf(src)

	//visual effect
	var/obj/effect/plasma_explosion/P = new(epicenter)
	P.pixel_x += src.pixel_x
	P.pixel_y += src.pixel_y

	//the custom sfx itself
	for(var/mob/M in GLOB.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			// If inside the blast radius + world.view - 2
			if(dist <= round(alt_explosion_range + world.view - 2, 1))
				M.playsound_local(epicenter, 'code/modules/halo/sounds/Plasmanadedetonate.ogg', 100, 1)
	var/mob/living/carbon/human/mob_containing = loc
	do_alt_explosion()
	if(istype(mob_containing))
		mob_containing.contents -= src
	loc = null
	qdel(src)

//plasma grenade visual effect
/obj/effect/plasma_explosion
	name = "plasma blast"
	icon = 'code/modules/halo/weapons/covenant/plasma_explosion.dmi'
	icon_state = "plasma_explosion"
	var/lifetime = 7

/obj/effect/plasma_explosion/New()
	. = ..()
	pixel_x -= 32
	pixel_y -= 32
	spawn(lifetime)
		qdel(src)

//fuel rod visual effect
/obj/effect/plasma_explosion/green
	lifetime = 4
	icon_state = "green"
