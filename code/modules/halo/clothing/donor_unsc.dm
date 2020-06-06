#define ODST_OVERRIDE 'code/modules/halo/clothing/odst.dmi'
#define ITEM_INHAND 'code/modules/halo/clothing/odst_items.dmi'
#define MARINE_OVERRIDE 'code/modules/halo/clothing/marine.dmi'
#define MARINE_INHAND 'code/modules/halo/clothing/marine_items.dmi'
#define SPARTAN_OVERRIDE 'code/modules/halo/clothing/SpartanHussarKit.dmi'
#define ONI_OVERRIDE 'code/modules/halo/clothing/oni_guard.dmi'
#define ONI_ITEM_INHAND 'code/modules/halo/clothing/item_oni.dmi'

////////ashvor\\\\\\\\

//Marine

/obj/item/clothing/under/unsc/marine_fatigues/ashvor
	desc = "A variant of the standard issue uniform used with the pressurized Atmospheric/Exoatmospheric armor worn by members of the UNSC Marine Corps."
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

/obj/item/weapon/storage/backpack/marine/ashvor
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
					/obj/item/weapon/storage/backpack/marine/ashvor)
	can_hold = list(/obj/item/clothing/under/unsc/marine_fatigues/ashvor,
					/obj/item/clothing/suit/spaceeva/eva/ashvor,
					/obj/item/clothing/gloves/thick/unsc/ashvor,
					/obj/item/clothing/shoes/magboots/eva/marine/ashvor,
					/obj/item/clothing/head/helmet/eva/marine/ashvor,
					/obj/item/weapon/storage/backpack/marine/ashvor)

/decl/hierarchy/outfit/ashvor_marine
	name = "ashvor - marine"
	uniform = /obj/item/clothing/under/unsc/marine_fatigues/ashvor
	suit = /obj/item/clothing/suit/spaceeva/eva/ashvor
	shoes = /obj/item/clothing/shoes/magboots/eva/marine/ashvor
	gloves = /obj/item/clothing/gloves/thick/unsc/ashvor
	head = /obj/item/clothing/head/helmet/eva/marine/ashvor
	back = /obj/item/weapon/storage/backpack/marine/ashvor

//ODST

/obj/item/clothing/under/unsc/odst_jumpsuit/ashvor
	name = "UNSC Cross Branch Battle Dress Uniform"
	desc = "A variant of the standard issue uniform used with the pressurized Atmospheric/Exoatmospheric armor worn by members of the UNSC Marine Corps. This uniform sports ODST colors."
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	item_state = "ashvor-odst-uniform"
	icon_state = "ashvor-odst-uniform_obj"
	worn_state = "ashvor-odst-uniform"
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/head/helmet/odst/ashvor
	desc = "A modified ECH252 Enclosed Helmet, has been brought into line with ODST Armor Specs and Requirements,"
	name = "Modified ECH252 Enclosed Helmet"
	item_state = "ashvor-odst-helmet_worn"
	icon_state = "ashvor-odst-helmet_obj"
	item_state_novisr = "ashvor-odst-helmet-open_worn"
	icon_state_novisr = "ashvor-odst-helmet-open_obj"
	item_state_slots = list(slot_l_hand_str = "ashvor-odst-helmet", slot_r_hand_str = "ashvor-odst-helmet")

/obj/item/clothing/suit/armor/special/odst/ashvor
	desc = "The standard M52A/X worn by Marines, further modified with ODST armor chestplate. Additional plates have been added across the suit and a new two piece ballistic plate fitted to the left shoulder."
	name = "Modified M52A/X Body Armor"
	item_state = "ashvor-odst-armor_worn"
	icon_state = "ashvor-odst-armor_obj"
	flags_inv = HIDETAIL
	item_state_slots = list(slot_l_hand_str = "ashvor-odst-armor", slot_r_hand_str = "ashvor-odst-armor")

/obj/item/weapon/storage/backpack/odst/donator/general/ashvor
	desc = "The a softcase backpack with capacity to carry ammunition, tools, and medical supplies. Used by the UNSC Army, Marines, and Air Force. This one sports ODST markings and coat."
	name = "UNSC Tactical Backpack"
	item_state = "ashvor-odst-backpack_worn"
	icon_state = "ashvor-odst-backpack_obj"
	item_state_slots = list(slot_l_hand_str = "ashvor-odst-backpack", slot_r_hand_str = "ashvor-odst-backpack")

/decl/hierarchy/outfit/ashvor_odst
	name = "ashvor - odst"
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit/ashvor
	suit = /obj/item/clothing/suit/armor/special/odst/ashvor
	shoes = /obj/item/clothing/shoes/magboots/eva/marine/ashvor
	gloves = /obj/item/clothing/gloves/thick/unsc/ashvor
	head = /obj/item/clothing/head/helmet/odst/ashvor
	back = /obj/item/weapon/storage/backpack/odst/donator/general/ashvor

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
	l_ear = /obj/item/device/radio/headset/unsc/spartan

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


