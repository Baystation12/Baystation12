//I'm putting, or have put all donator items here to make it x1000 easier to manage and implement. Please put all new donator items here according to the format.

#define ODST_OVERRIDE 'code/modules/halo/clothing/odst.dmi'
#define ITEM_INHAND 'code/modules/halo/clothing/odst_items.dmi'
#define MARINE_OVERRIDE 'code/modules/halo/clothing/marine.dmi'
#define MARINE_INHAND 'code/modules/halo/clothing/marine_items.dmi'
#define URF_HAND 'code/modules/halo/clothing/head.dmi'
#define URF_OVERRIDE 'code/modules/halo/clothing/urf_commando.dmi'


//Obj sprites go in ITEM_INHAND or MARINE_INHAND
//WORN sprites go in ODST_OVERRIDE or MARINE_OVERRIDE

///////Donor Box\\\\\\

//Parent Box - Do not remove!

/obj/item/weapon/storage/box/large/donator
	name = "Snowflake Crate"
	desc = "Contains gear for those special snowflakes."
	w_class = ITEM_SIZE_GARGANTUAN
	max_storage_space = 50
	max_w_class = ITEM_SIZE_GARGANTUAN
	startswith = list()
	can_hold = list()


////////ashvor\\\\\\\\

//Marine

/obj/item/clothing/under/unsc/marine_fatigues/ashvor
	desc = "A variant of the standard issue uniform used with the pressurized Atmospheric/Exoatmospheric armor worn by members of the UNSC Marine Corps"
	name = "UNSC Cross Branch Battle Dress Uniform"
	item_state = "ashvor-uniform"
	icon_state = "ashvor-uniform_obj"
	worn_state = "ashvor-uniform"
	item_state_slots = list(slot_l_hand_str = "ashvor-uniform", slot_r_hand_str = "ashvor-uniform")

/obj/item/clothing/head/helmet/eva/marine/ashvor
	desc = "The ECH252 is an enclosed variant of the standard CH252 helmet. The helmet can be fully enclosed and environmentally sealed,"
	name = "ECH252 Enclosed Helmet"
	item_state = "ashvor-helmet_worn"
	icon_state = "ashvor-helmet_obj"
	item_state_slots = list(slot_l_hand_str = "ashvor-helmet", slot_r_hand_str = "ashvor-helmet")

/obj/item/clothing/suit/spaceeva/eva/ashvor
	desc = "A pressurized Atmospheric/Exoatmospheric (A/X) version of the standard M52 Body Armor, Worn mitigate the atmospheric hazards caused by nearby glassing,"
	name = "M52A/X Body Armor"
	item_state = "ashvor-armor_worn"
	icon_state = "ashvor-armor_obj"
	item_state_slots = list(slot_l_hand_str = "ashvor-armor", slot_r_hand_str = "ashvor-armor")

/obj/item/clothing/gloves/thick/unsc/ashvor
	desc = "The pressurized and sealed combat gloves worn with the A/X armor for the members of the UNSC Marine Corps."
	name = "A/X Combat_Gloves"
	icon = MARINE_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "ashvor-gloves_worn"
	icon_state = "ashvor-gloves_obj"
	item_state_slots = list(slot_l_hand_str = "ashvor-gloves", slot_r_hand_str = "ashvor-gloves")

/obj/item/clothing/shoes/magboots/eva/marine/ashvor
	desc = "The Atmospheric/Exoatmospheric sealed variant of the standard combat boots worn by the members of the UNSC Marine Corps."
	name = "A/X Combat Boots"
	item_state = "ashvor-boots_worn"
	icon_state = "ashvor-boots_obj0"
	icon_base = "ashvor-boots_obj"
	item_state_slots = list(slot_l_hand_str = "ashvor-boots", slot_r_hand_str = "ashvor-boots")

/obj/item/weapon/storage/backpack/odst/regular/ashvor
	desc = "The a softcase backpack with capacity to carry ammunition, tools, and medical supplies. Used by the UNSC Army, Marines, and Air Force."
	name = "UNSC Tactical Backpack"
	item_state = "ashvor-backpack_worn"
	icon_state = "ashvor-backpack_obj"
	item_state_slots = list(slot_l_hand_str = "ashvor-backpack", slot_r_hand_str = "ashvor-backpack")

/obj/item/weapon/gun/projectile/m6d_magnum/ashvor
	name = "\improper M6G Magnum"
	desc = "A UNSC sidearm and one of the variants of Misriah Armory's M6 handgun series. Takes 12.7mm calibre magazines."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "m6g"
	item_state = "m6g"
	fire_sound = 'code/modules/halo/sounds/Magnum_Reach_Fire.wav'
	reload_sound = 'code/modules/halo/sounds/Magnum_Reach_Reload.wav'

	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_belt_str = 'code/modules/halo/weapons/icons/Belt_Weapons.dmi',
		)

/obj/item/weapon/gun/projectile/m6d_magnum/ashvor/update_icon()
	if(ammo_magazine)
		icon_state = "m6g"
	else
		icon_state = "m6g_unloaded"

/obj/item/weapon/storage/box/large/donator/ashvor
	startswith = list(/obj/item/clothing/under/unsc/marine_fatigues/ashvor,
					/obj/item/clothing/suit/spaceeva/eva/ashvor,
					/obj/item/clothing/gloves/thick/unsc/ashvor,
					/obj/item/clothing/shoes/magboots/eva/marine/ashvor,
					/obj/item/clothing/head/helmet/eva/marine/ashvor,
					/obj/item/weapon/storage/backpack/odst/regular/ashvor)
	can_hold = list(/obj/item/clothing/under/unsc/marine_fatigues/ashvor,
					/obj/item/clothing/suit/spaceeva/eva/ashvor,
					/obj/item/clothing/gloves/thick/unsc/ashvor,
					/obj/item/clothing/shoes/magboots/eva/marine/ashvor,
					/obj/item/clothing/head/helmet/eva/marine/ashvor,
					/obj/item/weapon/storage/backpack/odst/regular/ashvor)

/decl/hierarchy/outfit/ashvor_marine
	name = "ashvor - marine"
	uniform = /obj/item/clothing/under/unsc/marine_fatigues/ashvor
	suit = /obj/item/clothing/suit/spaceeva/eva/ashvor
	shoes = /obj/item/clothing/shoes/magboots/eva/marine/ashvor
	gloves = /obj/item/clothing/gloves/thick/unsc/ashvor
	head = /obj/item/clothing/head/helmet/eva/marine/ashvor
	back = /obj/item/weapon/storage/backpack/odst/regular/ashvor

////////caelumz\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/caelumz
	name = "Customized ODST Sniper Helmet"

	item_state = "Odst Helmet Caelum"
	icon_state = "Odst Helmet Caelum"
	item_state_novisr = "Odst Helmet Caelum Transparent"
	icon_state_novisr = "Odst Helmet Caelum Transparent"

/obj/item/clothing/suit/armor/special/odst/donator/caelumz
	name = "Customized ODST Sniper Armour"

	icon_state = "Odst Armor Caelum"

/obj/item/weapon/storage/box/large/donator/caelumz
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/caelumz,
					/obj/item/clothing/suit/armor/special/odst/donator/caelumz
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/caelumz,
					/obj/item/clothing/suit/armor/special/odst/donator/caelumz)

/decl/hierarchy/outfit/caelumz_odst
	name = "caelumz - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/caelumz
	suit = /obj/item/clothing/suit/armor/special/odst/donator/caelumz

//Spartan

/obj/item/clothing/head/helmet/spartan/praetor
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV Praetor"
	icon_state = "caelum-praetor-helm"
	item_state = "caelum-praetor-helm-worn"

/obj/item/clothing/suit/armor/special/spartan/praetor
	name = "MJOLNIR Powered Assault Armor Mark IV Praetor"
	icon_state = "caelum-praetor-armor"
	item_state = "caelum-praetor-armor-worn"

/decl/hierarchy/outfit/caelumz_spartan
	name = "caelumz - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/praetor
	head = /obj/item/clothing/head/helmet/spartan/praetor
	suit_store = /obj/item/weapon/tank/emergency/oxygen/double

////////BurnedSweetPotato\\\\\\\\

//Spartan

/obj/item/clothing/head/helmet/spartan/burnedsweetpotato
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV Burnt"
	icon_state = "burned-spartanhelm_obj"
	item_state = "burned-spartanhelm_worn"
	icon_override = 'code/modules/halo/clothing/spartan_armour_large.dmi'

/obj/item/clothing/suit/armor/special/spartan/burnedsweetpotato
	name = "MJOLNIR Powered Assault Armor Mark IV Burnt"
	icon_state = "burned-spartanarmour_obj"
	item_state = "burned-spartanarmour_worn"
	icon_override = 'code/modules/halo/clothing/spartan_armour_large.dmi'

/decl/hierarchy/outfit/burnedsweetpotato_spartan
	name = "BurnedSweetPotato - Spartan II"
	suit = /obj/item/clothing/suit/armor/special/spartan/burnedsweetpotato
	head = /obj/item/clothing/head/helmet/spartan/burnedsweetpotato
	l_ear = /obj/item/device/radio/headset/unsc/odsto

////////bobatnight\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/bobatnight
	name = "Sal's ODST Helmet"

	item_state = "bobatnight-helmet_worn"
	icon_state = "bobatnight-helmet_obj"
	item_state_novisr = "bobatnight-helmet_worn"
	icon_state_novisr = "bobatnight-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/bobatnight
	name = "Sal's ODST Armour"

	icon_state = "bobatnight-armor_obj"
	item_state = "bobatnight-armor_worn"

/obj/item/weapon/storage/backpack/odst/bobatnight
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Sal's ODST Backpack"
	item_state = "bobatnight-backpack_worn"
	icon_state = "bobatnight-backpack_obj"

/obj/item/weapon/storage/box/large/donator/bobatnight
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/bobatnight,
					/obj/item/clothing/suit/armor/special/odst/donator/bobatnight,
					/obj/item/weapon/storage/backpack/odst/bobatnight
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/bobatnight,
					/obj/item/clothing/suit/armor/special/odst/donator/bobatnight,
					/obj/item/weapon/storage/backpack/odst/bobatnight
					)

/decl/hierarchy/outfit/bobatnight_odst
	name = "bobatnight - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/bobatnight
	suit = /obj/item/clothing/suit/armor/special/odst/donator/bobatnight
	back = /obj/item/weapon/storage/backpack/odst/bobatnight

////////Boltersam\\\\\\\\

