/obj/structure/grille
	name = "grille"
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	icon = 'icons/obj/grille.dmi'
	icon_state = "grille"
	color = COLOR_STEEL
	density = TRUE
	anchored = TRUE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	layer = BELOW_OBJ_LAYER
	explosion_resistance = 1
	rad_resistance_modifier = 0.1
	health_max = 10
	damage_hitsound = 'sound/effects/grillehit.ogg'
	var/init_material = MATERIAL_STEEL

	blend_objects = list(/obj/machinery/door, /turf/simulated/wall) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)

/obj/structure/grille/broken
	name = "broken grille"
	desc = "The remains of a flimsy lattice of metal rods, with screws to secure it to the floor."
	icon_state = "broken"
	density = FALSE
	health_max = 6

/obj/structure/grille/get_material()
	return material

/obj/structure/grille/proc/is_broken()
	return istype(src, /obj/structure/grille/broken)

/obj/structure/grille/Initialize(mapload, var/new_material)
	. = ..()
	if(!new_material)
		new_material = init_material
	material = SSmaterials.get_material_by_name(new_material)
	if(!istype(material))
		..()
		return INITIALIZE_HINT_QDEL

	var/broken = is_broken()
	name = "[broken ? "broken " : null][material.display_name] grille"
	desc = "[broken ? "The remains of a" : "A"] lattice of [material.display_name] rods, with screws to secure it to the floor."
	color =  material.icon_colour
	set_max_health(max(1, round(material.integrity / 15)))
	update_connections(1)
	update_icon()

/obj/structure/grille/Destroy()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/grille/G in orange(1, location))
		G.update_connections()
		G.queue_icon_update()

/obj/structure/grille/on_update_icon()
	var/on_frame = is_on_frame()

	overlays.Cut()
	if (is_broken())
		if(on_frame)
			icon_state = "broken_onframe"
		else
			icon_state = "broken"
	else
		var/image/I
		icon_state = ""
		if(on_frame)
			for(var/i = 1 to 4)
				if(other_connections[i] != "0")
					I = image(icon, "grille_other_onframe[connections[i]]", dir = SHIFTL(1, i - 1))
				else
					I = image(icon, "grille_onframe[connections[i]]", dir = SHIFTL(1, i - 1))
				overlays += I
		else
			for(var/i = 1 to 4)
				if(other_connections[i] != "0")
					I = image(icon, "grille_other[connections[i]]", dir = SHIFTL(1, i - 1))
				else
					I = image(icon, "grille[connections[i]]", dir = SHIFTL(1, i - 1))
				overlays += I

/obj/structure/grille/Bumped(atom/user)
	if(ismob(user)) shock(user, 70)

/obj/structure/grille/attack_hand(mob/user as mob)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)
	user.do_attack_animation(src)

	var/damage_dealt = 1
	var/attack_message = "kicks"
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_message = "mangles"
			damage_dealt = 5

	if(shock(user, 70))
		return

	if(MUTATION_HULK in user.mutations)
		damage_dealt += 5
	else
		damage_dealt += 1

	attack_generic(user,damage_dealt,attack_message)

/obj/structure/grille/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_GRILLE))
		return 1
	else
		if(istype(mover, /obj/item/projectile))
			return prob(30)
		else
			return !density

/obj/structure/grille/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return

	//Flimsy grilles aren't so great at stopping projectiles. However they can absorb some of the impact
	var/damage = Proj.get_structure_damage()
	var/passthrough = 0

	if(!damage) return

	//20% chance that the grille provides a bit more cover than usual. Support structure for example might take up 20% of the grille's area.
	//If they click on the grille itself then we assume they are aiming at the grille itself and the extra cover behaviour is always used.
	switch(Proj.damage_type)
		if (DAMAGE_BRUTE)
			//bullets
			if(Proj.original == src || prob(20))
				Proj.damage *= clamp(Proj.damage / 60, 0, 0.5)
				if(prob(max((damage-10)/25, 0))*100)
					passthrough = 1
			else
				Proj.damage *= clamp(Proj.damage / 60, 0, 1)
				passthrough = 1
		if (DAMAGE_BURN)
			//beams and other projectiles are either blocked completely by grilles or stop half the damage.
			if(!(Proj.original == src || prob(20)))
				Proj.damage *= 0.5
				passthrough = 1

	if(passthrough)
		. = PROJECTILE_CONTINUE
		damage = clamp((damage - Proj.damage) * (Proj.damage_type == DAMAGE_BRUTE ? 0.4 : 1), 0, 10) //if the bullet passes through then the grille avoids most of the damage

	damage_health(damage, Proj.damage_type)