////////flaksim\\\\\\\\

//ODST

/obj/item/clothing/head/helmet/odst/donator/flaksim
	name = "Flaksim's ODST Helmet"

	item_state = "Odst Helmet Flaksim"
	icon_state = "Odst Helmet Flaksim"
	item_state_novisr = "Odst Helmet Flaksim Transparent"
	icon_state_novisr = "Odst Helmet Flaksim Transparent"

/obj/item/clothing/suit/armor/special/odst/donator/flaksim
	name = "Flaksim's ODST Armour"

	icon_state = "Odst Armor Flaksim"

/obj/item/weapon/storage/backpack/odst/donator/flaksim
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Flaksim's Backpack"
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

//Spartan

/obj/item/clothing/head/helmet/spartan/kozi_spartan
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV Hassar"
	icon = 'code/modules/halo/clothing/SpartanHussarKit.dmi'
	icon_state = "osama-spartan-helm_obj"
	item_state = "osama-spartan-helm_worn"
	icon_override = SPARTAN_OVERRIDE

/obj/item/clothing/suit/armor/special/spartan/kozi_spartan
	name = "MJOLNIR Powered Assault Armor Mark IV Hassar"
	icon = 'code/modules/halo/clothing/SpartanHussarKit.dmi'
	icon_state = "osama-spartan-armor_obj"
	item_state = "osama-spartan-armor_worn"
	icon_override = SPARTAN_OVERRIDE

/decl/hierarchy/outfit/kozi_spartan
	name = "kozi - spartan"
	suit = /obj/item/clothing/suit/armor/special/spartan/kozi_spartan
	head = /obj/item/clothing/head/helmet/spartan/kozi_spartan
	l_hand = /obj/item/weapon/material/machete/kozi

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

/obj/item/clothing/head/helmet/spartan/loafe
	icon_state = "loafe-helm-obj"
	item_state = "loafe-helm-worn"

/obj/item/clothing/suit/armor/special/spartan/loafe
	icon_state = "loafe-shell-obj"
	item_state = "loafe-shell-worn"

