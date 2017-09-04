obj/structure/firedoor_assembly
	name = "\improper emergency shutter assembly"
	desc = "It can save lives."
	icon = 'icons/obj/doors/DoorHazard.dmi'
	icon_state = "door_construction"
	anchored = 0
	opacity = 0
	density = 1
	var/wired = 0

obj/structure/firedoor_assembly/update_icon()
	if(anchored)
		icon_state = "door_anchored"
	else
		icon_state = "door_construction"

obj/structure/firedoor_assembly/attackby(C as obj, mob/user as mob)
	if(istype(C, /obj/item/stack/cable_coil) && !wired && anchored)
		var/obj/item/stack/cable_coil/cable = C
		if (cable.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one length of coil to wire \the [src].</span>")
			return
		user.visible_message("[user] wires \the [src].", "You start to wire \the [src].")
		if(do_after(user, 40, src) && !wired && anchored)
			if (cable.use(1))
				wired = 1
				to_chat(user, "<span class='notice'>You wire \the [src].</span>")

	else if(istype(C, /obj/item/weapon/wirecutters) && wired )
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("[user] cuts the wires from \the [src].", "You start to cut the wires from \the [src].")

		if(do_after(user, 40, src))
			if(!src) return
			to_chat(user, "<span class='notice'>You cut the wires!</span>")
			new/obj/item/stack/cable_coil(src.loc, 1)
			wired = 0

	else if(istype(C, /obj/item/weapon/airalarm_electronics) && wired)
		if(anchored)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='warning'>[user] has inserted a circuit into \the [src]!</span>",
								  "You have inserted the circuit into \the [src]!")
			new /obj/machinery/door/firedoor(src.loc)
			qdel(C)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You must secure \the [src] first!</span>")
	else if(istype(C, /obj/item/weapon/wrench))
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user.visible_message("<span class='warning'>[user] has [anchored ? "" : "un" ]secured \the [src]!</span>",
							  "You have [anchored ? "" : "un" ]secured \the [src]!")
		update_icon()
	else if(!anchored && istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			user.visible_message("<span class='warning'>[user] dissassembles \the [src].</span>",
			"You start to dissassemble \the [src].")
			if(do_after(user, 40, src))
				if(!src || !WT.isOn()) return
				user.visible_message("<span class='warning'>[user] has dissassembled \the [src].</span>",
									"You have dissassembled \the [src].")
				new /obj/item/stack/material/steel(src.loc, 2)
				qdel(src)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel.</span>")
	else
		..(C, user)
