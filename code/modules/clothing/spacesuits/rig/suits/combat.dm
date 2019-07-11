/obj/item/weapon/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "security_rig"
	suit_type = "combat hardsuit"
	armor = list(melee = 80, bullet = 65, laser = 55, energy = 15, bomb = 80, bio = 100, rad = 60)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs,/obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/tool/crowbar, \
	/obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/weldingtool, /obj/item/weapon/tool/wirecutters, /obj/item/weapon/tool/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/device/suit_cooling_unit)

	chest_type = /obj/item/clothing/suit/space/rig/combat
	helm_type = /obj/item/clothing/head/helmet/space/rig/combat
	boot_type = /obj/item/clothing/shoes/magboots/rig/combat
	glove_type = /obj/item/clothing/gloves/rig/combat

/obj/item/clothing/head/helmet/space/rig/combat
	light_overlay = "helmet_light_dual_green"
	species_restricted = list(SPECIES_HUMAN, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/head.dmi'
		)

/obj/item/clothing/suit/space/rig/combat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/suit.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/combat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/feet.dmi'
		)

/obj/item/clothing/gloves/rig/combat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/hands.dmi'
		)

/obj/item/weapon/rig/combat/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit
		)

//Extremely OP, hardly standard issue equipment
//Now a little less OP
/obj/item/weapon/rig/military
	name = "military hardsuit control module"
	desc = "An austere hardsuit used by paramilitary groups and real soldiers alike."
	icon_state = "military_rig"
	suit_type = "military hardsuit"
	armor = list(melee = 80, bullet = 75, laser = 60, energy = 15, bomb = 80, bio = 100, rad = 30)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(/obj/item/device/flashlight, /obj/item/weapon/tank,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs,/obj/item/device/t_scanner, /obj/item/weapon/rcd, /obj/item/weapon/tool/crowbar, \
	/obj/item/weapon/tool/screwdriver, /obj/item/weapon/tool/weldingtool, /obj/item/weapon/tool/wirecutters, /obj/item/weapon/tool/wrench, /obj/item/device/multitool, \
	/obj/item/device/radio, /obj/item/device/analyzer,/obj/item/weapon/storage/briefcase/inflatable, /obj/item/weapon/melee/baton, /obj/item/weapon/gun, \
	/obj/item/weapon/storage/firstaid, /obj/item/weapon/reagent_containers/hypospray, /obj/item/roller, /obj/item/device/suit_cooling_unit)

	chest_type = /obj/item/clothing/suit/space/rig/military
	helm_type = /obj/item/clothing/head/helmet/space/rig/military
	boot_type = /obj/item/clothing/shoes/magboots/rig/military
	glove_type = /obj/item/clothing/gloves/rig/military

/obj/item/clothing/head/helmet/space/rig/military
	light_overlay = "helmet_light_dual_green"
	species_restricted = list(SPECIES_HUMAN)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/head.dmi'
		)

/obj/item/clothing/suit/space/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/suit.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/feet.dmi'
		)

/obj/item/clothing/gloves/rig/military
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/hands.dmi'
		)

/obj/item/weapon/rig/military/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit
		)
		
	

	
/////////////////////////////////////////////////////////////
///////////////Dead Space EDF Rig Suits Proper///////////////
/////////////////////////////////////////////////////////////

	
/obj/item/weapon/rig/deadspace/edfsoldier
	name = "advanced edf infantry rig control module"
	suit_type = "advanced edf infantry rig"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "edfgrunt_rig"
	desc = "A reinforced rig suit with several thick armour plates covering vital areas. It bears the emblem of the USM Valor, an Earth Defense Force Destroyer Class vessel. It bears a mission patch on the right shoulder, a crimson red planet with a black Unitologist marker-like structure overshadowing it. 'Operation White Light, Cygnus System' is embroidered into the patch."
	armor = list(melee = 70, bullet = 70, laser = 30, energy = 20, bomb = 50, bio = 50, rad = 50)
	online_slowdown = 0.6
	offline_slowdown = 5
	emp_protection = 10

	chest_type = /obj/item/clothing/suit/space/rig/edfsoldier
	helm_type = /obj/item/clothing/head/helmet/space/rig/edfsoldier
	boot_type = /obj/item/clothing/shoes/magboots/rig/edfsoldier
	glove_type = /obj/item/clothing/gloves/rig/edfsoldier
	
	
/obj/item/clothing/suit/space/rig/edfsoldier
	name = "advanced combat armor"
	breach_threshold = 60

