/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/dartgun
	name = "Dart Gun"
	item_cost = 20
	path = /obj/item/weapon/gun/projectile/dartgun

/datum/uplink_item/item/visible_weapons/crossbow
	name = "Energy Crossbow"
	item_cost = 24
	path = /obj/item/weapon/gun/energy/crossbow

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword"
	item_cost = 32
	path = /obj/item/weapon/melee/energy/sword

/datum/uplink_item/item/visible_weapons/g9mm
	name = "Silenced Holdout Pistol"
	item_cost = 32
	path = /obj/item/weapon/storage/box/syndie_kit/g9mm

/datum/uplink_item/item/visible_weapons/riggedlaser
	name = "Exosuit (APLU) Rigged Laser"
	item_cost = 32
	path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/uplink_item/item/visible_weapons/energy_gun
	name = "Energy Gun"
	item_cost = 32
	path = /obj/item/weapon/gun/energy/gun

/datum/uplink_item/item/visible_weapons/revolver
	name = "Revolver, .357"
	item_cost = 56
	antag_costs = list(MODE_MERCENARY = 7)
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/revolver

/datum/uplink_item/item/visible_weapons/revolver2
	name = "Revolver, .44"
	item_cost = 48
	antag_costs = list(MODE_MERCENARY = 5)
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/revolver2

/datum/uplink_item/item/visible_weapons/grenade_launcher
	name = "Grenade Launcher"
	item_cost = 60
	antag_roles = list(MODE_MERCENARY = 12)
	path = /obj/item/weapon/gun/launcher/grenade/loaded

//These are for traitors (or other antags, perhaps) to have the option of purchasing some merc gear.
/datum/uplink_item/item/visible_weapons/submachinegun
	name = "Submachine Gun"
	item_cost = 52
	antag_costs = list(MODE_MERCENARY = 6)
	path = /obj/item/weapon/gun/projectile/automatic/c20r

/datum/uplink_item/item/visible_weapons/assaultrifle
	name = "Assault Rifle"
	item_cost = 60
	antag_costs = list(MODE_MERCENARY = 9)
	path = /obj/item/weapon/gun/projectile/automatic/sts35

/datum/uplink_item/item/visible_weapons/advanced_energy_gun
	name = "Advanced Energy Gun"
	item_cost = 60
	path = /obj/item/weapon/gun/energy/gun/nuclear

/datum/uplink_item/item/visible_weapons/heavysniper
	name = "Anti-materiel Rifle with ammunition"
	item_cost = 68
	path = /obj/item/weapon/storage/secure/briefcase/heavysniper

/datum/uplink_item/item/visible_weapons/machine_pistol
	name = "Machine Pistol"
	item_cost = 45
	path = /obj/item/weapon/gun/projectile/automatic/machine_pistol

/datum/uplink_item/item/visible_weapons/combat_shotgun
	name = "Combat Shotgun"
	item_cost = 52
	path = /obj/item/weapon/gun/projectile/shotgun/pump/combat

/datum/uplink_item/item/visible_weapons/sawnoff
	name = "Sawnoff Shotgun"
	item_cost = 45
	path = /obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn

/datum/uplink_item/item/visible_weapons/deagle
	name = "Magnum Pistol"
	item_cost = 52
	path = /obj/item/weapon/gun/projectile/magnum_pistol

/datum/uplink_item/item/visible_weapons/detective_revolver
	name = "Holdout Revolver"
	item_cost = 38
	path = /obj/item/weapon/gun/projectile/revolver/detective

/datum/uplink_item/item/visible_weapons/pulserifle
	name = "Pulse Rifle"
	item_cost = 68
	antag_costs = list(MODE_MERCENARY = 9)
	path = /obj/item/weapon/gun/energy/pulse_rifle

/datum/uplink_item/item/visible_weapons/flechetterifle
	name = "Flechette Rifle"
	item_cost = 60
	antag_costs = list(MODE_MERCENARY = 9)
	path = /obj/item/weapon/gun/magnetic/railgun/flechette