// SIERRA TODO: Перенести к диванам в мод + вернуть иконки

/obj/structure/bed/chair/pew/up
	// icon = 'packs/infinity/icons/obj/furniture.dmi'
	// icon_state = "pew_up"
	base_icon = "pew_up"

/obj/structure/bed/chair/pew/down
	// icon = 'packs/infinity/icons/obj/furniture.dmi'
	// icon_state = "pew_down"
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
	..(newloc, newmaterial, MATERIAL_CARPET)

/obj/structure/bed/chair/office/teal/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "teal")

/obj/structure/bed/chair/office/dark/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "black")

/obj/structure/bed/chair/office/green/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "green")

/obj/structure/bed/chair/office/purple/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "purple")

/obj/structure/bed/chair/office/blue/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "blue")

/obj/structure/bed/chair/office/beige/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "beige")

/obj/structure/bed/chair/office/lime/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "lime")

/obj/structure/bed/chair/office/yellow/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, "yellow")

/obj/structure/bed/chair/office/light/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, newmaterial, MATERIAL_CLOTH)



/obj/structure/bed/chair/shuttle/hard/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, padding_material)

/obj/structure/bed/chair/shuttle/blue/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, "blue")

/obj/structure/bed/chair/shuttle/black/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL , "black")

/obj/structure/bed/chair/shuttle/white/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

/obj/structure/bed/chair/shuttle/red/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, MATERIAL_CARPET)

/obj/structure/bed/chair/shuttle/green/New(newloc, newmaterial = DEFAULT_FURNITURE_MATERIAL)
	..(newloc, MATERIAL_STEEL, "green")
