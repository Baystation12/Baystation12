
#define SANGHEILI_ARMOUR_ICON 'code/modules/halo/covenant/species/sangheili/Sangheili_Combat_Harness.dmi'
#define SANGHEILI_BLEEDBLOCK_CHANCE 50

/obj/item/weapon/storage/backpack/sangheili
	name = "Covenant Battle Pack"
	desc = "An airtight storage compartment sometimes used by Sangheili to carry supplies into combat."
	icon = 'code/modules/halo/covenant/species/sangheili/backpack.dmi'
	icon_state = "covpack"
	item_state = null

/obj/item/clothing/under/covenant/sangheili
	name = "\improper Sangheili Body-suit"
	desc = "A sealed, airtight bodysuit. Meant to be worn underneath combat harnesses."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "sangheili_suit"
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS
	item_flags = STOPPRESSUREDAMAGE|AIRTIGHT
	matter = list("cloth" = 1)

/obj/item/clothing/head/helmet/sangheili
	name = "Sangheili Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = null
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	unacidable = 1
	armor = list(melee = 60, bullet = 40, laser = 30,energy = 30, bomb = 25, bio = 30, rad = 30) //Spartan tier helms.
	matter = list("nanolaminate" = 1)

	integrated_hud = /obj/item/clothing/glasses/hud/tactical/covenant

/obj/item/clothing/suit/armor/special/combatharness
	name = "Sangheili Combat Harness"
	desc = "A Sangheili Combat Harness."
	species_restricted = list("Sangheili")
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = null
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/gun/energy, /obj/item/weapon/gun/projectile, /obj/item/ammo_magazine,
				   /obj/item/ammo_casing, /obj/item/weapon/melee/baton, /obj/item/weapon/melee/energy/elite_sword)
	specials = list(/datum/armourspecials/shields/elite,/datum/armourspecials/shieldmonitor/sangheili)
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25)
	unacidable = 1
	max_suitstore_w_class = ITEM_SIZE_HUGE
	matter = list("nanolaminate" = 2)

/obj/item/clothing/suit/armor/special/combatharness/New()
	..()
	pocket_curr = new/obj/item/weapon/storage/internal/pockets(src,2, ITEM_SIZE_SMALL,null,ARMOUR_POCKET_CANHOLD)

/obj/item/clothing/shoes/sangheili
	name = "Sanghelli Leg Armour"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = null
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	body_parts_covered = FEET
	armor = list(melee = 60, bullet = 45, laser = 35,energy = 35, bomb = 30, bio = 35, rad = 35)
	armor_thickness = 20
	matter = list("nanolaminate" = 1)
	stepsound = 'code/modules/halo/sounds/walk_sounds/spartan_boots.ogg'

/obj/item/clothing/gloves/thick/sangheili
	name = "Sangheili Combat Gauntlets"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = null
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	siemens_coefficient = 0.15
	permeability_coefficient = 0.05
	body_parts_covered = HANDS
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 30, bio = 0, rad = 0)
	armor_thickness = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	matter = list("nanolaminate" = 1)

//Code for in guantlet energy daggers + the weapon itself ( edited dagger)

	action_button_name = "Toggle Gauntlet Energy Dagger"

	var/obj/item/weapon/melee/energy/elite_sword/g_dagger/connected_dagger = /obj/item/weapon/melee/energy/elite_sword/g_dagger
	var/mob/current_user

/obj/item/clothing/gloves/thick/sangheili/New()
	. = ..()
	connected_dagger = new connected_dagger (src)

/obj/item/clothing/gloves/thick/sangheili/proc/gauntlets_check()
	var/mob/living/carbon/human/h = current_user
	if(istype(h))
		if(h.gloves == src)
			return 1
	return 0

/obj/item/clothing/gloves/thick/sangheili/equipped(var/mob/user)
	current_user = user
	if(!gauntlets_check())
		current_user = null

/obj/item/clothing/gloves/thick/sangheili/dropped(var/mob/user)
	if(!gauntlets_check())
		current_user = null

/obj/item/clothing/gloves/thick/sangheili/proc/equip_dagger()
	if(!current_user)
		return
	if(!current_user.put_in_active_hand(connected_dagger))
		if(!current_user.put_in_inactive_hand(connected_dagger))
			to_chat(current_user,"<span class = 'notice'>You need one hand free to use [src.name]</span>")

	update_inhand_icons()

