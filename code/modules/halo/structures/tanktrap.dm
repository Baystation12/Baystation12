
/obj/structure/destructible/tanktrap
	name = "tanktrap"
	desc = "This space is blocked off by a barricade."
	icon_state = "tanktrap"
	dead_type = /obj/structure/tanktrap_dead

/obj/structure/destructible/tanktrap/update_icon()
	if(health > maxHealth * 0.66)
		icon_state = "tanktrap"
	else if(health > maxHealth * 0.33)
		icon_state = "tanktrap2"
	else
		icon_state = "tanktrap3"

/obj/structure/tanktrap_dead
	name = "destroyed tanktrap"
	desc = "Can be cleared with a lit welder."
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "tanktrap_dead"
	density = 0

/obj/structure/tanktrap_dead/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			user.visible_message("<span class='notice'>[user] clears [src].</span>",\
				"<span class='notice'>You clear [src].</span>")
			new /obj/item/stack/material/steel(src.loc)
			qdel(src)
			return 1
		else
			to_chat(user, "<span class='warning'>You need more fuel.</span>")
	else
		. = ..()
