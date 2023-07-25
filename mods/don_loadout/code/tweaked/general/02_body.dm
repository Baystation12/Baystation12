/datum/category_item/player_setup_item/physical/body/content(mob/user)
	. = list()

	var/datum/species/mob_species = all_species[pref.species]
	. += "<b>Раса ([BTN("show_species", "?")]):</b> [BTN("set_species", mob_species.name)]"
	. += "<br />"
	if (length(mob_species.description) > 100)
		. += "[hide_species ? copytext(mob_species.description, 1, 100) : mob_species.description]"
		. += "<br /><a href='?src=\ref[src];toggle_species_verbose=1'>[hide_species ? "Развернуть" : "Свернуть"]</a>"
	else
		. += "[mob_species.description]"

	. += "<hr />"

	. += "<b>Тело ([BTN("random", "&reg;")]):</b>"
	. += "<br />[TBTN("gender", gender2text(pref.gender), "Пол")]"
	. += "<br />[TBTN("age", pref.age, "Возраст")]"
	. += "<br />[TBTN("blood_type", pref.b_type, "Тип крови")]"
	. += "<br />[VTBTN("disabilities", NEARSIGHTED, pref.disabilities & NEARSIGHTED ? "Да" : "Нет", "Близорукость")]"

	. += "<br />Аугментация: [BTN("limbs", "Конечности")] [BTN("organs", "Органы")] [BTN("reset_limbs", "Сбросить")]"
	var/list/alt_organs = list()
	for (var/name in pref.organ_data)
		var/status = pref.organ_data[name]
		var/organ_name
		switch (name)
			if (BP_L_ARM) organ_name = "left arm"
			if (BP_R_ARM) organ_name = "right arm"
			if (BP_L_LEG) organ_name = "left leg"
			if (BP_R_LEG) organ_name = "right leg"
			if (BP_L_FOOT) organ_name = "left foot"
			if (BP_R_FOOT) organ_name = "right foot"
			if (BP_L_HAND) organ_name = "left hand"
			if (BP_R_HAND) organ_name = "right hand"
			if (BP_HEART) organ_name = BP_HEART
			if (BP_EYES) organ_name = BP_EYES
			if (BP_BRAIN) organ_name = BP_BRAIN
			if (BP_LUNGS) organ_name = BP_LUNGS
			if (BP_LIVER) organ_name = BP_LIVER
			if (BP_KIDNEYS) organ_name = BP_KIDNEYS
			if (BP_STOMACH) organ_name = BP_STOMACH
			if (BP_CHEST) organ_name = "upper body"
			if (BP_GROIN) organ_name = "lower body"
			if (BP_HEAD) organ_name = "head"
		switch (status)
			if ("amputated") alt_organs += "Amputated [organ_name]"
			if ("mechanical")
				alt_organs += "[organ_name == BP_BRAIN ? "Positronic" : "Synthetic"] [organ_name]"
			if ("cyborg")
				var/datum/robolimb/limb = basic_robolimb
				if (pref.rlimb_data[name] && all_robolimbs[pref.rlimb_data[name]])
					limb = all_robolimbs[pref.rlimb_data[name]]
				alt_organs += "[limb.company] [organ_name] prosthesis"
			if ("assisted")
				switch (organ_name)
					if (BP_HEART) alt_organs += "Pacemaker-assisted [organ_name]"
					if ("voicebox") alt_organs += "Surgically altered [organ_name]"
					if (BP_EYES) alt_organs += "Retinal overlayed [organ_name]"
					if (BP_BRAIN) alt_organs += "Machine-interface [organ_name]"
					else alt_organs += "Mechanically assisted [organ_name]"
	if (length(alt_organs))
		. += "<br />[alt_organs.Join(", ")]"
	. += "<br />"

	if (length(pref.body_descriptors))
		for (var/entry in pref.body_descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if (!descriptor) //this hides a nabber problem
				continue
			var/description = descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])
			. += "<br />[capitalize(descriptor.chargen_label)]: [description] [VBTN("change_descriptor", entry, "Изменить")]"

	if (HasAppearanceFlag(mob_species, SPECIES_APPEARANCE_HAS_EYE_COLOR))
		var/color = pref.eye_color
		. += "<br /><br />Цвет глаз: [COLOR_PREVIEW(color)] [BTN("eye_color", "Изменить")]"

	var/has_head_hair = length(mob_species.get_hair_styles())
	if (has_head_hair > 1)
		. += "<br /><br />Причёска:"
		. += "<br />- Стиль: [BTN("hair_style=1;dec", "&lt;")][BTN("hair_style=1;inc", "&gt;")] [BTN("hair_style", pref.head_hair_style)]"
		if (HasAppearanceFlag(mob_species, SPECIES_APPEARANCE_HAS_HAIR_COLOR))
			var/color = pref.head_hair_color
			. += "<br />- Цвет: [COLOR_PREVIEW(color)] [BTN("hair_color", "Изменить")]"

	var/has_facial_hair = length(mob_species.get_facial_hair_styles(pref.gender))
	if (has_facial_hair > 1)
		. += "<br /><br />Лицевая растительность: "
		. += "<br />- Стиль: [BTN("facial_style=1;dec", "&lt;")][BTN("facial_style=1;inc", "&gt;")] [BTN("facial_style", pref.facial_hair_style)]"
		if (HasAppearanceFlag(mob_species, SPECIES_APPEARANCE_HAS_HAIR_COLOR))
			var/color = pref.facial_hair_color
			. += "<br />- Цвет: [COLOR_PREVIEW(color)] [BTN("facial_color", "Изменить")]"

	. += "<br />"
	if (HasAppearanceFlag(mob_species, SPECIES_APPEARANCE_HAS_BASE_SKIN_COLOURS))
		. += TBTN("base_skin", pref.base_skin, "<br />Основной цвет")

	if (HasAppearanceFlag(mob_species, SPECIES_APPEARANCE_HAS_SKIN_COLOR))
		var/color = pref.skin_color
		. += "[TBTN("skin_color", "Color", "<br />Цвет покрова")] [COLOR_PREVIEW(color)]"

	else if (HasAppearanceFlag(mob_species, SPECIES_APPEARANCE_HAS_A_SKIN_TONE))
		. += "[TBTN("skin_tone", "[-pref.skin_tone + 35]/[mob_species.max_skin_tone()]", "<br />Тон кожи")]"

	. += "<hr />"
	. += "<b>Нательные метки</b>"
	. += "<br />[BTN("marking_style", "+ Добавить")]"
	for (var/marking in pref.body_markings)
		. += "<br />[marking]: "
		var/datum/sprite_accessory/marking/instance = GLOB.body_marking_styles_list[marking]
		if (instance.do_coloration == DO_COLORATION_USER)
			var/color = pref.body_markings[marking]
			. += "[COLOR_PREVIEW(color)] [VBTN("marking_color", marking, "Изменить")] "
		. += "[VBTN("marking_remove", marking, "Удалить")]"
	if (length(pref.body_markings))
		. += "<br />"
	. = jointext(., null)
