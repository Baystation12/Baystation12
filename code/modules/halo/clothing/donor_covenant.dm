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

/obj/item/weapon/storage/box/large/donator/boltersam/captain
	startswith = list(/obj/item/clothing/head/helmet/jiralhanae/covenant/boltersam,
					/obj/item/clothing/suit/armor/jiralhanae/covenant/boltersam,
					/obj/item/clothing/shoes/jiralhanae/covenant/boltersam,
					/obj/item/weapon/grav_hammer/boltersam
					)
	can_hold = list(/obj/item/clothing/head/helmet/jiralhanae/covenant/boltersam,
					/obj/item/clothing/suit/armor/jiralhanae/covenant/boltersam,
					/obj/item/clothing/shoes/jiralhanae/covenant/boltersam,
					/obj/item/weapon/grav_hammer/boltersam
					)

/decl/hierarchy/outfit/boltersam_jiralhanae
	name = "boltersam - jiralhanae"
	head = /obj/item/clothing/head/helmet/jiralhanae/covenant/boltersam
	suit = /obj/item/clothing/suit/armor/jiralhanae/covenant/boltersam
	shoes = /obj/item/clothing/shoes/jiralhanae/covenant/boltersam
	back = /obj/item/weapon/grav_hammer/boltersam

///////billymom2\\\\\\\\\

/obj/item/clothing/head/helmet/jiralhanae/covenant/billymom2
	icon_state = "billymom2_helm"

/obj/item/clothing/suit/armor/jiralhanae/covenant/billymom2
	icon_state = "billymom2_armour"

/obj/item/clothing/shoes/jiralhanae/covenant/billymom2
	icon_state = " "

/obj/item/weapon/storage/box/large/donator/billymom2
	startswith = list(/obj/item/clothing/head/helmet/jiralhanae/covenant/billymom2,
					/obj/item/clothing/suit/armor/jiralhanae/covenant/billymom2,
					/obj/item/clothing/shoes/jiralhanae/covenant/billymom2,
					)
	can_hold = list(/obj/item/clothing/head/helmet/jiralhanae/covenant/billymom2,
					/obj/item/clothing/suit/armor/jiralhanae/covenant/billymom2,
					/obj/item/clothing/shoes/jiralhanae/covenant/billymom2,
					)


///////MAGNUM\\\\\\\\

//Sangheili Ultra

/obj/item/clothing/under/covenant/sangheili/magnum
	name = "Sangheili Body-suit"
	desc = "A sealed, airtight bodysuit. Meant to be worn underneath the ornate 'Strangam Clan Ultra harness."
	icon_state = "sangheili-magnum_suit"
	species_restricted = list ("Sangheili")
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS

/obj/item/clothing/head/helmet/sangheili/ultra/magnum
	name = "‘Strangam Clan - Ultra Sangheili Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon_state = "Magnum_helmet_obj"
	item_state = "Magnum_helmet"

/obj/item/clothing/suit/armor/special/combatharness/ultra/magnum
	name = "‘Strangam Clan - Ultra Combat Harness"
	icon_state = "Magnum_chest_obj"
	item_state = "Magnum_chest"

/obj/item/clothing/shoes/sangheili/ultra/magnum
	name = "‘Strangam Clan - Ultra Leg Armour"
	desc = "Leg armour, to be used with the Sangheili Combat Harness."
	icon_state = "Magnum_boots_obj"
	item_state = "Magnum_boots"

/obj/item/clothing/gloves/thick/sangheili/ultra/magnum
	name = "‘Strangam Clan - Ultra Gauntlets"
	desc = "Hand armour, to be used with the Sangheili Combat Harness."
	icon_state = "Magnum_gloves_obj"
	item_state = "Magnum_gloves"

/obj/item/weapon/storage/box/large/donator/magnum_ultra
	startswith = list(/obj/item/clothing/head/helmet/sangheili/ultra/magnum,
					/obj/item/clothing/suit/armor/special/combatharness/ultra/magnum,
					/obj/item/clothing/shoes/sangheili/ultra/magnum,
					/obj/item/clothing/gloves/thick/sangheili/ultra/magnum,
					/obj/item/clothing/under/covenant/sangheili/magnum
					)
	can_hold = list(/obj/item/clothing/head/helmet/sangheili/ultra/magnum,
					/obj/item/clothing/suit/armor/special/combatharness/ultra/magnum,
					/obj/item/clothing/shoes/sangheili/ultra/magnum,
					/obj/item/clothing/gloves/thick/sangheili/ultra/magnum,
					/obj/item/clothing/under/covenant/sangheili/magnum
					)