/obj/item/clothing/gloves/thick/sangheili/proc/unequip_dagger()
	current_user.drop_from_inventory(connected_dagger)
	contents += connected_dagger
	update_inhand_icons()

/obj/item/clothing/gloves/thick/sangheili/proc/update_inhand_icons()
	if(!current_user)
		return

	if(current_user.l_hand == connected_dagger)
		current_user.update_inv_l_hand()
	if(current_user.r_hand == connected_dagger)
		current_user.update_inv_r_hand()


/obj/item/clothing/gloves/thick/sangheili/proc/on_dagger_dropped()
	contents += connected_dagger

/obj/item/clothing/gloves/thick/sangheili/ui_action_click()
	if(!connected_dagger.inhand_check())
		equip_dagger()
		playsound(usr, 'code/modules/halo/sounds/Energysworddeploy.ogg',75, 1)
	else
		playsound(usr, 'code/modules/halo/sounds/Energysworddeactivate.ogg', 50, 1)
		unequip_dagger()


//Physical dagger object define - this is essentially the dagger but without activate states - can only be 'on'. Had to do it this way due to the inherits from /energy and /elite_sword causing issues//

/obj/item/weapon/melee/energy/elite_sword/g_dagger
	name = "Internal Energy Dagger"
	desc = "A wrist-mounted energy dagger that extends from Sangheili combat gauntlets."

	icon = 'code/modules/halo/weapons/icons/Covenant Weapons.dmi'
	icon_state = "en_dag_deploy"
	w_class = ITEM_SIZE_NORMAL
	force = 30
	throwforce = 12
	edge = 1
	sharp = 1
	var/obj/item/clothing/gloves/thick/sangheili/creator_dagger
	armor_penetration = 50
	canremove = 0

	melee_strikes = list(/datum/melee_strike/precise_strike/fast_attacks,/datum/melee_strike/swipe_strike/harrying_strike)

	item_icons = list(slot_l_hand_str ='code/modules/halo/icons/energy_dagger_inhand.dmi',slot_r_hand_str = 'code/modules/halo/icons/energy_dagger_inhand.dmi')
	item_state_slots = list(
	slot_l_hand_str = "en_dag_l_hand",
	slot_r_hand_str = "en_dag_r_hand" )
	hitsound = 'code/modules/halo/sounds/Energyswordhit.ogg'

/obj/item/weapon/melee/energy/elite_sword/g_dagger/can_execute(mob/living/carbon/human/user, mob/living/carbon/human/victim)
	active = 1
	. = ..()
	active = initial(active)

/obj/item/weapon/melee/energy/elite_sword/g_dagger/New(var/obj/created_by)
	.=..()
	creator_dagger = created_by
	verbs -= /obj/item/weapon/melee/energy/elite_sword/proc/enable_failsafe

/obj/item/weapon/melee/energy/elite_sword/g_dagger/proc/inhand_check()
	var/mob/living/carbon/human/h = creator_dagger.current_user
	if(istype(h))
		if(h.l_hand == src || h.r_hand == src)
			return 1
	return 0

/obj/item/weapon/melee/energy/elite_sword/g_dagger/get_lunge_dist(var/mob/living/carbon/human/mob)
	return 2

/obj/item/weapon/melee/energy/elite_sword/g_dagger/dropped()
	if(!inhand_check())
		creator_dagger.on_dagger_dropped()

/obj/item/weapon/melee/energy/elite_sword/g_dagger/activate(mob/living/user)
	return

/obj/item/weapon/melee/energy/elite_sword/g_dagger/deactivate(mob/living/user)
	return

//Sangheili Armour Subtype Defines//

/obj/item/clothing/head/helmet/sangheili/minor
	name = "Sangheili Helmet (Minor)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "minor_helm_obj"
	item_state = "minor_helm"

/obj/item/clothing/suit/armor/special/combatharness/minor
	name = "Sangheili Combat Harness (Minor)"
	icon_state = "minor_chest_obj"
	item_state = "minor_chest"
	totalshields = 150

/obj/item/clothing/shoes/sangheili/minor
	name = "Sanghelli Leg Armour (Minor)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "minor_legs_obj"
	item_state = "minor_legs"