/obj/item/clothing/head/helmet/space/rig/edfsoldier
	name = "advanced combat helmet"
	light_overlay = "helmet_light_dual"
		
/obj/item/clothing/shoes/magboots/rig/edfsoldier
	name = "advanced combat magboots"

/obj/item/clothing/gloves/rig/edfsoldier
	name = "advanced combat gloves"
	siemens_coefficient = 0


/obj/item/weapon/rig/deadspace/edfsoldier/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/mounted/taser	//adding taser here to reflect the stun mode EDF marines had in Dead Space: Aftermath
		)


/obj/item/weapon/rig/deadspace/edfengineer
	name = "advanced edf sapper rig control module"
	suit_type = "advanced edf sapper rig"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "edfengie_rig"
	desc = "A reinforced rig suit with several thick armour plates covering vital areas. It bears the emblem of the USM Valor, an Earth Defense Force Destroyer Class vessel. It bears a mission patch on the right shoulder, a crimson red planet with a black Unitologist marker-like structure overshadowing it. 'Operation White Light, Cygnus System' is embroidered into the patch. The suit has several yellow lines striped across it and the word 'Sapper' stamped on the chest."
	armor = list(melee = 70, bullet = 70, laser = 30, energy = 20, bomb = 90, bio = 70, rad = 90)
	online_slowdown = 0.6
	offline_slowdown = 5
	emp_protection = 10

	chest_type = /obj/item/clothing/suit/space/rig/edfengie
	helm_type = /obj/item/clothing/head/helmet/space/rig/edfengie
	boot_type = /obj/item/clothing/shoes/magboots/rig/edfengie
	glove_type = /obj/item/clothing/gloves/rig/edfengie


/obj/item/clothing/suit/space/rig/edfengie
	name = "advanced combat armor"
	breach_threshold = 60

/obj/item/clothing/head/helmet/space/rig/edfengie
	name = "advanced combat helmet"
	light_overlay = "helmet_light_dual"
		
/obj/item/clothing/shoes/magboots/rig/edfengie
	name = "advanced combat magboots"

/obj/item/clothing/gloves/rig/edfengie
	name = "advanced combat gloves"
	siemens_coefficient = 0


/obj/item/weapon/rig/deadspace/edfengineer/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/mounted/taser	//adding taser here to reflect the stun mode EDF marines had in Dead Space: Aftermath
		)


/obj/item/weapon/rig/deadspace/edfmedic
	name = "advanced edf medic rig control module"
	suit_type = "advanced edf medic rig"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "edfmedic_rig"
	desc = "A reinforced rig suit with several thick armour plates covering vital areas. It bears the emblem of the USM Valor, an Earth Defense Force Destroyer Class vessel. It bears a mission patch on the right shoulder, a crimson red planet with a black Unitologist marker-like structure overshadowing it. 'Operation White Light, Cygnus System' is embroidered into the patch. The suit has a red cross on the chest, as well as the word 'Medic' stamped on the armour."
	armor = list(melee = 70, bullet = 70, laser = 30, energy = 20, bomb = 50, bio = 90, rad = 70)
	online_slowdown = 0.6
	offline_slowdown = 5
	emp_protection = 10

	chest_type = /obj/item/clothing/suit/space/rig/edfmedic
	helm_type = /obj/item/clothing/head/helmet/space/rig/edfmedic
	boot_type = /obj/item/clothing/shoes/magboots/rig/edfmedic
	glove_type = /obj/item/clothing/gloves/rig/edfmedic

	
/obj/item/clothing/suit/space/rig/edfmedic
	name = "advanced combat armor"
	breach_threshold = 60

/obj/item/clothing/head/helmet/space/rig/edfmedic
	name = "advanced combat helmet"
	light_overlay = "helmet_light_dual"
		
/obj/item/clothing/shoes/magboots/rig/edfmedic
	name = "advanced combat magboots"

/obj/item/clothing/gloves/rig/edfmedic
	name = "advanced combat gloves"
	siemens_coefficient = 0


/obj/item/weapon/rig/deadspace/edfmedic/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/mounted/taser	//adding taser here to reflect the stun mode EDF marines had in Dead Space: Aftermath
		)


