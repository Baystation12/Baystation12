GLOBAL_DATUM_INIT(raiders, /datum/antagonist/raider, new)

/datum/antagonist/raider
	id = MODE_RAIDER
	role_text = "Raider"
	role_text_plural = "Raiders"
	antag_indicator = "hudraider"
	landmark_id = "voxstart"
	welcome_text = "Use :H to talk on your encrypted channel."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudraider"

	hard_cap = 6
	hard_cap_round = 10
	initial_spawn_req = 3
	initial_spawn_target = 4
	min_player_age = 14

	id_type = /obj/item/card/id/syndicate

	faction = "pirate"
	base_to_load = /datum/map_template/ruin/antag_spawn/heist

	var/list/raider_uniforms = list(
		/obj/item/clothing/under/soviet,
		/obj/item/clothing/under/pirate,
		/obj/item/clothing/under/redcoat,
		/obj/item/clothing/under/serviceoveralls,
		/obj/item/clothing/under/captain_fly,
		/obj/item/clothing/under/det,
		/obj/item/clothing/under/color/brown,
		)

	var/list/raider_shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/laceup
		)

	var/list/raider_helmets = list(
		/obj/item/clothing/head/bearpelt,
		/obj/item/clothing/head/ushanka,
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/mask/bandana/red,
		/obj/item/clothing/head/hgpiratecap,
		)

	var/list/raider_suits = list(
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/suit/hgpirate,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/storage/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/brown_jacket,
		/obj/item/clothing/suit/storage/toggle/hoodie,
		/obj/item/clothing/suit/storage/toggle/hoodie/black,
		/obj/item/clothing/suit/unathi/mantle,
		/obj/item/clothing/suit/poncho/colored,
		)

	var/list/raider_guns = list(
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/retro,
		/obj/item/gun/energy/xray,
		/obj/item/gun/energy/xray/pistol,
		/obj/item/gun/energy/mindflayer,
		/obj/item/gun/energy/toxgun,
		/obj/item/gun/energy/stunrevolver,
		/obj/item/gun/energy/ionrifle,
		/obj/item/gun/energy/taser,
		/obj/item/gun/energy/crossbow/largecrossbow,
		/obj/item/gun/launcher/crossbow,
		/obj/item/gun/launcher/grenade/loaded,
		/obj/item/gun/launcher/pneumatic,
		/obj/item/gun/projectile/automatic/machine_pistol,
		/obj/item/gun/projectile/automatic/merc_smg,
		/obj/item/gun/projectile/automatic/sec_smg,
		/obj/item/gun/projectile/automatic/assault_rifle,
		/obj/item/gun/projectile/shotgun/pump,
		/obj/item/gun/projectile/shotgun/pump/combat,
		/obj/item/gun/projectile/shotgun/doublebarrel,
		/obj/item/gun/projectile/shotgun/doublebarrel/pellet,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn,
		/obj/item/gun/projectile/pistol/sec,
		/obj/item/gun/projectile/pistol/holdout,
		/obj/item/gun/projectile/revolver,
		/obj/item/gun/projectile/pirate,
		/obj/item/gun/projectile/revolver/medium,
		/obj/item/gun/projectile/pistol/broomstick
		)

	var/list/raider_holster = list(
		/obj/item/clothing/accessory/storage/holster/armpit,
		/obj/item/clothing/accessory/storage/holster/waist,
		/obj/item/clothing/accessory/storage/holster/hip
		)

/datum/antagonist/raider/update_access(var/mob/living/player)
	for(var/obj/item/storage/wallet/W in player.contents)
		for(var/obj/item/card/id/id in W.contents)
			id.SetName("[player.real_name]'s Passport")
			id.registered_name = player.real_name
			W.SetName("[initial(W.name)] ([id.name])")

/datum/antagonist/raider/create_global_objectives()

	if(!..())
		return 0

	var/i = 1
	var/max_objectives = pick(2,2,2,2,3,3,3,4)
	global_objectives = list()
	while(i<= max_objectives)
		var/list/goals = list("kidnap","loot","salvage")
		var/goal = pick(goals)
		var/datum/objective/heist/O

		if(goal == "kidnap")
			goals -= "kidnap"
			O = new /datum/objective/heist/kidnap()
		else if(goal == "loot")
			O = new /datum/objective/heist/loot()
		else
			O = new /datum/objective/heist/salvage()
		O.choose_target()
		global_objectives |= O

		i++

	global_objectives |= new /datum/objective/heist/preserve_crew
	return 1