/obj/item/clothing/gloves/thick/sangheili/minor
	name = "Sanghelli Combat Gauntlets (Minor)"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "minor_gloves_obj"
	item_state = "minor_gloves"

/obj/item/clothing/head/helmet/sangheili/major
	name = "Sangheili Helmet (Major)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "major_helm_obj"
	item_state = "major_helm"

/obj/item/clothing/suit/armor/special/combatharness/major
	name = "Sangheili Combat Harness (Major)"
	icon_state = "major_chest_obj"
	item_state = "major_chest"
	totalshields = 180

/obj/item/clothing/shoes/sangheili/major
	name = "Sanghelli Leg Armour (Major)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "major_legs_obj"
	item_state = "major_legs"

/obj/item/clothing/gloves/thick/sangheili/major
	name = "Sanghelli Combat Gauntlets (Major)"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "major_gloves_obj"
	item_state = "major_gloves"

/obj/item/clothing/head/helmet/sangheili/honour_guard
	name = "Sangheili Helmet (Honour Guard)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "honour_helm_obj"
	item_state = "honour_helm"
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/covenant/medic

/obj/item/clothing/suit/armor/special/combatharness/honour_guard
	name = "Sangheili Combat Harness (Honour Guard)"
	icon_state = "honour_chest_obj"
	item_state = "honour_chest"
	totalshields = 210

/obj/item/clothing/shoes/sangheili/honour_guard
	name = "Sanghelli Leg Armour (Honour Guard)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "honour_legs_obj"
	item_state = "honour_legs"

/obj/item/clothing/gloves/thick/sangheili/honour_guard
	name = "Sanghelli Combat Gauntlets (Honour Guard)"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "honour_gloves_obj"
	item_state = "honour_gloves"

/obj/item/clothing/head/helmet/sangheili/ultra
	name = "Sangheili Helmet (Ultra)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "ultra_helm_obj"
	item_state = "ultra_helm"
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/covenant/medic

/obj/item/clothing/suit/armor/special/combatharness/ultra
	name = "Sangheili Combat Harness (Ultra)"
	icon_state = "ultra_chest_obj"
	item_state = "ultra_chest"
	totalshields = 240

/obj/item/clothing/shoes/sangheili/ultra
	name = "Sanghelli Leg Armour (Ultra)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "ultra_legs_obj"
	item_state = "ultra_legs"

/obj/item/clothing/gloves/thick/sangheili/ultra
	name = "Sanghelli Combat Gauntlets (Ultra)"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "ultra_gloves_obj"
	item_state = "ultra_gloves"

/obj/item/clothing/head/helmet/sangheili/zealot
	name = "Sangheili Helmet (Zealot)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "zealot_helm_obj"
	item_state = "zealot_helm"
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/covenant/medic

/obj/item/clothing/suit/armor/special/combatharness/zealot
	name = "Sangheili Combat Harness (Zealot)"
	icon_state = "zealot_chest_obj"
	item_state = "zealot_chest"
	totalshields = 270

/obj/item/clothing/shoes/sangheili/zealot
	name = "Sanghelli Leg Armour (Zealot)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "zealot_legs_obj"
	item_state = "zealot_legs"

/obj/item/clothing/gloves/thick/sangheili/zealot
	name = "Sanghelli Combat Gauntlets (Zealot)"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "zealot_gloves_obj"
	item_state = "zealot_gloves"
/////
/obj/item/clothing/head/helmet/sangheili/shipmaster
	name = "Sangheili Helmet (Shipmaster)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "regal_helm_obj"
	item_state = "regal_helm"
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/covenant/medic

/obj/item/clothing/suit/armor/special/combatharness/shipmaster
	name = "Sangheili Combat Harness (Shipmaster)"
	icon_state = "regal_chest_obj"
	item_state = "regal_chest"
	totalshields = 270

/obj/item/clothing/shoes/sangheili/shipmaster
	name = "Sanghelli Leg Armour (Shipmaster)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "zealot_legs_obj"
	item_state = "zealot_legs"

/obj/item/clothing/gloves/thick/sangheili/shipmaster
	name = "Sanghelli Combat Gauntlets (Shipmaster)"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "zealot_gloves_obj"
	item_state = "zealot_gloves"

