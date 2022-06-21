/datum/uplink_random_item
	var/uplink_item				// The uplink item
	var/keep_probability		// The probability we'll decide to keep this item if selected
	var/reselect_probability	// Probability that we'll decide to keep this item if previously selected.
								// Is done together with the keep_probability check. Being selected more than once does not affect this probability.

/datum/uplink_random_item/New(var/uplink_item, var/keep_probability = 100, var/reselect_propbability = 33)
	..()
	src.uplink_item = uplink_item
	src.keep_probability = keep_probability
	src.reselect_probability = reselect_probability

/datum/uplink_random_selection
	var/list/datum/uplink_random_item/items

/datum/uplink_random_selection/New()
	..()
	items = list()

/datum/uplink_random_selection/proc/get_random_item(var/telecrystals, obj/item/device/uplink/U, var/list/bought_items)
	var/const/attempts = 50

	for(var/i = 0; i < attempts; i++)
		var/datum/uplink_random_item/RI = pick(items)
		if(!prob(RI.keep_probability))
			continue
		var/datum/uplink_item/I = uplink.items_assoc[RI.uplink_item]
		if(I.cost(telecrystals, U) > telecrystals)
			continue
		if(bought_items && (I in bought_items) && !prob(RI.reselect_probability))
			continue
		if(U && !I.can_buy(U))
			continue
		return I
	return uplink.items_assoc[/datum/uplink_item/item/stealthy_weapons/soap]

var/list/uplink_random_selections_
/proc/get_uplink_random_selection_by_type(var/uplist_selection_type)
	if(!uplink_random_selections_)
		uplink_random_selections_ = init_subtypes(/datum/uplink_random_selection)
		for(var/datum/entry in uplink_random_selections_)
			uplink_random_selections_[entry.type] = entry
	return uplink_random_selections_[uplist_selection_type]

/datum/uplink_random_selection/default/New()
	..()

	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/silenced)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/revolver)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/heavysniper, 15, 0)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/grenades/emp, 50)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/crossbow, 33)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/energy_sword, 75)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealthy_weapons/soap, 5, 100)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealthy_weapons/concealed_cane, 50, 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealthy_weapons/sleepy)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealthy_weapons/cigarette_kit)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/id)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/spy)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/chameleon_kit)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/chameleon_projector)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/voice)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/toolbox, reselect_propbability = 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/plastique)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/encryptionkey_radio)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/encryptionkey_binary)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/emag, 100, 50)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/clerical)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/armor/space_suit, 50, 10) //proxima //was:/datum/uplink_item/item/tools/space_suit
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/thermal)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/armor/heavy_armor) //proxima //was:/datum/uplink_item/item/tools/heavy_armor
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/powersink, 10, 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/ai_module, 25, 0)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/polychromic_dye_bottle)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/implants/imp_freedom)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/implants/imp_compress)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/implants/imp_explosive)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/medical/sinpockets, reselect_propbability = 20)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/medical/surgery, reselect_propbability = 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/medical/combat, reselect_propbability = 10)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/energy_net, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/ewar_voice, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/maneuvering_jets, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/egun, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/power_sink, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/laser_canon, reselect_propbability = 5)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/suit_sensor_mobile)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/services/suit_sensor_shutdown, 75, 0)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/services/suit_sensor_garble, 75, 0)

/datum/uplink_random_selection/blacklist
	var/list/blacklist = list(
			/datum/uplink_item/item/ammo,
			/datum/uplink_item/item/badassery,
			/datum/uplink_item/item/telecrystal,
			/datum/uplink_item/item/tools/supply_beacon,
			/datum/uplink_item/item/implants/imp_uplink,
		)

/datum/uplink_random_selection/blacklist/New()
	..()
	for(var/uplink_item_type in subtypesof(/datum/uplink_item/item))
		var/datum/uplink_item/item/ui = uplink_item_type
		if(!initial(ui.name))
			continue
		if(is_path_in_list(uplink_item_type, blacklist))
			continue
		var/new_thing = new/datum/uplink_random_item(uplink_item_type)
		items += new_thing

/datum/uplink_random_selection/blacklist/get_random_item(var/telecrystals, obj/item/device/uplink/U, var/list/bought_items)
	var/const/attempts = 50
	for(var/i = 0; i < attempts; i++)
		var/datum/uplink_random_item/RI = pick(items)
		if(!prob(RI.keep_probability))
			continue
		var/datum/uplink_item/I = uplink.items_assoc[RI.uplink_item]
		if(I.cost(telecrystals, U) > telecrystals)
			continue
		if(bought_items && (I in bought_items) && !prob(RI.reselect_probability))
			continue
		return I
	return uplink.items_assoc[/datum/uplink_item/item/stealthy_weapons/soap]

#ifdef DEBUG
/proc/debug_uplink_purchage_log()
	for(var/antag_type in GLOB.all_antag_types_)
		var/datum/antagonist/A = GLOB.all_antag_types_[antag_type]
		A.print_player_summary()

/proc/debug_uplink_item_assoc_list()
	for(var/key in uplink.items_assoc)
		log_debug("[key] - [uplink.items_assoc[key]]")

#endif
