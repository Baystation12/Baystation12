/obj/item/weapon/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers."
	description_info = "This device disrupts shields on directly adjacent tiles (in a + shaped pattern), in a similar way the floor mounted variant does. It is, however, portable and run by an internal battery. Can be recharged with a regular recharger."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "hdiffuser_off"
	origin_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_ILLEGAL = 2)
	var/obj/item/weapon/cell/device/cell
	var/enabled = 0

/obj/item/weapon/shield_diffuser/update_icon()
	if(enabled)
		icon_state = "hdiffuser_on"
	else
		icon_state = "hdiffuser_off"

/obj/item/weapon/shield_diffuser/New()
	cell = new(src)
	..()

/obj/item/weapon/shield_diffuser/Destroy()
	QDEL_NULL(cell)
	if(enabled)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/shield_diffuser/Process()
	if(!enabled)
		return

	for(var/direction in GLOB.cardinal)
		var/turf/simulated/shielded_tile = get_step(get_turf(src), direction)
		for(var/obj/effect/shield/S in shielded_tile)
			// 10kJ per pulse, but gap in the shield lasts for longer than regular diffusers.
			if(istype(S) && !S.diffused_for && !S.disabled_for && cell.checked_use(10 KILOWATTS * CELLRATE))
				S.diffuse(20)

/obj/item/weapon/shield_diffuser/attack_self()
	enabled = !enabled
	update_icon()
	if(enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	to_chat(usr, "You turn \the [src] [enabled ? "on" : "off"].")

/obj/item/weapon/shield_diffuser/examine()
	. = ..()
	to_chat(usr, "The charge meter reads [cell ? cell.percent() : 0]%")
	to_chat(usr, "It is [enabled ? "enabled" : "disabled"].")