/obj/structure/flora/seaweed
	name = "seaweed"
	desc = "Waving fronds of ocean greenery."
	icon = 'icons/obj/structures/plants.dmi'
	icon_state = "seaweed"
	anchored = TRUE
	density = FALSE
	opacity = FALSE

/obj/structure/flora/seaweed/mid
	icon_state = "seaweed1"

/obj/structure/flora/seaweed/large
	icon_state = "seaweed2"

/obj/structure/flora/seaweed/glow
	name = "glowing seaweed"
	desc = "It shines with an eerie bioluminescent light."
	icon_state = "glowweed1"

/obj/structure/flora/seaweed/glow/Initialize()
	. = ..()
	set_light(0.6, 0.1, 4, 3, "#00fff4")
	icon_state = "glowweed[rand(1,3)]"

/obj/effect/decal/cleanable/lichen
	name = "lichen"
	desc = "Damp and mossy plant life."
	icon_state = "lichen"
	icon = 'icons/obj/structures/plants.dmi'