//JIRALHANAE

/obj/item/clothing/head/helmet/jiralhanae/covenant/boltersam
	icon_state = "bolter_helm"
/obj/item/clothing/suit/armor/jiralhanae/covenant/boltersam
	icon_state = "bolter_armour"

/obj/item/clothing/shoes/jiralhanae/covenant/boltersam
	icon_state = "bolter_greaves"

/obj/item/weapon/grav_hammer/boltersam
	icon_state = "goremaul"
	item_state_slots = list(slot_l_hand_str = "goremaul", slot_r_hand_str = "goremaul", slot_back_str = "back_maul")

/obj/item/weapon/storage/box/large/donator/boltersam
	startswith = list(/obj/item/clothing/head/helmet/jiralhanae/covenant/boltersam,
					/obj/item/clothing/suit/armor/jiralhanae/covenant/boltersam,
					/obj/item/clothing/shoes/jiralhanae/covenant/boltersam,
					)
	can_hold = list(/obj/item/clothing/head/helmet/jiralhanae/covenant/boltersam,
					/obj/item/clothing/suit/armor/jiralhanae/covenant/boltersam,
					/obj/item/clothing/shoes/jiralhanae/covenant/boltersam,
					)

/decl/hierarchy/outfit/boltersam_jiralhanae
	name = "boltersam - jiralhanae"
	head = /obj/item/clothing/head/helmet/jiralhanae/covenant/boltersam
	suit = /obj/item/clothing/suit/armor/jiralhanae/covenant/boltersam
	shoes = /obj/item/clothing/shoes/jiralhanae/covenant/boltersam
	back = /obj/item/weapon/grav_hammer/boltersam

////////eonoc\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/eonoc
	name = "Barnabus's ODST Helmet"

	item_state = "eonoc-helmet_worn"
	icon_state = "eonoc-helmet_obj"
	item_state_novisr = "eonoc-helmet-open_worn"
	icon_state_novisr = "eonoc-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/eonoc
	name = "Barnabus's ODST Armor"
	icon_state = "eonoc-armor_worn"

/obj/item/weapon/storage/backpack/odst/eonoc
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Barnabus's ODST Backpack"
	item_state = "eonoc-backpack_worn"
	icon_state = "eonoc-backpack_obj"

/obj/item/weapon/storage/box/large/donator/eonoc
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/eonoc,
					/obj/item/clothing/suit/armor/special/odst/donator/eonoc,
					/obj/item/weapon/storage/backpack/odst/eonoc
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/eonoc,
					/obj/item/clothing/suit/armor/special/odst/donator/eonoc,
					/obj/item/weapon/storage/backpack/odst/eonoc
					)

/decl/hierarchy/outfit/eonoc_odst
	name = "eonoc - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/eonoc
	suit = /obj/item/clothing/suit/armor/special/odst/donator/eonoc
	back = /obj/item/weapon/storage/backpack/odst/eonoc

////////eluxor\\\\\\\\

//URFC

/obj/item/clothing/under/urfc_jumpsuit/eluxor
	name = "SOE Commando uniform"
	desc = "Standard issue SOE Commando uniform, more badass than that, you die."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "harun_clothes"
	item_state = "harun_clothes"
	worn_state = "harun_clothes"

/obj/item/clothing/head/helmet/urfccommander/eluxor
	name = "Harun's Turban"
	desc = "A turban made of some kind of resistant material, it has an emblem with an Eagle and a fist on the front."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "harun_turban"
	icon_state = "harun_turban_obj"

/obj/item/clothing/suit/armor/special/urfc/eluxor
	name = "Harun's Custom Armor"
	desc = "A custom made armorset with a cape included, clearly made by an armorsmisth in a very rough and old fashioned way. Clearly made by the Khoros Raiders."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "harun_armor"
	icon_state = "harun_armor_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'

/obj/item/clothing/shoes/magboots/urfc/eluxor
	name = "SOE Magboots"
	desc = "Experimental black magnetic boots, used to ensure the user is safely attached to any surfaces during extra-vehicular operations. They're large enough to be worn over other footwear."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "harun_boots_obj0"
	icon_base = "harun_boots_obj"
	item_state = "harun_boots"

/obj/item/clothing/gloves/soegloves/urfc/eluxor
	name = "SOE Gloves"
	desc = "These  gloves are somewhat fire and impact-resistant."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "harun_gloves"
	icon_state = "harun_gloves_obj"

/obj/item/clothing/mask/gas/soebalaclava/eluxor
	name = "SOE Balaclava"
	desc = "Designed to both hide identities and keep your face comfy and warm, a mask that can be connected to an air supply. Filters harmful gases from the air."
	icon_state = "harun_balaclava"
	item_state = "harun_balaclava"

/obj/item/weapon/storage/box/large/donator/eluxor
	startswith = list(/obj/item/clothing/under/urfc_jumpsuit/eluxor,
					/obj/item/clothing/head/helmet/urfccommander/eluxor,
					/obj/item/clothing/suit/armor/special/urfc/eluxor,
					/obj/item/clothing/shoes/magboots/urfc/eluxor,
					/obj/item/clothing/gloves/soegloves/urfc/eluxor,
					/obj/item/clothing/mask/gas/soebalaclava/eluxor,
					)
	can_hold = list(/obj/item/clothing/under/urfc_jumpsuit/eluxor,
					/obj/item/clothing/head/helmet/urfccommander/eluxor,
					/obj/item/clothing/suit/armor/special/urfc/eluxor,
					/obj/item/clothing/shoes/magboots/urfc/eluxor,
					/obj/item/clothing/gloves/soegloves/urfc/eluxor,
					/obj/item/clothing/mask/gas/soebalaclava/eluxor,
					)

/decl/hierarchy/outfit/eluxor
	name = "eluxor - urfc"
	uniform = /obj/item/clothing/under/urfc_jumpsuit/eluxor
	head = /obj/item/clothing/head/helmet/urfccommander/eluxor
	suit = /obj/item/clothing/suit/armor/special/urfc/eluxor
	gloves = /obj/item/clothing/gloves/soegloves/urfc/eluxor
	shoes = /obj/item/clothing/shoes/magboots/urfc/eluxor
	mask = /obj/item/clothing/mask/gas/soebalaclava/eluxor

////////flaksim\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/flaksim
	name = "Kashada's ODST Helmet"

	item_state = "Odst Helmet Flaksim"
	icon_state = "Odst Helmet Flaksim"
	item_state_novisr = "Odst Helmet Flaksim Transparent"
	icon_state_novisr = "Odst Helmet Flaksim Transparent"

/obj/item/clothing/suit/armor/special/odst/donator/flaksim
	name = "Kashada's ODST Armour"

	icon_state = "Odst Armor Flaksim"

/obj/item/weapon/storage/backpack/odst/donator/flaksim
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Kashada's Backpack"
	item_state = "Odst Flaksim Backpack"
	icon_state = "Odst Flaksim Backpack"

/obj/item/weapon/storage/box/large/donator/flaksim
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/flaksim,
					/obj/item/clothing/suit/armor/special/odst/donator/flaksim,
					/obj/item/weapon/storage/backpack/odst/donator/flaksim
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/flaksim,
					/obj/item/clothing/suit/armor/special/odst/donator/flaksim,
					/obj/item/weapon/storage/backpack/odst/donator/flaksim
					)

/decl/hierarchy/outfit/flaksim_odst
	name = "flaksim - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/flaksim
	suit = /obj/item/clothing/suit/armor/special/odst/donator/flaksim
	back = /obj/item/weapon/storage/backpack/odst/donator/flaksim

//Spartan

/obj/item/clothing/head/helmet/spartan/mkiv_flak
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV Flak"
	icon_state = "SPARTAN-flaksimhelm"
	item_state = "SPARTAN-flaksimhelm-worn"

/obj/item/clothing/suit/armor/special/spartan/mkiv_flak
	name = "MJOLNIR Powered Assault Armor Mark IV Flak"
	icon_state = "SPARTAN-flaksimarmor"
	item_state = "SPARTAN-flaksimarmor-worn"

/decl/hierarchy/outfit/flaksim_spartan
	name = "flaksim - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/mkiv_flak
	head = /obj/item/clothing/head/helmet/spartan/mkiv_flak


//Focks in a bocks

//Spartan

/obj/item/clothing/head/helmet/spartan/mkiv_security
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV Security"
	icon_state = "SPARTAN-morekhelm"
	item_state = "SPARTAN-morekhelm-worn"

/obj/item/clothing/suit/armor/special/spartan/mkiv_security
	name = "MJOLNIR Powered Assault Armor Mark IV Security"
	icon_state = "SPARTAN-morekarmor"
	item_state = "SPARTAN-morekarmor-worn"

/decl/hierarchy/outfit/focks_spartan
	name = "focks - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/mkiv_security
	head = /obj/item/clothing/head/helmet/spartan/mkiv_security

////////Franz\\\\\\\\

//Spartan

/obj/item/clothing/head/helmet/spartan/mkv_franz
	name = "MJOLNIR Powered Assault Armor Helmet Mark V Franz"
	icon_state = "mk5-commandohelm_obj"
	item_state = "mk5-commandohelm_worn"

/obj/item/clothing/suit/armor/special/spartan/mkv_franz
	name = "MJOLNIR Powered Assault Armor Mark V Franz"
	icon_state = "mk5-shell_obj"
	item_state = "mk5-shell_worn"

/decl/hierarchy/outfit/franz_spartan
	name = "franz - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/mkv_franz
	head = /obj/item/clothing/head/helmet/spartan/mkv_franz

////////Gulag\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/gulag
	name = "Murmillo Helmet"
	item_state = "gulag-helmet_worn"
	icon_state = "gulag-helmet_obj"
	item_state_novisr = "gulag-helmet_worn"
	icon_state_novisr = "gulag-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/gulag
	name = "Murmillo Armour"
	icon_state = "gulag-armor_obj"
	item_state = "gulag-armor_worn"

/obj/item/weapon/storage/box/large/donator/gulag
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/gulag,
					/obj/item/clothing/suit/armor/special/odst/donator/gulag
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/gulag,
					/obj/item/clothing/suit/armor/special/odst/donator/gulag
					)

/decl/hierarchy/outfit/gulag_odst
	name = "gulag - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/gulag
	suit = /obj/item/clothing/suit/armor/special/odst/donator/gulag


///////Jul\\\\\\\

//Ship/Oni Crew


