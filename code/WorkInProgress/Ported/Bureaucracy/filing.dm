/obj/structure/filingcabinet
	name = "Filing Cabinet"
	desc = "A large cabinet with drawers."
	icon = 'bureaucracy.dmi'
	icon_state = "filingcabinet"
	density = 1
	anchored = 1

/obj/structure/filingcabinet/attackby(var/obj/O, mob/M)
	if(istype(O, /obj/item/weapon/paper))
		M << "You put the [O] in the [src]."
		M.drop_item()
		P.loc = src

	else if(istype (O, /obj/item/weapon/wrench))
		playsound(src.loc, 'Ratchet.ogg', 50, 1)
		if (do_after(user, 40))
			user.visible_message( \
				"[user] break \the [src].", \
				"\blue You have break \the [src].", \
				"You hear ratchet.")
			for(var/obj/O in src.contents)
				O = src.loc
			var/obj/item/stack/sheet/metal/MS = new /obj/item/stack/sheet/metal(src.loc)
			MS.amount = 2
			del(src)

	else if(istype (O, /obj/item/weapon/screwdriver))
		if (do_after(user, 20))
			playsound(src.loc, 'Screwdriver.ogg', 50, 1)
			user.visible_message( \
				"[user] [anchored ? "un" : ""]wrench \the [src].", \
				"\blue You have [anchored ? "un" : ""]wrench \the [src].", \
				"You hear ratchet.")
			anchored = !anchored

	else
		M << "You can't put a [P] in the [src]!"

/obj/structure/filingcabinet/attack_hand(mob/user)
	if(src.contents.len <= 0)
		user << "The [src] is empty."
		return
	var/obj/item/weapon/paper/P = input(user,"Choose a sheet to take out.","[src]", "Cancel") as null|obj in src.contents
	if(!isnull(P) && in_range(src,user))
		P.loc = user.loc