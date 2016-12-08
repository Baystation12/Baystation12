/*
	TODO README
*/

var/list/fusion_cores = list()

#define MAX_FIELD_STR 1000
#define MIN_FIELD_STR 1

/obj/machinery/power/fusion_core
	name = "\improper R-UST Mk. 8 Tokamak core"
	desc = "An enormous solenoid for generating extremely high power electromagnetic fields. It includes a kinetic energy harvester."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "core0"
	density = 1
	use_power = 1
	idle_power_usage = 50
	active_power_usage = 500 //multiplied by field strength
	anchored = 0

	var/obj/effect/fusion_em_field/owned_field
	var/field_strength = 1//0.01
	var/id_tag

/obj/machinery/power/fusion_core/mapped
	anchored = 1

/obj/machinery/power/fusion_core/initialize()
	. = ..()
	connect_to_network()
	fusion_cores += src

/obj/machinery/power/fusion_core/Destroy()
	for(var/obj/machinery/computer/fusion_core_control/FCC in machines)
		FCC.connected_devices -= src
		if(FCC.cur_viewed_device == src)
			FCC.cur_viewed_device = null
	fusion_cores -= src
	return ..()

/obj/machinery/power/fusion_core/process()
	if((stat & BROKEN) || !powernet || !owned_field)
		Shutdown()

/obj/machinery/power/fusion_core/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["str"])
		var/dif = text2num(href_list["str"])
		field_strength = min(max(field_strength + dif, MIN_FIELD_STR), MAX_FIELD_STR)
		active_power_usage = 500 * field_strength
		if(owned_field)
			owned_field.ChangeFieldStrength(field_strength)

/obj/machinery/power/fusion_core/proc/Startup()
	if(owned_field)
		return
	owned_field = new(loc, src)
	owned_field.ChangeFieldStrength(field_strength)
	icon_state = "core1"
	use_power = 2
	. = 1

/obj/machinery/power/fusion_core/proc/Shutdown(var/force_rupture)
	if(owned_field)
		icon_state = "core0"
		if(force_rupture || owned_field.plasma_temperature > 1000)
			owned_field.Rupture()
		else
			owned_field.RadiateAll()
		qdel(owned_field)
		owned_field = null
	use_power = 1

/obj/machinery/power/fusion_core/proc/AddParticles(var/name, var/quantity = 1)
	if(owned_field)
		owned_field.AddParticles(name, quantity)
		. = 1

/obj/machinery/power/fusion_core/bullet_act(var/obj/item/projectile/Proj)
	if(owned_field)
		. = owned_field.bullet_act(Proj)

/obj/machinery/power/fusion_core/proc/set_strength(var/value)
	value = Clamp(value, MIN_FIELD_STR, MAX_FIELD_STR)
	field_strength = value
	active_power_usage = 5 * value
	if(owned_field)
		owned_field.ChangeFieldStrength(value)

/obj/machinery/power/fusion_core/attack_hand(var/mob/user)
	if(!Adjacent(user)) // As funny as it was for the AI to hug-kill the tokamak field from a distance...
		return
	visible_message("<span class='notice'>\The [user] hugs \the [src] to make it feel better!</span>")
	if(owned_field)
		Shutdown()

/obj/machinery/power/fusion_core/attackby(var/obj/item/W, var/mob/user)

	if(owned_field)
		to_chat(user,"<span class='warning'>Shut \the [src] off first!</span>")
		return

	if(ismultitool(W))
		var/new_ident = input("Enter a new ident tag.", "Fusion Core", id_tag) as null|text
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
		return

	else if(iswrench(W))
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear a ratchet")
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear a ratchet")
		return

	return ..()

/obj/machinery/power/fusion_core/proc/jumpstart(var/field_temperature)
	field_strength = 501 // Generally a good size.
	Startup()
	if(!owned_field)
		return FALSE
	owned_field.plasma_temperature = field_temperature
	return TRUE