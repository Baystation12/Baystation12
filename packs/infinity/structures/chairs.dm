/obj/structure/bed/chair/pew/up
	icon = 'packs/infinity/icons/obj/furniture.dmi'
	icon_state = "pew_up"
	base_icon = "pew_up"

/obj/structure/bed/chair/pew/down
	icon = 'packs/infinity/icons/obj/furniture.dmi'
	icon_state = "pew_down"
	base_icon = "pew_down"

/obj/structure/bed/chair/pew/up/mahogany
	color = WOOD_COLOR_RICH
	pew_material = MATERIAL_MAHOGANY

/obj/structure/bed/chair/pew/down/mahogany
	color = WOOD_COLOR_RICH
	pew_material = MATERIAL_MAHOGANY



/obj/structure/bed/chair/office/hard/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, padding_material)

/obj/structure/bed/chair/office/brown/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_LEATHER_GENERIC)

/obj/structure/bed/chair/office/red/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_RED_CLOTH)

/obj/structure/bed/chair/office/teal/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_TEAL_CLOTH)

/obj/structure/bed/chair/office/dark/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_BLACK_CLOTH)

/obj/structure/bed/chair/office/green/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_GREEN_CLOTH)

/obj/structure/bed/chair/office/purple/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_PURPLE_CLOTH)

/obj/structure/bed/chair/office/blue/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_BLUE_CLOTH)

/obj/structure/bed/chair/office/beige/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_BEIGE_CLOTH)

/obj/structure/bed/chair/office/lime/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_LIME_CLOTH)

/obj/structure/bed/chair/office/yellow/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_YELLOW_CLOTH)

/obj/structure/bed/chair/office/light/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_CLOTH)



/obj/structure/bed/chair/shuttle/hard/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, padding_material)

/obj/structure/bed/chair/shuttle/blue/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, MATERIAL_BLUE_CLOTH)

/obj/structure/bed/chair/shuttle/black/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL ,MATERIAL_BLACK_CLOTH)

/obj/structure/bed/chair/shuttle/white/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

/obj/structure/bed/chair/shuttle/red/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, MATERIAL_RED_CLOTH)

/obj/structure/bed/chair/shuttle/green/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, MATERIAL_GREEN_CLOTH)
