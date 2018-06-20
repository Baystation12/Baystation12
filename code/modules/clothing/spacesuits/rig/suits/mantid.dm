/obj/item/weapon/rig/mantid
	name = "mantid support rig"
	desc = "A powerful support exosuit with integrated power supply, weapon and atmosphere. It's closer to a mech than a rig."
	icon_state = "kexosuit"
	item_state = null
	suit_type = "support exosuit"
	armor = list(melee = 80, bullet = 80, laser = 75, energy = 50, bomb = 90, bio = 100, rad = 100)
	online_slowdown = 0
	offline_slowdown = 1
	equipment_overlay_icon = null
	air_type =   /obj/item/weapon/tank/mantid
	cell_type =  /obj/item/weapon/cell/high/mantid
	chest_type = /obj/item/clothing/suit/space/rig/mantid
	helm_type =  /obj/item/clothing/head/helmet/space/rig/mantid
	boot_type =  /obj/item/clothing/shoes/magboots/rig/mantid
	glove_type = /obj/item/clothing/gloves/rig/mantid
	icon_override = 'icons/mob/species/mantid/onmob_back_alate.dmi'
	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/onmob_back_gyne.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_back_alate.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/onmob_back_gas.dmi'
		)
	initial_modules = list(
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/mantid,
		/obj/item/rig_module/mounted/energy_blade/mantid,
		//obj/item/rig_module/mounted/multitool,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/maneuvering_jets
		)

	var/mantid_caste = SPECIES_MANTID_ALATE

// Renamed blade.
/obj/item/rig_module/mounted/energy_blade/mantid
	name = "alien blade projector"
	interface_name = "energy blade"
	icon = 'icons/obj/mantid_gear.dmi'
	icon_state = "blade"
	gun = null

// Self-charging power cell.
/obj/item/weapon/cell/high/mantid
	name = "mantid microfusion plant"
	desc = "An impossibly tiny fusion reactor of mantid design."
	icon = 'icons/obj/mantid_gear.dmi'
	icon_state = "plant"
	var/recharge_amount = 12

/obj/item/weapon/cell/high/mantid/Initialize()
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/cell/high/mantid/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/cell/high/mantid/Process()
	if(charge < maxcharge)
		give(recharge_amount)

// Atmosphere/jetpack filler.
/obj/item/weapon/tank/mantid
	name = "mantid gas reactor"
	desc = "A mantid gas processing plant that continuously synthesises 'breathable' atmosphere."
	icon_state = "bromomethane"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 180

	var/charge_cost = 12
	var/refill_gas_type = "methyl_bromide"
	var/gas_regen_amount = 0.05
	var/gas_regen_cap = 50

/obj/item/weapon/tank/mantid/Initialize()
	starting_pressure = list("[refill_gas_type]" = 6 * ONE_ATMOSPHERE)
	. = ..()

/obj/item/weapon/tank/mantid/oxygen
	refill_gas_type = "oxygen"

/obj/item/weapon/tank/mantid/Process()
	..()
	var/obj/item/weapon/rig/holder = loc
	if(air_contents.total_moles < gas_regen_cap && istype(holder) && holder.cell && holder.cell.use(charge_cost))
		air_contents.adjust_gas(refill_gas_type, gas_regen_amount)

// Chem dispenser.
/obj/item/rig_module/chem_dispenser/mantid
	name = "mantid chemical injector"
	desc = "A compact chemical dispenser of mantid design."
	icon = 'icons/obj/mantid_gear.dmi'
	icon_state = "injector"
	charges = list(
		list("bromide",             "bromide",             /datum/reagent/toxin/bromide, 80),
		list("crystallizing agent", "crystallizing agent", /datum/reagent/crystal,       80),
		list("spaceacillin",        "spaceacillin",        /datum/reagent/spaceacillin,  80),
		list("tramadol",            "tramadol",            /datum/reagent/tramadol,      80)
	)

// Rig definitions.
/obj/item/weapon/rig/mantid/gyne
	icon_override = 'icons/mob/species/mantid/onmob_back_gyne.dmi'
	mantid_caste = SPECIES_MANTID_GYNE

/obj/item/weapon/rig/mantid/nabber
	icon_override = 'icons/mob/species/nabber/onmob_back_gas.dmi'
	mantid_caste = SPECIES_NABBER
	air_type =   /obj/item/weapon/tank/mantid/oxygen

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
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/onmob_head_gyne.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_head_alate.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/onmob_head_gas.dmi'
		)

/obj/item/clothing/suit/space/rig/mantid
	desc = "It's closer to a mech than a suit."
	species_restricted = list(SPECIES_MANTID_GYNE, SPECIES_MANTID_ALATE, SPECIES_NABBER)
	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/onmob_suit_gyne.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_suit_alate.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/onmob_suit_gas.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/mantid
	desc = "It's like a highly advanced forklift."
	species_restricted = list(SPECIES_MANTID_GYNE, SPECIES_MANTID_ALATE, SPECIES_NABBER)
	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/onmob_shoes_gyne.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_shoes_alate.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/onmob_shoes_gas.dmi'
		)

/obj/item/clothing/gloves/rig/mantid
	desc = "They look like a cross between a can opener and a Swiss army knife the size of a shoebox."
	species_restricted = list(SPECIES_MANTID_GYNE, SPECIES_MANTID_ALATE, SPECIES_NABBER)
	sprite_sheets = list(
		SPECIES_MANTID_GYNE =  'icons/mob/species/mantid/onmob_gloves_gyne.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_gloves_alate.dmi',
		SPECIES_NABBER =       'icons/mob/species/nabber/onmob_hands_gas.dmi'
		)
