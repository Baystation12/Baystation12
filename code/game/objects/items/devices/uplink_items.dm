var/datum/uplink/uplink = new()

/datum/uplink
	var/list/items_assoc
	var/list/datum/uplink_item/items
	var/list/datum/uplink_category/categories

/datum/uplink/New()
	items_assoc = list()
	items = init_subtypes(/datum/uplink_item)
	categories = init_subtypes(/datum/uplink_category)
	categories = dd_sortedObjectList(categories)

	for(var/datum/uplink_item/item in items)
		if(!item.name)
			items -= item
			continue

		items_assoc[item.type] = item

		for(var/datum/uplink_category/category in categories)
			if(item.category == category.type)
				category.items += item

	for(var/datum/uplink_category/category in categories)
		category.items = dd_sortedObjectList(category.items)

/datum/uplink_item
	var/name
	var/desc
	var/item_cost = 0
	var/datum/uplink_category/category		// Item category
	var/list/datum/antagonist/antag_roles	// Antag roles this item is displayed to. If empty, display to all.

/datum/uplink_item/item
	var/path = null

/datum/uplink_item/New()
	..()
	antag_roles = list()



/datum/uplink_item/proc/buy(var/obj/item/device/uplink/U, var/mob/user)
	var/extra_args = extra_args(user)
	if(!extra_args)
		return

	if(!can_buy(U))
		return

	var/cost = cost(U.uses)

	var/goods = get_goods(U, get_turf(user), user, extra_args)
	if(!goods)
		return

	purchase_log(U)
	U.uses -= cost
	U.used_TC += cost
	return goods

// Any additional arguments you wish to send to the get_goods
/datum/uplink_item/proc/extra_args(var/mob/user)
	return 1

/datum/uplink_item/proc/can_buy(obj/item/device/uplink/U)
	if(cost(U.uses) > U.uses)
		return 0

	return can_view(U)

/datum/uplink_item/proc/can_view(obj/item/device/uplink/U)
	// Making the assumption that if no uplink was supplied, then we don't care about antag roles
	if(!U || !antag_roles.len)
		return 1

	// With no owner, there's no need to check antag status.
	if(!U.owner)
		return 0

	for(var/antag_role in antag_roles)
		var/datum/antagonist/antag = all_antag_types[antag_role]
		if(antag.is_antagonist(U.owner))
			return 1
	return 0

/datum/uplink_item/proc/cost(var/telecrystals)
	return item_cost

/datum/uplink_item/proc/description()
	return desc

// get_goods does not necessarily return physical objects, it is simply a way to acquire the uplink item without paying
/datum/uplink_item/proc/get_goods(var/obj/item/device/uplink/U, var/loc)
	return 0

/datum/uplink_item/proc/log_icon()
	return

/datum/uplink_item/proc/purchase_log(obj/item/device/uplink/U)
	feedback_add_details("traitor_uplink_items_bought", "[src]")
	U.purchase_log[src] = U.purchase_log[src] + 1

datum/uplink_item/dd_SortValue()
	return cost(INFINITY)

/********************************
*                           	*
*	Physical Uplink Entries		*
*                           	*
********************************/
/datum/uplink_item/item/buy(var/obj/item/device/uplink/U, var/mob/user)
	var/obj/item/I = ..()
	if(!I)
		return

	if(istype(I, /list))
		var/list/L = I
		if(L.len) I = L[1]

	if(istype(I) && ishuman(user))
		var/mob/living/carbon/human/A = user
		A.put_in_any_hand_if_possible(I)
	return I

/datum/uplink_item/item/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/obj/item/I = new path(loc)
	return I

/datum/uplink_item/item/description()
	if(!desc)
		// Fallback description
		var/obj/temp = src.path
		desc = initial(temp.desc)
	return ..()

/datum/uplink_item/item/log_icon()
	var/obj/I = path
	return "\icon[I]"

/*************
* Ammunition *
*************/
/datum/uplink_item/item/ammo
	item_cost = 2
	category = /datum/uplink_category/ammunition

/datum/uplink_item/item/ammo/a357
	name = ".357"
	path = /obj/item/ammo_magazine/a357

/datum/uplink_item/item/ammo/mc9mm
	name = ".9mm"
	path = /obj/item/ammo_magazine/mc9mm

/datum/uplink_item/item/ammo/darts
	name = "Darts"
	path = /obj/item/ammo_magazine/chemdart