/obj/item/weapon/storage/box/large/donator/loafe/spartan
	startswith = list(/obj/item/clothing/head/helmet/spartan/loafe,
	/obj/item/clothing/suit/armor/special/spartan/loafe
	)
	can_hold = list(/obj/item/clothing/head/helmet/spartan/loafe,
	/obj/item/clothing/suit/armor/special/spartan/loafe
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
	name = "SPI-M Helmet"
	desc = "This is helmet is one of the sleeker designed pieces of EVA capable gear for the UNSC. Currently, in it's field testing phase it's fitted with the latest VISR HUD."
	item_state = "mann-odst-spi-helmet_worn"
	icon_state = "mann-odst-spi-helmet_obj"
	item_state_novisr = "mann-odst-spi-helmet-open_worn"
	icon_state_novisr = "mann-odst-spi-helmet-open_obj"

/obj/item/clothing/suit/armor/special/odst/donator/mann
	name = "SPI-M Armor"
	desc = "The newest breakthrough from ONI being put into field testing in limited quantities for select Helljumpers. Being called SPI-M, it sports the Helljumper insignia emblazoned on the shoulderpads in the standard gold and maroon finish."
	icon_state = "mann-odst-spi-armor_obj"
	item_state = "mann-odst-spi-armor_worn"

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

/obj/item/weapon/storage/backpack/odst/mann
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Mann's Backpack"
	item_state = "mann-odst-spi-backpack_worn"
	icon_state = "mann-odst-spi-backpack_obj"


/obj/item/weapon/storage/box/large/donator/mann
	startswith = list(/obj/item/clothing/head/helmet/odst/donator/mann,
					/obj/item/clothing/suit/armor/special/odst/donator/mann,
					/obj/item/weapon/gun/projectile/m6c_magnum_s/donator/mann,
					/obj/item/weapon/storage/backpack/odst/mann
					)
	can_hold = list(/obj/item/clothing/head/helmet/odst/donator/mann,
					/obj/item/clothing/suit/armor/special/odst/donator/mann,
					/obj/item/weapon/gun/projectile/m6c_magnum_s/donator/mann,
					/obj/item/weapon/storage/backpack/odst/mann
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


//Socks Spartan

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


///////////CommanderXor/////////

//ONI Researcher, using guard armour.

/obj/item/weapon/gun/projectile/br55/xor
	name = "FN-FAL"
	desc = "A custom made recreation of an old-world weapon. with internals modelled to function as a BR55."

	icon_state = "fal"

	wielded_item_state = null

/obj/item/clothing/suit/storage/oni_guard/xor
	name = "Refitted T voan Armour"
	desc = "Looks like someone captured and refitted the armour of a Covenant T voan."

	icon = ONI_ITEM_INHAND
	icon_override = ONI_OVERRIDE
	icon_state = "armor"
	item_state = "xor_armour"

/obj/item/clothing/shoes/oni_guard/xor
	name = "Refitted T voan Boots"
	desc = "The boots of a T voan, fitted to function as footwear for humans."

	icon = ONI_ITEM_INHAND
	icon_override = ONI_OVERRIDE
	icon_state = "boots_ico"
	item_state = "xor_boots"

/obj/item/clothing/gloves/thick/oni_guard/xor
	name = "Refitted T voan Gloves"
	desc = "These gloves have been refitted to allow for human usage."

	icon = ONI_ITEM_INHAND
	icon_override = ONI_OVERRIDE
	icon_state = "unsc gloves_obj"
	item_state = "xor_gloves"

/obj/item/clothing/head/helmet/oni_guard/xor
	name = "Refitted T voan Helmet"
	desc = "Despite the look, this isn't actually airtight."
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR|BLOCKHEADHAIR

	icon = ONI_ITEM_INHAND
	icon_override = ONI_OVERRIDE
	item_state = "xor_helm"

/obj/item/weapon/storage/backpack/marine/xor
	name = "Storage Cape"
	desc = "The bulk of this backpack is masked by a cape. Fancy ONI trickery..."

	icon = ONI_OVERRIDE
	icon_override = ONI_OVERRIDE
	icon_state = "xor_backpack_cloak"
	item_state = "xor_backpack_cloak"

/obj/item/weapon/storage/box/large/donator/xor
	startswith = list(\
	/obj/item/clothing/suit/storage/oni_guard/xor,
	/obj/item/clothing/shoes/oni_guard/xor,
	/obj/item/clothing/gloves/thick/oni_guard/xor,
	/obj/item/clothing/head/helmet/oni_guard/xor,
	/obj/item/weapon/storage/backpack/marine/xor,
	/obj/item/weapon/gun/projectile/br55/xor
	)
	can_hold = list(\
	/obj/item/clothing/suit/storage/oni_guard/xor,
	/obj/item/clothing/shoes/oni_guard/xor,
	/obj/item/clothing/gloves/thick/oni_guard/xor,
	/obj/item/clothing/head/helmet/oni_guard/xor,
	/obj/item/weapon/storage/backpack/marine/xor,
	/obj/item/weapon/gun/projectile/br55/xor
	)

/obj/item/clothing/head/helmet/odst/commanderxor
	name = "Harridan Battle Armour Helmet"
	desc = "Looks like a heavily modified ODST helmet."
	item_state = "sapphireodsthelmet"
	item_state_novisr = "sapphireodsthelmet"

/obj/item/clothing/suit/armor/special/odst/commanderxor
	name = "Harridan Battle Armour"
	desc = "Seems to be a heavy modification of ODST armour."
	item_state = "sapphireodstarmor"
	flags_inv = HIDETAIL

/obj/item/weapon/storage/backpack/odst/donator/general/commanderxor
	name = "Harridan Battle Armour Jetpack"
	desc = "Sadly, this no longer functions as a jetpack. It makes for a nice storage item, though."
	item_state = "sapphireodstbackpack"

/obj/item/weapon/storage/box/large/donator/xor_odst
	startswith = list(\
	/obj/item/clothing/head/helmet/odst/commanderxor,
	/obj/item/clothing/suit/armor/special/odst/commanderxor,
	/obj/item/weapon/storage/backpack/odst/donator/general/commanderxor,
	/obj/item/weapon/gun/projectile/br55/xor
	)
	can_hold = list(\
	/obj/item/clothing/head/helmet/odst/commanderxor,
	/obj/item/clothing/suit/armor/special/odst/commanderxor,
	/obj/item/weapon/storage/backpack/odst/donator/general/commanderxor,
	/obj/item/weapon/gun/projectile/br55/xor
	)

/obj/item/weapon/gun/projectile/br55/xor/update_icon()
	if(ammo_magazine)
		icon_state = "fal"
	else
		icon_state = "fal_unloaded"

//GhostDex
/obj/item/clothing/head/helmet/spartan/ghostdex
	icon_state = "ghostdex-helm-obj"
	item_state = "ghostdex-helm-worn"

/obj/item/clothing/suit/armor/special/spartan/ghostdex
	icon_state = "ghostdex-obj"
	item_state = "ghostdex-worn"
	flags_inv = HIDETAIL

/obj/item/weapon/storage/box/large/donator/ghostdex_spartan
	startswith = list(\
	/obj/item/clothing/head/helmet/spartan/ghostdex,
	/obj/item/clothing/suit/armor/special/spartan/ghostdex
	)
	can_hold = list(\
	/obj/item/clothing/head/helmet/spartan/ghostdex,
	/obj/item/clothing/suit/armor/special/spartan/ghostdex
	)

#undef ODST_OVERRIDE
#undef ITEM_INHAND
#undef MARINE_OVERRIDE
#undef MARINE_INHAND
#undef SPARTAN_OVERRIDE
#undef ONI_OVERRIDE
#undef ONI_ITEM_INHAND