
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
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "tanktrap_dead"
	density = 0