/datum/uplink_item/item/ammo/sniperammo
	name = "14.5mm"
	path = /obj/item/weapon/storage/box/sniperammo

/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword"
	item_cost = 4
	path = /obj/item/weapon/melee/energy/sword

/datum/uplink_item/item/visible_weapons/dartgun
	name = "Dart Gun"
	item_cost = 5
	path = /obj/item/weapon/gun/projectile/dartgun

/datum/uplink_item/item/visible_weapons/crossbow
	name = "Energy Crossbow"
	item_cost = 5
	path = /obj/item/weapon/gun/energy/crossbow

/datum/uplink_item/item/visible_weapons/g9mm
	name = "Silenced 9mm"
	item_cost = 5
	path = /obj/item/weapon/storage/box/syndie_kit/g9mm

/datum/uplink_item/item/visible_weapons/riggedlaser
	name = "Exosuit Rigged Laser"
	item_cost = 6
	path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/uplink_item/item/visible_weapons/revolver
	name = "Revolver"
	item_cost = 6
	path = /obj/item/weapon/gun/projectile/revolver

/datum/uplink_item/item/visible_weapons/heavysniper
	name = "Anti-materiel Rifle"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/weapon/gun/projectile/heavysniper

/*************************************
* Stealthy and Inconspicuous Weapons *
*************************************/
/datum/uplink_item/item/stealthy_weapons
	category = /datum/uplink_category/stealthy_weapons

/datum/uplink_item/item/stealthy_weapons/soap
	name = "Subversive Soap"
	item_cost = 1
	path = /obj/item/weapon/soap/syndie

/datum/uplink_item/item/stealthy_weapons/concealed_cane
	name = "Concealed Cane Sword"
	item_cost = 1
	path = /obj/item/weapon/cane/concealed

/datum/uplink_item/item/stealthy_weapons/detomatix
	name = "Detomatix PDA Cartridge"
	item_cost = 3
	path = /obj/item/weapon/cartridge/syndicate

/datum/uplink_item/item/stealthy_weapons/parapen
	name = "Paralysis Pen"
	item_cost = 3
	path = /obj/item/weapon/pen/reagent/paralysis

/datum/uplink_item/item/stealthy_weapons/cigarette_kit
	name = "Cigarette Kit"
	item_cost = 3
	path = /obj/item/weapon/storage/box/syndie_kit/cigarette

/datum/uplink_item/item/stealthy_weapons/random_toxin
	name = "Random Toxin - Beaker"
	item_cost = 3
	path = /obj/item/weapon/storage/box/syndie_kit/toxin

/*******************************
* Stealth and Camouflage Items *
*******************************/
/datum/uplink_item/item/stealth_items
	category = /datum/uplink_category/stealth_items

/datum/uplink_item/item/stealth_items/id
	name = "Agent ID card"
	item_cost = 2
	path = /obj/item/weapon/card/id/syndicate

/datum/uplink_item/item/stealth_items/syndigaloshes
	name = "No-Slip Shoes"
	item_cost = 2
	path = /obj/item/clothing/shoes/syndigaloshes

/datum/uplink_item/item/stealth_items/spy
	name = "Bug Kit"
	item_cost = 2
	path = /obj/item/weapon/storage/box/syndie_kit/spy

/datum/uplink_item/item/stealth_items/chameleon_kit
	name = "Chameleon Kit"
	item_cost = 3
	path = /obj/item/weapon/storage/box/syndie_kit/chameleon

/datum/uplink_item/item/stealth_items/chameleon_projector
	name = "Chameleon-Projector"
	item_cost = 4
	path = /obj/item/device/chameleon

/datum/uplink_item/item/stealth_items/chameleon_projector
	name = "Chameleon-Projector"
	item_cost = 4
	path = /obj/item/device/chameleon

/datum/uplink_item/item/stealth_items/voice
	name = "Voice Changer"
	item_cost = 4
	path = /obj/item/clothing/mask/gas/voice

/datum/uplink_item/item/stealth_items/camera_floppy
	name = "Camera Network Access - Floppy"
	item_cost = 6
	path = /obj/item/weapon/disk/file/cameras/syndicate

/********************
* Devices and Tools *
********************/
/datum/uplink_item/item/tools
	category = /datum/uplink_category/tools

/datum/uplink_item/item/tools/toolbox
	name = "Fully Loaded Toolbox"
	item_cost = 1
	path = /obj/item/weapon/storage/toolbox/syndicate