/obj/item/clothing/head/dress/Jul
	name = "UNSC Officer Dress Cap"
	item_state = "Jul Jul Cap_worn"
	icon_state = "Jul Jul Cap_obj"
	icon = MARINE_INHAND
	icon_override = MARINE_OVERRIDE
	desc = "A formal cap worn with the UNSC Dress Uniform."

/obj/item/clothing/under/mildress/Jul
	name = "UNSC Officer Dress Uniform"
	item_state = "Jul Jul Dress"
	icon_state = "Jul Jul Dress_obj"
	worn_state = "Jul Jul Dress"
	icon = MARINE_INHAND
	icon_override = MARINE_OVERRIDE
	desc = "A presentable dress uniform worn by UNSC Officers."

/obj/item/clothing/shoes/black/Jul
	name = "UNSC Dress Shoes"
	item_state = "Jul Jul Shoes_worn"
	icon_state = "Jul Jul Shoes_obj"
	icon = MARINE_INHAND
	icon_override = MARINE_OVERRIDE

decl/hierarchy/outfit/Jul
	name = "Jul Waters - officer"
	uniform = /obj/item/clothing/under/mildress/Jul
	shoes = /obj/item/clothing/shoes/black/Jul
	head = /obj/item/clothing/head/dress/Jul
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s


/obj/item/weapon/storage/box/large/donator/Jul
	startswith = list(/obj/item/clothing/head/dress/Jul,
					/obj/item/clothing/shoes/black/Jul,
					/obj/item/clothing/under/mildress/Jul,
					/obj/item/weapon/gun/projectile/m6c_magnum_s
					)
	can_hold = list(/obj/item/clothing/head/dress/Jul,
					/obj/item/clothing/shoes/black/Jul,
					/obj/item/clothing/under/mildress/Jul,
					/obj/item/weapon/gun/projectile/m6c_magnum_s
					)


////////karmac\\\\\\\

//Marine

/obj/item/clothing/head/helmet/marine/karmac
	name = "Marine Hat"
	item_state = "karmac-marinehelmet_worn"
	icon_state = "karmac-marinehelmet_obj"
	desc = "The standard issue combat hat worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."

/obj/item/clothing/suit/storage/marine/karmac
	item_state = "karmac-marine_worn"
	icon_state = "karmac-marine_obj"

//For whatever goddamn reason I can only get jumpsuits to work with the urfc path... If you can change this to /unsc/marine_fatigues/ or whatever it is, please do and tell me what I did wrong -Stingray

/obj/item/clothing/under/unsc/marine_fatigues/karmac
	desc = "Standard issue uniform for UNSC Marine Corps."
	name = "UNSC Marine fatigues"
	item_state = "karmac-uniform"
	icon_state = "karmac-uniform_obj"
	worn_state = "karmac-uniform"

/obj/item/clothing/shoes/marine/karmac
	item_state = "karmac-marineboots_worn"
	icon_state = "karmac-marineboots_obj"

/obj/item/clothing/gloves/thick/unsc/karmac
	icon = MARINE_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "karmac-marinegloves_worn"
	icon_state = "karmac-marinegloves_obj"

/obj/item/weapon/storage/box/large/donator/karmac
	startswith = list(/obj/item/clothing/under/unsc/marine_fatigues/karmac,
					/obj/item/clothing/suit/storage/marine/karmac,
					/obj/item/clothing/shoes/marine/karmac,
					/obj/item/clothing/gloves/thick/unsc/karmac,
					/obj/item/clothing/head/helmet/marine/karmac
					)
	can_hold = list(/obj/item/clothing/under/unsc/marine_fatigues/karmac,
					/obj/item/clothing/suit/storage/marine/karmac,
					/obj/item/clothing/shoes/marine/karmac,
					/obj/item/clothing/gloves/thick/unsc/karmac,
					/obj/item/clothing/head/helmet/marine/karmac
					)

/decl/hierarchy/outfit/karmac_marine
	name = "karmac - marine"
	uniform = /obj/item/clothing/under/unsc/marine_fatigues/karmac
	suit = /obj/item/clothing/suit/storage/marine/karmac
	shoes = /obj/item/clothing/shoes/marine/karmac
	gloves = /obj/item/clothing/gloves/thick/unsc/karmac
	head = /obj/item/clothing/head/helmet/marine/karmac


////////Kelso\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/kelso
	name = "Recon Helmet"

	item_state = "kelso-odst-helmet_worn"
	icon_state = "kelso-odst-helmet_obj"
	item_state_novisr = "kelso-odst-helmet-open_worn"
	icon_state_novisr = "kelso-odst-helmet-open_obj"

/obj/item/clothing/suit/armor/special/odst/donator/kelso
	name = "Recon Armor"

	item_state = "kelso-odst-armor_worn"
	icon_state = "kelso-odst-armor_obj"

/obj/item/weapon/storage/box/large/donator/kelso
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/kelso,
					/obj/item/clothing/suit/armor/special/odst/donator/kelso
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/kelso,
					/obj/item/clothing/suit/armor/special/odst/donator/kelso
					)

/decl/hierarchy/outfit/kelso
	name = "kelso - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/kelso
	suit = /obj/item/clothing/suit/armor/special/odst/donator/kelso

//Spartan

/obj/item/clothing/head/helmet/spartan/mkiv_kelso
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV Recon"
	icon_state = "kelso-spartanhelm_obj"
	item_state = "kelso-spartanhelm_worn"

/obj/item/clothing/suit/armor/special/spartan/mkiv_kelso
	name = "MJOLNIR Powered Assault Armor Mark IV Grenadier"
	icon_state = "kelso-spartanarmor_obj"
	item_state = "kelso-spartanarmor_worn"

/decl/hierarchy/outfit/kelso_spartan
	name = "kelso - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/mkiv_kelso
	head = /obj/item/clothing/head/helmet/spartan/mkiv_kelso

////////Kozi\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/kozi
	name = "Kozi's Hassar Helmet"
	item_state = "kozi-helmet_worn"
	icon_state = "kozi-helmet_obj"
	item_state_novisr = "kozi-helmet_worn"
	icon_state_novisr = "kozi-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/kozi
	name = "Kozi's Hassar Armor"
	icon_state = "kozi-armor_obj"
	item_state = "kozi-armor_worn"

/obj/item/weapon/storage/backpack/odst/kozi
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Kozi's Hassar Backpack"
	item_state = "kozi-backpack_worn"
	icon_state = "kozi-backpack_obj"

/obj/item/weapon/material/machete/kozi
	name = "Hassar Sabre"
	icon_state = "kozi-sabre_obj"
	item_state = "kozi-sabre"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/storage/box/large/donator/kozi
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/kozi,
					/obj/item/clothing/suit/armor/special/odst/donator/kozi,
					/obj/item/weapon/storage/backpack/odst/kozi,
					/obj/item/weapon/material/machete/kozi
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/kozi,
					/obj/item/clothing/suit/armor/special/odst/donator/kozi,
					/obj/item/weapon/storage/backpack/odst/kozi,
					/obj/item/weapon/material/machete/kozi
					)

/decl/hierarchy/outfit/kozi_odst
	name = "kozi - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/kozi
	suit = /obj/item/clothing/suit/armor/special/odst/donator/kozi
	l_hand = /obj/item/weapon/material/machete/kozi
	back = /obj/item/weapon/storage/backpack/odst/kozi

////////liam_gallagher\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/liam_gallagher
	name = "ODST EOD Helmet"

	item_state = "osama-helmet_worn"
	icon_state = "osama-helmet_obj"
	item_state_novisr = "osama-helmet-open_worn"
	icon_state_novisr = "osama-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/liam_gallagher
	name = "ODST EOD Suit"

	icon_state = "osama-armor_worn"

/obj/item/weapon/storage/box/large/donator/liam_gallagher
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/liam_gallagher,
					/obj/item/clothing/suit/armor/special/odst/donator/liam_gallagher
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/liam_gallagher,
					/obj/item/clothing/suit/armor/special/odst/donator/liam_gallagher
					)

/decl/hierarchy/outfit/liam_gallagher_odst
	name = "liam gallagher - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/liam_gallagher
	suit = /obj/item/clothing/suit/armor/special/odst/donator/liam_gallagher

//Marine

/obj/item/clothing/suit/storage/marine/donator/liam_gallagher
	name = "Experimental Marine Armor"

	item_state = "osama-UNSCarmor_worn"

/obj/item/clothing/head/helmet/marine/donator/liam_gallagher
	name = "Experimental Marine Helmet"

	item_state = "osama-UNSChelm_worn"
	icon_state = "osama-UNSChelm_obj"

/obj/item/clothing/under/unsc/marine/marine_fatigues/liam_gallagher
	desc = "A specialized set of fatigues with latches and hooks for a special set of UNSC armor."
	name = "UNSC Experimental Fatigues"
	icon = MARINE_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "osama-UNSCsuit_worn"
	icon_state = "osama-UNSCsuit_worn"
	worn_state = "UNSC Marine Fatiguesold"

/obj/item/weapon/storage/box/large/donator/liam_gallagheralt
	startswith = list(/obj/item/clothing/suit/storage/marine/donator/liam_gallagher,
					/obj/item/clothing/head/helmet/marine/donator/liam_gallagher,
					/obj/item/clothing/under/unsc/marine/marine_fatigues/liam_gallagher
					)
	can_hold = list(/obj/item/clothing/suit/storage/marine/donator/liam_gallagher,
					/obj/item/clothing/head/helmet/marine/donator/liam_gallagher,
					/obj/item/clothing/under/unsc/marine/marine_fatigues/liam_gallagher
					)

////////Loafe\\\\\\\\


//ODST

/obj/item/clothing/head/helmet/odst/donator/loafe
	name = "Loafe's Helmet"
	item_state = "loafe-helmet_worn"
	icon_state = "loafe-helmet_obj"
	item_state_novisr = "loafe-helmet_worn"
	icon_state_novisr = "loafe-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/loafe
	name = "Loafe's Armor"
	icon_state = "loafe-armor_obj"
	item_state = "loafe-armor_worn"

/obj/item/weapon/storage/backpack/odst/loafe
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Loafe's Backpack"
	item_state = "loafe-backpack_worn"
	icon_state = "loafe-backpack_obj"

/obj/item/weapon/storage/box/large/donator/loafe
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/loafe,
					/obj/item/clothing/suit/armor/special/odst/donator/loafe,
					/obj/item/weapon/storage/backpack/odst/loafe
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/loafe,
					/obj/item/clothing/suit/armor/special/odst/donator/loafe,
					/obj/item/weapon/storage/backpack/odst/loafe
					)

