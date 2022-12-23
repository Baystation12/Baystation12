//Resomi scarf
/obj/item/clothing/accessory/scarf/resomi
	name = "small mantle"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_accessories_resomi.dmi'
	icon_state = "small_mantle"
	species_restricted = list(SPECIES_RESOMI)

/*
/obj/item/clothing/mask/gas/explorer_resomi
	name = "exploratory mask"
	desc = "It looks like a tracker's mask. Too small for tall humanoids."
	icon = CUSTOM_ITEM_OBJ
	item_icons = list(slot_wear_mask_str = CUSTOM_ITEM_MOB)
	icon_state = "explorer_mask"
	item_state = "explorer_mask"
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(SPECIES_RESOMI = CUSTOM_ITEM_MOB)
*/

/obj/item/clothing/shoes/workboots/resomi
	icon_state = "resomi_workboots"
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_feet_resomi.dmi'
	item_state = "workboots"
	name = "small workboots"
	desc = "Small and tight shoes with an iron sole for those who work in dangerous area or hate their paws"

	w_class = ITEM_SIZE_SMALL
	species_restricted = list(SPECIES_RESOMI)

/obj/item/clothing/shoes/workboots/resomi/New()
	..()
	slowdown_per_slot[slot_shoes] = 0.3


/obj/item/clothing/shoes/footwraps
	name = "cloth footwraps"
	desc = "A roll of treated canvas used for wrapping paws"
	icon_state = "clothwrap"
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_feet_resomi.dmi'
	item_state = "clothwrap"
	force = 0
	item_flags = ITEM_FLAG_SILENT
	w_class = ITEM_SIZE_SMALL
	species_restricted = list(SPECIES_RESOMI)

/obj/item/clothing/shoes/footwraps/socks_resomi
	name = "koishi"
	desc = "Looks like socks but with toe holes and thick sole."
	icon_state = "socks"
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_feet_resomi.dmi'
	item_state = "socks"


/obj/item/clothing/under/thermal
	name = "thermal suit"
	desc = "Gray thermal suit. Nothing interesting."
	icon = 'packs/infinity/icons/obj/clothing/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'packs/infinity/icons/mob/onmob/onmob_under.dmi')
	icon_state = "gray_camo"
	item_state = "gray_camo"
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = T0C - 75
	max_heat_protection_temperature = T0C + 50
	var/max_cooling = 1.2					// in degrees per second - probably don't need to mess with heat capacity here
	var/thermostat = T0C + 10


/obj/item/clothing/under/thermal/resomi
	name = "small thermal suit"
	desc = "Looks like very small suit. For children or resomi? This thermal suit is black."
	icon_state = "thermores_1"
	item_state = "thermores_1"
	thermostat = T0C
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_RESOMI = 'packs/infinity/icons/mob/onmob/onmob_under.dmi',
		)

/obj/item/clothing/under/thermal/resomi/white
	desc = "Looks like very small suit. For children or resomi? This thermal suit is white. "
	icon_state = "thermores_2"
	item_state = "thermores_2"


/datum/sprite_accessory/hair/resomi
	name = "Resomi Plumage"
	icon_state = "resomi_default"
	icon = 'packs/infinity/icons/mob/human_races/species/resomi/hair.dmi'
	species_allowed = list(SPECIES_RESOMI)

/datum/sprite_accessory/hair/resomi/ears
	name = "Resomi Ears"
	icon_state = "resomi_ears"

/datum/sprite_accessory/hair/resomi/excited
	name = "Resomi Spiky"
	icon_state = "resomi_spiky"

/datum/sprite_accessory/hair/resomi/hedgehog
	name = "Resomi Hedgehog"
	icon_state = "resomi_hedge"

/datum/sprite_accessory/hair/resomi/long
	name = "Resomi Unpruned"
	icon_state = "resomi_long"

/datum/sprite_accessory/hair/resomi/sunburst
	name = "Resomi Sunburst"
	icon_state = "resomi_burst_short"

/datum/sprite_accessory/hair/resomi/mohawk
	name = "Resomi Mohawk"
	icon_state = "resomi_mohawk"

/datum/sprite_accessory/hair/resomi/pointy
	name = "Resomi Pointy"
	icon_state = "resomi_pointy"

/datum/sprite_accessory/hair/resomi/upright
	name = "Resomi Upright"
	icon_state = "resomi_upright"

/datum/sprite_accessory/hair/resomi/mane
	name = "Resomi Mane"
	icon_state = "resomi_mane"

/datum/sprite_accessory/hair/resomi/mane_beardless
	name = "Resomi Large Ears"
	icon_state = "resomi_mane_beardless"

