/obj/item/weapon/rig/mantid
	name = "drone rig"
	desc = "An integrated cybernetic drone control system and docking rig."
	icon_state = "kexosuit"
	item_state = null
	suit_type = "support exosuit"
	armor = list(melee = 80, bullet = 80, laser = 75, energy = 50, bomb = 90, bio = 100, rad = 100)
	online_slowdown = 0
	offline_slowdown = 1
	equipment_overlay_icon = null
	air_type =   /obj/item/weapon/tank/methyl_bromide

	chest_type = /obj/item/clothing/suit/space/rig/mantid
	helm_type = /obj/item/clothing/head/helmet/space/rig/mantid
	boot_type = /obj/item/clothing/shoes/magboots/rig/mantid
	glove_type = /obj/item/clothing/gloves/rig/mantid

	icon_override = 'icons/mob/species/mantid/alate_back.dmi'
	var/mantid_caste = SPECIES_MANTID_ALATE

	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/gyne_back.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/alate_back.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/back.dmi'
		)

/obj/item/weapon/rig/mantid/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/maneuvering_jets
		)

/obj/item/weapon/rig/mantid/gyne
	icon_override = 'icons/mob/species/mantid/gyne_back.dmi'
	mantid_caste = SPECIES_MANTID_GYNE

/obj/item/weapon/rig/mantid/gyne/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/maneuvering_jets
		)

/obj/item/weapon/rig/mantid/nabber
	icon_override = 'icons/mob/species/nabber/back.dmi'
	mantid_caste = SPECIES_NABBER
	air_type =   /obj/item/weapon/tank/oxygen

/obj/item/weapon/rig/mantid/nabber/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/mounted/energy_blade,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/maneuvering_jets
		)

/obj/item/weapon/rig/mantid/mob_can_equip(var/mob/M, var/slot)
	. = ..()
	if(. && slot == slot_back)
		var/mob/living/carbon/human/H = M
		if(!istype(H) || H.species.get_bodytype(H) != mantid_caste)
			to_chat(H, "<span class='danger'>Your species cannot wear \the [src].</span>")
			. = 0

/obj/item/clothing/head/helmet/space/rig/mantid
	light_color = "#00ffff"
	desc = "More like a torpedo casing than a helmet."
	species_restricted = list(SPECIES_MANTID_GYNE, SPECIES_MANTID_ALATE, SPECIES_NABBER)
	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/gyne_head.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/alate_head.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/head.dmi'
		)

/obj/item/clothing/suit/space/rig/mantid
	desc = "It's closer to a mech than a suit."
	species_restricted = list(SPECIES_MANTID_GYNE, SPECIES_MANTID_ALATE, SPECIES_NABBER)
	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/gyne_suit.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/alate_suit.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/suit.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/mantid
	desc = "It's like a highly advanced forklift."
	species_restricted = list(SPECIES_MANTID_GYNE, SPECIES_MANTID_ALATE, SPECIES_NABBER)
	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/gyne_shoes.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/alate_shoes.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/shoes.dmi'
		)

/obj/item/clothing/gloves/rig/mantid
	desc = "They look like a cross between a can opener and a Swiss army knife the size of a shoebox."
	species_restricted = list(SPECIES_MANTID_GYNE, SPECIES_MANTID_ALATE, SPECIES_NABBER)
	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/gyne_gloves.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/alate_gloves.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/gloves.dmi'
		)
