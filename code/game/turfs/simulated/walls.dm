/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to separate rooms."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "generic"
	opacity = 1
	density = TRUE
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	atom_flags = ATOM_FLAG_CAN_BE_PAINTED

	var/damage_overlay = 0
	var/static/damage_overlays[16]
	var/active
	var/can_open = 0
	var/material/material
	var/material/reinf_material
	var/last_state
	var/construction_stage
	var/hitsound = 'sound/weapons/Genhit.ogg'
	var/list/wall_connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/floor_type = /turf/simulated/floor/plating //turf it leaves after destruction
	var/paint_color
	var/stripe_color
	var/static/list/wall_stripe_cache = list()
	var/list/blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall/wood, /turf/simulated/wall/walnut, /turf/simulated/wall/maple, /turf/simulated/wall/mahogany, /turf/simulated/wall/ebony)
	var/list/blend_objects = list(/obj/machinery/door, /obj/structure/wall_frame, /obj/structure/grille, /obj/structure/window/reinforced/full, /obj/structure/window/reinforced/polarized/full, /obj/structure/window/shuttle, ,/obj/structure/window/boron_basic/full, /obj/structure/window/boron_reinforced/full) // Objects which to blend with
	var/list/noblend_objects = list(/obj/machinery/door/window) //Objects to avoid blending with (such as children of listed blend objects.)

/turf/simulated/wall/New(newloc, materialtype, rmaterialtype)
	..(newloc)
	icon_state = "blank"
	if (!materialtype)
		materialtype = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(materialtype)
	if (!isnull(rmaterialtype))
		reinf_material = SSmaterials.get_material_by_name(rmaterialtype)
	update_material()
	hitsound = material.hitsound

/turf/simulated/wall/Initialize()
	set_extension(src, /datum/extension/penetration/proc_call, .proc/CheckPenetration)
	START_PROCESSING(SSturf, src) //Used for radiation.
	. = ..()

/turf/simulated/wall/Destroy()
	STOP_PROCESSING(SSturf, src)
	. = ..()

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/protects_atom(atom/A)
	var/obj/O = A
	return (istype(O) && O.hides_under_flooring()) || ..()

/turf/simulated/wall/Process(wait, times_fired)
	var/how_often = max(round(2 SECONDS/wait), 1)
	if (times_fired % how_often)
		return //We only work about every 2 seconds
	if (!radiate())
		return PROCESS_KILL

/turf/simulated/wall/proc/get_material()
	return material

/turf/simulated/wall/proc/calculate_damage_data()
	// Health
	var/max_health = material.integrity * 1.5
	if (reinf_material)
		max_health += round(reinf_material.integrity * 0.75)
	set_max_health(max_health)

	// Minimum force required to damage the wall
	health_min_damage = material.hardness * 2.6
	if (reinf_material)
		health_min_damage += round(reinf_material.hardness * 1.9)
	health_min_damage = round(health_min_damage / 10)

	// Brute and burn armor
	var/brute_armor = material.brute_armor * 0.4
	var/burn_armor = material.burn_armor * 0.4
	if (reinf_material)
		brute_armor += reinf_material.brute_armor * 0.4
		burn_armor += reinf_material.burn_armor * 0.4
	// Materials enter armor as divisors, health system uses multipliers
	if (brute_armor)
		brute_armor = round(1 / brute_armor, 0.01)
	if (burn_armor)
		burn_armor = round(1 / burn_armor, 0.01)
	set_damage_resistance(DAMAGE_BRUTE, brute_armor)
	set_damage_resistance(DAMAGE_BURN, burn_armor)

/turf/simulated/wall/bullet_act(obj/item/projectile/Proj)
	if (istype(Proj,/obj/item/projectile/beam))
		burn(2500)
	else if (istype(Proj,/obj/item/projectile/ion))
		burn(500)

	if (Proj.ricochet_sounds && prob(15))
		playsound(src, pick(Proj.ricochet_sounds), 100, 1)
		new /obj/effect/sparks(get_turf(Proj))

	create_bullethole(Proj)//Potentially infinite bullet holes but most walls don't last long enough for this to be a problem.
	..()

