/obj/item/mounted/frame/newscaster
	name = "Unhinged Newscaster"
	desc = "The difference between an unhinged newscaster and a journalist is that one of them is actually crazy."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "newscaster_off"
	mount_reqs = MOUNTREQ_SIMFLOOR|MOUNTREQ_NOSPACE
	var/securityCaster = 0

/obj/item/mounted/frame/newscaster/do_build(turf/on_wall, mob/user)
	var/obj/machinery/newscaster/caster = new(get_turf(src), get_dir(user, on_wall))
	caster.securityCaster = securityCaster
	qdel(src)
