/*
/datum/trade_item
	var/name
	var/item_type
	var/category
	var/quantity = 0
	var/value = 0
	var/trader_weight = 1
	var/list/bonus_items = list()
	var/is_template = 1
*/



/* ORE */

/datum/trade_item/coal
	name = "coal"
	item_type = /obj/item/weapon/ore/coal
	category = "ore"
	quantity = 10
	value = 10
	trader_weight = 0

/datum/trade_item/iron
	name = "iron ore"
	item_type = /obj/item/weapon/ore/iron
	category = "ore"
	quantity = 0
	value = 25
	trader_weight = 0

/datum/trade_item/silver
	name = "native silver ore"
	item_type = /obj/item/weapon/ore/silver
	category = "ore"
	quantity = 0
	value = 50
	trader_weight = 0

/datum/trade_item/gold
	name = "native gold ore"
	item_type = /obj/item/weapon/ore/gold
	category = "ore"
	quantity = 0
	value = 50
	trader_weight = 0

/datum/trade_item/platinum
	name = "native platinum ore"
	item_type = /obj/item/weapon/ore/osmium
	category = "ore"
	quantity = 0
	value = 100
	trader_weight = 0

/datum/trade_item/hydrogen
	name = "metallic hydrogen strands"
	item_type = /obj/item/weapon/ore/hydrogen
	category = "ore"
	quantity = 0
	value = 50
	trader_weight = 0

/datum/trade_item/diamond
	name = "rough diamond"
	item_type = /obj/item/weapon/ore/diamond
	category = "ore"
	quantity = 0
	value = 100
	trader_weight = 0

/datum/trade_item/uranium
	name = "uranium ore"
	item_type = /obj/item/weapon/ore/uranium
	category = "ore"
	quantity = 0
	value = 150
	trader_weight = 0

/datum/trade_item/phoron
	name = "rough phoron crystals"
	item_type = /obj/item/weapon/ore/phoron
	category = "ore"
	quantity = 0
	value = 75
	trader_weight = 0

/datum/trade_item/corundum
	name = "corundum ore"
	item_type = /obj/item/weapon/ore/corundum
	category = "ore"
	quantity = 0
	value = 125
	trader_weight = 0

/datum/trade_item/duridium
	name = "duridiumore "
	item_type = /obj/item/weapon/ore/duridium
	category = "ore"
	quantity = 0
	value = 100
	trader_weight = 0

/datum/trade_item/kemocite
	name = "kemocite"
	item_type = /obj/item/weapon/ore/kemocite
	category = "ore"
	quantity = 0
	value = 50
	trader_weight = 0
