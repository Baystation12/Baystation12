var/global/material/material_holographic_steel = null
var/global/material/material_holographic_wood = null

/obj/structure/table

	standard
		icon_state = "plain_preview"
		color = "#666666"
		New()
			if(!name_to_material) populate_material_list()
			material = name_to_material[DEFAULT_WALL_MATERIAL]
			..()

	reinforced
		icon_state = "reinf_preview"
		color = "#666666"
		New()
			if(!name_to_material) populate_material_list()
			material = name_to_material[DEFAULT_WALL_MATERIAL]
			reinforced = name_to_material[DEFAULT_WALL_MATERIAL]
			..()

	woodentable
		icon_state = "plain_preview"
		color = "#824B28"
		New()
			if(!name_to_material) populate_material_list()
			material = name_to_material["wood"]
			..()

	gamblingtable
		icon_state = "gamble_preview"
		New()
			if(!name_to_material) populate_material_list()
			material = name_to_material["wood"]
			carpeted = 1
			..()

	glass
		icon_state = "plain_preview"
		color = "#00E1FF"
		alpha = 77 // 0.3 * 255
		New()
			if(!name_to_material) populate_material_list()
			material = name_to_material["glass"]
			..()

	holotable
		icon_state = "holo_preview"
		color = "#666666"
		New()
			if(!material_holographic_steel)
				material_holographic_steel = new /material/steel
				material_holographic_steel.stack_type = null // Tables with null-stacktype materials cannot be deconstructed
			material = material_holographic_steel
			..()

	woodentable/holotable
		icon_state = "holo_preview"
		New()
			if(!material_holographic_wood)
				material_holographic_wood = new /material/wood
				material_holographic_wood.stack_type = null // Tables with null-stacktype materials cannot be deconstructed
			material = material_holographic_wood
			..()
