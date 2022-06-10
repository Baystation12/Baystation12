#define DIRECT_HEAT 1000
#define IDEAL_FUEL  15
#define HIGH_FUEL   10
#define LOW_FUEL    5
#define FIRE_LIT    1
#define FIRE_DEAD  -1
#define FIRE_OUT    0
#define FUEL_CONSUMPTION_CONSTANT 0.1

/obj/structure/fire_source
	name = "campfire"
	desc = "Did anyone bring any marshmallows?"
	icon = 'icons/obj/structures/fire.dmi'
	icon_state = "campfire"
	anchored = TRUE
	density = FALSE

	var/datum/effect/effect/system/steam_spread/steam // Used when being quenched.

	var/const/light_range_high =  3
	var/const/light_range_mid =   2
	var/const/light_range_low =   1
	var/const/light_power_high =  0.8
	var/const/light_power_mid =   0.6
	var/const/light_power_low =   0.4
	var/const/light_color_high = "#ffdd55"
	var/const/light_color_mid =  "#ff9900"
	var/const/light_color_low =  "#ff0000"

	var/list/affected_exterior_turfs
	var/list/exterior_temperature = 30 // Celcius, but it is added directly to a Kelvin value so don't do any conversion.

	var/output_temperature = T0C+50  // The amount that the fire will try to heat up the air.
	var/fuel = 0                     // How much fuel is left?
	var/lit = 0

/obj/structure/fire_source/Initialize()
	. = ..()
	if(lit == FIRE_LIT && fuel > 0)
		light(TRUE)
	update_icon()
	steam = new(name)
	steam.attach(get_turf(src))
	steam.set_up(3, 0, get_turf(src))

/obj/structure/fire_source/Move()
	. = ..()
	if(. && lit == FIRE_LIT)
		refresh_affected_exterior_turfs()

/obj/structure/fire_source/proc/refresh_affected_exterior_turfs()

	if(lit != FIRE_LIT)
		for(var/thing in affected_exterior_turfs)
			var/turf/simulated/floor/exoplanet/T = thing
			LAZYREMOVE(T.affecting_heat_sources, src)
		affected_exterior_turfs = null
	else
		var/list/new_affecting
		for(var/turf/T in RANGE_TURFS(loc, light_range_high))
			LAZYADD(new_affecting, T)
		for(var/thing in affected_exterior_turfs)
			var/turf/simulated/floor/exoplanet/T = thing
			if(!(thing in new_affecting))
				LAZYREMOVE(T.affecting_heat_sources, src)
				LAZYREMOVE(affected_exterior_turfs, T)
			LAZYREMOVE(new_affecting, T)
		for(var/thing in new_affecting)
			var/turf/simulated/floor/exoplanet/T = thing
			LAZYDISTINCTADD(T.affecting_heat_sources, src)
			LAZYDISTINCTADD(affected_exterior_turfs, T)

/obj/structure/fire_source/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	light()

/obj/structure/fire_source/hearth
	name = "hearth fire"
	desc = "So cheery!"
	fuel = 100
	lit = FIRE_LIT

/obj/structure/fire_source/stove
	name = "stove"
	desc = "Just the thing to warm your hands by."
	icon_state = "stove"
	density = TRUE

/obj/structure/fire_source/stove/grab_attack(obj/item/grab/G)
	return FALSE

/obj/structure/fire_source/fireplace
	name = "fireplace"
	desc = "So cheery!"
	icon_state = "fireplace"
	density = TRUE

/obj/structure/fire_source/fireplace/grab_attack(obj/item/grab/G)
	return FALSE

/obj/structure/fire_source/ex_act()
	. = ..()
	if(!QDELETED(src))
		die()

/obj/structure/fire_source/proc/die()
	if(lit == FIRE_LIT)
		lit = FIRE_DEAD
		refresh_affected_exterior_turfs()
		visible_message(SPAN_DANGER("\The [src] goes out!"))
		STOP_PROCESSING(SSobj, src)
		update_icon()

/obj/structure/fire_source/proc/check_atmos()
	var/datum/gas_mixture/GM = loc?.return_air()
	for(var/datum/reagent/g in GM?.gas)
		if(g.gas_flags & XGM_GAS_OXIDIZER)
			return TRUE

