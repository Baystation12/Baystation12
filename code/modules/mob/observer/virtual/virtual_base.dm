var/list/all_virtual_listeners = list()

/mob/observer/virtual
	mouse_opacity = 0
	invisibility = INVISIBILITY_SYSTEM
	see_invisible = SEE_INVISIBLE_SYSTEM
	icon = 'icons/mob/virtual.dmi'

	var/atom/host
	var/host_type = /atom/movable
	var/abilities = VIRTUAL_ABILITY_HEAR|VIRTUAL_ABILITY_SEE
	var/list/broadcast_methods

	var/static/list/overlay_icons

/mob/observer/virtual/New(var/location, var/atom/movable/host)
	..()
	if(!istype(host, host_type))
		CRASH("Received an unexpected host type. Expected [host_type], was [host.type].")
	src.host = host
	moved_event.register(host, src, /atom/movable/proc/move_to_destination)

	mob_list -= src
	all_virtual_listeners += src

	if(!broadcast_methods)
		broadcast_methods = default_broadcasts

	updateicon()

/mob/observer/virtual/Destroy()
	moved_event.unregister(host, src, /atom/movable/proc/move_to_destination)
	all_virtual_listeners -= src
	host = null
	return ..()

/mob/observer/virtual/proc/broadcast(var/datum/communication/c, var/datum/communication_metadata/cm)
	for(var/method in broadcast_methods)
		var/datum/broadcast/b = method
		if(b.attempt_broadcast(src, c, cm))
			return

/mob/observer/virtual/proc/receive_sound(var/datum/communication/c, var/datum/communication_metadata/cm)
	host.hear(c, cm)

/mob/observer/virtual/proc/receive_sight(var/input, var/datum/communication_metadata/cm)
	host.see(input, cm)

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

/mob/observer/virtual/examinate()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/observer/virtual/pointed()
	set popup_menu = 0
	set src = usr.contents
	return 0

/atom
	var/datum/speech_handler/speech_handler
	var/mob/observer/virtual/virtual

/atom/New()
	..()
	if(ispath(virtual))
		virtual = new(get_turf(src), src)

/atom/Destroy()
	if(virtual && !ispath(virtual))
		qdel(virtual)
		virtual = null
	return ..()
