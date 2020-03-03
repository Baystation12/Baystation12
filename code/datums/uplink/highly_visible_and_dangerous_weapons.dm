/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/zipgun
	name = "Zip Gun"
	desc = "A pipe attached to crude wooden stock with firing mechanism, holds one round."
	item_cost = 8
	path = /obj/item/weapon/gun/projectile/pirate

/datum/uplink_item/item/visible_weapons/smallenergy_gun
	name = "Small Energy Gun"
	desc = "A pocket-sized energy based sidearm with three different lethality settings."
	item_cost = 16
	path = /obj/item/weapon/gun/energy/gun/small

/datum/uplink_item/item/visible_weapons/ancient
	name = "Replica Pistol"
	desc = "A cheap replica of an earth handgun. To reload, buy another."
	item_cost = 16
	path = /obj/item/weapon/gun/projectile/pistol/throwback

/datum/uplink_item/item/visible_weapons/dartgun
	name = "Dart Gun"
	desc = "A gas-powered dart gun capable of delivering chemical payloads across short distances. \
			Uses a unique cartridge loaded with hollow darts."
	item_cost = 20
	path = /obj/item/weapon/gun/projectile/dartgun

/datum/uplink_item/item/visible_weapons/crossbow
	name = "Energy Crossbow"
	desc = "A self-recharging, almost silent weapon employed by stealth operatives."
	item_cost = 24
	path = /obj/item/weapon/gun/energy/crossbow

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword"
	desc = "A hilt, that when activated, creates a solid beam of pure energy in the form of a sword. \
			Able to slice through people like butter!"
	item_cost = 32
	path = /obj/item/weapon/melee/energy/sword

/datum/uplink_item/item/visible_weapons/silenced
	name = "Small Silenced Pistol"
	desc = "A kit with a pocket-sized holdout pistol, silencer, and an extra magazine. \
			Attaching the silencer will make it too big to conceal in your pocket."
	item_cost = 32
	path = /obj/item/weapon/storage/box/syndie_kit/silenced

/datum/uplink_item/item/badassery/money_cannon
	name = "Modified Money Cannon"
	item_cost = 48
	path = /obj/item/weapon/gun/launcher/money/hacked
	desc = "Too much money? Not enough screaming? Try the Money Cannon."

/datum/uplink_item/item/visible_weapons/energy_gun
	name = "Energy Gun"
	desc = "A energy based sidearm with three different lethality settings."
	item_cost = 32
	path = /obj/item/weapon/gun/energy/gun

/datum/uplink_item/item/visible_weapons/ionpistol
	name = "Ion Pistol"
	desc = "Ion rifle in compact form."
	item_cost = 40
	path = /obj/item/weapon/gun/energy/ionrifle/small

/datum/uplink_item/item/visible_weapons/revolver
	name = "Magnum Revolver"
	desc = "A high-caliber revolver. Includes an extra speedloader of ammo."
	item_cost = 56
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/revolver

/datum/uplink_item/item/visible_weapons/grenade_launcher
	name = "Grenade Launcher"
	desc = "A pump action grenade launcher loaded with a random assortment of grenades"
	item_cost = 60
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/weapon/gun/launcher/grenade/loaded

//These are for traitors (or other antags, perhaps) to have the option of purchasing some merc gear.
/datum/uplink_item/item/visible_weapons/submachinegun
	name = "Standard Submachine Gun"
	desc = "A quick-firing weapon with three togglable fire modes."
	item_cost = 52
	path = /obj/item/weapon/gun/projectile/automatic/merc_smg
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/assaultrifle
	name = "Assault Rifle"
	desc = "A common rifle with three togglable fire modes."
	item_cost = 60
	path = /obj/item/weapon/gun/projectile/automatic/assault_rifle
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/advanced_energy_gun
	name = "Advanced Energy Gun"
	desc = "A highly experimental heavy energy weapon, with three different lethality settings."
	item_cost = 60
	path = /obj/item/weapon/gun/energy/gun/nuclear

