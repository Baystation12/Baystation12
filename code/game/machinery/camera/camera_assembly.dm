/obj/item/camera_assembly
	name = "camera assembly"
	desc = "A pre-fabricated security camera kit, ready to be assembled and mounted to a surface."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "cameracase"
	w_class = ITEM_SIZE_SMALL
	anchored = FALSE

	matter = list(MATERIAL_ALUMINIUM = 700, MATERIAL_GLASS = 300)

	//	Motion, EMP-Proof, X-Ray
	var/list/obj/item/possible_upgrades = list(/obj/item/device/assembly/prox_sensor, /obj/item/stack/material/osmium, /obj/item/stock_parts/scanning_module)
	var/list/upgrades = list()
	var/camera_name
	var/camera_network
	var/state = 0
	var/busy = 0
	/*
				0 = Nothing done to it
				1 = Wrenched in place
				2 = Welded in place
				3 = Wires attached to it (you can now attach/dettach upgrades)
				4 = Screwdriver panel closed and is fully built (you cannot attach upgrades)
	*/

/obj/item/camera_assembly/attackby(obj/item/W as obj, mob/living/user as mob)

	switch(state)

		if(0)
			// State 0
			if(isWrench(W) && isturf(src.loc))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				to_chat(user, "You wrench the assembly into place.")
				anchored = TRUE
				state = 1
				update_icon()
				auto_turn()
				return

		if(1)
			// State 1
			if(isWelder(W))
				if(weld(W, user))
					to_chat(user, "You weld the assembly securely into place.")
					anchored = TRUE
					state = 2
				return

			else if(isWrench(W))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				to_chat(user, "You unattach the assembly from its place.")
				anchored = FALSE
				update_icon()
				state = 0
				return

		if(2)
			// State 2
			if(isCoil(W))
				var/obj/item/stack/cable_coil/C = W
				if(C.use(2))
					to_chat(user, "<span class='notice'>You add wires to the assembly.</span>")
					state = 3
				else
					to_chat(user, "<span class='warning'>You need 2 coils of wire to wire the assembly.</span>")
				return

			else if(isWelder(W))

				if(weld(W, user))
					to_chat(user, "You unweld the assembly from its place.")
					state = 1
					anchored = TRUE
				return


		if(3)
			// State 3
			if(isScrewdriver(W))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)

				var/input = sanitize(input(usr, "Which networks would you like to connect this camera to? Separate networks with a comma. No Spaces!\nFor example: Exodus,Security,Secret", "Set Network", camera_network ? camera_network : NETWORK_EXODUS))
				if(!input)
					to_chat(usr, "No input found please hang up and try your call again.")
					return

				var/list/tempnetwork = splittext(input, ",")
				if(tempnetwork.len < 1)
					to_chat(usr, "No network found please hang up and try your call again.")
					return

				var/area/camera_area = get_area(src)
				var/temptag = "[sanitize(camera_area.name)] ([rand(1, 999)])"
				input = sanitizeSafe(input(usr, "How would you like to name the camera?", "Set Camera Name", camera_name ? camera_name : temptag), MAX_LNAME_LEN)

				state = 4
				var/obj/machinery/camera/C = new(src.loc)
				src.forceMove(C)
				C.assembly = src

				C.auto_turn()

				C.replace_networks(uniquelist(tempnetwork))

				C.c_tag = input

				for(var/i = 5; i >= 0; i -= 1)
					var/direct = input(user, "Direction?", "Assembling Camera", null) in list("LEAVE IT", "NORTH", "EAST", "SOUTH", "WEST" )
					if(direct != "LEAVE IT")
						C.dir = text2dir(direct)
					if(i != 0)
						var/confirm = alert(user, "Is this what you want? Chances Remaining: [i]", "Confirmation", "Yes", "No")
						if(confirm == "Yes")
							C.update_icon()
							break
				return

			else if(isWirecutter(W))

				new/obj/item/stack/cable_coil(get_turf(src), 2)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				to_chat(user, "You cut the wires from the circuits.")
				state = 2
				return

	// Upgrades!
	if(is_type_in_list(W, possible_upgrades) && !is_type_in_list(W, upgrades) && user.unEquip(W, src)) // Is a possible upgrade and isn't in the camera already.
		to_chat(user, "You attach \the [W] into the assembly inner circuits.")
		upgrades += W
		return

	// Taking out upgrades
	else if(isCrowbar(W) && upgrades.len)
		var/obj/U = locate(/obj) in upgrades
		if(U)
			to_chat(user, "You unattach an upgrade from the assembly.")
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			U.dropInto(loc)
			upgrades -= U
		return

	..()

/obj/item/camera_assembly/on_update_icon()
	if(anchored)
		icon_state = "camera1"
	else
		icon_state = "cameracase"

/obj/item/camera_assembly/attack_hand(mob/user as mob)
	if(!anchored)
		..()

/obj/item/camera_assembly/proc/weld(var/obj/item/weldingtool/WT, var/mob/user)

	if(busy)
		return 0

	if(WT.remove_fuel(0, user))
		to_chat(user, "<span class='notice'>You start to weld \the [src]..</span>")
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		busy = 1
		if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE) && WT.isOn())
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			busy = 0
			return 1

	busy = 0
	return 0
