#include "_flora.dm"
#include "_tree.dm"

/obj/structure/tree/snow_pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	woodleft = 3

/obj/structure/tree/snow_pine/New()
	..()
	icon_state = "pine_[rand(1,3)]"

/obj/structure/tree/snow_dead
	name = "dead tree"
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"
	woodleft = 2

/obj/structure/tree/snow_dead/New()
	..()
	icon_state = "tree_[rand(1,6)]"

/obj/effect/flora/snow
	name = "snowy grass"
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowgrass1bb"

/obj/effect/flora/snow/pick_icon_state()
	..()
	if(findtext(icon_state,"snowbush")
		name = "snowy bush"