/decl/hierarchy/outfit/loafe_odst
	name = "loafe - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/loafe
	suit = /obj/item/clothing/suit/armor/special/odst/donator/loafe
	back = /obj/item/weapon/storage/backpack/odst/loafe

//Spartan

/obj/item/clothing/head/helmet/spartan/liam_gallagher
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV Scarred EVA"
	icon = 'code/modules/halo/clothing/SpartanHussarKit.dmi'
	icon_state = "osama-spartan-helm_obj"
	item_state = "osama-spartan-helm_worn"
	icon_override = 'code/modules/halo/clothing/SpartanHussarKit.dmi'

/obj/item/clothing/suit/armor/special/spartan/liam_gallagher
	name = "MJOLNIR Powered Assault Armor Mark IV Scarred EVA"
	icon = 'code/modules/halo/clothing/SpartanHussarKit.dmi'
	icon_state = "osama-spartan-armor_obj"
	item_state = "osama-spartan-armor_worn"
	icon_override = 'code/modules/halo/clothing/SpartanHussarKit.dmi'

/decl/hierarchy/outfit/liam_gallagher_spartan
	name = "liam_gallagher - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/liam_gallagher
	head = /obj/item/clothing/head/helmet/spartan/liam_gallagher

//Spartan

/obj/item/clothing/head/helmet/spartan/mkv_grenadier
	name = "MJOLNIR Powered Assault Armor Helmet Mark V Grenadier"
	icon_state = "mk5-donorhelm"
	item_state = "mk5-donorhelm-worn"

/obj/item/clothing/suit/armor/special/spartan/mkv_grenadier
	name = "MJOLNIR Powered Assault Armor Mark V Grenadier"
	icon_state = "mk5-donorshell"
	item_state = "mk5-donorshell-worn"

/decl/hierarchy/outfit/liam_gallagher_spartan
	name = "liam_gallagher_spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/mkv_grenadier
	head = /obj/item/clothing/head/helmet/spartan/mkv_grenadier


////////mann\\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/mann
	name = "Mann's ODST Helmet"

	item_state = "mann-odst-helmet_worn"
	icon_state = "mann-odst-helmet_obj"
	item_state_novisr = "mann-odst-helmet-open_worn"
	icon_state_novisr = "mann-odst-helmet-open_obj"

/obj/item/clothing/suit/armor/special/odst/donator/mann
	name = "Mann's ODST Armour"

	icon_state = "mann-odst-armor_obj"
	item_state = "mann-odst-armor_worn"

/obj/item/weapon/gun/projectile/m6c_magnum_s/donator/mann
	name = "\improper Collectors SOCOM"
	desc = "Sporting the profile of an M6C-M, emblazoned cold-blue steel finish, decorated with a golden ODST Shocktrooper insignia on it's Gúta bone-ivory grip, alongside a threaded barrel with a custom-fitted silencer. This gun is a coveted collectors piece, sought after by ODST officers as reminder of the UNSC Bertels. Etched into the blue steel slide on the left side, is an ode to Empires of Humanity’s past, it reads; “VENI, VIDI, VICI”"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "socom-collector"
	item_state = "socom-collector"

/obj/item/weapon/gun/projectile/m6c_magnum_s/donator/mann/update_icon()
	if(ammo_magazine)
		icon_state = "socom-collector"
	else
		icon_state = "socom-collector_unloaded"


/obj/item/weapon/storage/box/large/donator/mann
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/mann,
					/obj/item/clothing/suit/armor/special/odst/donator/mann,
					/obj/item/weapon/gun/projectile/m6c_magnum_s/donator/mann
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/mann,
					/obj/item/clothing/suit/armor/special/odst/donator/mann,
					/obj/item/weapon/gun/projectile/m6c_magnum_s/donator/mann
					)

/decl/hierarchy/outfit/mann_odst
	name = "mann - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/mann
	suit = /obj/item/clothing/suit/armor/special/odst/donator/mann
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s/donator/mann

//Spartan

/obj/item/clothing/head/helmet/spartan/mkv_gungnir_mann
	name = "MJOLNIR Powered Assault Armor Helmet Mark V Gungnir"
	icon_state = "mk5-mistermannhelm"
	item_state = "mk5-mistermannhelm-worn"

/obj/item/clothing/suit/armor/special/spartan/mkv_gungnir_mann
	name = "MJOLNIR Powered Assault Armor Mark V Gungnir"
	icon_state = "mk5-mistermannshell"
	item_state = "mk5-mistermannshell-worn"

/decl/hierarchy/outfit/mann_spartan
	name = "mann - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/mkv_gungnir_mann
	head = /obj/item/clothing/head/helmet/spartan/mkv_gungnir_mann


////////maxattacker\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/maxattacker
	name = "Customized ODST Helmet"

	item_state = "Odst Helmet Maxattacker"
	icon_state = "Odst Helmet Maxattacker"
	item_state_novisr = "Odst Helmet Maxattacker Transparent"
	icon_state_novisr = "Odst Helmet Maxattacker Transparent"

/obj/item/clothing/suit/armor/special/odst/donator/maxattacker
	name = "Customized ODST Recon Armour"

	icon_state = "Odst Armor Maxattacker"

/obj/item/weapon/storage/box/large/donator/maxattacker
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/maxattacker,
					/obj/item/clothing/suit/armor/special/odst/donator/maxattacker
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/maxattacker,
					/obj/item/clothing/suit/armor/special/odst/donator/maxattacker
					)

/decl/hierarchy/outfit/maxattacker_odst
	name = "maxattacker - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/maxattacker
	suit = /obj/item/clothing/suit/armor/special/odst/donator/maxattacker

//ODST - 2

obj/item/clothing/head/helmet/odst/donator/maxattackeralt
	name = "ODST 'Grasshopper' Helmet"
	item_state = "maxattackeralt-helmet_worn"
	icon_state = "maxattackeralt-helmet_obj"
	item_state_novisr = "maxattackeralt-helmet_worn"
	icon_state_novisr = "maxattackeralt-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/maxattackeralt
	name = "ODST 'Thorn' Armour"
	icon_state = "maxattackeralt-armor_obj"
	item_state = "maxattackeralt-armor_worn"

/obj/item/weapon/storage/box/large/donator/maxattackeralt
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/maxattackeralt,
					/obj/item/clothing/suit/armor/special/odst/donator/maxattackeralt
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/maxattackeralt,
					/obj/item/clothing/suit/armor/special/odst/donator/maxattackeralt
					)

/decl/hierarchy/outfit/maxattacker_odst2
	name = "maxattacker - ODST2"
	head = /obj/item/clothing/head/helmet/odst/donator/maxattackeralt
	suit = /obj/item/clothing/suit/armor/special/odst/donator/maxattackeralt

//Spartan

/obj/item/clothing/head/helmet/spartan/mkv_gungnir_navy
	name = "MJOLNIR Powered Assault Armor Helmet Mark V Gungnir"
	icon_state = "mk5-navygungirhelm"
	item_state = "mk5-navygungirhelm-worn"

/obj/item/clothing/suit/armor/special/spartan/mkv_gungnir_navy
	name = "MJOLNIR Powered Assault Armor Mark V Gungnir"
	icon_state = "mk5-navygungirshell"
	item_state = "mk5-navygungirshell-worn"

/decl/hierarchy/outfit/maxattacker_spartan
	name = "maxattacker - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/mkv_gungnir_navy
	head = /obj/item/clothing/head/helmet/spartan/mkv_gungnir_navy
	suit_store = /obj/item/weapon/tank/emergency/oxygen/double

////////MCLOVIN\\\\\\\\

//URFC


/obj/item/clothing/head/helmet/urfc/mclovin
	name = "Jaguar Helmet"

	item_state = "mclovin-jaguar_worn"
	icon_state = "mclovin-jaguar_helmet"

/obj/item/clothing/suit/armor/special/urfc/mclovin
	name = "Jaguar Armour"

	item_state = "mclovin-jaguar_armour_worn"
	icon_state = "mclovin-jaguar_armour_obj"

/obj/item/clothing/head/helmet/zeal/mclovin
	name = "Eagle Helmet"
	desc = "A heavily modified helmet resembling an Eagle"

	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "mclovin-eagle_worn"
	icon_state = "mclovin-eagle_helmet"

/obj/item/clothing/suit/justice/zeal/mclovin/New()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/justice/zeal/mclovin
	name = "Eagle Armour"
	desc = "A heavily modified piece of armour resembling an Eagle"

	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "mclovin-eagle_armour_worn"
	icon_state = "mclovin-eagle_armour_obj"

/obj/item/weapon/material/machete/mclovin
	name = "Aztec Sword"
	desc = "An Aztec sword used to spill the blood of a warrior's enemy."
	icon_state = "mclovin-machete_obj"
	item_state = "mclovin-machete"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/clothing/suit/armor/special/urfc/aztec
	name = "Aztec Armour"

	item_state = "aztecpack_worn"
	icon_state = "aztecpack_obj"

/obj/item/clothing/shoes/magboots/urfc/aztec
	name = "Aztec Boots"

	item_state = "aztecboots_worn"
	icon_state = "scpboots_obj"

/obj/item/clothing/gloves/soegloves/urfc/aztec
	name = "Aztec Gloves"

	item_state = "aztecgloves_worn"
	icon_state = "scpgloves_obj"

/decl/hierarchy/outfit/mclovin_urfc
	name = "mclovin - urfc"
	head = /obj/item/clothing/head/helmet/urfc/mclovin
	suit = /obj/item/clothing/suit/armor/special/urfc/mclovin
	l_hand = /obj/item/weapon/material/machete/mclovin

/obj/item/weapon/storage/box/large/donator/mclovin_urfc
	startswith = list(/obj/item/clothing/head/helmet/urfc/mclovin,
					/obj/item/clothing/suit/armor/special/urfc/mclovin,
					/obj/item/weapon/material/machete/mclovin
					)
	can_hold = list(/obj/item/clothing/head/helmet/urfc/mclovin,
					/obj/item/clothing/suit/armor/special/urfc/mclovin,
					/obj/item/weapon/material/machete/mclovin
					)

/decl/hierarchy/outfit/mclovin_zeal
	name = "mclovin - zeal"
	head = /obj/item/clothing/head/helmet/zeal/mclovin
	suit = /obj/item/clothing/suit/justice/zeal/mclovin
	l_hand = /obj/item/weapon/material/machete/mclovin