/obj/structure/fire_source/proc/light(var/force)
	if(!check_atmos())
		return FALSE
	if(lit == FIRE_LIT && !force)
		return FALSE
	if(!process_fuel())
		return FALSE
	lit = FIRE_LIT
	refresh_affected_exterior_turfs()
	visible_message(SPAN_DANGER("\The [src] catches alight!"))
	START_PROCESSING(SSobj, src)
	update_icon()
	return TRUE

/obj/structure/fire_source/attack_hand(var/mob/user)

	if(length(contents))
		var/obj/item/removing = pick(contents)
		removing.dropInto(loc)
		user.put_in_hands(removing)
		if(lit == FIRE_LIT)
			visible_message(SPAN_DANGER("\The [user] fishes \the [removing] out of \the [src]!"))
			burn(user)
		else
			visible_message(SPAN_NOTICE("\The [user] removes \the [removing] from \the [src]."))
		return TRUE

	if(lit != FIRE_LIT && user.a_intent == I_HURT)
		to_chat(user, SPAN_DANGER("You start stomping on \the [src], trying to destroy it."))
		if(do_after(user, 5 SECONDS, src))
			visible_message(SPAN_DANGER("\The [user] stamps and kicks at \the [src] until it is completely destroyed."))
			qdel(src)
		return TRUE

	. = ..()

/obj/structure/fire_source/grab_attack(var/obj/item/grab/G)
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(!istype(affecting_mob))
		return FALSE
	if (G.assailant.a_intent != I_HURT)
		return TRUE
	if (!G.force_danger())
		to_chat(G.assailant, SPAN_WARNING("You need a better grip!"))
		return TRUE
	affecting_mob.forceMove(get_turf(src))
	affecting_mob.Weaken(5)
	visible_message(SPAN_DANGER("\The [G.assailant] hurls \the [affecting_mob] onto \the [src]!"))
	burn(affecting_mob)
	return TRUE

/obj/structure/fire_source/isflamesource()
	return (lit == FIRE_LIT)

/obj/structure/fire_source/attackby(var/obj/item/thing, var/mob/user)

	if(ATOM_IS_TEMPERATURE_SENSITIVE(thing) && user.a_intent != I_HURT)
		thing.HandleObjectHeating(src, user, DIRECT_HEAT)
		return TRUE

	if(thing.is_open_container())
		if(thing.reagents?.total_volume)
			user.visible_message(SPAN_DANGER("\The [user] pours the contents of \the [thing] into \the [src]!"))
			take_reagents(thing.reagents)
			return TRUE

	if(lit == FIRE_LIT)

		if(istype(thing, /obj/item/flame/match))
			var/obj/item/flame/match/match = thing
			if(!match.burnt && !match.lit)
				match.lit = TRUE
				match.update_icon()
				return TRUE

		if(istype(thing, /obj/item/flame/candle))
			var/obj/item/flame/candle/flame = thing
			flame.light(user)
			return TRUE

	else if(isflamesource(thing))
		visible_message(SPAN_NOTICE("\The [user] attempts to light \the [src] with \the [thing]..."))
		light()
		return TRUE

	if((lit != FIRE_LIT || user.a_intent == I_HURT) && user.unEquip(thing, src))
		user.visible_message(SPAN_NOTICE("\The [user] drops \the [thing] into \the [src]."))
		update_icon()
		return TRUE

	return ..()

