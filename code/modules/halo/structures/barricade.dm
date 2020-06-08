
/obj/structure/destructible/steel_barricade
	name = "steel barricade"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "barricade"
	flags = ON_BORDER
	cover_rating = 50
	repair_material_name = "steel"

/obj/structure/destructible/plasteel_barricade
	name = "plasteel barricade2"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "barricade2"
	flags = ON_BORDER
	cover_rating = 50 //Lower intercept, higher health
	maxHealth = 400
	loot_types = list(/obj/item/stack/material/plasteel)
	repair_material_name = "plasteel"

/obj/structure/destructible/steel_barricade/update_icon()
	. = ..()
	if(health > maxHealth * 0.66)
		icon_state = "barricade"
	else if(health > maxHealth * 0.33)
		icon_state = "barricade_dmg1"
	else
		icon_state = "barricade_dmg2"

/obj/structure/destructible/marine_barricade
	name = "marine barricade"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "marine barricade"
	flags = ON_BORDER
	cover_rating = 95 //High intercept, low health
	maxHealth = 300
	closerange_freefire = 0 //Also, we can't fire from behind this, just like the covenant energy 'cade
	loot_types = list(/obj/item/stack/material/plasteel)
	repair_material_name = "plasteel"
	climbable = 0

/obj/structure/destructible/plasteel_barricade/update_icon()
	. = ..()
	if(dir == NORTH || dir == SOUTH)
		pixel_x = -6

	if(dir == EAST || dir == WEST)
		plane = ABOVE_HUMAN_PLANE
		layer = ABOVE_HUMAN_LAYER

/obj/structure/destructible/covenant_barricade
	name = "covenant barricade"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "covenant_barricade"
	flags = ON_BORDER
	cover_rating = 66
	maxHealth = 400
	loot_types = list(/obj/item/stack/material/nanolaminate)
	repair_material_name = "nanolaminate"

/obj/structure/destructible/covenant_barricade/update_icon()
	. = ..()
	if(health > maxHealth * 0.66)
		icon_state = "covenant_barricade"
	else if(health > maxHealth * 0.33)
		icon_state = "covenant_dmg1"
	else
		icon_state = "covenant_dmg2"
