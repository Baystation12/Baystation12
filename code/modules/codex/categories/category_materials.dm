/datum/codex_category/materials/
	name = "Materials"
	desc = "Various natural and artificial materials."

/datum/codex_category/materials/Initialize()
	for(var/thing in SSmaterials.materials)
		var/material/mat = thing
		if(!mat.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[mat.display_name] (material)")
			entry.lore_text = mat.lore_text
			entry.antag_text = mat.antag_text
			var/list/material_info = list(mat.mechanics_text)

			material_info += "Its melting point is [mat.melting_point] K."
	
			if(mat.brute_armor < 2)
				material_info += "It is weak to physical impacts."
			else if(mat.brute_armor > 2)
				material_info += "It is [mat.brute_armor > 4 ? "very " : null]resistant to physical impacts."
			else
				material_info += "It has average resistance to physical impacts."

			if(mat.burn_armor < 2)
				material_info += "It is weak to applied energy."
			else if(mat.burn_armor > 2)
				material_info += "It is [mat.burn_armor > 4 ? "very " : null]resistant to applied energy."
			else
				material_info += "It has average resistance to applied energy."

			if(mat.conductive)
				material_info += "It conducts electricity."
			else
				material_info += "It does not conduct electricity."
			
			if(mat.opacity < 0.5)
				material_info += "It is transparent."

			if(mat.weight <= MATERIAL_LIGHT)
				material_info += "It is very light."
			else if(mat.weight >= MATERIAL_HEAVY)
				material_info += "It is very heavy."
			else
				material_info += "It is of average weight."

			var/material/steel = SSmaterials.materials_by_name[MATERIAL_STEEL]
			var/comparison = round(mat.hardness / steel.hardness, 0.1)
			if(comparison >= 0.9 && comparison <= 1.1)
				material_info += "It is as hard as steel."
			else if (comparison < 0.9)
				comparison = round(1/max(comparison,0.01),0.1)
				material_info += "It is ~[comparison] times softer than steel."
			else
				material_info += "It is ~[comparison] times harder than steel."

			comparison = round(mat.integrity / steel.integrity, 0.1)
			if(comparison >= 0.9 && comparison <= 1.1)
				material_info += "It is as durable as steel."
			else if (comparison < 0.9)
				comparison = round(1/comparison,0.1)
				material_info += "It is ~[comparison] times structurally weaker than steel."
			else
				material_info += "It is ~[comparison] times more durable than steel."

			if(LAZYLEN(mat.chem_products))
				var/chems = list()
				for(var/chemial in mat.chem_products)
					var/datum/reagent/R = chemial
					chems += "[initial(R.name)] ([mat.chem_products[chemial]]u)"
				material_info += "The following chemicals can be extracted from it (per [mat.sheet_singular_name]):<br>[english_list(chems)]"
			
			if(LAZYLEN(mat.alloy_materials))
				var/parts = list()
				for(var/alloy_part in mat.alloy_materials)
					var/material/part = SSmaterials.materials_by_name[alloy_part]
					parts += "[mat.alloy_materials[alloy_part]]u [part.display_name]"
				material_info += "It is an alloy of the following materials: [english_list(parts)]"

			if(mat.radioactivity)
				material_info += "It is radioactive."

			if(mat.is_fusion_fuel)
				material_info += "It can be used as fusion fuel."

			if(mat.flags & MATERIAL_UNMELTABLE)
				material_info += "It is impossible to melt."

			if(mat.flags & MATERIAL_BRITTLE)
				material_info += "It is brittle and can shatter under strain."

			if(mat.flags & MATERIAL_PADDING)
				material_info += "It can be used to pad furniture."

			entry.mechanics_text = jointext(material_info,"<br>")
			entry.update_links()
			SScodex.add_entry_by_string(entry.display_name, entry)
			items += entry.display_name
	..()