//UNSC Ship Crew Outfits

/decl/hierarchy/outfit/job/UNSC_ship
	name = "UNSC ship"
	hierarchy_type = /decl/hierarchy/outfit/job/UNSC_ship

/decl/hierarchy/outfit/job/UNSC_ship/bertelstechnician
	name = "UNSC Ship Engineer"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/technician
	shoes = /obj/item/clothing/shoes/workboots
	belt = /obj/item/weapon/storage/belt/utility/full
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e4)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/bertelshelmsman
	name = "UNSC Ship Helmsman"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/pilot
	shoes =  /obj/item/clothing/shoes/black
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e5)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/bertelsbridgecrew
	name = "UNSC Ship Bridge Crew"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/command
	shoes =  /obj/item/clothing/shoes/black
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e6)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/bertelspilot
	name = "UNSC Ship Pelican Pilot"

	l_ear = /obj/item/device/radio/headset/unsc/pilot
	uniform = /obj/item/clothing/under/unsc/pilot
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/helmet/pilot
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e5)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/bertelsjanitor
	name = "UNSC Ship Janitor"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/logistics
	shoes = /obj/item/clothing/shoes/black
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/bertelscrew
	name = "UNSC Ship Ship Crew"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/tactical
	shoes = /obj/item/clothing/shoes/black
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e3)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/bertelsCO
	name = "UNSC Ship Commanding Officer"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	belt = /obj/item/weapon/gun/projectile/m6d_magnum
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/officer/o4)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/bertelsXO
	name = "UNSC Ship Executive Officer"

	l_ear = /obj/item/device/radio/headset/unsc/officer
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/officer/o3)

	flags = 0

//UNSC Ship Medical Staff Outfits

/decl/hierarchy/outfit/job/UNSC_ship/medical
	name = "UNSC Ship Medical Staff"

	l_ear = /obj/item/device/radio/headset/unsc
	uniform = /obj/item/clothing/under/unsc/medical
	shoes = /obj/item/clothing/shoes/white
	l_hand = /obj/item/weapon/storage/firstaid/adv
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/enlisted/e4)

	flags = 0


//MARINE Outfits

/decl/hierarchy/outfit/job/UNSC_ship/bertelsmarine
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

/decl/hierarchy/outfit/job/UNSC_ship/bertelsmarine_xo
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

/decl/hierarchy/outfit/job/bertelsfacil_ODST
	name = "Bertels ODST Rifleman"
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

/decl/hierarchy/outfit/job/bertelsODSTSharpshooter
	name = "Bertels ODST Sharpshooter"
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

/decl/hierarchy/outfit/job/bertelsODSTMedic
	name = "Bertels ODST Field Medic"
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

/decl/hierarchy/outfit/job/bertelsODSTCQC
	name = "Bertels ODST CQC Specialist"
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

/decl/hierarchy/outfit/job/bertelsODSTengineer
	name = "Bertels ODST Combat Engineer"
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

/decl/hierarchy/outfit/job/bertelsODSTRifleman
	name = "Bertels ODST corporal"
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

/decl/hierarchy/outfit/job/bertelsODSTRifleman2
	name = "Bertels ODST sarge"
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

/decl/hierarchy/outfit/job/bertelsODSTstaffsergeant
	name = "Bertels ODST staffsarge"
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

/decl/hierarchy/outfit/job/bertelsODSTgunnerysergeant
	name = "Bertels ODST gunnysarge"
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

/decl/hierarchy/outfit/job/bertelsODSTFireteamLead
	name = "Bertels ODST Fireteam Leader"
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

/decl/hierarchy/outfit/job/bertelsODSTsecondlieutenant
	name = "Bertels ODST Second Lieutenant"
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

/decl/hierarchy/outfit/job/bertelsODSTfirstlieutenant
	name = "Bertels ODST First Lieutenant"
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


/decl/hierarchy/outfit/job/bertelsODSTcaptain
	name = "Bertels ODST odstCaptain"
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

/decl/hierarchy/outfit/job/bertelsODSTmajor
	name = "Bertels ODST Major"
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

/decl/hierarchy/outfit/job/bertelsODSTltcolonel
	name = "Bertels ODST LtColonel"
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

/decl/hierarchy/outfit/job/bertelsODSTcolonel
	name = "Bertels ODST Colonel"
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


/decl/hierarchy/outfit/job/URF_commando
	name = "URF Commando"

	//Actual Commando gear is spawned on their ship.
	//head = /obj/item/clothing/head/helmet/urfc
	//suit = /obj/item/clothing/suit/armor/special/urfc
	//gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset/commando
	uniform = /obj/item/clothing/under/tactical
	shoes =  /obj/item/clothing/shoes/black
	starting_accessories = list()

	flags = 0

/decl/hierarchy/outfit/job/URF_commando_officer
	name = "URF Commando Officer"

	head = /obj/item/clothing/head/helmet/urfc/squadleader
	suit = /obj/item/clothing/suit/armor/special/urfc/squadleader
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset/commando
	uniform = /obj/item/clothing/under/urfc_jumpsuit
	shoes = /obj/item/clothing/shoes/magboots/urfc
	starting_accessories = list()

	flags = 0

