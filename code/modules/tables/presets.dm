/obj/structure/table

	standard
		icon_state = "plain_preview"
		color = "#EEEEEE"
		New()
			material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
			..()

	steel
		icon_state = "plain_preview"
		color = "#666666"
		New()
			material = get_material_by_name(DEFAULT_WALL_MATERIAL)
			..()

	marble
		icon_state = "stone_preview"
		color = "#CCCCCC"
		New()
			material = get_material_by_name("marble")
			..()

	reinforced
		icon_state = "reinf_preview"
		color = "#EEEEEE"
		New()
			material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
			reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
			..()
	
	steel_reinforced
		icon_state = "reinf_preview"
		color = "#666666"
		New()
			material = get_material_by_name(DEFAULT_WALL_MATERIAL)
			reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
			..()

	woodentable
		icon_state = "plain_preview"
		color = "#824B28"
		New()
			material = get_material_by_name("wood")
			..()

	gamblingtable
		icon_state = "gamble_preview"
		New()
			material = get_material_by_name("wood")
			carpeted = 1
			..()

	glass
		icon_state = "plain_preview"
		color = "#00E1FF"
		alpha = 77 // 0.3 * 255
		New()
			material = get_material_by_name("glass")
			..()

	holotable
		icon_state = "holo_preview"
		color = "#EEEEEE"
		New()
			material = get_material_by_name("holographic [DEFAULT_TABLE_MATERIAL]")
			..()

	woodentable/holotable
		icon_state = "holo_preview"
		New()
			material = get_material_by_name("holographic wood")
			..()
