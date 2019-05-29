#define STATE_EMPTY 0
#define STATE_ASSEMBLY 1
#define STATE_PAYLOAD 2
#define STATE_WIRED 3
#define STATE_WELDED 4

/obj/item/device/landmine/proc/update_desc()
	name = "incomplete anti-personnel mine"
	icon_state = "shell"
	switch(state)
		if(STATE_EMPTY)
			desc = "A partially completed anti-personnel mine. It needs a device assembly with a proximity sensor and igniter added."
		if(STATE_ASSEMBLY)
			desc = "A partially completed anti-personnel mine. It needs a payload added."
		if(STATE_PAYLOAD)
			desc = "A partially completed anti-personnel mine. It needs cabling."
		if(STATE_WIRED)
			desc = "A partially completed anti-personnel mine. It needs to be welded to finish it off."
		if(STATE_WELDED)
			name = "anti-personnel mine"
			desc = "A dangerous area denial device. Can be customised for various anti-personnel purposes."
			icon_state = "landmine4"

/obj/item/device/landmine/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/device/assembly_holder))
		if(state == STATE_EMPTY)
			var/obj/item/device/assembly_holder/A = W
			//check if its the right kind of assembly
			if(!isigniter(A.a_right) && !isigniter(A.a_left))
				to_chat(user,"<span class='notice'>You must add an igniter to [A].</span>")
				return
			if(!isprox(A.a_right) && !isprox(A.a_left))
				to_chat(user,"<span class='notice'>You must add a proximity sensor to [A].</span>")
				return

			if(!A.secured)
				to_chat(user, "<span class='notice'>Assembly must be secured with screwdriver.</span>")
				return

			if(do_after(user, 30, src))
				user.drop_item()
				W.loc = src
				playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, -3)
				assembly = W
				set_state(STATE_ASSEMBLY)
				to_chat(user,"<span class='info'>You install [W] in [src].</span>")
				update_desc()
		else
			to_chat(user,"<span class='notice'>There's no need for that.</span>")

	else if(istype(W, /obj/item/stack/cable_coil))
		if(state == STATE_PAYLOAD)
			var/obj/item/stack/cable_coil/C = W
			if(C.can_use(2))
				if(do_after(user, 30, src))
					C.use(2)
					set_state(STATE_WIRED)
					to_chat(user,"<span class='info'>You wire together [src].</span>")
					update_desc()
			else
				to_chat(user,"<span class='warning'>You need at least 2 pieces left on the coil to write [src].</span>")
		else
			to_chat(user,"<span class='notice'>There's no need for that.</span>")

	else if(is_type_in_list(W, allowed_containers))
		if(state == STATE_ASSEMBLY)
			if(beakers.len == 2)
				to_chat(user, "<span class='warning'>[src] can not hold more containers.</span>")
				return
			else
				if(W.reagents.total_volume)
					to_chat(user, "<span class='notice'>You add \the [W] to [src].</span>")
					user.drop_item()
					W.loc = src
					beakers += W
					if(beakers.len == 2)
						set_state(STATE_PAYLOAD)
				else
					to_chat(user, "<span class='warning'>\The [W] is empty.</span>")
		else
			to_chat(user,"<span class='notice'>There's no need for that.</span>")

/*
payloads todo: explosive, EMP, gas, shrapnel, flame
*/

	else if(istype(W, /obj/item/weapon/weldingtool))
		if(state >= STATE_WIRED)
			var/obj/item/weapon/weldingtool/WT = W
			if(!WT.isOn())
				to_chat(user, "<span class='warning'>\The [WT] must be on to complete this task.</span>")
				return
			if(!WT.remove_fuel(1, user))
				to_chat(user, "<span class='warning'>[WT] does not have enough fuel remaining.</span>")
				return
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(do_after(user, 30, src))
				if(state >= STATE_WIRED)
					to_chat(user,"<span class='info'>You weld [src] and complete it.</span>")
					set_state(STATE_WELDED)
				else
					to_chat(user,"<span class='info'>You unweld [src] so it can be modified.</span>")
					set_state(STATE_WIRED)
					overlays = list()
				update_desc()

#undef STATE_EMPTY
#undef STATE_SCANNER
#undef STATE_PAYLOAD
#undef STATE_WIRED