/obj/item/weapon/storage/box/large/donator/mclovin_zeal
	startswith = list(/obj/item/clothing/head/helmet/zeal/mclovin,
					/obj/item/clothing/suit/justice/zeal/mclovin,
					/obj/item/weapon/material/machete/mclovin
					)
	can_hold = list(/obj/item/clothing/head/helmet/zeal/mclovin,
					/obj/item/clothing/suit/justice/zeal/mclovin,
					/obj/item/weapon/material/machete/mclovin
					)

/decl/hierarchy/outfit/mclovin_aztec
	name = "mclovin - aztec"
	head = /obj/item/clothing/head/helmet/zeal/mclovin
	suit = /obj/item/clothing/suit/justice/zeal/mclovin
	l_hand = /obj/item/weapon/material/machete/mclovin

/obj/item/weapon/storage/box/large/donator/aztec
	startswith = list(/obj/item/clothing/suit/armor/special/urfc/aztec,
					/obj/item/clothing/shoes/magboots/urfc/aztec,
					/obj/item/clothing/gloves/soegloves/urfc/aztec
					)
	can_hold = list(/obj/item/clothing/suit/armor/special/urfc/aztec,
					/obj/item/clothing/shoes/magboots/urfc/aztec,
					/obj/item/clothing/gloves/soegloves/urfc/aztec
					)


////////Moerk\\\\\\\\

//ODST

obj/item/clothing/head/helmet/odst/donator/moerk
	name = "Moerk's ODST Helmet"

	item_state = "Odst Helmet Moerk"
	icon_state = "Odst Helmet Moerk"
	item_state_novisr = "Odst Helmet Moerk"
	icon_state_novisr = "Odst Helmet Moerk"

/obj/item/clothing/suit/armor/special/odst/donator/moerk
	name = "Moerk's Customized ODST Armour"

	icon_state = "Odst Armor Moerk"

/obj/item/weapon/storage/box/large/donator/moerk
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/moerk,
					/obj/item/clothing/suit/armor/special/odst/donator/moerk
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/moerk,
					/obj/item/clothing/suit/armor/special/odst/donator/moerk
					)

/decl/hierarchy/outfit/moerk_odst
	name = "moerk - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/moerk
	suit = /obj/item/clothing/suit/armor/special/odst/donator/moerk

////////M.Green/Dogler\\\\\\\\

//Sangheili

/obj/item/clothing/head/helmet/sangheili/dogler
	name = "Sya'tenee's Sangheili Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon_state = "dogler_helm_obj"
	item_state = "dogler_helm"

/obj/item/clothing/suit/armor/special/combatharness/dogler
	name = "Sya'tenee's Sangheili Combat Harness"
	icon_state = "dogler_chest_obj"
	item_state = "dogler_chest"
	totalshields = 125

/obj/item/clothing/shoes/sangheili/dogler
	name = "Sya'tenee's Sanghelli Leg Armour"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "dogler_legs_obj"
	item_state = "dogler_legs"

/obj/item/clothing/gloves/thick/sangheili/dogler
	name = "Sya'tenee's Sanghelli Combat Gauntlets"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "dogler_gloves_obj"
	item_state = "dogler_gloves"

/obj/item/weapon/storage/box/large/donator/dogler
	startswith = list(/obj/item/clothing/head/helmet/sangheili/dogler,
					/obj/item/clothing/suit/armor/special/combatharness/dogler,
					/obj/item/clothing/shoes/sangheili/dogler,
					/obj/item/clothing/gloves/thick/sangheili/dogler
					)
	can_hold = list(/obj/item/clothing/head/helmet/sangheili/dogler,
					/obj/item/clothing/suit/armor/special/combatharness/dogler,
					/obj/item/clothing/shoes/sangheili/dogler,
					/obj/item/clothing/gloves/thick/sangheili/dogler
					)

/decl/hierarchy/outfit/dogler_sangheili
	name = "dogler/m.green - sangheili"
	suit = /obj/item/clothing/suit/armor/special/combatharness/dogler
	suit_store = /obj/item/weapon/gun/energy/plasmarifle
	back = /obj/item/weapon/gun/energy/plasmarifle
	belt = /obj/item/weapon/gun/energy/plasmapistol
	gloves = /obj/item/clothing/gloves/thick/sangheili/dogler
	shoes = /obj/item/clothing/shoes/sangheili/dogler
	head = /obj/item/clothing/head/helmet/sangheili/dogler
	l_pocket = /obj/item/weapon/grenade/plasma

////////NANU\\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/nanu
	name = "ODST Snow Variant Mk-3 Helmet"

	item_state = "nanu-helmet_worn"
	icon_state = "nanu-helmet_obj"
	item_state_novisr = "nanu-helmet-open_worn"
	icon_state_novisr = "nanu-helmet-open_obj"

/obj/item/clothing/suit/armor/special/odst/donator/nanu
	name = "ODST Snow Variant Mk-3 Armor"
	desc = "The Mk3 armor was made to give more camouflage in cold and artic environments due to its special nature of being extra insulated against the elements and is therefore also made for prolonged exposure to space."

	item_state = "nanu-armor_worn"
	icon_state = "nanu-armor_obj"

/obj/item/weapon/storage/backpack/odst/nanu
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "ODST Snow Variant Mk-3 Armor Backpack"
	item_state = "nanu-backpack_worn"
	icon_state = "nanu-backpack_obj"

/obj/item/weapon/storage/box/large/donator/nanu
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/nanu,
					/obj/item/clothing/suit/armor/special/odst/donator/nanu,
					/obj/item/weapon/storage/backpack/odst/nanu
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/nanu,
					/obj/item/clothing/suit/armor/special/odst/donator/nanu,
					/obj/item/weapon/storage/backpack/odst/nanu
					)

/decl/hierarchy/outfit/nanu
	name = "nanu - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/nanu
	suit = /obj/item/clothing/suit/armor/special/odst/donator/nanu
	back = /obj/item/weapon/storage/backpack/odst/nanu

////////PANTAS\\\\\\\\

//URFC


/obj/item/clothing/head/helmet/urfc/pantas
	name = "Darko's SoE Combat Engineer Helmet"
	desc = "A simple helmet. Despite the old age, a lot of work has been put into adding additional armor and refining the base processes. It's quite heavy, but a lot of soft material has been added to the inside to make the metal more comfy. Outdated, but can be expected in combat engagements to perform on par with modern equipment, due to the extensive modifications."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "pantas_soe_helmet_worn"
	icon_state = "pantas_soe_helmet_obj"
	item_state_slots = list(slot_l_hand_str = "pantas_soe_helmet_worn", slot_r_hand_str = "pantas_soe_helmet_worn")

/obj/item/clothing/suit/armor/special/urfc/pantas
	name = "Darko's SoE Combat Engineer Armor"
	desc = "A bulletproof vest. Filled with pouches and storage compartments, while still keeping a scary amount of both mobility and protection. An ideal collage of the strengths of the URF, but with the added protection found only in high tier UNSC equipment. It's quite comfy, probably won't last long in space."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "pantas_soe_armor_worn"
	icon_state = "pantas_soe_armor_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state_slots = list(slot_l_hand_str = "pantas_soe_armor_worn", slot_r_hand_str = "pantas_soe_armor_worn")

/obj/item/clothing/head/helmet/soe/pantas
	name = "SOE Venerator Helmet"
	desc = "Non-Standard issue short-EVA capable helmet issued to commandos."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "pantas_soe_space_helmet_worn"
	icon_state = "pantas_soe_space_helmet_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state_slots = list(slot_l_hand_str = "pantas_soe_space_helmet_worn", slot_r_hand_str = "pantas_soe_space_helmet_worn")

obj/item/clothing/suit/armor/special/soe/pantas
	name = "SOE Venerator Armor"
	desc = "Heavyweight, somewhat durable armour issued to commandos for increased survivability in space."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state = "pantas_soe_spacesuit_worn"
	icon_state = "pantas_soe_spacesuit_obj"
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	item_state_slots = list(slot_l_hand_str = "pantas_soe_spacesuit_worn", slot_r_hand_str = "pantas_soe_spacesuit_worn")

/obj/item/weapon/material/machete/pantascmdo
	name = "Judgement of Eridanus"
	desc = "A Holy-Looking sword used to Judge the enemies of Eridanus"
	icon_state = "pantascmdo-machete_obj"
	item_state = "pantascmdo-machete"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/br85/pantasma3
	name = "Ancient AK-47"
	desc = "An ancient weapon used in forgettable times. How does it even still work?"
	icon_state = "pantasAK47"
	item_state = "pantasAK47"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

/obj/item/weapon/gun/projectile/br85/pantasma3/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = "pantasAK47"
	else
		icon_state = "pantasAK47_unloaded"

/obj/item/weapon/tank/jetpack/void/urfc/pantas
	icon_state = "pantas_soe_airtank_obj"
	item_state = "pantas_soe_airtank_worn"

/obj/item/weapon/storage/box/large/donator/pantas_urfc
	startswith = list(/obj/item/clothing/head/helmet/urfc/pantas,
					/obj/item/clothing/suit/armor/special/urfc/pantas,
					/obj/item/clothing/head/helmet/soe/pantas,
					/obj/item/clothing/suit/armor/special/soe/pantas,
					/obj/item/weapon/material/machete/pantascmdo,
					/obj/item/weapon/gun/projectile/br85/pantasma3,
					/obj/item/weapon/tank/jetpack/void/urfc/pantas
					)
	can_hold = list(/obj/item/clothing/head/helmet/urfc/pantas,
					/obj/item/clothing/suit/armor/special/urfc/pantas,
					/obj/item/clothing/head/helmet/soe/pantas,
					/obj/item/clothing/suit/armor/special/soe/pantas,
					/obj/item/weapon/material/machete/pantascmdo,
					/obj/item/weapon/gun/projectile/br85/pantasma3,
					/obj/item/weapon/tank/jetpack/void/urfc/pantas
					)

/decl/hierarchy/outfit/pantas_urfc
	name = "pantas - urfc"
	head = /obj/item/clothing/head/helmet/urfc/pantas
	suit = /obj/item/clothing/suit/armor/special/urfc/pantas
	l_hand = /obj/item/weapon/material/machete/pantascmdo
	r_hand = /obj/item/weapon/gun/projectile/br85/pantasma3

