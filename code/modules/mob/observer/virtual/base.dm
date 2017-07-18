var/list/all_virtual_listeners = list()

/mob/observer/virtual
	icon = 'icons/mob/virtual.dmi'
	invisibility = INVISIBILITY_SYSTEM
	see_in_dark = SEE_IN_DARK_DEFAULT
	see_invisible = SEE_INVISIBLE_LIVING
	sight = SEE_SELF

	virtual_mob = null

	var/atom/movable/host
	var/host_type = /atom/movable
	var/abilities = VIRTUAL_ABILITY_HEAR|VIRTUAL_ABILITY_SEE
	var/list/broadcast_methods

	var/static/list/overlay_icons

/mob/observer/virtual/New(var/location, var/atom/movable/host)
	..()
	if(!istype(host, host_type))
		CRASH("Received an unexpected host type. Expected [host_type], was [log_info_line(host)].")
	src.host = host
	moved_event.register(host, src, /atom/movable/proc/move_to_turf_or_null)

	mob_list -= src
	all_virtual_listeners += src

	updateicon()

/mob/observer/virtual/Destroy()
	moved_event.unregister(host, src, /atom/movable/proc/move_to_turf_or_null)
	all_virtual_listeners -= src
	host = null
	return ..()

/mob/observer/virtual/updateicon()
	if(!overlay_icons)
		overlay_icons = list()
		for(var/i_state in icon_states(icon))
			overlay_icons[i_state] = image(icon = icon, icon_state = i_state)
	overlays.Cut()

	if(abilities & VIRTUAL_ABILITY_HEAR)
		overlays += overlay_icons["hear"]
	if(abilities & VIRTUAL_ABILITY_SEE)
		overlays += overlay_icons["see"]

/***********************
* Virtual Mob Creation *
***********************/
/atom/movable
	var/mob/observer/virtual/virtual_mob

/atom/movable/initialize()
	..()
	if(ispath(virtual_mob))
		if(shall_have_virtual_mob())
			virtual_mob = new virtual_mob(get_turf(src), src)
		else
			virtual_mob = null

/atom/movable/Destroy()
	if(virtual_mob && !ispath(virtual_mob))
		qdel(virtual_mob)
	virtual_mob = null
	return ..()

/atom/movable/proc/shall_have_virtual_mob()
	return TRUE

/mob/shall_have_virtual_mob()
	return (src in mob_list)
