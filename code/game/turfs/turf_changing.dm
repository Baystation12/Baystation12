/turf/proc/ReplaceWithLattice(material)
	var base_turf = get_base_turf_by_area(src, TRUE)
	if(type != base_turf)
		src.ChangeTurf(get_base_turf_by_area(src, TRUE))
	if(!locate(/obj/structure/lattice) in src)
		new /obj/structure/lattice(src, material)

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)
// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()
	if (above)
		above.update_mimic()

//Creates a new turf
/turf/proc/ChangeTurf(turf/N, tell_universe = TRUE, force_lighting_update = FALSE, keep_air = FALSE)
	if (!N)
		return

	if(isturf(N) && !N.flooded && N.flood_object)
		QDEL_NULL(flood_object)

	// This makes sure that turfs are not changed to space when one side is part of a zone
	if(N == /turf/space)
		var/turf/below = GetBelow(src)
		if(istype(below) && !istype(below,/turf/space))
			N = /turf/simulated/open

	var/old_density = density
	var/old_air = air
	var/old_hotspot = hotspot
	var/old_turf_fire = null
	var/old_opacity = opacity
	var/old_dynamic_lighting = TURF_IS_DYNAMICALLY_LIT_UNSAFE(src)
	var/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/old_ao_neighbors = ao_neighbors
	var/old_above = above
	var/old_permit_ao = permit_ao
	var/old_zflags = z_flags

	if(isspaceturf(N) || isopenspace(N))
		QDEL_NULL(turf_fire)
	else
		old_turf_fire = turf_fire

	//log_debug("Replacing [src.type] with [N]")

	changing_turf = TRUE

	if(connections) connections.erase_all()

	ClearOverlays()
	underlays.Cut()
	if(istype(src,/turf/simulated))
		//Yeah, we're just going to rebuild the whole thing.
		//Despite this being called a bunch during explosions,
		//the zone will only really do heavy lifting once.
		var/turf/simulated/S = src
		if(S.zone) S.zone.rebuild()

	if(ambient_bitflag) //Should remove everything about current bitflag, let it be recalculated by SS later
		SSambient_lighting.clean_turf(src)

	// Run the Destroy() chain.
	qdel(src)
	var/turf/simulated/W = new N(src)

	if (permit_ao)
		regenerate_ao()

	if (keep_air)
		W.air = old_air

	if(ispath(N, /turf/simulated))
		if(old_hotspot)
			hotspot = old_hotspot
		if (istype(W,/turf/simulated/floor))
			W.RemoveLattice()
	else if(hotspot)
		qdel(hotspot)


	if(tell_universe)
		GLOB.universe.OnTurfChange(W)

	SSair.mark_for_update(src) //handle the addition of the new turf.

	for(var/turf/space/S in range(W,1))
		S.update_starlight()

	W.above = old_above

	W.post_change()
	. = W

	W.ao_neighbors = old_ao_neighbors
	// lighting stuff

	if(SSlighting.initialized)
		recalc_atom_opacity()
		lighting_overlay = old_lighting_overlay
		affecting_lights = old_affecting_lights
		if (old_opacity != opacity || dynamic_lighting != old_dynamic_lighting || force_lighting_update)
			reconsider_lights()
			updateVisibility(src)

		if (dynamic_lighting != old_dynamic_lighting)
			if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(src))
				lighting_build_overlay()
			else
				lighting_clear_overlay()

	W.setup_local_ambient()
	if(z_flags != old_zflags)
		W.rebuild_zbleed()
	// end of lighting stuff

	for(var/turf/T in RANGE_TURFS(src, 1))
		T.update_icon()

	if(density != old_density)
		GLOB.density_set_event.raise_event(src, old_density, density)

	if(!density)
		turf_fire = old_turf_fire
	else if(old_turf_fire)
		QDEL_NULL(old_turf_fire)

	if(density != old_density || permit_ao != old_permit_ao)
		regenerate_ao()

	GLOB.turf_changed_event.raise_event(src, old_density, density, old_opacity, opacity)
	updateVisibility(src, FALSE)

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0
	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	CopyOverlays(other)
	src.underlays = other.underlays.Copy()
	if(other.decals)
		src.decals = other.decals.Copy()
		src.update_icon()
	return 1

//I would name this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0

	if(other.zone)
		if(!src.air)
			src.make_air()
		src.air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1

/turf/simulated/wall/transport_properties_from(turf/simulated/wall/other)
	if(!..())
		return 0
	paint_color = other.paint_color
	return 1

//No idea why resetting the base appearence from New() isn't enough, but without this it doesn't work
/turf/simulated/shuttle/wall/corner/transport_properties_from(turf/simulated/other)
	. = ..()
	reset_base_appearance()
