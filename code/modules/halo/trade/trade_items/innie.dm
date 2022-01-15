
/datum/trade_item/helmet
	name = "Salvaged Helmet"
	item_type = /obj/item/clothing/head/helmet/innie
	quantity = 10
	value = 100
	trader_weight = 20
	category = "innie"

/datum/trade_item/armour
	name = "Salvaged Armor"
	item_type = /obj/item/clothing/suit/armor/innie
	quantity = 10
	value = 150
	trader_weight = 20
	category = "innie"

/datum/trade_item/shemagh
	name = "Shemagh"
	item_type = /obj/item/clothing/mask/innie/shemagh
	quantity = 10
	value = 25
	trader_weight = 5
	category = "innie"

/datum/trade_item/shotgun_soe
	name = "KV-32 custom shotgun"
	item_type = /obj/item/weapon/gun/projectile/shotgun/soe
	quantity = 8
	value = 2800
	trader_weight = 5
	bonus_items = list(/obj/item/ammo_magazine/kv32)
	category = "innie"

/datum/trade_item/m545_lmg
	name = "M545 Light Machine Gun"
	item_type = /obj/item/weapon/gun/projectile/m545_lmg
	quantity = 1
	value = 12000
	category = "innie"
	bonus_items = list(/obj/item/ammo_magazine/m545/m118)

/datum/trade_item/m392_dmr/innie
	name = "Modified M392 DMR"
	item_type = /obj/item/weapon/gun/projectile/m392_dmr/innie
	quantity = 4
	value = 17000
	trader_weight = 5
	bonus_items = list(/obj/item/ammo_magazine/m392/m120)
	category = "innie"

/datum/trade_item/ACL55
	name = "ACL-55"
	item_type = /obj/item/weapon/gun/projectile/ACL55
	quantity = 1
	value = 68000
	bonus_items = list(/obj/item/ammo_magazine/m26)
	trader_weight = 1
	category = "innie"
