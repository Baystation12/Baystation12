/turf/simulated/floor
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	permit_ao = TRUE

	// Damage to flooring.
	var/broken
	var/burnt

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'
	var/base_icon_state = "plating"
	var/base_color = COLOR_WHITE

	// Flooring data.
	var/flooring_override
	var/initial_flooring
	var/singleton/flooring/flooring
	var/mineral = DEFAULT_WALL_MATERIAL

	// Initialization modifiers for mapping
	/// Boolean (Default `FALSE`) - If set, the tile will not have atmosphere on init.
	var/map_airless = FALSE

	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/lava = 0

	height = -FLUID_SHALLOW / 2

/turf/simulated/floor/is_plating()
	return !flooring

/turf/simulated/floor/protects_atom(atom/A)
	return (A.level == ATOM_LEVEL_UNDER_TILE && !is_plating()) || ..()

/turf/simulated/floor/New(newloc, floortype)
	var/area/area = get_area(src)
	if (map_airless || area?.turfs_airless)
		initial_gas = null
		temperature = TCMB
	..(newloc)
	if(!floortype && initial_flooring)
		floortype = initial_flooring
	if(floortype)
		set_flooring(GET_SINGLETON(floortype))

/turf/simulated/floor/proc/set_flooring(singleton/flooring/newflooring)
	make_plating(defer_icon_update = 1)
	flooring = newflooring
	update_icon(1)
	levelupdate()

//This proc will set floor_type to null and the update_icon() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/simulated/floor/proc/make_plating(place_product, defer_icon_update)

	ClearOverlays()

	for(var/obj/decal/writing/W in src)
		qdel(W)

	SetName(base_name)
	desc = base_desc
	icon = base_icon
	icon_state = base_icon_state
	color = base_color
	layer = PLATING_LAYER

	if(flooring)
		flooring.on_remove()
		if(flooring.build_type && place_product)
			new flooring.build_type(src)
		flooring = null

	set_light(0)
	broken = null
	burnt = null
	flooring_override = null
	levelupdate()

	if(!defer_icon_update)
		update_icon(1)

/turf/simulated/floor/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && src.flooring)

	if(flooring)
		layer = TURF_LAYER
		height = flooring.height
	else
		layer = PLATING_LAYER
		height = -FLUID_SHALLOW / 2

/turf/simulated/floor/can_engrave()
	return (!flooring || flooring.can_engrave)

/turf/simulated/floor/shuttle_ceiling
	name = "hull plating"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced_light"
	initial_gas = null

/turf/simulated/floor/shuttle_ceiling/air
	initial_gas = list(GAS_OXYGEN = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)

/turf/simulated/floor/is_floor()
	return TRUE

/turf/simulated/IgniteTurf(power, fire_colour)
	if(turf_fire)
		turf_fire.AddPower(power)
		return
	new /obj/turf_fire(src, power, fire_colour)
