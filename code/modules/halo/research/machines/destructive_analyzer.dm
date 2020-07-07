
/obj/machinery/research/destructive_analyzer
	name = "destructive analyzer"
	desc = "Assists technology research by destroying things."
	icon_state = "d_analyzer"

	var/obj/item/weapon/loaded_item = null
	var/busy = FALSE

/obj/machinery/research/destructive_analyzer/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/destructive_analyzer(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	RefreshParts()

	/*
/obj/machinery/research/destructive_analyzer/RefreshParts()
	. = ..()
	var/T = 0
	for(var/obj/item/weapon/stock_parts/S in src)
		T += S.rating
	decon_mod = T * 0.1
	*/

/obj/machinery/research/destructive_analyzer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	attempt_load_item(O, user)
	return 1

/obj/machinery/research/destructive_analyzer/attempt_load_item(var/obj/item/O as obj, var/mob/user as mob)
	/*if(!controller)
		to_chat(user,"\icon[src] <span class='warning'>[src] cannot accept anything until it is connected to control software.</span>")
		return*/

	. = TRUE

	if(loaded_item)
		to_chat(user,"\icon[src] <span class='warning'>[src] already has something loaded.</span>")
		return

	if(busy)
		to_chat(user,"\icon[src] <span class='warning'>[src] is busy right now.</span>")
		return

	if(item_wanted(O))
		if(user)
			user.drop_item()
		load_item(O)
		to_chat(user, "<span class='notice'>You add \the [O] to \the [src].</span>")
	else
		to_chat(user,"\icon[src] <span class='warning'>[src] does not want that right now.</span>")

/obj/machinery/research/destructive_analyzer/proc/item_wanted(var/obj/item/O as obj)
	//automation is a hardware upgrade, but we still need the control software for it to work
	if(automated && controller)
		return controller.can_destruct_object(O)

	//accept anything
	return TRUE

/obj/machinery/research/destructive_analyzer/proc/load_item(var/obj/item/O as obj)
	loaded_item = O
	O.loc = src
	icon_state = "d_analyzer_l"
	flick("d_analyzer_la", src)
	busy = TRUE
	playsound(src, 'sound/machines/BoltsUp.ogg', 100, 1)

	//give time for the loading animation to finish
	spawn(10)
		busy = FALSE

		//automation is a hardware upgrade, but we still need the control software for it to work
		if(automated && controller)
			//tell the controller to activate us
			controller.activate_destruct()

/obj/machinery/research/destructive_analyzer/attack_hand(var/mob/user)
	if(busy)
		to_chat(user,"\icon[src] <span class='warning'>[src] is busy right now.</span>")
		return

	if(loaded_item)
		eject_item()
	else
		to_chat(user,"\icon[src] <span class='warning'>[src] has nothing loaded right now.</span>")

/obj/machinery/research/destructive_analyzer/proc/eject_item()
	if(loaded_item && !busy)
		playsound(src, 'sound/machines/BoltsDown.ogg', 100, 1)
		icon_state = "d_analyzer"
		loaded_item.loc = src.loc
		loaded_item = null

/obj/machinery/research/destructive_analyzer/proc/activate_destruct()
	//only the control software should be calling this proc
	if(loaded_item && !busy)
		use_power(active_power_usage)
		playsound(src, 'sound/machines/blender.ogg', 100, 1)
		icon_state = "d_analyzer"
		flick("d_analyzer_process", src)
		busy = TRUE
		spawn(24)
			busy = FALSE
			finish_destruct()
		return 1

/obj/machinery/research/destructive_analyzer/proc/finish_destruct()
	if(controller)
		controller.obj_destruct(loaded_item)
		qdel(loaded_item)
		loaded_item = null
	else
		eject_item()
		visible_message("\icon[src] <span class='notice'>Contact lost with control software.</span>")
