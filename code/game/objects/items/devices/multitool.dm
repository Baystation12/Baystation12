/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/device/multitool
	name = "multitool"
	desc = "Used for pulsing wires to test which to cut. Not recommended by doctors."
	icon_state = "multitool"
	flags = CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	desc = "You can use this on airlocks or APCs to try to hack them without cutting wires."

	matter = list(DEFAULT_WALL_MATERIAL = 50,"glass" = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

	var/buffer_name
	var/atom/buffer_object

/obj/item/device/multitool/proc/get_buffer(var/typepath)
	// Update the buffer name only when someone fetches the buffer.
	// Means you cannot be sure the source hasn't been destroyed until the very moment it's needed.
	buffer_name = buffer_object ? buffer_object.name : null
	if(buffer_object && (!typepath || istype(buffer_object, typepath)))
		return buffer_object

/obj/item/device/multitool/proc/set_buffer(var/atom/buffer)
	if(!buffer || istype(buffer))
		buffer_name = buffer ? buffer.name : null
		if(buffer != buffer_object)
			if(buffer_object)
				buffer_object.unregister(OBSERVER_EVENT_DESTROY, src)
			buffer_object = buffer
			if(buffer_object)
				buffer_object.register(OBSERVER_EVENT_DESTROY, src, /obj/item/device/multitool/proc/on_buffer_destroyed)

/obj/item/device/multitool/proc/on_buffer_destroyed(var/atom/destroyed_buffer)
	// Only remove the buffered object, don't reset the name
	// This means one cannot know if the buffer has been destroyed until one attempts to use it.
	if(destroyed_buffer == buffer_object)
		buffer_object = null

/obj/item/device/multitool/resolve_attackby(atom/A, mob/user)
	if(!isobj(A))
		return ..(A, user)

	var/obj/O = A
	var/datum/expansion/multitool/MT = O.expansions[/datum/expansion/multitool]
	if(!MT)
		return ..(A, user)

	MT.interact(src, user)
	return 1
