#define TURF_FIRE_REQUIRED_TEMP (T0C+10)
#define TURF_FIRE_TEMP_BASE (T0C+100)
#define TURF_FIRE_POWER_LOSS_ON_LOW_TEMP 7
#define TURF_FIRE_TEMP_INCREMENT_PER_POWER 3
#define TURF_FIRE_VOLUME 150
#define TURF_FIRE_MAX_POWER 50

#define TURF_FIRE_ENERGY_PER_BURNED_OXY_MOL 12000
#define TURF_FIRE_BURN_RATE_BASE 0.12
#define TURF_FIRE_BURN_RATE_PER_POWER 0.02
#define TURF_FIRE_BURN_CARBON_DIOXIDE_MULTIPLIER 0.75
#define TURF_FIRE_BURN_MINIMUM_OXYGEN_REQUIRED 0.5
#define TURF_FIRE_BURN_PLAY_SOUND_EFFECT_CHANCE 6

#define TURF_FIRE_STATE_SMALL 1
#define TURF_FIRE_STATE_MEDIUM 2
#define TURF_FIRE_STATE_LARGE 3

/obj/effect/turf_fire
	icon = 'icons/effects/turf_fire.dmi'
	base_icon_state = "red"
	icon_state = "red_small"
	layer = BELOW_OPEN_DOOR_LAYER
	anchored = TRUE
	move_resist = INFINITY
	light_range = 1.5
	light_power = 1.5
	light_color = LIGHT_COLOR_FIRE
	mouse_opacity = FALSE
	/// How much power have we got. This is treated like fuel, be it flamethrower liquid or any random thing you could come up with
	var/fire_power = 20
	/// If false, it does not interact with atmos.
	var/interact_with_atmos = TRUE

	/// If false, it will not lose power by itself. Mainly for adminbus events or mapping.
	var/passive_loss = TRUE

	/// Visual state of the fire. Kept track to not do too many updates.
	var/current_fire_state

	/// the list of allowed colors, if fire_color doesn't match, we store the color in hex_color instead and we color the fire based on hex instead
	var/list/allowed_colors = list("red", "blue", "green", "white")

	/// If we are using a custom hex color, which color are we using?
	var/hex_color

///All the subtypes are for adminbussery and or mapping
/obj/effect/turf_fire/magical
	interact_with_atmos = FALSE
	passive_loss = FALSE

/obj/effect/turf_fire/small
	fire_power = 10

/obj/effect/turf_fire/small/magical
	interact_with_atmos = FALSE
	passive_loss = FALSE

/obj/effect/turf_fire/inferno
	fire_power = 30

/obj/effect/turf_fire/inferno/magical
	interact_with_atmos = FALSE
	passive_loss = FALSE

/obj/effect/turf_fire/Initialize(mapload, power, fire_color)
	. = ..()
	var/turf/open_turf = loc
	if(open_turf.turf_fire)
		return INITIALIZE_HINT_QDEL

	// var/static/list/loc_connections = list(
	// 	COMSIG_ATOM_ENTERED = .proc/on_entered,
	// )
	// AddElement(/datum/element/connect_loc, loc_connections)

	if(!fire_color)
		base_icon_state = "red"
	else if(fire_color in allowed_colors)
		base_icon_state = fire_color
	else
		hex_color = fire_color
		color = fire_color
		base_icon_state = "greyscale"

	open_turf.turf_fire = src
	SSturf_fire.fires += src
	if(power)
		fire_power = min(TURF_FIRE_MAX_POWER, power)
	UpdateFireState()

/obj/effect/turf_fire/Destroy()
	var/turf/open/open_turf = loc
	open_turf.turf_fire = null
	SSturf_fire.fires -= src
	return ..()

/obj/effect/turf_fire/proc/process_waste()
	var/turf/open/open_turf = loc
	if(open_turf.planetary_atmos)
		return TRUE
	var/datum/gas_mixture/cached_air = open_turf.air
	var/oxy = cached_air.get_moles(GAS_O2)
	if (oxy < TURF_FIRE_BURN_MINIMUM_OXYGEN_REQUIRED)
		return FALSE
	var/temperature = cached_air.return_temperature()
	var/old_heat_capacity = cached_air.heat_capacity()
	var/burn_rate = TURF_FIRE_BURN_RATE_BASE + fire_power * TURF_FIRE_BURN_RATE_PER_POWER
	if(burn_rate > oxy)
		burn_rate = oxy

	var/new_o2 = (cached_air.get_moles(GAS_O2) - burn_rate)
	cached_air.set_moles(GAS_O2, new_o2)

	var/new_co2 = (cached_air.get_moles(GAS_O2) + burn_rate * TURF_FIRE_BURN_CARBON_DIOXIDE_MULTIPLIER)
	cached_air.set_moles(GAS_CO2, new_co2)

	var/new_heat_capacity = cached_air.heat_capacity()
	var/energy_released = burn_rate * TURF_FIRE_ENERGY_PER_BURNED_OXY_MOL
	cached_air.adjust_heat((temperature * old_heat_capacity + energy_released) / new_heat_capacity)
	open_turf.air = cached_air
	open_turf.air_update_turf(TRUE)
	return TRUE