/decl/hierarchy/outfit/pantas_soe
	name = "pantas - soe"
	head = /obj/item/clothing/head/helmet/soe/pantas
	suit = /obj/item/clothing/suit/armor/special/urfc/pantas
	l_hand = /obj/item/weapon/material/machete/pantascmdo
	r_hand = /obj/item/weapon/gun/projectile/br85/pantasma3
	back = /obj/item/weapon/tank/jetpack/void/urfc/pantas

//SANGHEILI (MINOR)

// Scribe Minor

/obj/item/clothing/head/helmet/sangheili/minor/pantas
	name = "Sangheili Helmet (Scribe Minor)"
	icon_state = "pantas2_helm_obj"
	item_state = "pantas2_helm"

/obj/item/clothing/suit/armor/special/combatharness/minor/pantas
	name = "Sangheili Combat Harness (Scribe Minor)"
	icon_state = "pantas2_chest_obj"
	item_state = "pantas2_chest"

/obj/item/clothing/shoes/sangheili/minor/pantas
	name = "Sanghelli Leg Armour (Scribe Minor)"
	icon_state = "pantas2_legs_obj"
	item_state = "pantas2_legs"

/obj/item/clothing/gloves/thick/sangheili/minor/pantas
	name = "Sanghelli Combat Gauntlets (Scribe Minor)"
	icon_state = "pantas2_gloves_obj"
	item_state = "pantas2_gloves"

/obj/item/weapon/storage/box/large/donator/pantas_minor
	startswith = list(/obj/item/clothing/suit/armor/special/combatharness/minor/pantas,
					/obj/item/clothing/shoes/sangheili/minor/pantas,
					/obj/item/clothing/gloves/thick/sangheili/minor/pantas,
					/obj/item/clothing/head/helmet/sangheili/minor/pantas
					)
	can_hold = list(/obj/item/clothing/suit/armor/special/combatharness/minor/pantas,
					/obj/item/clothing/shoes/sangheili/minor/pantas,
					/obj/item/clothing/gloves/thick/sangheili/minor/pantas,
					/obj/item/clothing/head/helmet/sangheili/minor/pantas
					)

/decl/hierarchy/outfit/pantas_sangheili_minor
	name = "pantas - sangheili minor"
	suit = /obj/item/clothing/suit/armor/special/combatharness/minor/pantas
	back = /obj/item/weapon/gun/energy/plasmarifle
	belt = /obj/item/weapon/gun/energy/plasmapistol
	gloves = /obj/item/clothing/gloves/thick/sangheili/minor/pantas
	shoes = /obj/item/clothing/shoes/sangheili/minor/pantas
	head = /obj/item/clothing/head/helmet/sangheili/minor/pantas
	mask = null
	l_pocket = /obj/item/weapon/grenade/plasma
	r_pocket = null

//SANGHEILI (MAJOR)

/obj/item/clothing/head/helmet/sangheili/major/pantas
	name = "Sangheili Helmet (Berserker Major)"
	icon_state = "pantas_helm_obj"
	item_state = "pantas_helm"

/obj/item/clothing/suit/armor/special/combatharness/major/pantas
	name = "Sangheili Combat Harness (Berserker Major)"
	icon_state = "pantas_chest_obj"
	item_state = "pantas_chest"

/obj/item/clothing/shoes/sangheili/major/pantas
	name = "Sanghelli Leg Armour (Berserker Major)"
	icon_state = "pantas_legs_obj"
	item_state = "pantas_legs"

/obj/item/clothing/gloves/thick/sangheili/major/pantas
	name = "Sanghelli Combat Gauntlets (Berserker Major)"
	icon_state = "pantas_gloves_obj"
	item_state = "pantas_gloves"

/obj/item/weapon/storage/box/large/donator/pantas_major
	startswith = list(/obj/item/clothing/suit/armor/special/combatharness/major/pantas,
					/obj/item/clothing/gloves/thick/sangheili/major/pantas,
					/obj/item/clothing/shoes/sangheili/major/pantas,
					/obj/item/clothing/head/helmet/sangheili/major/pantas
					)
	can_hold = list(/obj/item/clothing/suit/armor/special/combatharness/major/pantas,
					/obj/item/clothing/gloves/thick/sangheili/major/pantas,
					/obj/item/clothing/shoes/sangheili/major/pantas,
					/obj/item/clothing/head/helmet/sangheili/major/pantas
					)

/decl/hierarchy/outfit/pantas_sangheili_major
	name = "pantas - sangheili major"
	suit = /obj/item/clothing/suit/armor/special/combatharness/major/pantas
	suit_store = /obj/item/weapon/gun/energy/plasmarifle
	back = /obj/item/weapon/gun/energy/plasmarifle
	belt = /obj/item/weapon/gun/energy/plasmapistol
	gloves = /obj/item/clothing/gloves/thick/sangheili/major/pantas
	shoes = /obj/item/clothing/shoes/sangheili/major/pantas
	head = /obj/item/clothing/head/helmet/sangheili/major/pantas
	l_pocket = /obj/item/weapon/grenade/plasma

////////Pinstripe\\\\\\\\

//ODST

obj/item/clothing/head/helmet/odst/donator/pinstripe
	name = "Pinstripe's ODST Helmet"
	item_state = "pinstripe-helmet_worn"
	icon_state = "pinstripe-helmet_obj"
	item_state_novisr = "pinstripe-helmet_worn"
	icon_state_novisr = "pinstripe-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/pinstripe
	name = "Pinstripe's ODST Armour"
	icon_state = "pinstripe-armor_obj"
	item_state = "pinstripe-armor_worn"

/obj/item/weapon/storage/box/large/donator/pinstripe
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/pinstripe,
					/obj/item/clothing/suit/armor/special/odst/donator/pinstripe
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/pinstripe,
					/obj/item/clothing/suit/armor/special/odst/donator/pinstripe
					)

/decl/hierarchy/outfit/pinstripe_odst
	name = "pinstripe - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/pinstripe
	suit = /obj/item/clothing/suit/armor/special/odst/donator/pinstripe

//Spartan

/obj/item/clothing/head/helmet/spartan/pinstripe
	name = "MJOLNIR Powered Assault Armor Helmet Mark VI"
	icon_state = "pinstripe-spartanhelm_obj"
	item_state = "pinstripe-spartanhelm_worn"

/obj/item/clothing/suit/armor/special/spartan/pinstripe
	name = "MJOLNIR Powered Assault Armor Mark VI"
	icon_state = "pinstripe-spartanarmor_obj"
	item_state = "pinstripe-spartanarmor_worn"

/decl/hierarchy/outfit/pinstripe_spartan
	name = "pinstripe - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/pinstripe
	head = /obj/item/clothing/head/helmet/spartan/pinstripe

////////ragnarok\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/ragnarok
	name = "Bishop's ODST Helmet"

	item_state = "ragnarok-helmet_worn"
	icon_state = "ragnarok-helmet_obj"
	item_state_novisr = "ragnarok-helmet-open_worn"
	icon_state_novisr = "ragnarok-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/ragnarok
	name = "Bishop's ODST Armour"

	icon_state = "ragnarok-armor_worn"

/obj/item/weapon/storage/box/large/donator/ragnarok
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/ragnarok,
					/obj/item/clothing/suit/armor/special/odst/donator/ragnarok
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/ragnarok,
					/obj/item/clothing/suit/armor/special/odst/donator/ragnarok
					)

/decl/hierarchy/outfit/ragnarok_odst
	name = "ragnarok - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/ragnarok
	suit = /obj/item/clothing/suit/armor/special/odst/donator/ragnarok

////////Sleepy Retard\\\\\\\\

//Marine

/obj/item/clothing/head/helmet/marine/sleepy_retard
	name = "UNSC Patrol Cap"
	item_state = "sleepy-marinehelmet_worn"
	icon_state = "sleepy-marinehelmet_obj"
	desc = "A comfortable and effective way to attract gunfire towards the head. This one is lightly faded."

/obj/item/clothing/suit/storage/marine/sleepy_retard
	name = "M52B-S Body Armour"
	desc = "A variant of the standard issue M52B armour, with plating removed, allowing greater freedom of movement."
	item_state = "sleepy-marine_worn"
	icon_state = "sleepy-marine_obj"

/obj/item/clothing/under/unsc/marine_fatigues/sleepy_retard
	desc = "Standard issue uniform for UNSC Marine Corps."
	name = "UNSC Marine fatigues"
	item_state = "sleepy-uniform"
	icon_state = "sleepy-uniform_obj"
	worn_state = "sleepy-uniform"

/obj/item/clothing/shoes/marine/sleepy_retard
	name = "VZG-S Armored Boots."
	desc = "A variant of the standard issue VZG7 armoured boots, this one has trimmed ankle guards."
	item_state = "sleepy-marineboots_worn"
	icon_state = "sleepy-marineboots_obj"

/obj/item/clothing/gloves/thick/unsc/sleepy_retard
	name = "UNSC Custom Gloves:"
	desc = "Standard issue UNSC gloves, but with a coarse material for better grip. Or just poor materials."
	icon = MARINE_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "sleepy-gloves_worn"
	icon_state = "sleepy-gloves_obj"

/obj/item/clothing/mask/marine/sleepy_retard
	name = "UNSC Bandana"
	desc = "A UNSC issued rag that is used to conceal one's identity, and to look untrustworthy."
	icon = MARINE_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "sleepybandana"
	icon_state = "sleepybandana"
	flags_inv = null

/obj/item/weapon/storage/box/large/donator/sleepy_marine
	startswith = list(/obj/item/clothing/under/unsc/marine_fatigues/sleepy_retard,
					/obj/item/clothing/mask/marine/sleepy_retard,
					/obj/item/clothing/suit/storage/marine/sleepy_retard,
					/obj/item/clothing/shoes/marine/sleepy_retard,
					/obj/item/clothing/head/helmet/marine/sleepy_retard,
					/obj/item/clothing/gloves/thick/unsc/sleepy_retard
					)
	can_hold = list(/obj/item/clothing/under/unsc/marine_fatigues/sleepy_retard,
					/obj/item/clothing/mask/marine/sleepy_retard,
					/obj/item/clothing/suit/storage/marine/sleepy_retard,
					/obj/item/clothing/shoes/marine/sleepy_retard,
					/obj/item/clothing/head/helmet/marine/sleepy_retard,
					/obj/item/clothing/gloves/thick/unsc/sleepy_retard)