/datum/sprite_accessory/hair/resomi/droopy
	name = "Resomi Droopy"
	icon_state = "resomi_droopy"

/datum/sprite_accessory/hair/resomi/mushroom
	name = "Resomi Mushroom"
	icon_state = "resomi_mushroom"

/datum/sprite_accessory/hair/resomi/twies
	name = "Resomi Twies"
	icon_state = "resomi_twies"

/datum/sprite_accessory/hair/resomi/backstrafe
	name = "Resomi Backstrafe"
	icon_state = "resomi_backstrafe"

/datum/sprite_accessory/hair/resomi/longway
	name = "Resomi Long way"
	icon_state = "resomi_longway"

/datum/sprite_accessory/hair/resomi/notree
	name = "Resomi Tree"
	icon_state = "resomi_notree"

/datum/sprite_accessory/hair/resomi/fluffymohawk
	name = "Resomi Fluffy Mohawk"
	icon_state = "resomi_fluffymohawk"

// MARKINGS

/datum/sprite_accessory/marking/resomi
	icon = 'packs/infinity/icons/mob/human_races/species/resomi/markings.dmi'
	species_allowed = list(SPECIES_RESOMI)
	do_coloration = TRUE

/datum/sprite_accessory/marking/resomi/resomi_fluff
	name = "Resomi underfluff"
	icon_state = "resomi_fluff"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_GROIN,BP_CHEST,BP_HEAD)

/datum/sprite_accessory/marking/resomi/resomi_small_feathers
	name = "Resomi small wingfeathers"
	icon_state = "resomi_sf"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND,BP_CHEST)


/*
 * RESOMI SOL GOV UNDER
 */

/obj/item/clothing/under/solgov/pt/expeditionary/resomi
	name = "small expeditionary pt smock"
	desc = "It looks fitted to nonhuman proportions."
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_under_resomi.dmi'
	item_icons = list('packs/infinity/icons/mob/species/resomi/onmob_under_resomi.dmi')
	icon_state = "resomi_expeditionpt"
	worn_state = "resomi_expeditionpt"
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(SPECIES_RESOMI = 'packs/infinity/icons/mob/species/resomi/onmob_under_resomi.dmi')

/obj/item/clothing/under/solgov/utility/expeditionary/resomi
	name = "small expeditionary uniform"
	desc = "It looks fitted to nonhuman proportions."
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_under_resomi.dmi'
	item_icons = list('packs/infinity/icons/mob/species/resomi/onmob_under_resomi.dmi')
	icon_state = "resomi_blackutility"
	worn_state = "resomi_blackutility"
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(SPECIES_RESOMI = 'packs/infinity/icons/mob/species/resomi/onmob_under_resomi.dmi')

/obj/item/clothing/under/solgov/utility/expeditionary/officer/resomi
	name = "small expeditionary officer's uniform"
	desc = "It looks fitted to nonhuman proportions."
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_under_resomi.dmi'
	item_icons = list('packs/infinity/icons/mob/species/resomi/onmob_under_resomi.dmi')
	icon_state = "resomi_blackutility_com"
	worn_state = "resomi_blackutility_com"
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(SPECIES_RESOMI = 'packs/infinity/icons/mob/species/resomi/onmob_under_resomi.dmi')
	accessories = list(/obj/item/clothing/accessory/solgov/department/command)

/obj/item/clothing/under/solgov/mildress/expeditionary/resomi
	name = "small expeditionary dress uniform"
	desc = "It looks fitted to nonhuman proportions."
	icon = 'packs/infinity/icons/obj/clothing/species/resomi/obj_under_resomi.dmi'
	item_icons = list('packs/infinity/icons/mob/species/resomi/onmob_under_resomi.dmi')
	icon_state = "resomi_greydress"
	worn_state = "resomi_greydress"
	species_restricted = list(SPECIES_RESOMI)
	sprite_sheets = list(SPECIES_RESOMI = 'packs/infinity/icons/mob/species/resomi/onmob_under_resomi.dmi')


/datum/gear/uniform/resomi
	display_name = "(Resomi) smock, grey"
	path = /obj/item/clothing/under/resomi
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/uniform/resomi/New()
	..()
	var/uniform = list()
	uniform["rainbow smock"] 	 =  /obj/item/clothing/under/resomi/rainbow
	uniform["engineering smock"] =	/obj/item/clothing/under/resomi/yellow
	uniform["robotics smock"] 	 = 	/obj/item/clothing/under/resomi/robotics
	uniform["security smock"] 	 = 	/obj/item/clothing/under/resomi/red
	gear_tweaks += new/datum/gear_tweak/path(uniform)

