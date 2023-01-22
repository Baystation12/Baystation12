GLOBAL_DATUM_INIT(mercs, /datum/antagonist/mercenary, new)

/datum/antagonist/mercenary
	id = MODE_MERCENARY
	role_text = "Mercenary"
	antag_indicator = "hudsyndicate"
	role_text_plural = "Mercenaries"
	landmark_id = "Syndicate-Spawn"
	leader_welcome_text = "You are the leader of the mercenary strikeforce; hail to the chief. Use :t to speak to your underlings."
//	welcome_text = "To speak on the strike team's private channel use :t."  // ORIG

// proxima code start
	welcome_text = "<hr><u>Работа должна быть выполнена, а те, кто согласен идти с вами через ад должны остаться \
	в живых</u> - это первое, о чём вам стоило бы задуматься, когда Вы согласились на эту роль. Ваша работа \
	состоит из выполнения специфичных заказов от <b>очень</b> серьезных людей - политические убийства, \
	терракты, уничтожение лабораторий корпораций, захват заложников, кража исследований и другие операции, \
	о которых корпорация или государство не стало бы афишировать. <u>Вы должны уничтожить судно \
	с помощью ядерного заряда, предварительно выкачав оттуда всё ценное - исследования, учёных, глав и всех, \
	кому хватит мозгов сдаться вам.</u> \
	Доставьте их в качестве заложников на свою базу за минуту до того, как залитый кровью невинных корабль \
	будет уничтожен ядерным огнём. <br>Используйте префикс ':t' для общения со своими через рацию.\
	<br><b>Определитесь с главным и постарайтесь не прикончить друг друга ещё до начала операции.</b>"
// proxima code end

	flags = ANTAG_VOTABLE | ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudoperative"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 3
	initial_spawn_target = 5
	min_player_age = 14

	faction = "mercenary"

	base_to_load = /datum/map_template/ruin/antag_spawn/mercenary

// proxima code start
/datum/antagonist/mercenary/create_objectives(var/datum/mind/mercenary, override = 1)
	if(!..())
		return
// proxima code end

/datum/antagonist/mercenary/create_global_objectives(override = TRUE)
	if(!..())
		return 0
	global_objectives = list()
//	global_objectives |= new /datum/objective/nuclear
// proxima code start
	var/datum/objective/nuclear/kidnap/K
	K = new /datum/objective/nuclear/kidnap()
	K.choose_target()
	global_objectives |= K
	global_objectives |= new /datum/objective/nuclear/steal //INF
	global_objectives |= new /datum/objective/nuclear/steal_AI //INF
	global_objectives |= new /datum/objective/nuclear/researches //INF
	global_objectives |= new /datum/objective/nuclear //INF
// proxima code end
	return 1

/datum/antagonist/mercenary/equip(var/mob/living/carbon/human/player)
	if(!..())
		return 0

	var/decl/hierarchy/outfit/mercenary = outfit_by_type(/decl/hierarchy/outfit/mercenary)
	mercenary.equip(player)

/* [ORIG]
	var/obj/item/device/radio/uplink/U = new(get_turf(player), player.mind, DEFAULT_TELECRYSTAL_AMOUNT)
	player.put_in_hands(U)
[/ORIG] */

// proxima code start
	if(player.mind == leader)
		var/obj/item/device/radio/uplink/U = new(get_turf(player), player.mind, TEAM_TELECRYSTAL_AMOUNT)
		player.put_in_hands(U)
		var/obj/item/clothing/head/beret/leader = new(get_turf(player))
		player.equip_to_slot_or_del(leader, slot_head)
		var/obj/item/paper/roles_nuclear/paper = new(get_turf(player))
		player.put_in_hands(paper)
		var/obj/machinery/nuclearbomb/nuke = locate(/obj/machinery/nuclearbomb/station) in SSmachines.machinery
		player.StoreMemory("<b>Код для активации устройства самоуничтожения [GLOB.using_map.full_name]:</b> [nuke.r_code]", /decl/memory_options/system)
	else
		var/obj/item/device/radio/uplink/U = new(get_turf(player), player.mind, 0)
		player.put_in_hands(U)
		var/obj/item/paper/roles_nuclear/paper = new(get_turf(player))
		player.put_in_hands(paper)
// proxima code end

	return 1

/datum/antagonist/mercenary/equip_vox(mob/living/carbon/human/vox, mob/living/carbon/human/old)
	vox.equip_to_slot_or_del(new /obj/item/clothing/under/vox/vox_casual(vox), slot_w_uniform)
	vox.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(vox), slot_shoes)
	vox.equip_to_slot_or_del(new /obj/item/clothing/gloves/vox(vox), slot_gloves)
	vox.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat/vox(vox), slot_wear_mask)
	vox.equip_to_slot_or_del(new /obj/item/tank/nitrogen(vox), slot_back)
	vox.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(vox), slot_glasses)
	vox.equip_to_slot_or_del(new /obj/item/card/id/syndicate(vox), slot_wear_id)
	vox.put_in_hands(locate(/obj/item/device/radio/uplink) in old.contents)
	vox.set_internals(locate(/obj/item/tank) in vox.contents)


/obj/item/vox_changer/merc
	allowed_role = "Mercenary"

/obj/item/vox_changer/merc/OnCreated(mob/living/carbon/human/vox, mob/living/carbon/human/old)
	GLOB.mercs.equip_vox(vox, old)

/obj/item/vox_changer/merc/OnReady(mob/living/carbon/human/vox, mob/living/carbon/human/old)
	GLOB.mercs.update_access(vox)