/obj/structure/fire_source/proc/process_fuel()

	if(fuel >= IDEAL_FUEL)
		return TRUE

	var/list/waste = list()
	for(var/obj/item/thing in contents)

		if(fuel >= IDEAL_FUEL)
			break

		if(istype(thing, /obj/item/stack))
			var/obj/item/stack/stack = thing
			if(stack.use_material.fuel_value > 0)
				var/fuel_per_unit = 2 * stack.use_material.fuel_value
				var/use_stacks = min(stack.amount, Floor((IDEAL_FUEL - fuel) / fuel_per_unit))
				var/add_fuel = round(fuel_per_unit * use_stacks)
				if(stack.use_material.burn_product)
					if(waste[stack.use_material.burn_product])
						waste[stack.use_material.burn_product] += add_fuel
					else
						waste[stack.use_material.burn_product] = add_fuel
				fuel += add_fuel
				stack.use(use_stacks)
				continue

		var/modified_fuel = FALSE
		for(var/mat in thing.matter)
			var/decl/material/material = GET_DECL(mat)
			if(material.fuel_value > 0)
				modified_fuel = TRUE
				var/add_fuel = round(thing.matter[mat] / SHEET_MATERIAL_AMOUNT) * material.fuel_value
				if(material.burn_product)
					if(waste[material.burn_product])
						waste[material.burn_product] += add_fuel
					else
						waste[material.burn_product] = add_fuel
				fuel += add_fuel

		if(modified_fuel)
			qdel(thing)
			continue

	// Dump waste gas from burned fuel.
	var/turf/T = get_turf(src)
	var/datum/gas_mixture/environment = T?.return_air()
	if(environment && length(waste))
		for(var/w in waste)
			if(waste[w] > 0)
				environment.adjust_gas(w, waste[w], FALSE)
		environment.update_values()

	return (fuel > 0)

/obj/structure/fire_source/proc/take_reagents(datum/reagents/RG)
	var/do_steam = FALSE
	for(var/rtype in RG.reagent_list)
		var/datum/reagent/R = GET_DECL(rtype)
		if(R.fuel_value <= 0)
			do_steam = TRUE
		fuel += REAGENT_VOLUME(RG, rtype) * R.fuel_value
	RG.clear_reagents()
	fuel = max(0, fuel)
	if(lit == FIRE_LIT)
		if(fuel <= 0)
			die()
		if(do_steam)
			steam.start() // HISSSSSS!

/obj/structure/fire_source/Destroy()
	QDEL_NULL(steam)
	STOP_PROCESSING(SSobj, src)
	lit = FIRE_DEAD
	refresh_affected_exterior_turfs()
	return ..()

/obj/structure/fire_source/Process()

	if(!check_atmos())
		die()
		return

	fuel -= FUEL_CONSUMPTION_CONSTANT
	if(!process_fuel())
		die()
		return

	// Burn anyone sitting in the fire.
	var/turf/T = loc
	if(istype(T))
		T.hotspot_expose(DIRECT_HEAT, 500, 1)
		for(var/mob/living/M in T)
			burn(M)
			visible_message(SPAN_DANGER("Flames from \the [src] lick around \the [M]!"))

		// Copied from space heaters. Heat up the air on our tile, heat will percolate out.
		var/datum/gas_mixture/GM = T.return_air()
		if(GM && abs(GM.temperature - output_temperature) > 0.1)
			var/transfer_moles = 0.25 * GM.total_moles
			var/datum/gas_mixture/removed = GM.remove(transfer_moles)
			if(removed)
				var/heat_transfer = removed.get_thermal_energy_change(output_temperature)
				if(heat_transfer > 0) removed.add_thermal_energy(heat_transfer)
			GM.merge(removed)
	queue_icon_update()

/obj/structure/fire_source/on_update_icon()
	..()
	if((fuel || length(contents)) && (lit != FIRE_DEAD))
		overlays.Add("[icon_state]_full")
	switch(lit)
		if(FIRE_LIT)
			if(fuel >= HIGH_FUEL)
				overlays.Add("[icon_state]_lit")
				set_light(light_range_high, light_power_high, light_color_high)
			else if(fuel <= LOW_FUEL)
				overlays.Add("[icon_state]_lit_dying")
				set_light(light_range_mid, light_power_mid, light_color_mid)
			else
				overlays.Add("[icon_state]_lit_low")
				set_light(light_range_low, light_power_low, light_color_low)

		if(FIRE_DEAD)
			overlays.Add("[icon_state]_burnt")
			set_light(0)
		else
			set_light(0)

/obj/structure/fire_source/proc/burn(var/atom/movable/victim)
	if(isliving(victim))
		var/mob/living/M = victim
		to_chat(M, SPAN_DANGER("You are burned by \the [src]!"))
		M.IgniteMob()
		M.apply_damage(rand(5, 15), DAMAGE_BURN)

#undef FUEL_CONSUMPTION_CONSTANT
#undef FIRE_LIT
#undef FIRE_DEAD
#undef FIRE_OUT
#undef LOW_FUEL
#undef HIGH_FUEL
#undef IDEAL_FUEL
#undef DIRECT_HEAT