/obj/structure/grille/attackby(obj/item/W as obj, mob/user as mob)
	if (user.a_intent == I_HURT)
		if (!(W.obj_flags & OBJ_FLAG_CONDUCTIBLE) || !shock(user, 70))
			..()
		return

	if(isWirecutter(W))
		if(!shock(user, 100))
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			new /obj/item/stack/material/rods(get_turf(src), is_broken() ? 1 : 2, material.name)
			qdel(src)
		return

	if((isScrewdriver(W)) && (istype(loc, /turf/simulated) || anchored))
		if(!shock(user, 90))
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			anchored = !anchored
			user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the grille.</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the grille to" : "unfastened the grill from"] the floor.</span>")
			update_connections(1)
			update_icon()
		return

//window placing
	if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(ST.material.opacity > 0.7)
			return 0

		var/dir_to_set = 5
		if(!is_on_frame())
			if(loc == user.loc)
				dir_to_set = user.dir
			else
				dir_to_set = get_dir(loc, user)
				if(dir_to_set & (dir_to_set - 1)) //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
					to_chat(user, "<span class='notice'>You can't reach.</span>")
					return
		place_window(user, loc, dir_to_set, ST)
		return

	if (!(W.obj_flags & OBJ_FLAG_CONDUCTIBLE) || !shock(user, 70))
		..()

/obj/structure/grille/on_death(new_death_state)
	visible_message(SPAN_WARNING("\The [src] falls to pieces!"))
	new /obj/item/stack/material/rods(get_turf(src), 1, material.name)
	new /obj/structure/grille/broken(get_turf(src), material.name)
	qdel(src)

/obj/structure/grille/broken/on_death(new_death_state)
	visible_message(SPAN_WARNING("The remains of \the [src] break apart!"))
	new /obj/item/stack/material/rods(get_turf(src), 1, material.name)
	qdel(src)

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user as mob, prb)
	if(!anchored || is_broken())		// anchored/destroyed grilles are never connected
		return 0
	if(material && !material.conductive)
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent TK and exosuit users from getting shocked
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			if(C.powernet)
				C.powernet.trigger_warning()
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(user.stunned)
				return 1
		else
			return 0
	return 0

/obj/structure/grille/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (!is_broken() && exposed_temperature > material.melting_point)
		damage_health(1, DAMAGE_BURN)
	..()

/obj/structure/grille/cult
	name = "cult grille"
	desc = "A matrice built out of an unknown material, with some sort of force field blocking air around it."
	init_material = MATERIAL_CULT

/obj/structure/grille/cult/CanPass(atom/movable/mover, turf/target, height = 1.5, air_group = 0)
	if(air_group)
		return 0 //Make sure air doesn't drain
	..()

/obj/structure/grille/proc/is_on_frame()
	if(locate(/obj/structure/wall_frame) in loc)
		return TRUE

/proc/place_grille(mob/user, loc, obj/item/stack/material/rods/ST)
	if(ST.in_use)
		return
	if(ST.get_amount() < 2)
		to_chat(user, "<span class='warning'>You need at least two rods to do this.</span>")
		return
	to_chat(user, "<span class='notice'>Assembling grille...</span>")
	ST.in_use = 1
	if (!do_after(user, 1 SECOND, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		ST.in_use = 0
		return
	if(!ST.use(2))
		return
	var/obj/structure/grille/F = new /obj/structure/grille(loc, ST.material.name)
	to_chat(user, "<span class='notice'>You assemble a grille</span>")
	ST.in_use = 0
	F.add_fingerprint(user)
