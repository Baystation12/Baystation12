/obj/machinery/door/blast/stage_curtain
	opacity = 1
	density = 0
	name = "stage curtain"
	desc = "A red velvet stage curtain."
	icon = 'icons/obj/curtains.dmi'
	icon_state = "c_close"
	icon_state_opening = ""
	icon_state_closing = ""
	icon_state_open = ""
	icon_state_closed = ""
	var/l_end = 0 // bool for left end of curtain
	var/r_end = 0 // bool for right end of curtain
	layer = MOB_LAYER - 0.1


/obj/machinery/door/blast/stage_curtain/attack_hand(mob/user)
	user << "You need to use the curtain button to operate these!"


/obj/machinery/door/blast/stage_curtain/force_toggle()
	if(src.opacity)
		src.force_open()
	else
		src.force_close()


/obj/machinery/door/blast/stage_curtain/force_open()
	src.operating = 1
	flick(icon_state_opening, src)
	src.opacity = 0
	update_nearby_tiles()
	src.update_icon()
	src.SetOpacity(0)
	sleep(15)
	src.operating = 0


/obj/machinery/door/blast/stage_curtain/force_close()
	src.operating = 1
	flick(icon_state_closing, src)
	src.SetOpacity(1)
	update_nearby_tiles()
	src.update_icon()
	sleep(15)
	src.operating = 0


/obj/machinery/door/blast/stage_curtain/update_icon()
	if(opacity)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	return


/obj/machinery/door/blast/stage_curtain/attackby(obj/item/weapon/C as obj, mob/user as mob)
	return


/obj/machinery/door/blast/stage_curtain/repair_price()
	return


/obj/machinery/door/blast/stage_curtain/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0


/obj/machinery/door/blast/stage_curtain/left
	icon_state_opening = "l_opening"
	icon_state_closing = "l_closing"
	icon_state_open = "l_drawn"
	icon_state_closed = "l_close"


/obj/machinery/door/blast/stage_curtain/right
	icon_state_opening = "r_opening"
	icon_state_closing = "r_closing"
	icon_state_open = "r_drawn"
	icon_state_closed = "r_close"


/obj/machinery/door_control/curtain_control
	name = "remote curtain control"
	desc = "Controls curtains, remotely!"

/obj/machinery/door_control/curtain_control/handle_door()
	for(var/obj/machinery/door/airlock/D in world)
		if(D.id_tag == src.id)
			if(specialfunctions & OPEN)
				if (D.opacity)
					spawn(0)
						D.open()
						return
				else
					spawn(0)
						D.close()
						return
			if(desiredstate == 1)
				if(specialfunctions & IDSCAN)
					D.aiDisabledIdScanner = 1
				if(specialfunctions & BOLTS)
					D.lock()
				if(specialfunctions & SHOCK)
					D.secondsElectrified = -1
				if(specialfunctions & SAFE)
					D.safe = 0
			else
				if(specialfunctions & IDSCAN)
					D.aiDisabledIdScanner = 0
				if(specialfunctions & BOLTS)
					if(!D.isWireCut(4) && D.arePowerSystemsOn())
						D.unlock()
				if(specialfunctions & SHOCK)
					D.secondsElectrified = 0
				if(specialfunctions & SAFE)
					D.safe = 1
