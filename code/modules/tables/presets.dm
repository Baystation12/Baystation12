/obj/structure/table/standard
	icon_state = "plain_preview"
	color = COLOR_OFF_WHITE
	material = DEFAULT_FURNITURE_MATERIAL

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = COLOR_GRAY40
	material = MATERIAL_STEEL

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = COLOR_GRAY80
	material = MATERIAL_MARBLE

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = COLOR_OFF_WHITE
	material = DEFAULT_FURNITURE_MATERIAL
	reinforced = MATERIAL_STEEL

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = COLOR_GRAY40
	material = MATERIAL_STEEL
	reinforced = MATERIAL_STEEL

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"
	carpeted = 1
	material = MATERIAL_WALNUT

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = COLOR_DEEP_SKY_BLUE
	alpha = 77 // 0.3 * 255
	material = MATERIAL_GLASS

/obj/structure/table/glass/pglass
	color = "#8f29a3"
	material = MATERIAL_PHORON_GLASS

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE

/obj/structure/table/holotable/New()
	material = "holo[DEFAULT_FURNITURE_MATERIAL]"
	..()

/obj/structure/table/holo_woodentable
	icon_state = "holo_preview"

/obj/structure/table/holo_woodentable/New()
	material = "holo[MATERIAL_WOOD]"
	..()

//wood wood wood
/obj/structure/table/woodentable
	icon_state = "solid_preview"
	color = WOOD_COLOR_GENERIC
	material = MATERIAL_WOOD

/obj/structure/table/woodentable_reinforced
	icon_state = "reinf_preview"
	color = WOOD_COLOR_GENERIC
	material = MATERIAL_WOOD
	reinforced = MATERIAL_WOOD

/obj/structure/table/woodentable_reinforced/walnut
	icon_state = "reinf_preview"
	color = WOOD_COLOR_CHOCOLATE
	material = MATERIAL_WALNUT
	reinforced = MATERIAL_WALNUT

/obj/structure/table/woodentable_reinforced/walnut/maple
	reinforced = MATERIAL_MAPLE

/obj/structure/table/woodentable_reinforced/mahogany
	icon_state = "reinf_preview"
	color = WOOD_COLOR_RICH
	material = MATERIAL_MAHOGANY
	reinforced = MATERIAL_MAHOGANY

/obj/structure/table/woodentable_reinforced/mahogany/walnut
	reinforced = MATERIAL_WALNUT

/obj/structure/table/woodentable_reinforced/ebony
	icon_state = "reinf_preview"
	color = WOOD_COLOR_BLACK
	material = MATERIAL_EBONY
	reinforced = MATERIAL_WALNUT

/obj/structure/table/woodentable_reinforced/ebony/walnut
	reinforced = MATERIAL_WALNUT

/obj/structure/table/woodentable/mahogany
	color = WOOD_COLOR_RICH
	material = MATERIAL_MAHOGANY

/obj/structure/table/woodentable/maple
	color = WOOD_COLOR_PALE
	material = MATERIAL_MAPLE

/obj/structure/table/woodentable/ebony
	color = WOOD_COLOR_BLACK
	material = MATERIAL_EBONY

/obj/structure/table/woodentable/walnut
	color = WOOD_COLOR_CHOCOLATE
	material = MATERIAL_WALNUT