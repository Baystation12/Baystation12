
/obj/structure/tree/snow_pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	woodleft = 3

/obj/structure/tree/snow_pine/New()
	..()
	icon_state = "pine_[rand(1,3)]"

/obj/structure/tree/snow_pine_giant
	name = "pine tree"
	icon = 'code/modules/halo/icons/doodads/trees.dmi'
	icon_state = "pine1"
	woodleft = 5

/obj/structure/tree/snow_pine_giant/New()
	..()
	icon_state = "pine[rand(1,2)]"

/obj/structure/tree/snow_dead
	name = "dead tree"
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"
	woodleft = 2

/obj/structure/tree/snow_dead/New()
	..()
	icon_state = "tree_[rand(1,6)]"
