/obj/structure/table/standard
	icon_state = "plain_preview"
	color = COLOR_OFF_WHITE
	material = DEFAULT_TABLE_MATERIAL

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = COLOR_GRAY40
	material = DEFAULT_WALL_MATERIAL

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = COLOR_GRAY80
	material = "marble"

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = COLOR_OFF_WHITE
	material = DEFAULT_TABLE_MATERIAL
	reinforced = DEFAULT_WALL_MATERIAL

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = COLOR_GRAY40
	material = DEFAULT_WALL_MATERIAL
	reinforced = DEFAULT_WALL_MATERIAL

/obj/structure/table/woodentable
	icon_state = "plain_preview"
	color = COLOR_BROWN_ORANGE
	material = "wood"

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"
	carpeted = 1
	material = "wood"

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = COLOR_DEEP_SKY_BLUE
	alpha = 77 // 0.3 * 255
	material = "glass"

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = COLOR_OFF_WHITE
/obj/structure/table/holotable/New()
	material = "holo[DEFAULT_TABLE_MATERIAL]"
	..()

/obj/structure/table/holo_woodentable
	icon_state = "holo_preview"
	material = "holowood"
