//UNSC Aegis Crew Outfits

/decl/hierarchy/outfit/job/UNSC_ship/aegistechnician
	name = "UNSC Aegis Engineer"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/technician
	shoes = /obj/item/clothing/shoes/workboots
	belt = /obj/item/weapon/storage/belt/utility/full
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e4)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/aegishelmsman
	name = "UNSC Aegis Helmsman"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/pilot
	shoes =  /obj/item/clothing/shoes/black
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e5)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/aegisbridgecrew
	name = "UNSC Aegis Bridge Crew"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/command
	shoes =  /obj/item/clothing/shoes/black
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e6)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/aegispilot
	name = "UNSC Aegis Pelican Pilot"

	l_ear = /obj/item/device/radio/headset/unsc/pilot
	uniform = /obj/item/clothing/under/unsc/pilot
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/helmet/pilot
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e5)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/aegisjanitor
	name = "UNSC Aegis Janitor"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/logistics
	shoes = /obj/item/clothing/shoes/black
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/aegiscrew
	name = "UNSC Aegis Ship Crew"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/tactical
	shoes = /obj/item/clothing/shoes/black
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e3)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/aegisCO
	name = "UNSC Aegis Commanding Officer"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	belt = /obj/item/weapon/gun/projectile/m6d_magnum
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/officer/o4)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/aegisXO
	name = "UNSC Aegis Executive Officer"

	l_ear = /obj/item/device/radio/headset/unsc/officer
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/officer/o3)

	flags = 0

//UNSC Aegis Medical Staff Outfits

/decl/hierarchy/outfit/job/UNSC_ship/medical
	name = "UNSC Aegis Medical Staff"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/medical
	shoes = /obj/item/clothing/shoes/white
	l_hand = /obj/item/weapon/storage/firstaid/adv
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e4)

	flags = 0


//MARINE Outfits

/decl/hierarchy/outfit/job/UNSC_ship/aegismarine
	name = "UNSC Marine"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	gloves = /obj/item/clothing/gloves/thick/unsc
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/aegismarine_xo
	name = "Marine Platoon Leader"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	l_hand = /obj/item/squad_manager
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	gloves = /obj/item/clothing/gloves/thick/unsc
	starting_accessories = list(/obj/item/clothing/accessory/rank/marine/enlisted/e7)

	flags = 0


//ODST Outfits

/decl/hierarchy/outfit/job/aegisfacil_ODST
	name = "Rifleman"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e4, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTSharpshooter
	name = "Sharpshooter"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e5, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTMedic
	name = "Field Medic"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/fleet/enlisted/e4, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTCQC
	name = "CQC Specialist"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e2, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTengineer
	name = "Combat Engineer"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e3, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTRifleman
	name = "corporal"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e4, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTRifleman2
	name = "sarge"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e5, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTstaffsergeant
	name = "staffsarge"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e6, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTgunnerysergeant
	name = "gunnysarge"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e7, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTFireteamLead
	name = "Fireteam Leader"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e8, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTsecondlieutenant
	name = "Second Lieutenant"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/officer, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTfirstlieutenant
	name = "First Lieutenant"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/officer/o2, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job


/decl/hierarchy/outfit/job/aegisODSTcaptain
	name = "odstCaptain"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/officer/o3, /obj/item/clothing/accessory/ribbon/frontier, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTmajor
	name = "Major"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/officer/o4, /obj/item/clothing/accessory/ribbon/marksman,/obj/item/clothing/accessory/ribbon/frontier,/obj/item/clothing/accessory/ribbon/instructor, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTltcolonel
	name = "LtColonel"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/officer/o5, /obj/item/clothing/accessory/ribbon/marksman,/obj/item/clothing/accessory/ribbon/frontier,/obj/item/clothing/accessory/ribbon/instructor, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/decl/hierarchy/outfit/job/aegisODSTcolonel
	name = "Colonel"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	gloves = /obj/item/clothing/gloves/tactical
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick/combat
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/odst
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/officer/o6, /obj/item/clothing/accessory/ribbon/marksman,/obj/item/clothing/accessory/ribbon/frontier,/obj/item/clothing/accessory/ribbon/instructor, /obj/item/clothing/accessory/holster/thigh, /obj/item/clothing/accessory/badge/tags)

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job