/datum/antagonist/raider/proc/is_raider_crew_safe()

	if(!current_antagonists || current_antagonists.len == 0)
		return 0

	for(var/datum/mind/player in current_antagonists)
		if(!player.current || get_area(player.current) != locate(/area/map_template/skipjack_station/start))
			return 0
	return 1

/datum/antagonist/raider/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	if(player.species && player.species.get_bodytype(player) == SPECIES_VOX)
		equip_vox(player)
	else
		var/new_shoes =   pick(raider_shoes)
		var/new_uniform = pick(raider_uniforms)
		var/new_helmet =  pick(raider_helmets)
		var/new_suit =    pick(raider_suits)

		player.equip_to_slot_or_del(new new_shoes(player),slot_shoes)
		if(!player.shoes)
			//If equipping shoes failed, fall back to equipping sandals
			var/fallback_type = pick(/obj/item/clothing/shoes/sandal, /obj/item/clothing/shoes/jackboots/unathi)
			player.equip_to_slot_or_del(new fallback_type(player), slot_shoes)

		player.equip_to_slot_or_del(new new_uniform(player),slot_w_uniform)
		player.equip_to_slot_or_del(new new_helmet(player),slot_head)
		player.equip_to_slot_or_del(new new_suit(player),slot_wear_suit)
		equip_weapons(player)

	var/obj/item/card/id/id = create_id("Visitor", player, equip = 0)
	id.SetName("[player.real_name]'s Passport")
	id.assignment = "Visitor"
	var/obj/item/storage/wallet/W = new(player)
	W.handle_item_insertion(id)
	if(player.equip_to_slot_or_del(W, slot_wear_id))
		spawn_money(rand(50,150)*10,W)
	create_radio(RAID_FREQ, player)

	return 1

/datum/antagonist/raider/proc/equip_weapons(var/mob/living/carbon/human/player)
	var/new_gun = pick(raider_guns)
	var/new_holster = pick(raider_holster) //raiders don't start with any backpacks, so let's be nice and give them a holster if they can use it.
	var/turf/T = get_turf(player)

	var/obj/item/primary = new new_gun(T)
	var/obj/item/clothing/accessory/storage/holster/holster = null

	//Give some of the raiders a pirate gun as a secondary
	if(prob(60))
		var/obj/item/secondary = new /obj/item/gun/projectile/pirate(T)
		if(!(primary.slot_flags & SLOT_HOLSTER))
			holster = new new_holster(T)
			var/datum/extension/holster/H = get_extension(holster, /datum/extension/holster)
			H.holster(secondary, player)
		else
			player.equip_to_slot_or_del(secondary, slot_belt)

	if(primary.slot_flags & SLOT_HOLSTER)
		holster = new new_holster(T)
		var/datum/extension/holster/H = get_extension(holster, /datum/extension/holster)
		H.holster(primary, player)
	else if(!player.belt && (primary.slot_flags & SLOT_BELT))
		player.equip_to_slot_or_del(primary, slot_belt)
	else if(!player.back && (primary.slot_flags & SLOT_BACK))
		player.equip_to_slot_or_del(primary, slot_back)
	else
		player.put_in_any_hand_if_possible(primary)

	//If they got a projectile gun, give them a little bit of spare ammo
	equip_ammo(player, primary)

	if(holster)
		var/obj/item/clothing/under/uniform = player.w_uniform
		if(istype(uniform) && uniform.can_attach_accessory(holster))
			uniform.attackby(holster, player)
		else
			player.put_in_any_hand_if_possible(holster)

/datum/antagonist/raider/proc/equip_ammo(var/mob/living/carbon/human/player, var/obj/item/gun/gun)
	if(istype(gun, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/bullet_thrower = gun
		if(bullet_thrower.magazine_type)
			player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_l_store)
			if(prob(20)) //don't want to give them too much
				player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_r_store)
		else if(bullet_thrower.ammo_type)
			var/obj/item/storage/box/ammobox = new(get_turf(player.loc))
			for(var/i in 1 to rand(3,5) + rand(0,2))
				new bullet_thrower.ammo_type(ammobox)
			player.put_in_any_hand_if_possible(ammobox)
		return

