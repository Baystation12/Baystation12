GLOBAL_DATUM_INIT(renegades, /datum/antagonist/renegade, new)

/datum/antagonist/renegade
	role_text = "Renegade"
	role_text_plural = "Renegades"
	blacklisted_jobs = list(/datum/job/ai, /datum/job/submap)
	restricted_jobs = list(/datum/job/officer, /datum/job/warden, /datum/job/hos, /datum/job/captain)
	welcome_text = "Something's going to go wrong today, you can just feel it. You're paranoid, you've got a gun, and you're going to survive."
	antag_text = "You are a <b>minor</b> antagonist! Within the rules, \
		try to protect yourself and what's important to you. You aren't here to <i>cause</i> trouble, \
		you're just willing (and equipped) to go to extremes to <b>stop</b> it. \
		Your job is to oppose the other antagonists, should they threaten you, in ways that aren't quite legal. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to antagonists.</b>"

	id = MODE_RENEGADE
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 3
	hard_cap_round = 5

	initial_spawn_req = 1
	initial_spawn_target = 3
	antaghud_indicator = "hud_renegade"
	skill_setter = /datum/antag_skill_setter/station

	var/list/spawn_guns = list(
		/obj/item/weapon/gun/energy/retro,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/gun/energy/crossbow,
		/obj/item/weapon/gun/energy/pulse_rifle/pistol,
		/obj/item/weapon/gun/projectile/automatic,
		/obj/item/weapon/gun/projectile/automatic/machine_pistol,
		/obj/item/weapon/gun/projectile/automatic/sec_smg,
		/obj/item/weapon/gun/projectile/pistol/magnum_pistol,
		/obj/item/weapon/gun/projectile/pistol/military,
		/obj/item/weapon/gun/projectile/pistol/military/alt,
		/obj/item/weapon/gun/projectile/pistol/sec/lethal,
		/obj/item/weapon/gun/projectile/pistol/holdout,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/weapon/gun/projectile/revolver/medium,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn,
		/obj/item/weapon/gun/projectile/pistol/magnum_pistol,
		/obj/item/weapon/gun/projectile/revolver/holdout,
		/obj/item/weapon/gun/projectile/pistol/throwback
		)

/datum/antagonist/renegade/create_objectives(var/datum/mind/player)

	if(!..())
		return

	var/datum/objective/survive/survive = new
	survive.owner = player
	player.objectives |= survive

/datum/antagonist/renegade/equip(var/mob/living/carbon/human/player)

	if(!..())
		return

	var/gun_type = pick(spawn_guns)
	if(islist(gun_type))
		gun_type = pick(gun_type)
	var/obj/item/gun = new gun_type(get_turf(player))

	// Attempt to put into a container.
	if(player.equip_to_storage(gun))
		return

	// If that failed, attempt to put into any valid non-handslot
	if(player.equip_to_appropriate_slot(gun))
		return

	// If that failed, then finally attempt to at least let the player carry the weapon
	player.put_in_hands(gun)


/proc/rightandwrong()
	to_chat(usr, "<B>You summoned guns!</B>")
	message_admins("[key_name_admin(usr, 1)] summoned guns!")
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == 2 || !(H.client)) continue
		if(is_special_character(H)) continue
		GLOB.renegades.add_antagonist(H.mind)
