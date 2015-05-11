/obj/item/weapon/circuitboard/atmoscontrol
	name = "\improper Central Atmospherics Computer Circuitboard"
	build_path = /obj/machinery/computer/atmoscontrol

/obj/machinery/computer/atmoscontrol
	name = "\improper Central Atmospherics Computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer_generic"
	light_color = "#00b000"
	density = 1
	anchored = 1.0
	circuit = "/obj/item/weapon/circuitboard/atmoscontrol"
	req_access = list(access_ce)
	var/list/monitored_alarm_ids = null
	var/obj/nano_module/atmos_control/atmos_control

/obj/machinery/computer/atmoscontrol/New()
	..()

/obj/machinery/computer/atmoscontrol/laptop
	name = "Atmospherics Laptop"
	desc = "Cheap Nanotrasen Laptop."
	icon_state = "medlaptop"
	density = 0

/obj/machinery/computer/atmoscontrol/attack_ai(var/mob/user as mob)
	ui_interact(user)

/obj/machinery/computer/atmoscontrol/attack_hand(mob/user)
	if(..())
		return 1
	ui_interact(user)

/obj/machinery/computer/atmoscontrol/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		user.visible_message("\red \The [user] swipes \a [I] through \the [src], causing the screen to flash!",\
			"\red You swipe your [I] through \the [src], the screen flashing as you gain full control.",\
			"You hear the swipe of a card through a reader, and an electronic warble.")
		atmos_control.emagged = 1
		return
	return ..()

/obj/machinery/computer/atmoscontrol/ui_interact(var/mob/user)
	if(!atmos_control)
		atmos_control = new(src, req_access, req_one_access, monitored_alarm_ids)
	atmos_control.ui_interact(user)
