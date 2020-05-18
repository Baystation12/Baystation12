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
	initial_spawn_req = 4
	initial_spawn_target = 6
	min_player_age = 14

	id_type = /obj/item/weapon/card/id/syndicate

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

	var/list/raider_glasses = list(
		/obj/item/clothing/glasses/thermal,
		/obj/item/clothing/glasses/thermal/plain/eyepatch,
		/obj/item/clothing/glasses/thermal/plain/monocle
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
		/obj/item/weapon/gun/energy/laser,
		/obj/item/weapon/gun/energy/retro,
		/obj/item/weapon/gun/energy/xray,
		/obj/item/weapon/gun/energy/xray/pistol,
		/obj/item/weapon/gun/energy/mindflayer,
		/obj/item/weapon/gun/energy/toxgun,
		/obj/item/weapon/gun/energy/stunrevolver,
		/obj/item/weapon/gun/energy/ionrifle,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/weapon/gun/energy/crossbow/largecrossbow,
		/obj/item/weapon/gun/launcher/crossbow,
		/obj/item/weapon/gun/launcher/grenade/loaded,
		/obj/item/weapon/gun/launcher/pneumatic,
		/obj/item/weapon/gun/projectile/automatic/machine_pistol,
		/obj/item/weapon/gun/projectile/automatic/merc_smg,
		/obj/item/weapon/gun/projectile/automatic/sec_smg,
		/obj/item/weapon/gun/projectile/automatic/assault_rifle,
		/obj/item/weapon/gun/projectile/shotgun/pump,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn,
		/obj/item/weapon/gun/projectile/pistol/sec,
		/obj/item/weapon/gun/projectile/pistol/holdout,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/weapon/gun/projectile/pirate,
		/obj/item/weapon/gun/projectile/revolver/medium,
		/obj/item/weapon/gun/projectile/pistol/throwback
		)

	var/list/raider_holster = list(
		/obj/item/clothing/accessory/storage/holster/armpit,
		/obj/item/clothing/accessory/storage/holster/waist,
		/obj/item/clothing/accessory/storage/holster/hip
		)

/datum/antagonist/raider/update_access(var/mob/living/player)
	for(var/obj/item/weapon/storage/wallet/W in player.contents)
		for(var/obj/item/weapon/card/id/id in W.contents)
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
		var/new_glasses = pick(raider_glasses)
		var/new_helmet =  pick(raider_helmets)
		var/new_suit =    pick(raider_suits)

		player.equip_to_slot_or_del(new new_shoes(player),slot_shoes)
		if(!player.shoes)
			//If equipping shoes failed, fall back to equipping sandals
			var/fallback_type = pick(/obj/item/clothing/shoes/sandal, /obj/item/clothing/shoes/jackboots/unathi)
			player.equip_to_slot_or_del(new fallback_type(player), slot_shoes)

		player.equip_to_slot_or_del(new new_uniform(player),slot_w_uniform)
		player.equip_to_slot_or_del(new new_glasses(player),slot_glasses)
		player.equip_to_slot_or_del(new new_helmet(player),slot_head)
		player.equip_to_slot_or_del(new new_suit(player),slot_wear_suit)
		equip_weapons(player)

	var/obj/item/weapon/card/id/id = create_id("Visitor", player, equip = 0)
	id.SetName("[player.real_name]'s Passport")
	id.assignment = "Visitor"
	var/obj/item/weapon/storage/wallet/W = new(player)
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
		var/obj/item/secondary = new /obj/item/weapon/gun/projectile/pirate(T)
		if(!(primary.slot_flags & SLOT_HOLSTER))
			holster = new new_holster(T)
			var/datum/extension/holster/H = get_extension(holster, /datum/extension/holster)
			H.holstered = secondary
			secondary.forceMove(holster)
		else
			player.equip_to_slot_or_del(secondary, slot_belt)

	if(primary.slot_flags & SLOT_HOLSTER)
		holster = new new_holster(T)
		var/datum/extension/holster/H = get_extension(holster, /datum/extension/holster)
		H.holstered = primary
		primary.forceMove(holster)
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

/datum/antagonist/raider/proc/equip_ammo(var/mob/living/carbon/human/player, var/obj/item/weapon/gun/gun)
	if(istype(gun, /obj/item/weapon/gun/projectile))
		var/obj/item/weapon/gun/projectile/bullet_thrower = gun
		if(bullet_thrower.magazine_type)
			player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_l_store)
			if(prob(20)) //don't want to give them too much
				player.equip_to_slot_or_del(new bullet_thrower.magazine_type(player), slot_r_store)
		else if(bullet_thrower.ammo_type)
			var/obj/item/weapon/storage/box/ammobox = new(get_turf(player.loc))
			for(var/i in 1 to rand(3,5) + rand(0,2))
				new bullet_thrower.ammo_type(ammobox)
			player.put_in_any_hand_if_possible(ammobox)
		return

/datum/antagonist/raider/proc/equip_vox(var/mob/living/carbon/human/player)

	var/uniform_type = pick(list(/obj/item/clothing/under/vox/vox_robes,/obj/item/clothing/under/vox/vox_casual))
	var/new_glasses = pick(raider_glasses)
	var/new_holster = pick(raider_holster)

	player.equip_to_slot_or_del(new uniform_type(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(player), slot_shoes) // REPLACE THESE WITH CODED VOX ALTERNATIVES.
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/vox(player), slot_gloves) // AS ABOVE.
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat/vox(player), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(player), slot_back)
	player.equip_to_slot_or_del(new /obj/item/device/flashlight(player), slot_r_store)
	player.equip_to_slot_or_del(new new_glasses(player),slot_glasses)
	
	var/obj/item/clothing/accessory/storage/holster/holster = new new_holster
	if(holster)
		var/obj/item/clothing/under/uniform = player.w_uniform
		if(istype(uniform) && uniform.can_attach_accessory(holster))
			uniform.attackby(holster, player)
		else
			player.put_in_any_hand_if_possible(holster)
	
	player.set_internals(locate(/obj/item/weapon/tank) in player.contents)
	return 1

