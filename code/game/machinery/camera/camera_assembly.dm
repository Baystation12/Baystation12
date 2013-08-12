/obj/item/weapon/camera_assembly
	name = "camera assembly"
	desc = "The basic construction for Nanotrasen-Always-Watching-You cameras."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "cameracase"
	w_class = 2
	anchored = 0

	m_amt = 700
	g_amt = 300

	//	Motion, EMP-Proof, X-Ray
	var/list/obj/item/possible_upgrades = list(/obj/item/device/assembly/prox_sensor, /obj/item/stack/sheet/mineral/plasma, /obj/item/weapon/reagent_containers/food/snacks/grown/carrot)
	var/list/upgrades = list()
	var/state = 0
	var/busy = 0
	/*
				0 = Nothing done to it
				1 = Wrenched in place
				2 = Welded in place
				3 = Wires attached to it (you can now attach/dettach upgrades)
				4 = Screwdriver panel closed and is fully built (you cannot attach upgrades)
	*/

/obj/item/weapon/camera_assembly/attackby(obj/item/W as obj, mob/living/user as mob)

	switch(state)

		if(0)
			// State 0
			if(iswrench(W) && isturf(src.loc))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user << "You wrench the assembly into place."
				anchored = 1
				state = 1
				update_icon()
				auto_turn()
				return

		if(1)
			// State 1
			if(iswelder(W))
				if(weld(W, user))
					user << "You weld the assembly securely into place."
					anchored = 1
					state = 2
				return

			else if(iswrench(W))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				user << "You unattach the assembly from it's place."
				anchored = 0
				update_icon()
				state = 0
				return

		if(2)
			// State 2
			if(iscoil(W))
				var/obj/item/weapon/cable_coil/C = W
				if(C.use(2))
					user << "You add wires to the assembly."
					state = 3
				return

			else if(iswelder(W))

				if(weld(W, user))
					user << "You unweld the assembly from it's place."
					state = 1
					anchored = 1
				return


		if(3)
			// State 3
			if(isscrewdriver(W))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)

				var/input = strip_html(input(usr, "Which networks would you like to connect this camera to? Seperate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret ", "Set Network", "SS13"))
				if(!input)
					usr << "No input found please hang up and try your call again."
					return

				var/list/tempnetwork = text2list(input, ",")
				if(tempnetwork.len < 1)
					usr << "No network found please hang up and try your call again."
					return

				var/temptag = "[get_area(src)] ([rand(1, 999)])"
				input = strip_html(input(usr, "How would you like to name the camera?", "Set Camera Name", temptag))

				state = 4
				var/obj/machinery/camera/C = new(src.loc)
				src.loc = C
				C.assembly = src

				C.auto_turn()

				C.network = uniquelist(tempnetwork)
				tempnetwork = difflist(C.network,RESTRICTED_CAMERA_NETWORKS)
				if(!tempnetwork.len)//Camera isn't on any open network - remove its chunk from AI visibility.
					cameranet.removeCamera(C)

				C.c_tag = input

				for(var/i = 5; i >= 0; i -= 1)
					var/direct = input(user, "Direction?", "Assembling Camera", null) in list("LEAVE IT", "NORTH", "EAST", "SOUTH", "WEST" )
					if(direct != "LEAVE IT")
						C.dir = text2dir(direct)
					if(i != 0)
						var/confirm = alert(user, "Is this what you want? Chances Remaining: [i]", "Confirmation", "Yes", "No")
						if(confirm == "Yes")
							break
				return

			else if(iswirecutter(W))

				new/obj/item/weapon/cable_coil(get_turf(src), 2)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "You cut the wires from the circuits."
				state = 2
				return

	// Upgrades!
	if(is_type_in_list(W, possible_upgrades) && !is_type_in_list(W, upgrades)) // Is a possible upgrade and isn't in the camera already.
		user << "You attach the [W] into the assembly inner circuits."
		upgrades += W
		user.drop_item(W)
		W.loc = src
		return

	// Taking out upgrades
	else if(iscrowbar(W) && upgrades.len)
		var/obj/U = locate(/obj) in upgrades
		if(U)
			user << "You unattach an upgrade from the assembly."
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			U.loc = get_turf(src)
			upgrades -= U
		return

	..()

/obj/item/weapon/camera_assembly/update_icon()
	if(anchored)
		icon_state = "camera1"
	else
		icon_state = "cameracase"

/obj/item/weapon/camera_assembly/attack_hand(mob/user as mob)
	if(!anchored)
		..()

/obj/item/weapon/camera_assembly/proc/weld(var/obj/item/weapon/weldingtool/WT, var/mob/user)

	if(busy)
		return 0
	if(!WT.isOn())
		return 0

	user << "<span class='notice'>You start to weld the [src]..</span>"
	playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	WT.eyecheck(user)
	busy = 1
	if(do_after(user, 20))
		busy = 0
		if(!WT.isOn())
			return 0
		return 1
	busy = 0
	return 0