/decl/hierarchy/outfit/magnum_sangheili
	name = "RealMAGNUM - Sangheili Ultra"
	uniform = /obj/item/clothing/under/covenant/sangheili/magnum
	suit = /obj/item/clothing/suit/armor/special/combatharness/ultra/magnum
	suit_store = /obj/item/weapon/gun/energy/plasmarifle
	back = /obj/item/weapon/gun/energy/plasmarifle
	belt = /obj/item/weapon/gun/energy/plasmapistol
	gloves = /obj/item/clothing/gloves/thick/sangheili/ultra/magnum
	shoes = /obj/item/clothing/shoes/sangheili/ultra/magnum
	head = /obj/item/clothing/head/helmet/sangheili/ultra/magnum
	l_pocket = /obj/item/weapon/grenade/plasma
	r_pocket = /obj/item/weapon/grenade/plasma

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
	totalshields = 240

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

/obj/item/weapon/melee/energy/elite_sword/dagger/dogler

	name = "Sya'tenee's Energy Dagger"
	icon_state = "dogler_dag_handle"
	icon_state_deployed = "dogler_dag_deploy"

/obj/item/weapon/melee/energy/elite_sword/dagger/dogler/change_misc_variables(var/deactivate = 0)
	if(deactivate)
		item_icons = list(slot_l_hand_str = null,slot_r_hand_str = null)
		item_state_slots = null
		hitsound = "swing_hit"
	else
		item_icons = list(slot_l_hand_str ='code/modules/halo/icons/dogler_weapon_sprites.dmi',slot_r_hand_str = 'code/modules/halo/icons/dogler_weapon_sprites.dmi')
		item_state_slots = list(
		slot_l_hand_str = "dogler_dag_l_hand",
		slot_r_hand_str = "dogler_dag_r_hand" )
		hitsound = 'code/modules/halo/sounds/Energyswordhit.ogg'

//Axe

/obj/item/weapon/melee/energy/elite_sword/dogleraxe
	name = "Sya'tenee's Energy Axe"
	desc = "A huge, scary-looking energy axe, which looks too heavy to be wielded by humans..."
	icon = 'code/modules/halo/icons/dogler_weapon_sprites.dmi'
	force = 65
	armor_penetration = 35
	icon_state = "dogler_axe"
	item_icons = list(slot_l_hand_str ='code/modules/halo/icons/dogler_weapon_sprites.dmi',slot_r_hand_str = 'code/modules/halo/icons/dogler_weapon_sprites.dmi')
	item_state_slots = list(
	slot_l_hand_str = "dogler_axe_l1",
	slot_r_hand_str = "dogler_axe_r1")

/obj/item/weapon/melee/energy/elite_sword/dogleraxe/activate(mob/living/user)
	return

/obj/item/weapon/melee/energy/elite_sword/dogleraxe/deactivate(mob/living/user)
	return

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


//Socks Sangheili (MAJOR)

/obj/item/clothing/head/helmet/sangheili/socks
	name = "‘Nasan Clan - Bluekro Sangheili Helmet"
	desc = "Head armour, to be used with the Sangheili Combat Harness."
	icon_state = "socks_helm_obj"
	item_state = "socks_helm"

/obj/item/clothing/suit/armor/special/combatharness/socks
	name = "‘Nasan Clan - Bluekro Combat Harness"
	icon_state = "socks_chest_obj"
	item_state = "socks_chest"
	totalshields = 240

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


///////Vampire132978123\\\\\\\

//Skirmisher

/obj/item/clothing/head/helmet/kigyar/skirmisher/donator/vampire
	name = "Pirate's Hat"
	desc = "A worn, probably stolen, pirate hat. Looks like it belongs in a theater."
	icon = 'code/modules/halo/covenant/species/tvoan/skirm_clothing.dmi'
	icon_state = "piratehat_obj"
	item_state = "piratehat"
	species_restricted = list("Tvaoan Kig-Yar")