/datum/uplink_item/item/tools/plastique
	name = "C-4 (Destroys walls)"
	item_cost = 2
	path = /obj/item/weapon/plastique

/datum/uplink_item/item/tools/encryptionkey_radio
	name = "Encrypted Radio Channel Key"
	item_cost = 2
	path = /obj/item/device/encryptionkey/syndicate

/datum/uplink_item/item/tools/encryptionkey_binary
	name = "Binary Translator Key"
	item_cost = 3
	path = /obj/item/device/encryptionkey/binary

/datum/uplink_item/item/tools/emag
	name = "Cryptographic Sequencer"
	item_cost = 3
	path = /obj/item/weapon/card/emag

/datum/uplink_item/item/tools/clerical
	name = "Morphic Clerical Kit"
	item_cost = 3
	path = /obj/item/weapon/storage/box/syndie_kit/clerical

/datum/uplink_item/item/tools/space_suit
	name = "Space Suit"
	item_cost = 3
	path = /obj/item/weapon/storage/box/syndie_kit/space

/datum/uplink_item/item/tools/thermal
	name = "Thermal Imaging Glasses"
	item_cost = 3
	path = /obj/item/clothing/glasses/thermal/syndi

/datum/uplink_item/item/tools/heavy_vest
	name = "Heavy Armor Vest"
	item_cost = 4
	path = /obj/item/clothing/suit/storage/vest/heavy/merc

/datum/uplink_item/item/tools/powersink
	name = "Powersink (DANGER!)"
	item_cost = 5
	path = /obj/item/device/powersink

/datum/uplink_item/item/tools/ai_module
	name = "Hacked AI Upload Module"
	item_cost = 7
	path = /obj/item/weapon/aiModule/syndicate

/datum/uplink_item/item/tools/singularity_beacon
	name = "Singularity Beacon (DANGER!)"
	item_cost = 7
	path = /obj/item/device/radio/beacon/syndicate

/datum/uplink_item/item/tools/teleporter
	name = "Teleporter Circuit Board"
	item_cost = 20
	path = /obj/item/weapon/circuitboard/teleporter

/datum/uplink_item/item/tools/teleporter/New()
	..()
	antag_roles = list(MODE_MERCENARY)

/***********
* Implants *
***********/
/datum/uplink_item/item/implants
	category = /datum/uplink_category/implants

/datum/uplink_item/item/implants/imp_freedom
	name = "Freedom Implant"
	item_cost = 3
	path = /obj/item/weapon/storage/box/syndie_kit/imp_freedom

/datum/uplink_item/item/implants/imp_compress
	name = "Compressed Matter Implant"
	item_cost = 4
	path = /obj/item/weapon/storage/box/syndie_kit/imp_compress

/datum/uplink_item/item/implants/imp_explosive
	name = "Explosive Implant (DANGER!)"
	item_cost = 6
	path = /obj/item/weapon/storage/box/syndie_kit/imp_explosive

/datum/uplink_item/item/implants/imp_uplink
	name = "Uplink Implant (Contains 5 Telecrystals)"
	item_cost = 10
	path = /obj/item/weapon/storage/box/syndie_kit/imp_uplink

/**********
* Medical *
**********/
/datum/uplink_item/item/medical
	category = /datum/uplink_category/medical

/datum/uplink_item/item/medical/sinpockets
	name = "Box of Sin-Pockets"
	item_cost = 1
	path = /obj/item/weapon/storage/box/sinpockets

/datum/uplink_item/item/medical/surgery
	name = "Surgery kit"
	item_cost = 6
	path = /obj/item/weapon/storage/firstaid/surgery

/datum/uplink_item/item/medical/combat
	name = "Combat medical kit"
	item_cost = 6
	path = /obj/item/weapon/storage/firstaid/combat

/*******************
* Hardsuit Modules *
*******************/
/datum/uplink_item/item/hardsuit_modules
	category = /datum/uplink_category/hardsuit_modules

/datum/uplink_item/item/hardsuit_modules/thermal
	name = "Thermal Scanner"
	item_cost = 2
	path = /obj/item/rig_module/vision/thermal

/datum/uplink_item/item/hardsuit_modules/energy_net
	name = "Net Projector"
	item_cost = 3
	path = /obj/item/rig_module/fabricator/energy_net

/datum/uplink_item/item/ewar_voice
	name = "Electrowarfare Suite and Voice Synthesiser"
	item_cost = 4
	path = /obj/item/weapon/storage/box/syndie_kit/ewar_voice

