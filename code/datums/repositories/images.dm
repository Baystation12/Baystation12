/*
*	This repository is intended for images that are never altered after creation
*/

var/global/repository/images/image_repository = new()

/repository/images
	var/list/image_cache_for_atoms
	var/list/image_cache_for_overlays

/repository/images/New()
	..()
	image_cache_for_atoms = list()
	image_cache_for_overlays = list()

// Returns an image bound to the given atom and which is typically applied to client.images.
/repository/images/proc/atom_image(var/atom/holder, var/icon, var/icon_state, var/plane = FLOAT_PLANE, var/layer = FLOAT_LAYER)
	var/atom_cache_list = image_cache_for_atoms[holder]
	if(!atom_cache_list)
		atom_cache_list = list()
		image_cache_for_atoms[holder] = atom_cache_list
		GLOB.destroyed_event.register(holder, src, /repository/images/proc/atom_destroyed)

	var/cache_key = "[icon]-[icon_state]-[plane]-[layer]"
	. = atom_cache_list[cache_key]
	if(!.)
		var/image/I = image(icon, holder, icon_state)
		I.plane = plane
		I.layer = layer
		atom_cache_list[cache_key] = I
		return I

/repository/images/proc/atom_destroyed(var/atom/destroyed)
	var/list/atom_cache_list = image_cache_for_atoms[destroyed]
	for(var/img in atom_cache_list)
		qdel(atom_cache_list[img])
	atom_cache_list.Cut()
	image_cache_for_atoms -= destroyed

	GLOB.destroyed_event.unregister(destroyed, src, /repository/images/proc/atom_destroyed)

// Returns an image not bound to anything and which is typically applied as an overlay/underlay.
/repository/images/proc/overlay_image(var/icon, var/icon_state, var/alpha, var/appearance_flags, var/color, var/dir, var/plane = FLOAT_PLANE, var/layer = FLOAT_LAYER)
	var/cache_key = "[icon]-[icon_state]-[alpha]-[appearance_flags]-[color]-[dir]-[plane]-[layer]"
	. = image_cache_for_overlays[cache_key]
	if(!.)
		var/image/I = image(icon = icon, icon_state = icon_state)
		if(!isnull(dir))
			I.dir = dir
		if(!isnull(alpha))
			I.alpha = alpha
		if(!isnull(appearance_flags))
			I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | appearance_flags
		if(!isnull(plane))
			I.plane = plane
		if(!isnull(layer))
			I.layer = layer
		image_cache_for_overlays[cache_key] = I
		return I
