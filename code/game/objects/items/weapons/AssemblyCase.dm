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
	var/mach = null
	var/full = 0

/obj/item/weapon/assemblycase/attack_self(mob/user as mob)
	if(mach&&full)
		if(!machine)
			var/path = text2path(mach)
			if(!ispath(path))
				user << "\The [src] is blinks!"
				mach = null
				return
			machine = new mach(src)
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
	if(M!=machine)
		user << "\The [src] buzz!"
//		if(!emagged)
//			return
//		else
//			machine = M
		return
	else
		user << "\The [src] activate disassembly sequence!"
		user.drop_item(src)
		src.loc = M.loc
		src.anchored = 1
		spawn(50)
			M.loc = src
			src.anchored = 0
			src.full = 1
			src.visible_message("<span class='notice'>\The [src] beeps finished auto disassembly sequence.</span>")
		return
	..()

/obj/item/weapon/assemblycase/examine(mob/user)
	..()
	user << "A huge briefcase with an inbuilt auto-assembly system. [mach?"It is designed for [src] parts.":"It's program is broken."] \The [src] [full?"is full of useful parts.":"is empty."]"


/obj/item/weapon/assemblycase/empty
	icon_state = "inf_box"
	desc = "A huge briefcase with inbuilt auto assembly system."

	mach = null
	full = 0

/obj/item/weapon/assemblycase/pipelayer
	name = "pipelayer briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lockbox"

	mach = "/obj/machinery/pipelayer"
	full = 1

/obj/item/weapon/assemblycase/floorlayer
	name = "floorlayer briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lockbox+b"

	mach = "/obj/machinery/floorlayer"
	full = 1

/obj/item/weapon/assemblycase/cablelayer
	name = "cablelayer briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "lockbox+l"

	mach = "/obj/machinery/cablelayer"
	full = 1
