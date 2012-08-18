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
		O.loc = src

	else if(istype (O, /obj/item/weapon/wrench))
		playsound(M.loc, 'Ratchet.ogg', 50, 1)
		if (do_after(M, 40))
			M.visible_message( \
				"[M] break \the [src].", \
				"\blue You have break \the [src].", \
				"You hear ratchet.")
			for(var/obj/E in src.contents)
				E = src.loc
			var/obj/item/stack/sheet/metal/MS = new /obj/item/stack/sheet/metal(src.loc)
			MS.amount = 2
			del(src)

	else if(istype (O, /obj/item/weapon/screwdriver))
		playsound(M.loc, 'Screwdriver.ogg', 50, 1)
		if (do_after(M, 20))
			M.visible_message( \
				"[M] [anchored ? "un" : ""]wrench \the [src].", \
				"\blue You have [anchored ? "un" : ""]wrench \the [src].", \
				"You hear ratchet.")
			anchored = !anchored

	else
		M << "You can't put a [O] in the [src]!"

/obj/structure/filingcabinet/attack_hand(mob/user)
	if(src.contents.len <= 0)
		user << "The [src] is empty."
		return
	var/obj/item/weapon/paper/P = input(user,"Choose a sheet to take out.","[src]", "Cancel") as null|obj in src.contents
	if(!isnull(P) && in_range(src,user))
		P.loc = user.loc