var/datum/uplink_random_selection/default_uplink_selection = new/datum/uplink_random_selection/default()

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
		if(I.cost(telecrystals) > telecrystals)
			continue
		if(bought_items && (I in bought_items) && !prob(RI.reselect_probability))
			continue
		if(U && !I.can_buy(U))
			continue
		return I

/datum/uplink_random_selection/default/New()
	..()

	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/g9mm)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/ammo/mc9mm)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/revolver)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/ammo/a357)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/heavysniper, 15, 0)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/ammo/sniperammo, 15, 0)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/emp, 50)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/crossbow, 33)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/visible_weapons/energy_sword, 75)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealthy_weapons/soap, 5, 100)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealthy_weapons/concealed_cane, 50, 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealthy_weapons/detomatix, 20, 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealthy_weapons/parapen)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealthy_weapons/cigarette_kit)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/id)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/spy)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/chameleon_kit)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/chameleon_projector)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/voice)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/stealth_items/camera_floppy, 10, 0)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/toolbox, reselect_propbability = 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/plastique)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/encryptionkey_radio)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/encryptionkey_binary)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/emag, 100, 50)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/clerical)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/space_suit, 50, 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/thermal)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/heavy_vest)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/powersink, 10, 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/ai_module, 25, 0)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/tools/teleporter, 10, 0)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/implants/imp_freedom)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/implants/imp_compress)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/implants/imp_explosive)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/medical/sinpockets, reselect_propbability = 20)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/medical/surgery, reselect_propbability = 10)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/medical/combat, reselect_propbability = 10)

	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/thermal, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/energy_net, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/ewar_voice, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/maneuvering_jets, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/egun, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/power_sink, reselect_propbability = 15)
	items += new/datum/uplink_random_item(/datum/uplink_item/item/hardsuit_modules/laser_canon, reselect_propbability = 5)

#ifdef DEBUG
/proc/debug_uplink_purchage_log()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/A = all_antag_types[antag_type]
		A.print_player_summary()

/proc/debug_uplink_item_assoc_list()
	for(var/key in uplink.items_assoc)
		world << "[key] - [uplink.items_assoc[key]]"
#endif
