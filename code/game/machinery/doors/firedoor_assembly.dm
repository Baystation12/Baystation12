obj/structure/firedoor_assembly
	name = "\improper emergency shutter assembly"
	desc = "It can save lives."
	icon = 'icons/obj/doors/DoorHazard.dmi'
	icon_state = "door_construction"
	anchored = 0
	opacity = 0
	density = 0

obj/structure/firedoor_assembly/update_icon()
	if(anchored)
		icon_state = "door_anchored"
	else
		icon_state = "door_construction"

obj/structure/firedoor_assembly/attackby(C as obj, mob/user as mob)
	if(istype(C, /obj/item/weapon/airalarm_electronics))
		if(anchored)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='warning'>[user] has inserted a circuit into \the [src]!</span>",
								  "You have inserted the circuit into \the [src]!")
			new /obj/machinery/door/firedoor(src.loc)
			del(C)
			del(src)
		else
			user << "<span class='warning'>You must secure \the [src] first!</span>"
	else if(istype(C, /obj/item/weapon/wrench))
		anchored = !anchored
		density = !density
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user.visible_message("<span class='warning'>[user] has [anchored ? "" : "un" ]secured \the [src]!</span>",
							  "You have [anchored ? "" : "un" ]secured \the [src]!")
		update_icon()
	else if(!anchored && istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			user.visible_message("<span class='warning'>[user] dissassembles \the [src].</span>",
			"You start to dissassemble \the [src].")
			if(do_after(user, 40))
				if(!src || !WT.isOn()) return
				user.visible_message("<span class='warning'>[user] has dissassembled \the [src].</span>",
									"You have dissassembled \the [src].")
				new /obj/item/stack/sheet/metal(src.loc, 2)
				del (src)
		else
			user << "<span class='notice'>You need more welding fuel.</span>"
	else
		..(C, user)
