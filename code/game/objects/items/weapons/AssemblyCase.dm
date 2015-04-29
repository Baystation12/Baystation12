/obj/item/weapon/assemblycase
	name = "auto assembly briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "inf_box"
//	desc = "A huge briefcase with inbuilt auto assembly system."
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = 5.0

	var/obj/machine = null
	var/machine_path = null
	var/full = 0

/obj/item/weapon/assemblycase/attack_self(mob/user as mob)
	if(machine_path&&full)
		if(!machine)
			if(!ispath(machine_path))
				src.visible_message("\The [src] blinks!")
				machine_path = null
				return
			machine = new machine_path(src)
		user.visible_message("<span class='notice'>[user] has activated \the [src] auto assembly sequence.</span>", "<span class='notice'>You activate \the [src] auto assembly sequence.</span>")
		user.drop_item(src)
		if(get_step(user,user.dir))
			src.loc = get_step(user,user.dir)
		else
			src.loc = user.loc
		src.anchored = 1
		spawn(50)
			machine.loc = src.loc
			src.anchored = 0
			src.full = 0
			machine = null
		return
	else if(!full)
		user << "\The [src] is empty!"
	else
		user << "\The [src] program is brocken!"

/obj/item/weapon/assemblycase/afterattack(var/obj/M, mob/user as mob)
//	if(ispath(M,/obj))
	if(full)
		user << "\The [src] is full!"
		return
	if(!istype(M, machine_path))
		user << "\The [src] buzzes!"
//		if(!emagged)
//			return
//		else
//			machine = M
		return
	else
		user << "\The [src] activates disassembly sequence!"
		user.drop_item(src)
		src.loc = M.loc
		src.anchored = 1
		spawn(50)
			M.loc = src
			src.anchored = 0
			src.full = 1
			src.visible_message("<span class='notice'>\The [src] beeps, finishing auto disassembly sequence.</span>")
			machine = M
		return
	..()

/obj/item/weapon/assemblycase/examine(mob/user)
	..()
	user << "A huge briefcase with inbuilt auto assembly system. [machine_path?"It designed for [src] parts.":"It program is brocken."] \The [src] [full?"full of useful parts.":"is empty."]"


/obj/item/weapon/assemblycase/empty
	icon_state = "inf_box"
	desc = "A huge briefcase with inbuilt auto assembly system."

	machine_path = null
	full = 0

/obj/item/weapon/assemblycase/pipelayer
	name = "pipelayer briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lockbox"

	machine_path = /obj/machinery/pipelayer
	full = 1

/obj/item/weapon/assemblycase/floorlayer
	name = "floorlayer briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lockbox+b"

	machine_path = /obj/machinery/floorlayer
	full = 1

/obj/item/weapon/assemblycase/cablelayer
	name = "cablelayer briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lockbox+l"

	machine_path = /obj/machinery/cablelayer
	full = 1