/obj/effect/turf_fire/process()
	var/turf/current_turf = loc
	if(!isopenturf(current_turf)) //This can happen, how I'm not sure
		qdel(src)
		return
	var/turf/open/open_turf = loc
	if(open_turf.active_hotspot) //If we have an active hotspot, let it do the damage instead and lets not loose power
		return
	if(interact_with_atmos)
		if(!process_waste())
			qdel(src)
			return
	if(passive_loss)
		if(open_turf.air.return_temperature() < TURF_FIRE_REQUIRED_TEMP)
			fire_power -= TURF_FIRE_POWER_LOSS_ON_LOW_TEMP
		fire_power--
		if(fire_power <= 0)
			qdel(src)
			return
	open_turf.hotspot_expose(TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), TURF_FIRE_VOLUME)
	for(var/atom/movable/burning_atom as anything in open_turf)
		burning_atom.fire_act(TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), TURF_FIRE_VOLUME)
	if(interact_with_atmos)
		if(prob(fire_power))
			open_turf.burn_tile()
		if(prob(TURF_FIRE_BURN_PLAY_SOUND_EFFECT_CHANCE))
			playsound(open_turf, 'sound/effects/comfyfire.ogg', 40, TRUE)
		UpdateFireState()

/obj/effect/turf_fire/proc/on_entered(datum/source, atom/movable/atom_crossing)
	var/turf/open/open_turf = loc
	if(open_turf.active_hotspot) //If we have an active hotspot, let it do the damage instead
		return
	atom_crossing.fire_act(TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), TURF_FIRE_VOLUME)
	return

/obj/effect/turf_fire/extinguish()
	qdel(src)

/obj/effect/turf_fire/proc/AddPower(power)
	fire_power = min(TURF_FIRE_MAX_POWER, fire_power + power)
	UpdateFireState()

/obj/effect/turf_fire/proc/UpdateFireState()
	var/new_state
	switch(fire_power)
		if(0 to 10)
			new_state = TURF_FIRE_STATE_SMALL
		if(11 to 24)
			new_state = TURF_FIRE_STATE_MEDIUM
		if(25 to INFINITY)
			new_state = TURF_FIRE_STATE_LARGE

	if(new_state == current_fire_state)
		return
	current_fire_state = new_state

	switch(base_icon_state) //switches light color depdning on the flame color
		if("greyscale")
			light_color = hex_color
		if("red")
			light_color = LIGHT_COLOR_FIRE
		if("blue")
			light_color = LIGHT_COLOR_CYAN
		if("green")
			light_color = LIGHT_COLOR_GREEN
		else
			light_color = COLOR_VERY_LIGHT_GRAY
	update_light()

	switch(current_fire_state)
		if(TURF_FIRE_STATE_SMALL)
			icon_state = "[base_icon_state]_small"
			set_light_range(1.5)
		if(TURF_FIRE_STATE_MEDIUM)
			icon_state = "[base_icon_state]_medium"
			set_light_range(2.5)
		if(TURF_FIRE_STATE_LARGE)
			icon_state = "[base_icon_state]_big"
			set_light_range(3)

#undef TURF_FIRE_REQUIRED_TEMP
#undef TURF_FIRE_TEMP_BASE
#undef TURF_FIRE_POWER_LOSS_ON_LOW_TEMP
#undef TURF_FIRE_TEMP_INCREMENT_PER_POWER
#undef TURF_FIRE_VOLUME
#undef TURF_FIRE_MAX_POWER

#undef TURF_FIRE_ENERGY_PER_BURNED_OXY_MOL
#undef TURF_FIRE_BURN_RATE_BASE
#undef TURF_FIRE_BURN_RATE_PER_POWER
#undef TURF_FIRE_BURN_CARBON_DIOXIDE_MULTIPLIER
#undef TURF_FIRE_BURN_MINIMUM_OXYGEN_REQUIRED
#undef TURF_FIRE_BURN_PLAY_SOUND_EFFECT_CHANCE

#undef TURF_FIRE_STATE_SMALL
#undef TURF_FIRE_STATE_MEDIUM
#undef TURF_FIRE_STATE_LARGE