/decl/hierarchy/outfit/sleepy_marine
	name = "sleepy - marine"
	uniform = /obj/item/clothing/under/unsc/marine_fatigues/sleepy_retard
	mask = /obj/item/clothing/mask/marine/sleepy_retard
	suit = /obj/item/clothing/suit/storage/marine/sleepy_retard
	shoes = /obj/item/clothing/shoes/marine/sleepy_retard
	gloves = /obj/item/clothing/gloves/thick/unsc/sleepy_retard
	head = /obj/item/clothing/head/helmet/marine/sleepy_retard

//ODST

/obj/item/clothing/head/helmet/odst/engineer/sleepy
	name = "ODST Mechanist Helmet"
	desc = "Standard issue short-EVA capable helmet issued to ODST forces. This one is highlighted yellow, in accordance to the now-defunct Mechanist Corps."
	item_state = "sleepy odst-helmet_worn"
	icon_state = "sleepy odst-helmet_obj"
	item_state_novisr = "sleepy odst-helmet-open_worn"
	icon_state_novisr = "sleepy odst-helmet-open_obj"

/obj/item/clothing/suit/armor/special/odst/sleepy
	name = "ODST Mechanist Armour"
	desc = "Lightweight, durable armour issued to Orbital Drop Shock Troopers for increased survivability in the field. This one is highlighted yellow, in accordance to the now-defunct Mechanist Corps."
	item_state = "sleepy odst-armor_worn"
	icon_state = "sleepy odst-armour_obj"

/obj/item/weapon/storage/backpack/odst/sleepy
	name = "ODST Servo Arm Carriage"
	desc = "Standard issue Servo Arm Carriage for the ODST Mechanist Corps. The servo arm seems to be staring at you, with an intense smug aura. No eyes are seen."
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	item_state = "sleepy odst-backpack_worn"
	icon_state = "sleepy odst-backpack_obj"

/obj/item/weapon/gun/projectile/m6c_magnum_s/donator/sleepy
	name = "\improper M6G Golden Magnum"
	desc = "A luxury firearm obtained by paycutting your fellow ODSTs."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "m6gold"
	item_state = "m6gold"
	hitsound = 'code/modules/halo/sounds/hurtflesh2.ogg'

/obj/item/weapon/gun/projectile/m6c_magnum_s/donator/sleepy/update_icon()
	if(ammo_magazine)
		icon_state = "m6gold"
	else
		icon_state = "m6gold_unloaded"


/obj/item/weapon/storage/box/large/donator/sleepy
	startswith = list(/obj/item/clothing/suit/armor/special/odst/sleepy,
					/obj/item/clothing/head/helmet/odst/engineer/sleepy,
					/obj/item/weapon/storage/backpack/odst/sleepy)

/decl/hierarchy/outfit/sleepy_odst
	name = "sleepy - odst Mechanist"
	suit = /obj/item/clothing/suit/armor/special/odst/sleepy
	head = /obj/item/clothing/head/helmet/odst/engineer/sleepy
	back = /obj/item/weapon/storage/backpack/odst/sleepy

////////Spartankiller\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/spartan
	name = "Spartan's ODST Helmet"

	item_state = "Odst Helmet Spartan"
	icon_state = "Odst Helmet Spartan"
	item_state_novisr = "Odst Helmet Spartan Transparent"
	icon_state_novisr = "Odst Helmet Spartan Transparent"

/obj/item/clothing/suit/armor/special/odst/donator/spartan
	name = "Customized ODST CQB Armour"

	icon_state = "Odst Armor Spartan"

/obj/item/weapon/storage/backpack/odst/donator/spartan
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Spartan's Backpack"
	item_state = "Odst Spartan Backpack"
	icon_state = "Odst Spartan Backpack"

/decl/hierarchy/outfit/spartan_odst
	name = "spartan - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/spartan
	suit = /obj/item/clothing/suit/armor/special/odst/donator/spartan
	back = /obj/item/weapon/storage/backpack/odst/donator/spartan

//Spartan

/obj/item/clothing/head/helmet/spartan/spartan_killer
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV Scarred EVA"
	icon_state = "spartankiller-spartanhelm_obj"
	item_state = "spartankiller-spartanhelm_worn"

/obj/item/clothing/suit/armor/special/spartan/spartan_killer
	name = "MJOLNIR Powered Assault Armor Mark IV Scarred EVA"
	icon_state = "spartankiller-spartanarmor_obj"
	item_state = "spartankiller-spartanarmor_worn"

/decl/hierarchy/outfit/spartan_spartan
	name = "spartan - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan
	head = /obj/item/clothing/head/helmet/spartan

////////Socks\\\\\\\\

//URFC

/obj/item/clothing/head/helmet/urfc/socks
	name = "H34D Dome Protector (TEXUS)"

	item_state = "socks-helmet_worn"
	icon_state = "socks-helmet_obj"

/obj/item/clothing/suit/armor/special/urfc/socks
	name = "I25B Heavy Chest Rig (TEXUS)"

	item_state = "socks-armor_worn"
	icon_state = "socks-armor_obj"

/obj/item/clothing/under/urfc_jumpsuit/socks
	name = "Eridanus Uniform (TEXUS)"

	item_state = "socks-jumpsuit_worn"
	icon_state = "socks-jumpsuit_obj"

/obj/item/clothing/shoes/magboots/urfc/socks
	name = "F76F Mag Boots (TEXUS)"

	item_state = "socks-boots_worn"
	icon_state = "socks-boots_obj"

/obj/item/weapon/storage/box/large/donator/socks
	startswith = list(/obj/item/clothing/head/helmet/urfc/socks,
					/obj/item/clothing/suit/armor/special/urfc/socks,
					/obj/item/clothing/under/urfc_jumpsuit/socks,
					/obj/item/clothing/shoes/magboots/urfc/socks
					)
	can_hold = list(/obj/item/clothing/head/helmet/urfc/socks,
					/obj/item/clothing/suit/armor/special/urfc/socks,
					/obj/item/clothing/under/urfc_jumpsuit/socks,
					/obj/item/clothing/shoes/magboots/urfc/socks
					)

/decl/hierarchy/outfit/socks_urfc
	name = "socks - URFC"
	uniform = /obj/item/clothing/under/urfc_jumpsuit/socks
	shoes = /obj/item/clothing/shoes/magboots/urfc/socks
	head = /obj/item/clothing/head/helmet/urfc/socks
	suit = /obj/item/clothing/suit/armor/special/urfc/socks

//Spartan

/obj/item/clothing/head/helmet/spartan/mkiv_domeprotector
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV Special Issue Dome Protector"
	icon_state = "socks-spartanhelm_obj"
	item_state = "socks-spartanhelm_worn"

/obj/item/clothing/suit/armor/special/spartan/mkiv_domeprotector
	name = "MJOLNIR Powered Assault Armor Mark IV Special Issue Body Rig"
	icon_state = "socks-spartanarmor_obj"
	item_state = "socks-spartanarmor_worn"

/decl/hierarchy/outfit/socks_spartan
	name = "socks - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/mkiv_domeprotector
	head = /obj/item/clothing/head/helmet/spartan/mkiv_domeprotector

//Sangheili (MAJOR)

/obj/item/clothing/head/helmet/sangheili/socks
	name = "‘Nasan Clan - Bluekro Sangheili Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon_state = "socks_helm_obj"
	item_state = "socks_helm"

/obj/item/clothing/suit/armor/special/combatharness/socks
	name = "‘Nasan Clan - Bluekro Combat Harness"
	icon_state = "socks_chest_obj"
	item_state = "socks_chest"
	totalshields = 125

/obj/item/clothing/shoes/sangheili/socks
	name = "‘Nasan Clan - Bluekro Leg Armour"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "socks_legs_obj"
	item_state = "socks_legs"

/obj/item/clothing/gloves/thick/sangheili/socks
	name = "‘Nasan Clan - Bluekro Gauntlets"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "socks_gloves_obj"
	item_state = "socks_gloves"

/obj/item/weapon/storage/box/large/donator/socks_major
	startswith = list(/obj/item/clothing/head/helmet/sangheili/socks,
					/obj/item/clothing/suit/armor/special/combatharness/socks,
					/obj/item/clothing/shoes/sangheili/socks,
					/obj/item/clothing/gloves/thick/sangheili/socks
					)
	can_hold = list(/obj/item/clothing/head/helmet/sangheili/socks,
					/obj/item/clothing/suit/armor/special/combatharness/socks,
					/obj/item/clothing/shoes/sangheili/socks,
					/obj/item/clothing/gloves/thick/sangheili/socks
					)

/decl/hierarchy/outfit/socks_sangheili
	name = "socks - sangheili"
	suit = /obj/item/clothing/suit/armor/special/combatharness/socks
	suit_store = /obj/item/weapon/gun/energy/plasmarifle
	back = /obj/item/weapon/gun/energy/plasmarifle
	belt = /obj/item/weapon/gun/energy/plasmapistol
	gloves = /obj/item/clothing/gloves/thick/sangheili/socks
	shoes = /obj/item/clothing/shoes/sangheili/socks
	head = /obj/item/clothing/head/helmet/sangheili/socks
	l_pocket = /obj/item/weapon/grenade/plasma

////////Stingray\\\\\\\\

//Spartan

/obj/item/clothing/head/helmet/spartan/stingray
	name = "Ryan-074's MJOLNIR Powered Assault Armour Helmet"
	desc = "Ave, Imperator, morituri te salutant."
	icon_state = "stingray-spartanhelm_obj"
	item_state = "stingray-spartanhelm_worn"

/obj/item/clothing/suit/armor/special/spartan/stingray
	name = "Ryan-074's MJOLNIR Powered Assault Armour"
	desc = "a technologically-advanced combat exoskeleton system designed to vastly improve the strength, speed, agility, reflexes and durability of a SPARTAN-II, supersoldier in the field of combat.This one appears to have been heavily modified per the user's tactical needs."
	icon_state = "stingray-spartanarmor_obj"
	item_state = "stingray-spartanarmor_worn"

/decl/hierarchy/outfit/stingray_spartan
	name = "stingray - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/stingray
	head = /obj/item/clothing/head/helmet/spartan/stingray

////////wehraboo\\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/wehraboo
	name = "SPI Helmet Mk I"
	item_state = "wehraboo-helmet_worn"
	icon_state = "wehraboo-helmet_obj"
	item_state_novisr = "wehraboo-helmet_worn"
	icon_state_novisr = "wehraboo-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/wehraboo
	name = "SPI Armour Mk I"
	item_state = "wehraboo-armor_worn"
	icon_state = "wehraboo-armor_obj"

/obj/item/weapon/storage/box/large/donator/wehraboo
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/wehraboo,
					/obj/item/clothing/suit/armor/special/odst/donator/wehraboo
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/wehraboo,
					/obj/item/clothing/suit/armor/special/odst/donator/wehraboo
					)