/obj/item/weapon/rig/deadspace/edfcommander
	name = "advanced edf commander rig control module"
	suit_type = "advanced edf commander rig"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "edfcomm_rig"
	desc = "A reinforced rig suit with several thick armour plates covering vital areas. It bears the emblem of the USM Valor, an Earth Defense Force Destroyer Class vessel. It bears a mission patch on the right shoulder, a crimson red planet with a black Unitologist marker-like structure overshadowing it. 'Operation White Light, Cygnus System' is embroidered into the patch. The suit bears an additional shoulderpad, the mark of a commissioned officer amongst the EDF."
	armor = list(melee = 85, bullet = 85, laser = 30, energy = 20, bomb = 50, bio = 50, rad = 70)
	online_slowdown = 0.4
	offline_slowdown = 5
	emp_protection = 10

	chest_type = /obj/item/clothing/suit/space/rig/edfcommander
	helm_type = /obj/item/clothing/head/helmet/space/rig/edfcommander
	boot_type = /obj/item/clothing/shoes/magboots/rig/edfcommander
	glove_type = /obj/item/clothing/gloves/rig/edfcommander

	
/obj/item/clothing/suit/space/rig/edfcommander
	name = "advanced combat armor"
	breach_threshold = 60

/obj/item/clothing/head/helmet/space/rig/edfcommander
	name = "advanced combat helmet"
	light_overlay = "helmet_light_dual_green"
		
/obj/item/clothing/shoes/magboots/rig/edfcommander
	name = "advanced combat magboots"

/obj/item/clothing/gloves/rig/edfcommander
	name = "advanced combat gloves"
	siemens_coefficient = 0


/obj/item/weapon/rig/deadspace/edfcommander/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/mounted/taser	//adding taser here to reflect the stun mode EDF marines had in Dead Space: Aftermath
		)
		


//////////////////////////////////////////////////////////////////////
///////////////Dead Space Unitologists Rig Suits Proper///////////////
//////////////////////////////////////////////////////////////////////


/obj/item/weapon/rig/deadspace/unisoldier
	name = "unitologist combat rig control module"
	suit_type = "unitologist combat rig"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "unideac_rig"
	desc = "An old combat RIG used by SCAF over two hundred years ago. The armour has seen some wear but still functions as it should, it has been repainted in black and crimson colours. There are unitologist markings across the suit."
	armor = list(melee = 60, bullet = 60, laser = 30, energy = 20, bomb = 30, bio = 40, rad = 40)
	online_slowdown = 0.8
	offline_slowdown = 5
	emp_protection = 10

	chest_type = /obj/item/clothing/suit/space/rig/unisoldier
	helm_type = /obj/item/clothing/head/helmet/space/rig/unisoldier
	boot_type = /obj/item/clothing/shoes/magboots/rig/unisoldier
	glove_type = /obj/item/clothing/gloves/rig/unisoldier
	
	
/obj/item/clothing/suit/space/rig/unisoldier
	name = "combat armor"
	breach_threshold = 60

/obj/item/clothing/head/helmet/space/rig/unisoldier
	name = "combat helmet"
	light_overlay = "helmet_light_dual"
		
/obj/item/clothing/shoes/magboots/rig/unisoldier
	name = "combat magboots"

/obj/item/clothing/gloves/rig/unisoldier
	name = "combat gloves"
	siemens_coefficient = 0


/obj/item/weapon/rig/deadspace/unisoldier/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/voice
		)
		
/obj/item/weapon/rig/deadspace/uniengie
	name = "unitologist engineer rig control module"
	suit_type = "unitologist engineer rig"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "uniengie_rig"
	desc = "An old combat RIG used by SCAF over two hundred years ago. The armour has seen some wear but still functions as it should, it has been repainted in black and crimson colours. There are unitologist markings across the suit. This one includes an RCD module, the equipment of an engineer on the go."
	armor = list(melee = 60, bullet = 60, laser = 30, energy = 20, bomb = 70, bio = 40, rad = 90)
	online_slowdown = 0.8
	offline_slowdown = 5
	emp_protection = 10

	chest_type = /obj/item/clothing/suit/space/rig/uniengie
	helm_type = /obj/item/clothing/head/helmet/space/rig/uniengie
	boot_type = /obj/item/clothing/shoes/magboots/rig/uniengie
	glove_type = /obj/item/clothing/gloves/rig/uniengie
	
	
/obj/item/clothing/suit/space/rig/uniengie
	name = "combat armor"
	breach_threshold = 60

/obj/item/clothing/head/helmet/space/rig/uniengie
	name = "combat helmet"
	light_overlay = "helmet_light_dual"
		
/obj/item/clothing/shoes/magboots/rig/uniengie
	name = "combat magboots"

/obj/item/clothing/gloves/rig/uniengie
	name = "combat gloves"
	siemens_coefficient = 0


/obj/item/weapon/rig/deadspace/uniengie/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/device/rcd
		)