/datum/uplink_item/item/hardsuit_modules/maneuvering_jets
	name = "Maneuvering Jets"
	item_cost = 4
	path = /obj/item/rig_module/maneuvering_jets

/datum/uplink_item/item/hardsuit_modules/egun
	name = "Mounted Energy Gun"
	item_cost = 6
	path = /obj/item/rig_module/mounted/egun

/datum/uplink_item/item/hardsuit_modules/power_sink
	name = "Power Sink"
	item_cost = 6
	path = /obj/item/rig_module/power_sink

/datum/uplink_item/item/hardsuit_modules/laser_canon
	name = "Mounted Laser Cannon"
	item_cost = 8
	path = /obj/item/rig_module/mounted

/***********
* Grenades *
************/
/datum/uplink_item/item/grenades
	category = /datum/uplink_category/grenades

/datum/uplink_item/item/grenades/anti_photon
	name = "5xPhoton Disruption Grenades"
	item_cost = 2
	path = /obj/item/weapon/storage/box/anti_photons

/datum/uplink_item/item/grenades/emp
	name = "5xEMP Grenades"
	item_cost = 3
	path = /obj/item/weapon/storage/box/emps

/datum/uplink_item/item/grenades/smoke
	name = "5xSmoke Grenades"
	item_cost = 2
	path = /obj/item/weapon/storage/box/smokes

/************
* Badassery *
************/
/datum/uplink_item/item/badassery
	category = /datum/uplink_category/badassery

/datum/uplink_item/item/badassery/balloon
	name = "For showing that You Are The BOSS (Useless Balloon)"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/toy/syndicateballoon

/datum/uplink_item/item/badassery/balloon/NT
	name = "For showing that you love NT SOO much (Useless Balloon)"
	path = /obj/item/toy/nanotrasenballoon

/**************
* Random Item *
**************/
/datum/uplink_item/item/badassery/random_one
	name = "Random Item"
	desc = "Buys you one random item."

/datum/uplink_item/item/badassery/random_one/buy(var/obj/item/device/uplink/U, var/mob/user)
	var/datum/uplink_item/item = default_uplink_selection.get_random_item(U.uses)
	return item.buy(U, user)

/datum/uplink_item/item/badassery/random_one/can_buy(obj/item/device/uplink/U)
	return default_uplink_selection.get_random_item(U.uses, U) != null

/datum/uplink_item/item/badassery/random_many
	name = "Random Items"
	desc = "Buys you as many random items you can afford. Convenient packaging NOT included."

/datum/uplink_item/item/badassery/random_many/cost(var/telecrystals)
	return max(1, telecrystals)

/datum/uplink_item/item/badassery/random_many/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/list/bought_items = list()
	for(var/datum/uplink_item/UI in get_random_uplink_items(U, U.uses, loc))
		UI.purchase_log(U)
		var/obj/item/I = UI.get_goods(U, loc)
		if(istype(I))
			bought_items += I

	return bought_items

/datum/uplink_item/item/badassery/random_many/purchase_log(obj/item/device/uplink/U)
	feedback_add_details("traitor_uplink_items_bought", "[src]")

/****************
* Surplus Crate *
****************/
/datum/uplink_item/item/badassery/surplus
	name = "Surplus Crate"
	item_cost = 40
	var/item_worth = 60
	var/icon

/datum/uplink_item/item/badassery/surplus/New()
	..()
	antag_roles = list(MODE_MERCENARY)
	desc = "A crate containing [item_worth] telecrystal\s worth of surplus leftovers."

/datum/uplink_item/item/badassery/surplus/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/obj/structure/largecrate/C = new(loc)
	var/random_items = get_random_uplink_items(null, item_worth, C)
	for(var/datum/uplink_item/I in random_items)
		I.purchase_log(U)
		I.get_goods(U, C)

	return C

/datum/uplink_item/item/badassery/surplus/log_icon()
	if(!icon)
		var/obj/structure/largecrate/C = /obj/structure/largecrate
		icon = image(initial(C.icon), initial(C.icon_state))

	return "\icon[icon]"

/********************************
*                           	*
*	Abstract Uplink Entries		*
*                           	*
********************************/
var/image/default_abstract_uplink_icon
/datum/uplink_item/abstract/log_icon()
	if(!default_abstract_uplink_icon)
		default_abstract_uplink_icon = image('icons/obj/pda.dmi', "pda-syn")

	return "\icon[default_abstract_uplink_icon]"

