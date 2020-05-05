
/obj/structure/destructible/steel_barricade
	name = "steel barricade"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "barricade2"
	flags = ON_BORDER
	cover_rating = 50

/obj/structure/destructible/plasteel_barricade
	name = "plasteel barricade"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "barricade"
	flags = ON_BORDER
	cover_rating = 50
	loot_types = list(/obj/item/stack/material/plasteel)

/obj/structure/destructible/plasteel_barricade/update_icon()
	if(health > maxHealth * 0.66)
		icon_state = "barricade"
	else if(health > maxHealth * 0.33)
		icon_state = "barricade_dmg1"
	else
		icon_state = "barricade_dmg2"

/obj/structure/destructible/marine_barricade
	name = "marine barricade"
	icon = 'code/modules/halo/structures/Marine_Barricade.dmi'
	icon_state = "marine barricade"
	flags = ON_BORDER
	cover_rating = 95
	maxHealth = 1000
	loot_types = list(/obj/item/stack/material/plasteel)
	climbable = 0

/obj/structure/destructible/marine_barricade/New()
	. = ..()

	if(dir == NORTH || dir == SOUTH)
		pixel_x = -6

	if(dir == EAST || dir == WEST)
		plane = ABOVE_HUMAN_PLANE
		layer = ABOVE_HUMAN_LAYER
