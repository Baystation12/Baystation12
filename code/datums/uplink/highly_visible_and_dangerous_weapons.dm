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

/datum/uplink_item/item/visible_weapons/silenced
	name = "Silenced Holdout Pistol"
	desc = "Holdout pistol with silencer kit and ammunition."
	item_cost = 32
	path = /obj/item/weapon/storage/box/syndie_kit/silenced

/datum/uplink_item/item/badassery/money_cannon
	name = "Modified Money Cannon"
	item_cost = 48
	path = /obj/item/weapon/gun/launcher/money/hacked
	desc = "Too much money? Not enough screaming? Try the Money Cannon."

/datum/uplink_item/item/visible_weapons/riggedlaser
	name = "Exosuit (APLU) Rigged Laser"
	item_cost = 32
	path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/uplink_item/item/visible_weapons/energy_gun
	name = "Energy Gun"
	item_cost = 32
	path = /obj/item/weapon/gun/energy/gun

/datum/uplink_item/item/visible_weapons/revolver
	name = "Revolver"
	desc = "Magnum revolver, with ammunition."
	item_cost = 56
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/revolver

/datum/uplink_item/item/visible_weapons/grenade_launcher
	name = "Grenade Launcher"
	item_cost = 60
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/weapon/gun/launcher/grenade/loaded

//These are for traitors (or other antags, perhaps) to have the option of purchasing some merc gear.
/datum/uplink_item/item/visible_weapons/submachinegun
	name = "Submachine Gun"
	item_cost = 52
	path = /obj/item/weapon/gun/projectile/automatic/merc_smg
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/assaultrifle
	name = "Assault Rifle"
	item_cost = 60
	path = /obj/item/weapon/gun/projectile/automatic/assault_rifle
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/advanced_energy_gun
	name = "Advanced Energy Gun"
	item_cost = 60
	path = /obj/item/weapon/gun/energy/gun/nuclear

/datum/uplink_item/item/visible_weapons/heavysniper
	name = "Anti-materiel Rifle with ammunition"
	item_cost = 68
	path = /obj/item/weapon/storage/secure/briefcase/heavysniper
	antag_roles = list(MODE_MERCENARY)

/*
/datum/uplink_item/item/visible_weapons/psi_amp
	name = "Cerebroenergetic Psionic Amplifier"
	item_cost = 50
	path = /obj/item/clothing/head/helmet/space/psi_amp/lesser
	desc = "A powerful, illegal psi-amp. Boosts latent psi-faculties to extremely high levels."
*/

/datum/uplink_item/item/visible_weapons/machine_pistol
	name = "Machine Pistol"
	item_cost = 45
	path = /obj/item/weapon/gun/projectile/automatic/machine_pistol

/datum/uplink_item/item/visible_weapons/combat_shotgun
	name = "Combat Shotgun"
	item_cost = 52
	path = /obj/item/weapon/gun/projectile/shotgun/pump/combat
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/sawnoff
	name = "Sawnoff Shotgun"
	item_cost = 45
	path = /obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn

/datum/uplink_item/item/visible_weapons/deagle
	name = "Magnum Pistol"
	item_cost = 52
	path = /obj/item/weapon/gun/projectile/pistol/magnum_pistol

/datum/uplink_item/item/visible_weapons/sigsauer
	name = "Military Pistol"
	item_cost = 40
	path = /obj/item/weapon/gun/projectile/pistol/military/alt

/datum/uplink_item/item/visible_weapons/detective_revolver
	name = "Holdout Revolver"
	item_cost = 24
	path = /obj/item/weapon/gun/projectile/revolver/holdout

/datum/uplink_item/item/visible_weapons/pulserifle
	name = "Pulse Rifle"
	item_cost = 68
	path = /obj/item/weapon/gun/energy/pulse_rifle
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/flechetterifle
	name = "Flechette Rifle"
	item_cost = 60
	path = /obj/item/weapon/gun/magnetic/railgun/flechette
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/railgun // Like a semi-auto AMR
	name = "Railgun"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT - (DEFAULT_TELECRYSTAL_AMOUNT - (DEFAULT_TELECRYSTAL_AMOUNT % 6)) / 6
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/weapon/gun/magnetic/railgun

/datum/uplink_item/item/visible_weapons/railguntcc // Only slightly better than the normal railgun; but cooler looking
	name = "Advanced Railgun"
	antag_roles = list(MODE_MERCENARY)
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/weapon/gun/magnetic/railgun/tcc

/datum/uplink_item/item/visible_weapons/harpoonbomb
	name = "Explosive Harpoon"
	item_cost = 12
	path = /obj/item/weapon/material/harpoon/bomb