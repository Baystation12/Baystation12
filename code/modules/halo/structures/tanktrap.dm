
/obj/structure/destructible/tanktrap
	name = "tanktrap"
	desc = "This space is blocked off by a barricade."
	icon_state = "tanktrap"
	loot_type = /obj/item/stack/material/steel

/obj/structure/destructible/tanktrap/update_icon()
	if(health > maxHealth * 0.66)
		icon_state = "tanktrap"
	else if(health > maxHealth * 0.33)
		icon_state = "tanktrap2"
	else
		icon_state = "tanktrap3"

/obj/structure/destructible/tanktrap/place_scraps()
	. = ..()
	new /obj/structure/tanktrap_dead(src.loc)

/obj/structure/tanktrap_dead
	name = "destroyed tanktrap"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "tanktrap_dead"
	density = 0

/obj/structure/destructible/tanktrap/verb/verb_climb()
	set name = "Climb over tank trap"
	set category = "Object"
	set src = view(1)

	structure_climb(usr)