/obj/item/weapon/rig/deadspace/unifaithful
	name = "unitologist zealot combat rig control module"
	suit_type = "unitologist zealot combat rig"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "unifaith_rig"
	desc = "An old combat RIG used by SCAF over two hundred years ago. The armour has seen some wear but still functions as it should, it has been repainted in black and crimson colours. There are unitologist markings across the suit, this one in particular features marker script engraved across the suit, the armour of a zealot."
	armor = list(melee = 60, bullet = 60, laser = 30, energy = 20, bomb = 30, bio = 40, rad = 40)
	online_slowdown = 0.8
	offline_slowdown = 5
	emp_protection = 10

	chest_type = /obj/item/clothing/suit/space/rig/unifaithful
	helm_type = /obj/item/clothing/head/helmet/space/rig/unifaithful
	boot_type = /obj/item/clothing/shoes/magboots/rig/unifaithful
	glove_type = /obj/item/clothing/gloves/rig/unifaithful
	
	
/obj/item/clothing/suit/space/rig/unifaithful
	name = "combat armor"
	breach_threshold = 60

/obj/item/clothing/head/helmet/space/rig/unifaithful
	name = "combat helmet"
	light_overlay = "helmet_light_dual"
		
/obj/item/clothing/shoes/magboots/rig/unifaithful
	name = "zealot combat magboots"

/obj/item/clothing/gloves/rig/unifaithful
	name = "zealot combat gloves"
	siemens_coefficient = 0


/obj/item/weapon/rig/deadspace/unifaithful/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/voice
		)

/obj/item/weapon/rig/deadspace/unimedic
	name = "unitologist medic combat rig control module"
	suit_type = "unitologist medic combat rig"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "unimedic_rig"
	desc = "An old combat RIG used by SCAF over two hundred years ago. The armour has seen some wear but still functions as it should, it has been repainted in black and crimson colours. There are unitologist markings across the suit, this one in particular also features a red cross, indicating a medic."
	armor = list(melee = 50, bullet = 50, laser = 30, energy = 20, bomb = 30, bio = 90, rad = 40)
	online_slowdown = 0.8
	offline_slowdown = 5
	emp_protection = 10

	chest_type = /obj/item/clothing/suit/space/rig/unimedic
	helm_type = /obj/item/clothing/head/helmet/space/rig/unifaithful
	boot_type = /obj/item/clothing/shoes/magboots/rig/unimedic
	glove_type = /obj/item/clothing/gloves/rig/unimedic
	
	
/obj/item/clothing/suit/space/rig/unimedic
	name = "combat armor"
	breach_threshold = 60

/obj/item/clothing/head/helmet/space/rig/unimedic
	name = "combat helmet"
	light_overlay = "helmet_light_dual"
		
/obj/item/clothing/shoes/magboots/rig/unimedic
	name = "combat magboots"

/obj/item/clothing/gloves/rig/unimedic
	name = "combat gloves"
	siemens_coefficient = 0


/obj/item/weapon/rig/deadspace/unimedic/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/voice
		)


/obj/item/weapon/rig/deadspace/unizerker
	name = "unitologist berserker combat rig control module"
	suit_type = "unitologist berserker combat rig"
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "unizerk_rig"
	desc = "An extremely heavy reinforced urban combat rig painted in Unitologist iconography and... blood. Definitely something that only a madman would wear."
	armor = list(melee = 90, bullet = 90, laser = 30, energy = 20, bomb = 70, bio = 40, rad = 40)
	online_slowdown = 3 //higher slowdown since this suit is supposedly more protective.
	offline_slowdown = 5
	emp_protection = 10

	chest_type = /obj/item/clothing/suit/space/rig/unizerk
	helm_type = /obj/item/clothing/head/helmet/space/rig/unizerk
	boot_type = /obj/item/clothing/shoes/magboots/rig/unizerk
	glove_type = /obj/item/clothing/gloves/rig/unizerk
	
	
/obj/item/clothing/suit/space/rig/unizerk
	name = "combat armor"
	breach_threshold = 60

/obj/item/clothing/head/helmet/space/rig/unizerk
	name = "combat helmet"
	light_overlay = "helmet_light_dual"
		
/obj/item/clothing/shoes/magboots/rig/unizerk
	name = "combat magboots"

/obj/item/clothing/gloves/rig/unizerk
	name = "combat gloves"
	siemens_coefficient = 0


/obj/item/weapon/rig/deadspace/unizerker/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit,
		/obj/item/rig_module/voice
		)
