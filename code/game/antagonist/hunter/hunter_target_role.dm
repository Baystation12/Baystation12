/decl/hvt_role
	var/article = "a"
	var/name = "High Value Target"
	var/description = "You are a high value target of some sort. If you can see this, please make a bug report."
	var/outfit = /decl/hierarchy/outfit/hunter/vip
	var/force_species
	var/force_gender

	var/list/allowed_bodyguards
	var/list/disallowed_bodyguards
	var/list/allowed_leaders
	var/list/disallowed_leaders
	var/list/allowed_species
	var/list/disallowed_species

	var/doc_name
	var/doc_desc
	var/doc_icon
	var/doc_icon_state
	var/is_bodyguard = FALSE

/decl/hvt_role/proc/apply_to(var/mob/living/carbon/human/player)
	if(force_species && player.species.get_bodytype(player) != force_species)
		player.set_species(force_species)
	if(force_gender && player.gender != force_gender)
		player.gender = force_gender
		player.update_body()
		player.updatehealth()
		player.UpdateDamageIcon()
	if(outfit)
		for(var/obj/item/thing in player.contents)
			if(istype(thing, /obj/item/high_value_target_documents) && player.unEquip(thing))
				qdel(thing)
		var/decl/hierarchy/outfit/outfit_decl = outfit_by_type(outfit)
		outfit_decl.equip(player)
		GLOB.hunter_targets.create_id(name, player)
	player.mind.special_role = name
	to_chat(player, SPAN_NOTICE("<b>You are [article] [name]!</b>"))
	to_chat(player, SPAN_NOTICE(description))
	if(is_bodyguard)
		to_chat(GLOB.hunter_targets.leader?.current, SPAN_NOTICE("<b>One of your bodyguards is [player.real_name], [article] [name].</b>"))
	else if(GLOB.hunter_targets.leader == player.mind)
		GLOB.hunter_targets.leader_picked_role = src
		for(var/datum/mind/player_mind in GLOB.hunter_targets.current_antagonists)
			if(player_mind != GLOB.hunter_targets.leader)
				to_chat(player_mind.current, SPAN_NOTICE("<b>Your assigned ward is [player.real_name], [article] [name]. You should now pick your role using your official documentation!</b>"))
		for(var/datum/mind/player_mind in GLOB.hunters.current_antagonists)
			to_chat(player_mind.current, SPAN_DANGER("The target is [GLOB.hunter_targets.leader.current.real_name], [article] [name]. Bring them in warm or cold."))

/decl/hvt_role/proc/apply_to_prop(var/obj/item/high_value_target_documents/docs)
	if(doc_name)       docs.name = doc_name
	if(doc_desc)       docs.desc = doc_desc
	if(doc_icon)       docs.icon = doc_icon
	if(doc_icon_state) docs.icon_state = doc_icon_state

/obj/item/high_value_target_documents
	name = "official documentation"
	desc = "A thick sheaf of important, official-looking documentation."
	var/role_set = FALSE
	var/is_bodyguard_docs = FALSE
	var/mob/living/carbon/human/owner

/obj/item/high_value_target_documents/examine(mob/user, distance)
	. = ..()
	if(!role_set && user == owner && user.mind && GLOB.hunter_targets.is_antagonist(user.mind))
		to_chat(owner, SPAN_NOTICE("<b>You can use these documents in-hand to set your official role on [station_name()].</b>"))
	
/obj/item/high_value_target_documents/Destroy()
	owner = null
	. = ..()

/obj/item/high_value_target_documents/Initialize(var/ml, var/mob/living/carbon/human/_owner)
	if(istype(_owner))
		owner = _owner
	. = ..()

/obj/item/high_value_target_documents/attack_self(mob/user)
	if(role_set || user != owner || !user.mind || !GLOB.hunter_targets.is_antagonist(user.mind))
		return ..()
	update_hvt_role()
	return TRUE

/obj/item/high_value_target_documents/proc/get_roles()
	. = list()
	var/list/all_roles = decls_repository.get_decls_of_subtype(/decl/hvt_role)
	for(var/rtype in all_roles)
		var/decl/hvt_role/role = all_roles[rtype]
		if(role.is_bodyguard != is_bodyguard_docs)
			continue
		if(role.force_species && !is_alien_whitelisted(owner, role.force_species))
			continue
		if(length(role.disallowed_species) && (owner.species.get_bodytype(owner) in role.disallowed_species))
			continue
		. |= role

/obj/item/high_value_target_documents/proc/update_hvt_role()
	var/list/options = get_roles()
	var/decl/hvt_role/role = input(owner, "Which high value target role do you wish to be?", "High Value Target Role") as null|anything in options
	if(role_set || !role || !owner || !owner.mind || !owner.client || loc != owner || !GLOB.hunter_targets.is_antagonist(owner.mind))
		return
	role.apply_to(owner)
	role.apply_to_prop(src)
	role_set = TRUE

/obj/item/high_value_target_documents/bodyguard
	is_bodyguard_docs = TRUE

/obj/item/high_value_target_documents/bodyguard/get_roles()
	if(!GLOB.hunter_targets.leader_picked_role)
		return list()
	. = ..()
	var/decl/hvt_role/leader_role = GLOB.hunter_targets.leader_picked_role
	for(var/decl/hvt_role/role in .)
		if(length(leader_role.allowed_bodyguards) && !(role.type in leader_role.allowed_bodyguards))
			. -= role
			continue
		if(length(leader_role.disallowed_bodyguards) && (role.type in leader_role.disallowed_bodyguards))
			. -= role
			continue
		if(length(role.allowed_leaders) && !(leader_role.type in role.allowed_leaders))
			. -= role
			continue
		if(length(role.disallowed_leaders) && (leader_role.type in role.disallowed_leaders))
			. -= role
			continue
		if(role.force_species)
			if(length(leader_role.allowed_species) && !(role.force_species in leader_role.allowed_species))
				. -= role
				continue
			if(length(leader_role.disallowed_species) && (role.force_species in leader_role.disallowed_species))
				. -= role
				continue

/obj/item/high_value_target_documents/bodyguard/update_hvt_role()
	if(!GLOB.hunter_targets.leader_picked_role)
		to_chat(owner, SPAN_WARNING("You will need to wait for your leader to pick their role before you can pick yours."))
		return FALSE
	. = ..()

/decl/hierarchy/outfit/hunter
	hierarchy_type = /decl/hierarchy/outfit/hunter
	l_ear =          /obj/item/device/radio/headset
	id_types =       list(/obj/item/weapon/card/id)
	id_slot =        slot_wear_id

/decl/hierarchy/outfit/hunter/vip
	name = OUTFIT_JOB_NAME("Bounty Hunter VIP")
	uniform = /obj/item/clothing/under/suit_jacket/burgundy
	shoes =   /obj/item/clothing/shoes/laceup

/decl/hierarchy/outfit/hunter/bodyguard
	name = OUTFIT_JOB_NAME("Bounty Hunter VIP Bodyguard")
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	shoes =   /obj/item/clothing/shoes/black
	holster = /obj/item/clothing/accessory/storage/holster/armpit
	l_hand =  /obj/item/weapon/gun/projectile/pistol/holdout