/obj/item/clothing/head/helmet/sangheili/specops
	name = "Sangheili Helmet (Spec-Ops)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "specops_helm_obj"
	item_state = "specops_helm"

/obj/item/clothing/suit/armor/special/combatharness/specops
	name = "Sangheili Combat Harness (Spec-Ops)"
	icon_state = "specops_chest_obj"
	item_state = "specops_chest"
	totalshields = 50
	armor_thickness = 15
	specials = list(/datum/armourspecials/shields/elite,/datum/armourspecials/shieldmonitor/sangheili,/datum/armourspecials/cloaking/cov_specops)
	action_button_name = "Toggle Active Camouflage"

/obj/item/clothing/suit/armor/special/combatharness/specops/infiltrator
	specials = list(/datum/armourspecials/shields/elite,/datum/armourspecials/shieldmonitor/sangheili,/datum/armourspecials/cloaking/cov_specops,/datum/armourspecials/gear/sangheili_infiltrator)

/obj/item/clothing/shoes/sangheili/specops
	name = "Sanghelli Leg Armour (Spec-Ops)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "specops_legs_obj"
	item_state = "specops_legs"
	stepsound = 'code/modules/halo/sounds/walk_sounds/generic_walk.ogg'

/obj/item/clothing/gloves/thick/sangheili/specops
	name = "Sanghelli Combat Gauntlets (Spec-Ops)"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "specops_gloves_obj"
	item_state = "specops_gloves"

/obj/item/clothing/gloves/thick/sangheili/specops/infiltrator/New()
	. = ..()
	pocket_curr = new/obj/item/weapon/storage/internal/pockets(src,1,ITEM_SIZE_SMALL,null,list(/obj/item/device/ewar_spoofer))
	pocket_curr.name = "EWAR Storage"
	pocket_curr.handle_item_insertion(new /obj/item/device/ewar_spoofer/covenant(loc))

/obj/item/clothing/head/helmet/sangheili/silentshadow
	name = "Sangheili Helmet (Silent Shadow)"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "ss_helm_obj"
	item_state = "ss_helm"
	body_parts_covered = HEAD | FACE
	item_flags = THICKMATERIAL | FLASH_PROTECTION_MAJOR
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/special/combatharness/silentshadow
	name = "Sangheili Combat Harness (Silent Shadow)"
	icon_state = "ss_chest_obj"
	item_state = "ss_chest"
	slowdown_general = -1 //They're meant to be primarily melee-only and admemespawn anyway, so.
	totalshields = 210
	specials = list(/datum/armourspecials/shields/elite,/datum/armourspecials/shieldmonitor/sangheili,/datum/armourspecials/cloaking/silentshadow)
	action_button_name = "Toggle Active Camouflage"
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/magboots/sangheili/silentshadow
	name = "Sanghelli Leg Armour (Silent Shadow)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "ss_legs_obj"
	item_state = "ss_legs"
	stepsound = 'code/modules/halo/sounds/walk_sounds/generic_walk.ogg'

/obj/item/clothing/gloves/thick/sangheili/silentshadow
	name = "Sanghelli Combat Gauntlets (Silent Shadow)"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "ss_gloves_obj"
	item_state = "ss_gloves"
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	body_parts_covered = HANDS
	cold_protection = HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

///// RANGER EVA /////

/obj/item/clothing/head/helmet/sangheili/ranger
	name = "\improper Sangheili Ranger Helmet"
	desc = "A heavy Ranger helmet, designed for extended operations in EVA. Its airtight fittings provide the user with immunity to biological contaminants and resistance to radiological hazards."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "ranger_helm_obj"
	item_state = "ranger_helm"
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	body_parts_covered = HEAD | FACE
	item_flags = THICKMATERIAL | FLASH_PROTECTION_MAJOR | STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 60, bullet = 40, laser = 30,energy = 30, bomb = 25, bio = 100, rad = 30)
	armor_thickness = 20
	armor_thickness_max = 20

/obj/item/clothing/head/helmet/sangheili/ranger/New()
	..()
	slowdown_per_slot[slot_head] += 0.01 // Movement speed malus due to the armor's weight.

