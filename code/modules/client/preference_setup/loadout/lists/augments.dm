/datum/gear/augment
	sort_category = "Augments"
	category = /datum/gear/augment

/datum/gear/augment/minor_head
	display_name = "minor augments selection (head, passive)"
	description = "A minor augment with no in-game effects."
	cost = 1
	path = /obj/item/organ/internal/augment/fluff/head
	flags = GEAR_HAS_SUBTYPE_SELECTION

/datum/gear/augment/minor_chest
	display_name = "minor augments selection (chest)"
	description = "A minor augment with no in-game effects."
	cost = 1
	path = /obj/item/organ/internal/augment/fluff/chest
	flags = GEAR_HAS_SUBTYPE_SELECTION

/datum/gear/augment/corrective_lenses
	display_name = "corrective lenses (head, active)"
	cost = 2
	path = /obj/item/organ/internal/augment/active/simple/equip/corrective_lenses

/datum/gear/augment/leukocyte_breeder
	display_name = "leukocyte breeder (chest)"
	cost = 4
	path = /obj/item/organ/internal/augment/active/leukocyte_breeder

/datum/gear/augment/glare_dampeners
	display_name = "glare dampeners (head, active)"
	cost = 3
	path = /obj/item/organ/internal/augment/active/simple/equip/glare_dampeners

/datum/gear/augment/integrated_health_hud
	display_name = "integrated health HUD (head, active)"
	cost = 4
	path = /obj/item/organ/internal/augment/active/hud/health
	species_blacklist = list(SPECIES_ADHERENT) // Requested by Gentlefood, current Adherent maintainer.

/datum/gear/augment/integrated_security_hud
	display_name = "integrated security HUD (head, active)"
	cost = 5
	path = /obj/item/organ/internal/augment/active/hud/security

/datum/gear/augment/integrated_janitor_hud
	display_name = "integrated filth HUD (head, active)"
	cost = 4
	path = /obj/item/organ/internal/augment/active/hud/janitor

/datum/gear/augment/integrated_science_hud
	display_name = "integrated sciHUD (head, active)"
	cost = 4
	path = /obj/item/organ/internal/augment/active/hud/science
