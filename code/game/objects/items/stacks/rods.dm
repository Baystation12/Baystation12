/obj/item/stack/rods
	name = "metal rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "metal rod"
	icon_state = "rods"
	flags = CONDUCT
	w_class = ITEM_SIZE_LARGE
	force = 9.0
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 1875)
	max_amount = 100
	center_of_mass = null
	attack_verb = list("hit", "bludgeoned", "whacked")
	lock_picking_level = 3

/obj/item/stack/rods/ten
	amount = 10

/obj/item/stack/rods/fifty
	amount = 50

/obj/item/stack/rods/cyborg
	name = "metal rod synthesizer"
	desc = "A device that makes metal rods."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)
	stacktype = /obj/item/stack/rods

/obj/item/stack/rods/New()
	..()
	update_icon()

/obj/item/stack/rods/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two rods to do this.</span>")
			return

		if(WT.remove_fuel(0,user))
			var/obj/item/stack/material/steel/new_item = new(usr.loc)
			new_item.add_to_stacks(usr)
			for (var/mob/M in viewers(src))
				M.show_message("<span class='notice'>[src] is shaped into metal by [user.name] with the weldingtool.</span>", 3, "<span class='notice'>You hear welding.</span>", 2)
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.get_inactive_hand()==R)
			R.use(2)
			if (!R && replace)
				user.put_in_hands(new_item)
		return

	if (istype(W, /obj/item/weapon/tape_roll))
		var/obj/item/stack/medical/splint/ghetto/new_splint = new(user.loc)
		new_splint.dropInto(loc)
		new_splint.add_fingerprint(user)

		user.visible_message("<span class='notice'>\The [user] constructs \a [new_splint] out of a [singular_name].</span>", \
				"<span class='notice'>You use make \a [new_splint] out of a [singular_name].</span>")
		src.use(1)
		return

	..()


/obj/item/stack/rods/attack_self(mob/user as mob)
	src.add_fingerprint(user)

	if(!istype(user.loc,/turf)) return 0

	if (locate(/obj/structure/grille, usr.loc))
		for(var/obj/structure/grille/G in usr.loc)
			if (G.destroyed)
				G.health = 10
				G.set_density(1)
				G.destroyed = 0
				G.icon_state = "grille"
				use(1)
			else
				return 1

	else if(!in_use)
		if(get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two rods to do this.</span>")
			return
		to_chat(usr, "<span class='notice'>Assembling grille...</span>")
		in_use = 1
		if (!do_after(usr, 10))
			in_use = 0
			return
		var/obj/structure/grille/F = new /obj/structure/grille/ ( usr.loc )
		to_chat(usr, "<span class='notice'>You assemble a grille</span>")
		in_use = 0
		F.add_fingerprint(usr)
		use(2)
	return

/obj/item/stack/rods/update_icon()
	if(amount == 1)
		icon = 'icons/obj/weapons.dmi'
		icon_state = "metal-rod"
	else
		icon = initial(icon)
		icon_state = initial(icon_state)

/obj/item/stack/rods/use()
	. = ..()
	update_icon()

/obj/item/stack/rods/add()
	. = ..()
	update_icon()