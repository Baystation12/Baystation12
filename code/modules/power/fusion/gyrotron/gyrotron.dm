var/list/gyrotrons = list()

/obj/machinery/power/emitter/gyrotron
	name = "gyrotron"
	icon = 'icons/obj/machines/power/fusion.dmi'
	desc = "It is a heavy duty industrial gyrotron suited for powering fusion reactors."
	icon_state = "emitter-off"
	req_access = list(access_engine)
	use_power = 1
	active_power_usage = 50000

	var/id_tag
	var/rate = 3
	var/mega_energy = 1


/obj/machinery/power/emitter/gyrotron/anchored
	anchored = 1
	state = 2

/obj/machinery/power/emitter/gyrotron/initialize()
	gyrotrons += src
	active_power_usage = mega_energy * 50000
	. = ..()

/obj/machinery/power/emitter/gyrotron/Destroy()
	gyrotrons -= src
	return ..()

/obj/machinery/power/emitter/gyrotron/process()
	active_power_usage = mega_energy * 50000
	. = ..()

/obj/machinery/power/emitter/gyrotron/get_rand_burst_delay()
	return rate*10

/obj/machinery/power/emitter/gyrotron/get_burst_delay()
	return rate*10

/obj/machinery/power/emitter/gyrotron/get_emitter_beam()
	var/obj/item/projectile/beam/emitter/E = ..()
	E.damage = mega_energy * 50
	return E

/obj/machinery/power/emitter/gyrotron/update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = "emitter-on"
	else
		icon_state = "emitter-off"

/obj/machinery/power/emitter/gyrotron/attackby(var/obj/item/W, var/mob/user)
	if(ismultitool(W))
		var/new_ident = input("Enter a new ident tag.", "Gyrotron", id_tag) as null|text
		if(new_ident && user.Adjacent(src))
			id_tag = new_ident
		return
	return ..()