/obj/item/clothing/suit/armor/special/combatharness/eva/ranger
	name = "\improper Sangheili Ranger Combat Harness (Minor)"
	desc = "A heavy suit of reinforced spaceproof Ranger armor, designed for extended operations in EVA. Its airtight fittings provide the user with immunity to biological contaminants and resistance to radiological hazards. Features a built-in manouvering system for basic movement in zero-gravity, but lacks the stabilization technology of dedicated jetpacks."
	icon_state = "ranger_chest_obj"
	item_state = "ranger_chest"
	totalshields = 150
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 100, rad = 30)
	armor_thickness = 20
	armor_thickness_max = 20

	allowed = list(/obj/item/weapon/tank)

	specials = list(/datum/armourspecials/integrated_jetpack)

/obj/item/clothing/suit/armor/special/combatharness/eva/ranger/New()
	..()
	slowdown_per_slot[slot_wear_suit] += 0.02 // Movement speed malus due to the armor's weight.

/obj/item/clothing/shoes/magboots/sangheili
	name = "Sanghelli Ranger Greaves"
	desc = "A heavy pair of Ranger magboots, designed for extended operations in EVA. Its airtight fittings provide the user with immunity to biological contaminants and resistance to radiological hazards."
	icon = SANGHEILI_ARMOUR_ICON
	icon_state = "ranger_legs_obj"
	item_state = "ranger_legs"
	icon_base = null
	sprite_sheets = list("Sangheili" = SANGHEILI_ARMOUR_ICON)
	species_restricted = list("Sangheili")
	body_parts_covered = LEGS|FEET
	cold_protection = LEGS|FEET
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 60, bullet = 45, laser = 35, energy = 35, bomb = 30, bio = 100, rad = 30)
	armor_thickness = 20
	armor_thickness_max = 20
	overshoes = 0
	stepsound = 'code/modules/halo/sounds/walk_sounds/spartan_boots.ogg'

/obj/item/clothing/shoes/magboots/sangheili/New()
	..()
	slowdown_per_slot[slot_gloves] += 0.01 // Movement speed malus due to the armor's weight.

/obj/item/clothing/gloves/thick/sangheili/ranger
	name = "Sanghelli Ranger Gauntlets"
	desc = "A heavy pair of Ranger gauntlets, designed for extended operations in EVA. Its airtight fittings provide the user with immunity to biological contaminants and resistance to radiological hazards. Comes equipped with a built-in energy dagger."
	icon_state = "ranger_gloves_obj"
	item_state = "ranger_gloves"
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	body_parts_covered = HANDS
	cold_protection = HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 30, bio = 100, rad = 30)
	armor_thickness = 20
	armor_thickness_max = 20

/obj/item/clothing/gloves/thick/sangheili/ranger/New()
	..()
	slowdown_per_slot[slot_shoes] += 0.01 // Movement speed malus due to the armor's weight.

/// RANGER ARMOR RANK SUBTYPES ///

/obj/item/clothing/suit/armor/special/combatharness/eva/ranger/major
	name = "\improper Sangheili Ranger Combat Harness (Major)"
	totalshields = 180
	item_state = "ranger_chest_major"

/obj/item/clothing/suit/armor/special/combatharness/eva/ranger/ultra
	name = "\improper Sangheili Ranger Combat Harness (Ultra)"
	totalshields = 240
	item_state = "ranger_chest_ultra"

/// REACH CEREMONIAL ///

/obj/item/clothing/under/covenant/sangheili/reach
	name = "\improper Ceremonial Sangheili Body-suit"
	desc = "A sealed, airtight bodysuit. Meant to be worn underneath combat harnesses. Oooooh you're wearing a turtle neck!!"
	icon_state = "r_sangheili_suit"

/obj/item/clothing/head/helmet/sangheili/specops/reach
	name = "Ceremonial Sangheili Helmet (Spec-Ops)"
	icon_state = "r_specops_helm_obj"
	item_state = "r_specops_helm"

/obj/item/clothing/suit/armor/special/combatharness/specops/reach
	name = "Ceremonial Sangheili Combat Harness (Spec-Ops)"
	icon_state = "r_specops_chest_obj"
	item_state = "r_specops_chest"

/obj/item/clothing/gloves/thick/sangheili/specops/infiltrator/reach
	name = "Ceremonial Sanghelli Combat Gauntlets (Spec-Ops)"
	icon_state = "r_specops_gloves_obj"
	item_state = "r_specops_gloves"