/obj/item/clothing/suit/armor/special/skirmisher/donator/vampire
	name = "Worn Coat"
	desc = "A coat that is rumored to be owned by a legendary pirate, though some say it was stolen from a cargo vessel by a humanoid bird."
	icon = 'code/modules/halo/covenant/species/tvoan/skirm_clothing.dmi'
	icon_state = "piratecoat_obj"
	item_state = "piratecoat"
	sprite_sheets = list("Tvaoan Kig-Yar" = 'code/modules/halo/covenant/species/tvoan/skirm_clothing.dmi')
	species_restricted = list("Tvaoan Kig-Yar")
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL

/obj/item/toy/plushie/donator/vampire
	name = "Rafaj"
	desc = "A pirate's best friend, and most prized possession. It looks like it's been through many adventures. Squeeze to activate an internal speaker."
	icon = 'code/modules/halo/covenant/species/tvoan/Skirmisher_inhand.dmi'
	icon_state = "parrot_obj"
	item_state = "parrot"
	slot_flags = SLOT_POCKET | SLOT_BELT | SLOT_BACK | SLOT_EARS
	var/next_sound = 0
	var/play_music = 0
	var/list/sound_music = list(\
	'code/modules/halo/sounds/rafaj_donor/music_1.ogg' = 162 SECONDS,
	'code/modules/halo/sounds/rafaj_donor/music_2.ogg' = 127 SECONDS
	)
	var/list/sound_voice = list(\
	'code/modules/halo/sounds/rafaj_donor/voiceline_1.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_2.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_3.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_4.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_5.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_6.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_7.ogg'
	)

/obj/item/toy/plushie/donator/vampire/verb/toggle_soundtype()
	set name = "Toggle Speaker Type"
	set category = "Object"

	if(!istype(usr,/mob/living))
		return
	play_music = !play_music
	to_chat(usr,"<span class = 'notice'>You toggle [src] to [play_music ? "play music" : "play voice lines"].</span>")

/obj/item/toy/plushie/donator/vampire/attack_self(var/mob/user)
	if(sound_voice.len > 0)
		var/list/l_use = sound_voice
		if(play_music)
			if(sound_music.len == 0 || world.time < next_sound)
				return
			l_use = sound_music
		var/sfx_play = pick(l_use)
		if(play_music)
			next_sound = world.time + l_use[sfx_play]
		playsound(user, sfx_play , 100)

/obj/item/weapon/storage/box/large/donator/vampire
	startswith = list(/obj/item/clothing/head/helmet/kigyar/skirmisher/donator/vampire,
					/obj/item/clothing/suit/armor/special/skirmisher/donator/vampire,
					/obj/item/toy/plushie/donator/vampire
					)
	can_hold = list(/obj/item/clothing/head/helmet/kigyar/skirmisher/donator/vampire,
					/obj/item/clothing/suit/armor/special/skirmisher/donator/vampire,
					/obj/item/toy/plushie/donator/vampire
					)

/decl/hierarchy/outfit/vampire_kigyar
	name = "vampire - kig-yar"
	suit = /obj/item/clothing/suit/armor/special/skirmisher/donator/vampire
	suit_store = /obj/item/toy/plushie/donator/vampire
	head = /obj/item/clothing/head/helmet/kigyar/skirmisher/donator/vampire

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
	totalshields = 240

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

/decl/hierarchy/outfit/voloxus_sangheili
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
	totalshields = 240

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

/obj/item/weapon/melee/energy/elite_sword/zane
	icon_state = "zaneSword-handle"
	icon_state_deployed = "zaneSword-deployed"
	inhand_icon_state = "zaneSword"

/obj/item/weapon/storage/box/large/donator/zane_ultra
	startswith = list(/obj/item/clothing/head/helmet/sangheili/zane,
					/obj/item/clothing/suit/armor/special/combatharness/zane,
					/obj/item/clothing/shoes/sangheili/zane,
					/obj/item/clothing/gloves/thick/sangheili/zane,
					/obj/item/weapon/melee/energy/elite_sword/zane
					)
	can_hold = list(/obj/item/clothing/head/helmet/sangheili/zane,
					/obj/item/clothing/suit/armor/special/combatharness/zane,
					/obj/item/clothing/shoes/sangheili/zane,
					/obj/item/clothing/gloves/thick/sangheili/zane,
					/obj/item/weapon/melee/energy/elite_sword/zane
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