/datum/antagonist/raider/equip_vox(mob/living/carbon/human/vox, mob/living/carbon/human/old)

	var/uniform_type = pick(list(/obj/item/clothing/under/vox/vox_robes,/obj/item/clothing/under/vox/vox_casual))
	var/new_holster = pick(raider_holster)

	vox.equip_to_slot_or_del(new uniform_type(vox), slot_w_uniform)
	vox.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(vox), slot_shoes) // REPLACE THESE WITH CODED VOX ALTERNATIVES.
	vox.equip_to_slot_or_del(new /obj/item/clothing/gloves/vox(vox), slot_gloves) // AS ABOVE.
	vox.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat/vox(vox), slot_wear_mask)
	vox.equip_to_slot_or_del(new /obj/item/tank/nitrogen(vox), slot_back)
	vox.equip_to_slot_or_del(new /obj/item/device/flashlight(vox), slot_r_store)

	var/obj/item/clothing/accessory/storage/holster/holster = new new_holster
	if(holster)
		var/obj/item/clothing/under/uniform = vox.w_uniform
		if(istype(uniform) && uniform.can_attach_accessory(holster))
			uniform.attackby(holster, vox)
		else
			vox.put_in_any_hand_if_possible(holster)

	vox.set_internals(locate(/obj/item/tank) in vox.contents)

/obj/random/raider/hardsuit
	name = "Random Raider Hardsuit"
	desc = "This is a random hardsuit control module."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"

/obj/random/raider/hardsuit/spawn_choices()
	return list(/obj/item/rig/industrial,
				/obj/item/rig/eva,
				/obj/item/rig/light/hacker,
				/obj/item/rig/light,
				/obj/item/rig/unathi
	)

/obj/random/raider/lilgun
	name = "Random Raider Light Weapon"
	desc = "This is a random raider sidearm."
	icon = 'icons/obj/guns/pistol.dmi'
	icon_state = "secguncomp"

/obj/random/raider/lilgun/spawn_choices()
	return list(/obj/item/gun/projectile/pistol/sec,
				/obj/item/gun/energy/gun,
				/obj/item/gun/energy/stunrevolver,
				/obj/item/gun/projectile/shotgun/doublebarrel/sawn,
				/obj/item/gun/energy/xray/pistol,
				/obj/item/gun/energy/pulse_rifle/pistol,
				/obj/item/gun/energy/plasmacutter,
				/obj/item/gun/energy/incendiary_laser,
				/obj/item/gun/projectile/automatic/machine_pistol,
				/obj/item/gun/projectile/pistol/military/alt,
				/obj/item/gun/projectile/pistol/holdout,
				/obj/item/gun/projectile/revolver,
				/obj/item/gun/projectile/revolver/medium,
				/obj/item/gun/energy/retro,
				/obj/item/gun/projectile/pistol/throwback,
				/obj/item/gun/energy/ionrifle/small
	)

/obj/random/raider/biggun
	name = "Random Raider Heavy Weapon"
	desc = "This is a random raider rifle."
	icon = 'icons/obj/guns/assault_rifle.dmi'
	icon_state = "arifle"

/obj/random/raider/biggun/spawn_choices()
	return list(/obj/item/gun/energy/lasercannon,
				/obj/item/gun/energy/laser,
				/obj/item/gun/energy/captain,
				/obj/item/gun/energy/pulse_rifle,
				/obj/item/gun/energy/pulse_rifle/carbine,
				/obj/item/gun/energy/sniperrifle,
				/obj/item/gun/projectile/shotgun/doublebarrel,
				/obj/item/gun/energy/xray,
				/obj/item/gun/projectile/automatic/battlerifle,
				/obj/item/gun/projectile/sniper/semistrip,
				/obj/item/gun/projectile/sniper/garand,
				/obj/item/gun/projectile/automatic/assault_rifle,
				/obj/item/gun/projectile/automatic/sec_smg,
				/obj/item/gun/energy/crossbow/largecrossbow,
				/obj/item/gun/projectile/shotgun/pump/combat,
				/obj/item/gun/energy/ionrifle,
				/obj/item/gun/projectile/shotgun/pump
	)

/obj/item/vox_changer/raider
	allowed_role = "Raider"

/obj/item/vox_changer/raider/OnCreated(mob/living/carbon/human/vox, mob/living/carbon/human/old)
	GLOB.raiders.equip_vox(vox, old)

/obj/item/vox_changer/raider/OnReady(mob/living/carbon/human/vox, mob/living/carbon/human/old)
	GLOB.raiders.update_access(vox)
