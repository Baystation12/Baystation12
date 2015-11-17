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

/obj/item/device/multitool/proc/get_buffer()
	if(buffer_object)
		return buffer_object
	buffer_name = null

/obj/item/device/multitool/proc/set_buffer(var/atom/buffer)
	if(!buffer || istype(buffer))
		buffer_object = buffer
		buffer_name = buffer ? buffer_name : null

/obj/item/device/multitool/resolve_attackby(atom/A, mob/user)
	if(!isobject(A))
		return ..(A, user)

	var/obj/O = A
	var/datum/expansion/multitool/MT = O.expansions[/datum/expansion/multitool]
	if(!MT)
		return ..(A, user)

	MT.interact(src, user)
	return 1