/decl/hierarchy/outfit/wehraboo_odst
	name = "wehraboo - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/wehraboo
	suit = /obj/item/clothing/suit/armor/special/odst/donator/wehraboo

//Spartan

/obj/item/clothing/head/helmet/spartan/markvi_wehraboo
	name = "MJOLNIR Powered Assault Armor Helmet Mark VI"
	icon_state = "wehraboo-spartanhelm_obj"
	item_state = "wehraboo-spartanhelm_worn"

/obj/item/clothing/suit/armor/special/spartan/markvi_wehraboo
	name = "MJOLNIR Powered Assault Armor Mark VI"
	icon_state = "wehraboo-spartanarmor_obj"
	item_state = "wehraboo-spartanarmor_worn"

/decl/hierarchy/outfit/wehraboo_spartan
	name = "wehraboo - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/markvi_wehraboo
	head = /obj/item/clothing/head/helmet/spartan/markvi_wehraboo

////////winterume\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/winterume
	name = "Rose's Recon Helmet"

	item_state = "amy-helmet_worn"
	icon_state = "amy-helmet_obj"
	item_state_novisr = "amy-helmet-open_worn"
	icon_state_novisr = "amy-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/winterume
	name = "Rose's Recon Armor"

	item_state = "amy-armor_worn"
	icon_state = "amy-armor_obj"

/obj/item/weapon/storage/box/large/donator/winterume
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/winterume,
					/obj/item/clothing/suit/armor/special/odst/donator/winterume
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/winterume,
					/obj/item/clothing/suit/armor/special/odst/donator/winterume
					)

/decl/hierarchy/outfit/winterume_odst
	name = "winterume - ODST"
	head = /obj/item/clothing/head/helmet/odst/donator/winterume
	suit = /obj/item/clothing/suit/armor/special/odst/donator/winterume

//Spartan

/obj/item/clothing/head/helmet/spartan/mkv_airassault_amy
	name = "MJOLNIR Powered Assault Armor Helmet Mark V Air Assault (customised)"
	icon_state = "amy-spartan-helm"
	item_state = "amy-spartan-helm-worn"

/obj/item/clothing/suit/armor/special/spartan/mkv_airassault_amy
	name = "MJOLNIR Powered Assault Armor Mark V Air Assault (customised)"
	icon_state = "amy-spartan-shell"
	item_state = "amy-spartan-shell-worn"

/decl/hierarchy/outfit/winterume_spartan
	name = "winterume - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/mkv_airassault_amy
	head = /obj/item/clothing/head/helmet/spartan/mkv_airassault_amy

////////Riley\\\\\\\

//Marine

/obj/item/clothing/head/helmet/marine/riley
	name = " CH252MC-V modified helmet"
	item_state = "riley-helmet_worn"
	icon_state = "riley-helmet_obj"
	desc = " this is a CH252MC-V modified helmet of the CH252-V version, it contains a 1 eye visor, and a blue cross instead of a  red one , also it seems to have holographic cat ears attached"

/obj/item/clothing/gloves/thick/unsc/riley
	name = "UNSC Combat Gloves"
	icon = MARINE_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "UNSCMarineGloves"
	icon_state = "unsc gloves_obj"

/obj/item/clothing/shoes/marine/riley
	name = "VZG7 Armored Boots"
	item_state = "boots OLD"
	icon_state = "VZG7 Armored Legs"

/obj/item/clothing/under/unsc/marine_fatigues/riley
	item_state = "UNSC Marine Fatiguesold"
	icon_state = "uniform_obj"
	worn_state = "UNSC Marine Fatiguesold"

/obj/item/clothing/suit/storage/marine/riley
	desc = "this is an  M52BMC a modified M52B marine armor with Blue instead of red crosses and and front chest an tac pad monitor witch displays a blinking red cross and a text with says (you fuck up i patch up) the armor also seems to be fitted with a holographic cat tail"
	name = "M52BMC"
	item_state = "riley-armor_worn"
	icon_state = "riley-armor_obj"

/obj/item/weapon/gun/projectile/m7_smg/riley
	name = "P90-XTR"
	desc = "This is a P90-XTR an old gun form the 21st century with seems to have been painted in a blue/greyish camo and updated and modified to take a 60 round magazine of 5mm bullets."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "p90"
	item_state = "p90"
	wielded_item_state = null
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = null,
		slot_s_store_str = null,
		slot_belt_str = null,
		)

/obj/item/weapon/gun/projectile/m7_smg/riley/update_icon()
	if(ammo_magazine)
		icon_state = "p90"
	else
		icon_state = "p90_unloaded"

/obj/item/weapon/storage/box/large/donator/riley
	startswith = list(/obj/item/clothing/head/helmet/marine/riley,
					/obj/item/clothing/suit/storage/marine/riley,
					/obj/item/clothing/shoes/marine/riley,
					/obj/item/clothing/under/unsc/marine_fatigues/riley,
					/obj/item/clothing/gloves/thick/unsc/riley,
					/obj/item/weapon/gun/projectile/m7_smg/riley
					)
	can_hold = list(/obj/item/clothing/head/helmet/marine/riley,
					/obj/item/clothing/suit/storage/marine/riley,
					/obj/item/clothing/shoes/marine/riley,
					/obj/item/clothing/under/unsc/marine_fatigues/riley,
					/obj/item/clothing/gloves/thick/unsc/riley,
					/obj/item/weapon/gun/projectile/m7_smg/riley
					)

/decl/hierarchy/outfit/riley_marine
	name = "riley - marine"
	suit = /obj/item/clothing/suit/storage/marine/riley
	head = /obj/item/clothing/head/helmet/marine/riley

///////Voloxus\\\\\\\\

//Sangheili (ULTRA/MAJOR)

/obj/item/clothing/head/helmet/sangheili/voloxus
	name = "‘Vurom Clan Armor - Sangheili Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon_state = "Leevrukah_helmet_obj"
	item_state = "Leevrukah_helmet"

/obj/item/clothing/suit/armor/special/combatharness/voloxus
	name = "‘Vurom Clan Armor - Combat Harness"
	desc = "Worn only by those within the 'Vurom Clan that have distinguished themselves among the most faithful, and zealous within the Covenant."
	icon_state = "Leevrukah_chest_obj"
	item_state = "Leevrukah_chest"
	totalshields = 125

/obj/item/clothing/shoes/sangheili/voloxus
	name = "‘Vurom Clan Armor - Leg Armour"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "Leevrukah_legs_obj"
	item_state = "Leevrukah_legs"

/obj/item/clothing/gloves/thick/sangheili/voloxus
	name = "‘Vurom Clan Armor - Gauntlets"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "Leevrukah_gloves_obj"
	item_state = "Leevrukah_gloves"

/obj/item/weapon/storage/box/large/donator/voloxus_sangheili
	startswith = list(/obj/item/clothing/head/helmet/sangheili/voloxus,
					/obj/item/clothing/suit/armor/special/combatharness/voloxus,
					/obj/item/clothing/shoes/sangheili/voloxus,
					/obj/item/clothing/gloves/thick/sangheili/voloxus
					)
	can_hold = list(/obj/item/clothing/head/helmet/sangheili/voloxus,
					/obj/item/clothing/suit/armor/special/combatharness/voloxus,
					/obj/item/clothing/shoes/sangheili/voloxus,
					/obj/item/clothing/gloves/thick/sangheili/voloxus
					)

/decl/hierarchy/outfit/zane_sangheili
	name = "voloxus - Ultra/Major"
	suit = /obj/item/clothing/suit/armor/special/combatharness/voloxus
	suit_store = /obj/item/weapon/gun/energy/plasmarifle
	back = /obj/item/weapon/gun/energy/plasmarifle
	belt = /obj/item/weapon/gun/energy/plasmapistol
	gloves = /obj/item/clothing/gloves/thick/sangheili/voloxus
	shoes = /obj/item/clothing/shoes/sangheili/voloxus
	head = /obj/item/clothing/head/helmet/sangheili/voloxus
	l_pocket = /obj/item/weapon/grenade/plasma

///////Zane\\\\\\\\

//Sangheili (ULTRA)

/obj/item/clothing/head/helmet/sangheili/zane
	name = "‘Nasan Clan - Ultra Sangheili Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon_state = "bluekro_helm_obj"
	item_state = "bluekro_helm"

/obj/item/clothing/suit/armor/special/combatharness/zane
	name = "‘Nasan Clan - Ultra Combat Harness"
	icon_state = "bluekro_chest_obj"
	item_state = "bluekro_chest"
	totalshields = 125

/obj/item/clothing/shoes/sangheili/zane
	name = "‘Nasan Clan - Ultra Leg Armour"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "bluekro_legs_obj"
	item_state = "bluekro_legs"

/obj/item/clothing/gloves/thick/sangheili/zane
	name = "‘Nasan Clan - Ultra Gauntlets"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "bluekro_gloves_obj"
	item_state = "bluekro_gloves"

/obj/item/weapon/storage/box/large/donator/zane_ultra
	startswith = list(/obj/item/clothing/head/helmet/sangheili/zane,
					/obj/item/clothing/suit/armor/special/combatharness/zane,
					/obj/item/clothing/shoes/sangheili/zane,
					/obj/item/clothing/gloves/thick/sangheili/zane
					)
	can_hold = list(/obj/item/clothing/head/helmet/sangheili/zane,
					/obj/item/clothing/suit/armor/special/combatharness/zane,
					/obj/item/clothing/shoes/sangheili/zane,
					/obj/item/clothing/gloves/thick/sangheili/zane
					)

/decl/hierarchy/outfit/zane_sangheili
	name = "zane - Ultra"
	suit = /obj/item/clothing/suit/armor/special/combatharness/zane
	suit_store = /obj/item/weapon/gun/energy/plasmarifle
	back = /obj/item/weapon/gun/energy/plasmarifle
	belt = /obj/item/weapon/gun/energy/plasmapistol
	gloves = /obj/item/clothing/gloves/thick/sangheili/zane
	shoes = /obj/item/clothing/shoes/sangheili/zane
	head = /obj/item/clothing/head/helmet/sangheili/zane
	l_pocket = /obj/item/weapon/grenade/plasma


#undef ODST_OVERRIDE
#undef ITEM_INHAND
#undef MARINE_OVERRIDE
#undef MARINE_INHAND
#undef URF_OVERRIDE
#undef URF_HAND