/****************
* Announcements *
*****************/
/datum/uplink_item/abstract/announcements
	category = /datum/uplink_category/services

/datum/uplink_item/abstract/announcements/buy(var/obj/item/device/uplink/U, var/mob/user)
	. = ..()
	if(.)
		log_and_message_admins("has triggered a falsified [src]", user)

/datum/uplink_item/abstract/announcements/fake_centcom
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT / 2

/datum/uplink_item/abstract/announcements/fake_centcom/New()
	..()
	name = "[command_name()] Update Announcement"
	desc = "Causes a falsified [command_name()] Update. Triggers immediately after supplying additional data."
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/abstract/announcements/fake_centcom/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/user, var/list/args)
	command_announcement.Announce(args.["message"], args.["title"])
	return 1

/datum/uplink_item/abstract/announcements/fake_crew_arrival
	name = "Crew Arrival Announcement/Records"
	desc = "Creates a fake crew arrival announcement as well as fake crew records, using your current appearance (including held items!) and worn id card."
	item_cost = 4

/datum/uplink_item/abstract/announcements/fake_crew_arrival/New()
	..()
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/abstract/announcements/fake_crew_arrival/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/user, var/list/args)
	if(!user)
		return 0

	// TODO-PSI: Port cool agent ID
	var/obj/item/weapon/card/id/I = GetIdCard(user)
	var/assignment = I ? I.assignment : GetAssignment(user)

	var/datum/data/record/random_general_record
	var/datum/data/record/random_medical_record
	if(data_core.general.len)
		random_general_record	= pick(data_core.general)
		random_medical_record	= find_medical_record("id", random_general_record.fields["id"])

	var/datum/data/record/general = data_core.CreateGeneralRecord(user)
	if(I)
		general.fields["name"] = I.registered_name
	else
		general.fields["name"] = user.real_name

	var/datum/data/record/medical = data_core.CreateMedicalRecord(general.fields["name"], general.fields["id"])
	var/datum/data/record/security = data_core.CreateSecurityRecord(general.fields["name"], general.fields["id"])

	general.fields["rank"] = assignment
	general.fields["real_rank"] = assignment
	general.fields["sex"] = capitalize(user.gender)
	general.fields["species"] = user.get_species()
	var/mob/living/carbon/human/H
	if(istype(user,/mob/living/carbon/human))
		H = user
		general.fields["age"] = H.age
	else
		general.fields["age"] = initial(H.age)

	if(random_general_record)
		general.fields["citizenship"]	= random_general_record.fields["citizenship"]
		general.fields["faction"] 		= random_general_record.fields["faction"]
		general.fields["fingerprint"] 	= random_general_record.fields["fingerprint"]
		general.fields["home_system"] 	= random_general_record.fields["home_system"]
		general.fields["religion"] 		= random_general_record.fields["religion"]
	if(random_medical_record)
		medical.fields["b_type"]		= random_medical_record.fields["b_type"]
		medical.fields["b_dna"]			= random_medical_record.fields["b_type"]

	AnnounceArrivalSimple(general.fields["name"], general.fields["rank"])
	return 1

/datum/uplink_item/abstract/announcements/fake_ion_storm
	name = "Ion Storm Announcement"
	desc = "Interferes with the station's ion sensors. Triggers immediately upon investment."
	item_cost = 1

/datum/uplink_item/abstract/announcements/fake_ion_storm/get_goods(var/obj/item/device/uplink/U, var/loc)
	ion_storm_announcement()
	return 1

/datum/uplink_item/abstract/announcements/fake_radiation
	name = "Radiation Storm Announcement"
	desc = "Interferes with the station's radiation sensors. Triggers immediately upon investment."
	item_cost = 3

/datum/uplink_item/abstract/announcements/fake_radiation/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/datum/event_meta/EM = new(EVENT_LEVEL_MUNDANE, "Fake Radiation Storm", add_to_queue = 0)
	new/datum/event/radiation_storm/syndicate(EM)
	return 1


/****************
* Support procs *
****************/
/proc/get_random_uplink_items(var/obj/item/device/uplink/U, var/remaining_TC, var/loc)
	var/list/bought_items = list()
	while(remaining_TC)
		var/datum/uplink_item/I = default_uplink_selection.get_random_item(remaining_TC, U, bought_items)
		if(!I)
			break
		bought_items += I
		remaining_TC -= I.cost(remaining_TC)

	return bought_items
