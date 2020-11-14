/datum/robolimb
	var/includes_tail			//Cyberlimbs dmi includes a tail sprite to wear.
	//var/includes_wing			//Cyberlimbs dmi includes a wing sprite to wear.
	//var/list/whitelisted_to	//List of ckeys that are allowed to pick this in charsetup.

//////////////// General VS-only ones /////////////////
/datum/robolimb/talon //They're buildable by default due to being extremely basic.
	company = "Talon LLC"
	desc = "This metallic limb is sleek and featuresless apart from some exposed motors"
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/talon/talon_main.dmi' //Sprited by: Viveret
/*
/obj/item/weapon/disk/limb/talon
	company = "Talon LLC"
*/
/datum/robolimb/zenghu_taj
	company = "Zeng-Hu - Tajaran"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/zenghu/zenghu_taj.dmi'
	unavailable_at_fab = 1
	skintone = 1
	applies_to_part = list(BP_HEAD)

/datum/robolimb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	desc = "A slightly more refined limb variant from Eggnerd Prototyping. Its got red plating instead of orange."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/rahboopred/rahboopred.dmi'
	//blood_color = "#5e280d"
	includes_tail = 1
	unavailable_at_fab = 1
/*
/obj/item/weapon/disk/limb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "verkdisk"
*/

//Darkside Incorperated synthetic augmentation list! Many current most used fuzzy and notsofuzzy races made into synths here.

/datum/robolimb/dsi_tajaran
	company = "DSI - Tajaran"
	desc = "This limb feels soft and fluffy, realistic design and squish. By Darkside Incorperated."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/DSITajaran/dsi_tajaran.dmi'
	//blood_color = "#ffe2ff"
	//lifelike = 1
	unavailable_at_fab = 1
	includes_tail = 1
	skintone = 1
	//suggested_species = "Tajara"
/*
/obj/item/weapon/disk/limb/dsi_tajaran
	company = "DSI - Tajaran"
*/
/datum/robolimb/dsi_lizard
	company = "DSI - Lizard"
	desc = "This limb feels smooth and scalie, realistic design and squish. By Darkside Incorperated."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/DSILizard/dsi_lizard.dmi'
	//blood_color = "#ffe2ff"
	//lifelike = 1
	unavailable_at_fab = 1
	includes_tail = 1
	skintone = 1
	//suggested_species = "Unathi"
/*
/obj/item/weapon/disk/limb/dsi_lizard
	company = "DSI - Lizard"

/datum/robolimb/dsi_sergal
	company = "DSI - Sergal"
	desc = "This limb feels soft and fluffy, realistic design and toned muscle. By Darkside Incorperated."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/DSISergal/dsi_sergal.dmi'
	//blood_color = "#ffe2ff"
	//lifelike = 1
	unavailable_at_fab = 1
	includes_tail = 1
	skintone = 1
	//suggested_species = "Sergal"

/obj/item/weapon/disk/limb/dsi_sergal
	company = "DSI - Sergal"

/datum/robolimb/dsi_nevrean
	company = "DSI - Nevrean"
	desc = "This limb feels soft and feathery, lightweight, realistic design and squish. By Darkside Incorperated."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/DSINevrean/dsi_nevrean.dmi'
	//blood_color = "#ffe2ff"
	//lifelike = 1
	unavailable_at_fab = 1
	includes_tail = 1
	skintone = 1
	//suggested_species = "Nevrean"

/obj/item/weapon/disk/limb/dsi_nevrean
	company = "DSI - Nevrean"
*/
/datum/robolimb/dsi_vulpkanin
	company = "DSI - Vulpkanin"
	desc = "This limb feels soft and fluffy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/DSIVulpkanin/dsi_vulpkanin.dmi'
	//blood_color = "#ffe2ff"
	//lifelike = 1
	unavailable_at_fab = 1
	includes_tail = 1
	skintone = 1
	//suggested_species = "Vulpkanin"
/*
/obj/item/weapon/disk/limb/dsi_vulpkanin
	company = "DSI - Vulpkanin"
*/
/datum/robolimb/dsi_akula
	company = "DSI - Akula"
	desc = "This limb feels soft and fleshy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/DSIAkula/dsi_akula.dmi'
	//blood_color = "#ffe2ff"
	//lifelike = 1
	unavailable_at_fab = 1
	includes_tail = 1
	skintone = 1
	//suggested_species = "Akula"
/*
/obj/item/weapon/disk/limb/dsi_akula
	company = "DSI - Akula"
*/
/datum/robolimb/dsi_spider
	company = "DSI - Vasilissan"
	desc = "This limb feels hard and chitinous, realistic design. Seems a little mischievous. By Darkside Incorperated."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/DSISpider/dsi_spider.dmi'
	//blood_color = "#ffe2ff"
	//lifelike = 1
	unavailable_at_fab = 1
	includes_tail = 1
	skintone = 1
	//suggested_species = "Vasilissan"
/*
/obj/item/weapon/disk/limb/dsi_spider
	company = "DSI - Vasilissan"

/datum/robolimb/dsi_teshari
	company = "DSI - Teshari"
	desc = "This limb has a thin synthflesh casing with a few connection ports."
	icon = 'modular_mithra/icons/mob/human_races/cyberlimbs/DSITeshari/dsi_teshari.dmi'
	//lifelike = 1
	skintone = 1
	//suggested_species = "Teshari"

/datum/robolimb/dsi_teshari/New()
	species_cannot_use = all_species.Copy()
	species_cannot_use -= SPECIES_TESHARI
	..()

/obj/item/weapon/disk/limb/dsi_teshari
	company = "DSI - Teshari"
*/