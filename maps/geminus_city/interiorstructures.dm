/material/glass/black
	name = "black glass"
	icon_colour = "#000000"

/material/glass/lime
	name = "lime glass"
	icon_colour = "#c8e963"

/material/glass/red
	name = "red glass"
	icon_colour = "#800020"

/material/glass/pink
	name = "pink glass"
	icon_colour = "#F0A0A0"

/material/glass/white
	name = "white glass"
	icon_colour = "#ffffff"

/material/glass/brown
	name = "brown glass"
	icon_colour = "#634221"

/material/glass/blue
	name = "blue glass"
	icon_colour = "#4986CA"

/material/glass/purple
	name = "purple glass"
	icon_colour = "915C91"

/material/glass/teal
	name = "teal glass"
	icon_colour = "#008080"

/obj/structure/table/glass/black
	name = "black glass table"
	material = "black glass"

/obj/structure/table/glass/brown
	name = "brown glass table"
	material = "brown glass"

/obj/structure/table/glass/lime
	name = "lime glass table"
	material = "lime glass"

/obj/structure/table/glass/white
	name = "white glass table"
	material = "white glass"

/obj/structure/table/glass/red
	name = "red glass table"
	material = "red glass"

/obj/structure/table/glass/purple
	name = "purple glass table"
	material = "purple glass"

/obj/structure/table/glass/teal
	name = "teal glass table"
	material = "teal glass"

/obj/structure/sofa
	name = "old ratty sofa"
	icon = 'maps/geminus_city/citymap_icons/objects.dmi'
	icon_state = "sofamiddle"
	anchored = 1

/obj/structure/sofa/

/obj/structure/sofa/left
	icon_state = "sofaend_left"
/obj/structure/sofa/right
	icon_state = "sofaend_right"
/obj/structure/sofa/corner
	icon_state = "sofacorner"

/obj/structure/window/framed
	name = "framed window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'maps/geminus_city/citymap_icons/structures.dmi'
	icon_state = "framewindow"
	dir = 5
	shardtype = /obj/structure/grille/frame

/obj/structure/window/framed/update_icon()
//Framed window tiles do not change.
	return

/obj/structure/grille/frame
	name = "frame"
	icon = 'maps/geminus_city/citymap_icons/structures.dmi'
	icon_state = "frame"
	health = 10