/datum/uplink_item/item/visible_weapons/heavysniper
	name = "Anti-materiel Sniper Rifle"
	desc = "A secure briefcase that contains an immensely powerful penetrating rifle, as well as seven extra sniper rounds."
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
	name = "Standard Machine Pistol"
	desc = "A high rate of fire weapon in a smaller form factor, able to sling standard ammunition almost as quick as a submachine gun."
	item_cost = 45
	path = /obj/item/weapon/gun/projectile/automatic/machine_pistol

/datum/uplink_item/item/visible_weapons/combat_shotgun
	name = "Combat Shotgun"
	desc = "A high compacity, pump-action shotgun regularly used for repelling boarding parties in close range scenarios."
	item_cost = 52
	path = /obj/item/weapon/gun/projectile/shotgun/pump/combat
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/sawnoff
	name = "Sawnoff Shotgun"
	desc = "A shortened double-barrel shotgun, able to fire either one, or both, barrels at once."
	item_cost = 45
	path = /obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn

/datum/uplink_item/item/visible_weapons/deagle
	name = "Magnum Pistol"
	desc = "A high-caliber pistol that uses 15mm ammunition."
	item_cost = 52
	path = /obj/item/weapon/gun/projectile/pistol/magnum_pistol

/datum/uplink_item/item/visible_weapons/sigsauer
	name = "Standard Military Pistol"
	desc = "A regularly used and reliable weapon that is standard issue in the Navy."
	item_cost = 40
	path = /obj/item/weapon/gun/projectile/pistol/military/alt

/datum/uplink_item/item/visible_weapons/detective_revolver
	name = "Small Revolver"
	desc = "A pocket-sized holdout revolver. Easily concealable.."
	item_cost = 24
	path = /obj/item/weapon/gun/projectile/revolver/holdout

/datum/uplink_item/item/visible_weapons/pulserifle
	name = "Pulse Rifle"
	desc = "A triple burst, heavy laser rifle, with a large battery compacity."
	item_cost = 68
	path = /obj/item/weapon/gun/energy/pulse_rifle
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/flechetterifle
	name = "Flechette Rifle"
	desc = "A railgun with two togglable fire modes, able to launch flechette ammunition at incredible speeds."
	item_cost = 60
	path = /obj/item/weapon/gun/magnetic/railgun/flechette
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/railgun // Like a semi-auto AMR
	name = "Railgun"
	desc = "An anti-armour magnetic launching system fed by a high-capacity matter cartridge, \
			capable of firing slugs at intense speeds."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT - (DEFAULT_TELECRYSTAL_AMOUNT - (DEFAULT_TELECRYSTAL_AMOUNT % 6)) / 6
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/weapon/gun/magnetic/railgun

/datum/uplink_item/item/visible_weapons/railguntcc // Only slightly better than the normal railgun; but cooler looking
	name = "Advanced Railgun"
	desc = "A modified prototype of the original railgun implement, this time boring slugs out of steel rods loaded into the chamber, \
			now with even MORE stopping power."
	antag_roles = list(MODE_MERCENARY)
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/weapon/gun/magnetic/railgun/tcc

/datum/uplink_item/item/visible_weapons/harpoonbomb
	name = "Explosive Harpoon"
	item_cost = 12
	path = /obj/item/weapon/material/harpoon/bomb

/datum/uplink_item/item/visible_weapons/incendiary_laser
	name = "Incendiary Laser Blaster"
	desc = "A laser weapon developed and subsequently banned in Sol space, it sets its targets on fire with dispersed laser technology. \
			Most of these blasters were swiftly bought back and destroyed - but not this one."
	item_cost = 40
	path = /obj/item/weapon/gun/energy/incendiary_laser

/datum/uplink_item/item/visible_weapons/boltaction
	name = "Bolt Action Rifle"
	desc = "For arming your comrades on the cheap!"
	item_cost = 12
	path = /obj/item/weapon/gun/projectile/heavysniper/boltaction
	antag_roles = list(MODE_REVOLUTIONARY)