/datum/gear/uniform/resomi/white
	display_name = "(Resomi) smock, colored"
	path = /obj/item/clothing/under/resomi/white
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/resomi/dress
	display_name = "(Resomi) dresses selection"
	path = /obj/item/clothing/under/resomi/dress
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/resomi/utility
	display_name = "(Resomi) uniform selection"
	path = /obj/item/clothing/under/resomi/utility
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/resomi/sport
	display_name = "(Resomi) uniform, Sport"
	path = /obj/item/clothing/under/resomi/sport

/datum/gear/uniform/resomi/med
	display_name = "(Resomi) uniform, Medical"
	path = /obj/item/clothing/under/resomi/medical

/datum/gear/uniform/resomi/science
	display_name = "(Resomi) uniform, Science"
	path = /obj/item/clothing/under/resomi/science

/datum/gear/uniform/resomi/dark_worksmock
	display_name = "(Resomi) work uniform, dark"
	path = /obj/item/clothing/under/resomi/work_black
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/resomi/light_worksmock
	display_name = "(Resomi) work uniform, light"
	path = /obj/item/clothing/under/resomi/work_white
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/eyes/resomi
	display_name = "(Resomi) sun lenses"
	path = /obj/item/clothing/glasses/sunglasses/lenses
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/eyes/resomi/lenses_sec
	display_name = "(Resomi) sun sechud lenses"
	path = /obj/item/clothing/glasses/sunglasses/sechud/lenses

/datum/gear/eyes/resomi/lenses_med
	display_name = "(Resomi) sun medhud lenses"
	path = /obj/item/clothing/glasses/hud/health/lenses

/datum/gear/accessory/resomi_mantle
	display_name = "(Resomi) small mantle"
	path = /obj/item/clothing/accessory/scarf/resomi
	flags = GEAR_HAS_COLOR_SELECTION
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/suit/resomi_cloak
	display_name = "(Resomi) small cloak"
	path = /obj/item/clothing/suit/storage/toggle/Resomicoat
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/suit/resomi_cloak/New()
	..()
	var/resomi = list()
	resomi["black cloak"] = /obj/item/clothing/suit/storage/toggle/Resomicoat
	resomi["white cloak"] = /obj/item/clothing/suit/storage/toggle/Resomicoat/white
	gear_tweaks += new/datum/gear_tweak/path(resomi)

/datum/gear/shoes/resomi
	display_name = "(Resomi) small workboots"
	path = /obj/item/clothing/shoes/workboots/resomi
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/datum/gear/shoes/resomi/footwraps
	display_name = "(Resomi) foots clothwraps"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/shoes/footwraps

/datum/gear/shoes/resomi/socks
	display_name = "(Resomi) koishi"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/shoes/footwraps/socks_resomi

/datum/gear/suit/resomicloak
	display_name = "(Resomi) standard/job cloaks"
	sort_category = "Xenowear"
	path = /obj/item/clothing/suit/storage/resomicloak
	whitelisted = list(SPECIES_RESOMI)
	flags = GEAR_HAS_SUBTYPE_SELECTION

/datum/gear/suit/resomicloak_alt
	display_name = "(Resomi) alt cloaks"
	sort_category = "Xenowear"
	path = /obj/item/clothing/suit/storage/resomicloak_alt
	whitelisted = list(SPECIES_RESOMI)
	flags = GEAR_HAS_SUBTYPE_SELECTION

/datum/gear/suit/resomicloak_belted
	display_name = "(Resomi) belted cloaks"
	sort_category = "Xenowear"
	path = /obj/item/clothing/suit/storage/resomicloak_belted
	whitelisted = list(SPECIES_RESOMI)
	flags = GEAR_HAS_SUBTYPE_SELECTION

/datum/gear/suit/hooded/resomicloak
	display_name = "(Resomi) Hooded Cloak"
	sort_category = "Xenowear"
	path = /obj/item/clothing/suit/storage/hooded/resomi
	whitelisted = list(SPECIES_RESOMI)
	flags = GEAR_HAS_SUBTYPE_SELECTION


/datum/gear/suit/resomi_labcoat
	display_name = "(Resomi) small labcoat"
	path = /obj/item/clothing/suit/storage/toggle/Resomilabcoat
	flags = GEAR_HAS_COLOR_SELECTION
	sort_category = "Xenowear"
	whitelisted = list(SPECIES_RESOMI)

/obj/item/toy/plushie/resomi
	name = "resomi plush"
	desc = "This is a plush resomi. Very soft, with a pompom on the tail. The toy is made well, as if alive. Looks like she is sleeping. Shhh!"
	icon = 'packs/infinity/icons/obj/toy.dmi'
	icon_state = "resomiplushie"
