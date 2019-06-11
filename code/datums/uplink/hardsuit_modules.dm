/*******************
* Hardsuit Modules *
*******************/
/datum/uplink_item/item/hardsuit_modules
	category = /datum/uplink_category/hardsuit_modules

/datum/uplink_item/item/hardsuit_modules/thermal
	name = "\improper Thermal Scanner"
	desc = "A module capable of giving vision of synthetic or living creatures, through thermal imaging."
	item_cost = 16
	path = /obj/item/rig_module/vision/thermal

/datum/uplink_item/item/hardsuit_modules/energy_net
	name = "\improper Net Projector"
	desc = "A module capable of creating an energy net device that can be thrown in order to capture targets like the prey they are."
	item_cost = 20
	path = /obj/item/rig_module/fabricator/energy_net

/datum/uplink_item/item/hardsuit_modules/ewar_voice
	name = "\improper Electrowarfare Suite and Voice Synthesiser"
	desc = "Includes two modules that, once installed and activated, are capable of masking your voice and disrupting the AI from tracking you."
	item_cost = 24
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/ewar_voice

/datum/uplink_item/item/hardsuit_modules/maneuvering_jets
	name = "\improper Maneuvering Jets"
	desc = "A module capable of giving your suit an active thrust system, so that you can maneuver in zero gravity."
	item_cost = 32
	path = /obj/item/rig_module/maneuvering_jets

/datum/uplink_item/item/hardsuit_modules/egun
	name = "\improper Mounted Energy Gun"
	desc = "A module that drains your power reserves in order to fire an arm mounted energy gun."
	item_cost = 48
	path = /obj/item/rig_module/mounted/egun

/datum/uplink_item/item/hardsuit_modules/power_sink
	name = "\improper Power Sink"
	desc = "A module capable of recharging your suit's power reserves, by tapping into an exposed, live wire."
	item_cost = 48
	path = /obj/item/rig_module/power_sink

/datum/uplink_item/item/hardsuit_modules/laser_canon
	name = "\improper Mounted Laser Cannon"
	desc = "A module capable of draining your suit's power reserves in order to fire a shoulder mounted laser cannon."
	item_cost = 64
	path = /obj/item/rig_module/mounted/lcannon
	antag_roles = list(MODE_MERCENARY)
