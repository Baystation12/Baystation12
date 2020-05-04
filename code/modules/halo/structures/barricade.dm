
/obj/structure/destructible/steel_barricade
	name = "steel barricade"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "barricade2"
	flags = ON_BORDER
	cover_rating = 50
	loot_type = /obj/item/stack/material/steel

/obj/structure/destructible/steel_barricade/verb/verb_climb()
	set name = "Climb over barricade"
	set category = "Object"
	set src = view(1)

	structure_climb(usr)

/obj/structure/destructible/plasteel_barricade
	name = "plasteel barricade"
	icon = 'code/modules/halo/structures/structures.dmi'
	icon_state = "barricade"
	flags = ON_BORDER
	cover_rating = 50
	loot_type = /obj/item/stack/material/plasteel

/obj/structure/destructible/plasteel_barricade/update_icon()
	if(health > maxHealth * 0.66)
		icon_state = "barricade"
	else if(health > maxHealth * 0.33)
		icon_state = "barricade_dmg1"
	else
		icon_state = "barricade_dmg2"

/obj/structure/destructible/plasteel_barricade/verb/verb_climb()
	set name = "Climb over barricade"
	set category = "Object"
	set src = view(1)

	structure_climb(usr)

/obj/structure/destructible/marine_barricade
	name = "marine barricade"
	icon = 'code/modules/halo/structures/Marine_Barricade.dmi'
	icon_state = "marine barricade"
	flags = ON_BORDER
	cover_rating = 95
	maxHealth = 1000
	loot_type = /obj/item/stack/material/plasteel
