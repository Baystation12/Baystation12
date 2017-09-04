/obj/item/weapon/material/butterflyconstruction
	name = "unfinished concealed knife"
	desc = "An unfinished concealed knife, it looks like the screws need to be tightened."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterflystep1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/butterflyconstruction/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/screwdriver))
		to_chat(user, "You finish the concealed blade weapon.")
		new /obj/item/weapon/material/butterfly(user.loc, material.name)
		qdel(src)
		return

/obj/item/weapon/material/butterflyblade
	name = "knife blade"
	desc = "A knife blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly2"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/butterflyhandle
	name = "concealed knife grip"
	desc = "A plasteel grip with screw fittings for a blade."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/butterflyhandle/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/material/butterflyblade))
		var/obj/item/weapon/material/butterflyblade/B = W
		to_chat(user, "You attach the two concealed blade parts.")
		var/finished = new /obj/item/weapon/material/butterflyconstruction(user.loc, B.material.name)
		qdel(W)
		qdel(src)
		user.put_in_hands(finished)
		return

/obj/item/weapon/material/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	item_state = "rods"
	flags = CONDUCT
	force = 8
	throwforce = 10
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/weapon/material/wirerod/attackby(var/obj/item/I, mob/user as mob)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/weapon/material/shard) || istype(I, /obj/item/weapon/material/butterflyblade))
		var/obj/item/weapon/material/tmp_shard = I
		finished = new /obj/item/weapon/material/twohanded/spear(get_turf(user), tmp_shard.material.name)
		to_chat(user, "<span class='notice'>You fasten \the [I] to the top of the rod with the cable.</span>")
	else if(istype(I, /obj/item/weapon/wirecutters))
		finished = new /obj/item/weapon/melee/baton/cattleprod(get_turf(user))
		to_chat(user, "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>")
	if(finished)
		user.drop_from_inventory(src)
		user.drop_from_inventory(I)
		qdel(I)
		qdel(src)
		user.put_in_hands(finished)
	update_icon(user)
