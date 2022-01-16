/datum/gear/augment
	sort_category = "Augments"
	category = /datum/gear/augment
	cost = 1 //proxima. was: cost = 2


/datum/gear/augment/armor_minor
	display_name = "Armor Augments (Minor)"
	description = "Armor flavor augments with little or no in-game effects."
	path = /obj/item/organ/internal/augment


/datum/gear/augment/armor_minor/New()
	..()
	var/list/options = list()
	options["skeletal bracing"] = /obj/item/organ/internal/augment/skeletal_bracing
	options["ultraviolet shielding"] = /obj/item/organ/internal/augment/ultraviolet_shielding
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/augment/chest_minor
	display_name = "Chest Augments (Minor)"
	description = "Chest flavor augments with little or no in-game effects."
	path = /obj/item/organ/internal/augment


/datum/gear/augment/chest_minor/New()
	..()
	var/list/options = list()
	options["emergency battery"] = /obj/item/organ/internal/augment/emergency_battery
	options["leukocyte breeder"] = /obj/item/organ/internal/augment/active/leukocyte_breeder
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/augment/groin_minor
	display_name = "Lower Body Augments (Minor)"
	description = "Lower Body flavor augments with little or no in-game effects."
	path = /obj/item/organ/internal/augment


/datum/gear/augment/groin_minor/New()
	..()
	var/list/options = list()
	options["recycler suite"] = /obj/item/organ/internal/augment/recycler_suite
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/augment/head_minor
	display_name = "Head Augments (Minor)"
	description = "Head flavor augments with little or no in-game effects."
	path = /obj/item/organ/internal/augment


/datum/gear/augment/head_minor/New()
	..()
	var/list/options = list()
	options["circadian conditioner"] = /obj/item/organ/internal/augment/circadian_conditioner
	options["codex access chip"] = /obj/item/organ/internal/augment/codex_access
	options["data chip"] = /obj/item/organ/internal/augment/data_chip
	options["genetic backup"] = /obj/item/organ/internal/augment/genetic_backup
	options["neurostimulator implant"] = /obj/item/organ/internal/augment/neurostimulator_implant
	options["pain assistant"] = /obj/item/organ/internal/augment/pain_assistant
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/augment/head_vision
	display_name = "Head Augments (Vision)"
	description = "Head augments with vision effects."
	path = /obj/item/organ/internal/augment


/datum/gear/augment/head_vision/New()
	..()
	var/list/options = list()
	options["corrective lenses"] = /obj/item/organ/internal/augment/active/item/corrective_lenses
	options["glare dampeners"] = /obj/item/organ/internal/augment/active/item/glare_dampeners
	options["integrated health HUD"] = /obj/item/organ/internal/augment/active/hud/health
	options["integrated security HUD"] = /obj/item/organ/internal/augment/active/hud/security
	options["integrated filth HUD"] = /obj/item/organ/internal/augment/active/hud/janitor
	options["integrated sciHUD"] = /obj/item/organ/internal/augment/active/hud/science
	gear_tweaks += new /datum/gear_tweak/path (options)
