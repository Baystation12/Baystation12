/obj/machinery/papershredder
	name = "Paper Shredder"
	desc = "For those documents you don't want seen."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "papershredder0"
	density = 1
	anchored = 1
	var/max_paper = 10
	var/paperamount = 0


/obj/machinery/papershredder/attackby(obj/item/W as obj, mob/user as mob)
//	if(default_unfasten_wrench(user, W))
//		return
	if (istype(W, /obj/item/weapon/paper))
		if(paperamount == max_paper)
			if(prob(5))
				var/i
				var/curpaper = paperamount
				for(i=1; i<=curpaper; i++)
					var/obj/item/weapon/shreddedp/SP = new /obj/item/weapon/shreddedp(usr.loc)
					SP.pixel_x = rand(-5,5)
					SP.pixel_y = rand(-5,5)
					var/ran = rand(1,3)
					if(ran == 1)
						SP.color = "#BABABA"
					if(ran == 2)
						SP.color = "#7F7F7F"
					if(ran == 3)
						SP.color = null
					paperamount -=1
				update_icon()
				user <<"\red The [src] was too full and shredded paper goes everywhere"
				return
			else
				user << "\red The [src] is full please empty it before you continue"
				return
		if(paperamount < max_paper)
			del(W)
			paperamount += 1
			update_icon()
			playsound(src.loc, 'sound/items/pshred.ogg', 75, 1)
			return
	else if(istype(W, /obj/item/weapon/photo))
		if(paperamount < max_paper)
			del(W)
			paperamount += 1
			update_icon()
			playsound(src.loc, 'sound/items/pshred.ogg', 75, 1)
			return
	else if(istype(W, /obj/item/weapon/newspaper))
		if(paperamount < max_paper-3)
			del(W)
			paperamount += 3
			update_icon()
			playsound(src.loc, 'sound/items/pshred.ogg', 75, 1)
			return
	else if(istype(W, /obj/item/weapon/card/id))
		if(paperamount < max_paper-3)
			del(W)
			paperamount += 3
			update_icon()
			playsound(src.loc, 'sound/items/pshred.ogg', 75, 1)
			return
	else if(istype(W, /obj/item/weapon/paper_bundle))
		if(paperamount < max_paper-3)
			del(W)
			paperamount += 3
			update_icon()
			playsound(src.loc, 'sound/items/pshred.ogg', 75, 1)
			return
	else if(istype(W, /obj/item/weapon/storage/bag/trash))
		var/obj/item/weapon/storage/bag/trash/T = W
		var/curpaper = paperamount
		var/i
		for(i=1; i<=curpaper; i++)
			if(T.contents.len < 21)
				var/obj/item/weapon/shreddedp/SP = new /obj/item/weapon/shreddedp
				var/ran = rand(1,3)
				if(ran == 1)
					SP.color = "#BABABA"
				if(ran == 2)
					SP.color = "#7F7F7F"
				if(ran == 3)
					SP.color = null
				T.handle_item_insertion(SP)
				paperamount -=1
				update_icon()
			else
				user << "\red The [W] is full"
				return
	else if(istype(W, /obj/item/weapon/shreddedp))
		if(paperamount == max_paper)
			user << "\red The [src] is full please empty it before you continue"
			return
		if(paperamount < max_paper)
			del(W)
			paperamount += 1
			update_icon()
			return
	else
		return



/obj/machinery/papershredder/verb/emtpy()
	set name = "Empty bin"
	set category = "Object"
	set src in oview(1)
	if(paperamount != 0)
		var/i
		var/curpaper = paperamount
		for(i=1; i<=curpaper; i++)
			var/obj/item/weapon/shreddedp/SP = new /obj/item/weapon/shreddedp(usr.loc)
			SP.pixel_x = rand(-5,5)
			SP.pixel_y = rand(-5,5)
			var/ran = rand(1,3)
			if(ran == 1)
				SP.color = "#BABABA"
			if(ran == 2)
				SP.color = "#7F7F7F"
			if(ran == 3)
				SP.color = null
			paperamount -=1
		update_icon()

/obj/machinery/papershredder/update_icon()
	if(paperamount == 0)
		icon_state = "papershredder0"
	if(paperamount == 1||paperamount == 2)
		icon_state = "papershredder1"
	if(paperamount == 3||paperamount == 4)
		icon_state = "papershredder2"
	if(paperamount == 5||paperamount == 6)
		icon_state = "papershredder3"
	if(paperamount == 7||paperamount == 8)
		icon_state = "papershredder4"
	if(paperamount == 9||paperamount == 10)
		icon_state = "papershredder5"
	return

/obj/item/weapon/shreddedp
	name = "shredded paper"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "shredp"
	throwforce = 0
	w_class = 1.0
	throw_range = 3
	throw_speed = 1
	layer = 4
	pressure_resistance = 1

/obj/item/weapon/shreddedp/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/flame/lighter))
		burnpaper(W, user)
	else
		..()


/obj/item/weapon/shreddedp/proc/burnpaper(obj/item/weapon/flame/lighter/P, mob/user)
	var/class = "warning"

	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/weapon/flame/lighter/zippo))
			class = "rose"

		user.visible_message("<span class='[class]'>\The [user] holds \the [P] up to \the [src], it looks like \he's trying to burn it!</span>", \
		"<span class='[class]'>You hold \the [P] up to \the [src], burning it slowly.</span>")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.lit)
				user.visible_message("<span class='[class]'>\The [user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
				"<span class='[class]'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")

				if(user.get_inactive_hand() == src)
					user.drop_from_inventory(src)

				new /obj/effect/decal/cleanable/ash(src.loc)
				del(src)

			else
				user << "\red You must hold \the [P] steady to burn \the [src]."

/obj/item/weapon/shreddedp/proc/FireBurn()
	new /obj/effect/decal/cleanable/ash(src.loc)
	del(src)
