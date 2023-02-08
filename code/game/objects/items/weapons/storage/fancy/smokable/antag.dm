/obj/item/storage/fancy/smokable/antag
	abstract_type = /obj/item/storage/fancy/smokable/antag
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette = 6
	)

	/// The skin path this antag smokables container has selected.
	var/obj/item/storage/fancy/smokable/skin


/obj/item/storage/fancy/smokable/antag/Initialize()
	. = ..()
	var/static/list/allowed_skins = (\
		subtypesof(/obj/item/storage/fancy/smokable) \
		- typesof(/obj/item/storage/fancy/smokable/antag) \
		) - list(
			/obj/item/storage/fancy/smokable/cigar
		)
	skin = pick(allowed_skins)
	name = initial(skin.name)
	desc = "[initial(skin.desc)][desc]"
	icon_state = initial(skin.icon_state)
	item_state = initial(skin.item_state)


/obj/item/storage/fancy/smokable/antag/on_update_icon()
	icon_state = "[initial(skin.icon_state)][opened ? key_type_count : ""]"


/obj/item/storage/fancy/smokable/antag/fire
	desc = " 'F' has been scribbled on it."
	initial_reagents = list(
		/datum/reagent/aluminium = 8,
		/datum/reagent/potassium = 8,
		/datum/reagent/sulfur = 8
	)


/obj/item/storage/fancy/smokable/antag/smoke
	desc = " 'S' has been scribbled on it."
	initial_reagents = list(
		/datum/reagent/potassium = 8,
		/datum/reagent/sugar = 8,
		/datum/reagent/phosphorus = 8
	)


/obj/item/storage/fancy/smokable/antag/mindbreaker
	desc = " 'MB' has been scribbled on it."
	initial_reagents = list(
		/datum/reagent/drugs/mindbreaker = 30
	)


/obj/item/storage/fancy/smokable/antag/tricordrazine
	desc = " 'T' has been scribbled on it."
	initial_reagents = list(
		/datum/reagent/tricordrazine = 30
	)