/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/vine/plant in range(src, 1))
		if (!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_icon()
			plant.pixel_x = 0
			plant.pixel_y = 0

/turf/simulated/wall/ChangeTurf(newtype, tell_universe = TRUE, force_lighting_update = FALSE, keep_air = FALSE)
	clear_plants()
	clear_bulletholes()
	. = ..(newtype, tell_universe, force_lighting_update, keep_air)
	var/turf/new_turf = .
	for (var/turf/simulated/wall/W in RANGE_TURFS(new_turf, 1))
		if (W == src)
			continue
		W.update_connections()
		W.queue_icon_update()

//Appearance
/turf/simulated/wall/examine(mob/user)
	. = ..()

	if (paint_color)
		to_chat(user, SPAN_NOTICE("It has a coat of paint applied."))
	if (locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, SPAN_WARNING("There is fungus growing on [src]."))

//Damage

/turf/simulated/wall/melt()

	if (!can_melt())
		return

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	if (!F)
		return
	F.burn_tile()
	F.icon_state = "wall_thermite"
	visible_message(SPAN_DANGER("\The [src] spontaneously combusts!.")) //!!OH SHIT!!
	return

/turf/simulated/wall/can_damage_health(damage, damage_type)
	var/area/A = get_area(src)
	if (!A.can_modify_area())
		return FALSE
	return ..()

/turf/simulated/wall/get_max_health()
	. = ..()
	if (locate(/obj/effect/overlay/wallrot) in src)
		. = round(. / 10)

/turf/simulated/wall/post_health_change(damage, prior_health, damage_type)
	..()
	queue_icon_update()

/turf/simulated/wall/on_death()
	dismantle_wall(TRUE)

/turf/simulated/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air
	burn(exposed_temperature)
	..()

/turf/simulated/wall/get_material_melting_point()
	var/melting_point = material.melting_point
	if (reinf_material)
		melting_point += reinf_material.melting_point
	return melting_point

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	fire_act(adj_air, adj_temp, adj_volume)

/turf/simulated/wall/proc/dismantle_wall(devastated, no_product)

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if (!no_product)
		if (reinf_material)
			reinf_material.place_dismantled_girder(src, reinf_material)
		else
			material.place_dismantled_girder(src)
		material.place_dismantled_product(src,devastated)

	for(var/obj/O in src.contents) //Eject contents!
		if (istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.forceMove(src)

	clear_plants()
	clear_bulletholes()
	material = SSmaterials.get_material_by_name("placeholder")
	reinf_material = null
	update_connections(1)

	ChangeTurf(floor_type)

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if (locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/simulated/wall/proc/can_melt()
	if (material.flags & MATERIAL_UNMELTABLE)
		return 0
	return 1

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if (!can_melt())
		return
	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.SetName("Thermite")
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = TRUE
	O.set_density(1)
	O.plane = LIGHTING_PLANE
	O.layer = FIRE_LAYER

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	to_chat(user, SPAN_WARNING("The thermite starts melting through the wall."))

	spawn(100)
		if (O)
			qdel(O)
//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/proc/radiate()
	var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
	if (!total_radiation)
		return

	SSradiation.radiate(src, total_radiation)
	return total_radiation

/turf/simulated/wall/proc/burn(temperature)
	if (material.combustion_effect(src, temperature, 0.7))
		addtimer(new Callback(src, .proc/burn_adjacent, temperature), 2, TIMER_UNIQUE)

/turf/simulated/wall/proc/burn_adjacent(temperature)
	var/list/nearby_atoms = range(3,src)
	for (var/turf/simulated/wall/W in nearby_atoms)
		W.burn(temperature * 0.25)
	for (var/obj/machinery/door/airlock/phoron/D in nearby_atoms)
		D.ignite(temperature * 0.25)
	kill_health()

/turf/simulated/wall/get_color()
	return paint_color

/turf/simulated/wall/set_color(color)
	paint_color = color
	update_icon()

/turf/simulated/wall/proc/CheckPenetration(base_chance, damage)
	return round(damage / get_max_health() * 180)

/turf/simulated/wall/can_engrave()
	return (material && material.hardness >= 10 && material.hardness <= 100)

/turf/simulated/wall/is_wall()
	return TRUE