/obj/item/clothing/shoes/sangheili/specops/reach
	name = "Ceremonial Sanghelli Leg Armour (Spec-Ops)"
	icon_state = "r_specops_legs_obj"
	item_state = "r_specops_legs"
	stepsound = 'code/modules/halo/sounds/walk_sounds/generic_walk.ogg'

/obj/item/clothing/head/helmet/sangheili/ultra/reach
	name = "Ceremonial Sangheili Helmet (Ultra)"
	icon_state = "r_ultra_helm_obj"
	item_state = "r_ultra_helm"

/obj/item/clothing/suit/armor/special/combatharness/ultra/reach
	name = "Ceremonial Sangheili Combat Harness (Ultra)"
	icon_state = "r_ultra_chest_obj"
	item_state = "r_ultra_chest"

/obj/item/clothing/gloves/thick/sangheili/ultra/reach
	name = "Ceremonial Sanghelli Combat Gauntlets (Ultra)"
	icon_state = "r_ultra_gloves_obj"
	item_state = "r_ultra_gloves"

/obj/item/clothing/shoes/sangheili/ultra/reach
	name = "Ceremonial Sanghelli Leg Armour (Ultra)"
	icon_state = "r_ultra_legs_obj"
	item_state = "r_ultra_legs"

/obj/item/clothing/head/helmet/sangheili/major/reach
	name = "Ceremonial Sangheili Helmet (Officer)"
	icon_state = "r_major_helm_obj"
	item_state = "r_major_helm"

/obj/item/clothing/suit/armor/special/combatharness/major/reach
	name = "Ceremonial Sangheili Combat Harness (Officer)"
	icon_state = "r_major_chest_obj"
	item_state = "r_major_chest"

/obj/item/clothing/shoes/sangheili/major/reach
	name = "Ceremonial Sanghelli Leg Armour (Officer)"
	icon_state = "r_major_legs_obj"
	item_state = "r_major_legs"

/obj/item/clothing/gloves/thick/sangheili/major/reach
	name = "Ceremonial Sanghelli Combat Gauntlets (Officer)"
	icon_state = "r_major_gloves_obj"
	item_state = "r_major_gloves"

/obj/item/clothing/head/helmet/sangheili/zealot/reach
	name = "Ceremonial Sangheili Helmet (Zealot)"
	icon_state = "r_zealot_helm_obj"
	item_state = "r_zealot_helm"

/obj/item/clothing/suit/armor/special/combatharness/zealot/reach
	name = "Ceremonial Sangheili Combat Harness (Zealot)"
	icon_state = "r_zealot_chest_obj"
	item_state = "r_zealot_chest"

/obj/item/clothing/gloves/thick/sangheili/zealot/reach
	name = "Ceremonial Sanghelli Combat Gauntlets (Zealot)"
	icon_state = "r_zealot_gloves_obj"
	item_state = "r_zealot_gloves"

/obj/item/clothing/shoes/sangheili/zealot/reach
	name = "Ceremonial Sanghelli Leg Armour (Zealot)"
	icon_state = "r_zealot_legs_obj"
	item_state = "r_zealot_legs"

/obj/item/clothing/head/helmet/sangheili/zealot/fieldmarshal
	name = "Ceremonial Sangheili Helmet (Field Marshal)"
	icon_state = "r_fmarshal_helm_obj"
	item_state = "r_fmarshal_helm"

/obj/item/clothing/suit/armor/special/combatharness/zealot/fieldmarshal
	name = "Ceremonial Sangheili Combat Harness (Field Marshal)"
	icon_state = "r_fmarshal_chest_obj"
	item_state = "r_fmarshal_chest"

/obj/item/clothing/gloves/thick/sangheili/zealot/fieldmarshal
	name = "Ceremonial Sanghelli Combat Gauntlets (Field Marshal)"
	icon_state = "r_fmarshal_gloves_obj"
	item_state = "r_fmarshal_gloves"

/obj/item/clothing/shoes/sangheili/zealot/fieldmarshal
	name = "Ceremonial Sanghelli Leg Armour (Field Marshal)"
	icon_state = "r_fmarshal_legs_obj"
	item_state = "r_fmarshal_legs"

#undef SANGHEILI_ARMOUR_ICON
