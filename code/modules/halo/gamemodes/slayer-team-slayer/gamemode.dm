
/datum/game_mode/slayer
	name = "Slayer Free For All"
	round_description = "Free for all: fight to the death."
	extended_round_description = "Free for all: fight to the death."
	config_tag = "Slayer FFA"
	deny_respawn = 1 //We'll do that ourselves.
	votable = 1
	probability = 0
	var/obj/effect/spawnpoint/spwnpts = list()
	var/slayer_maps = list()
	var/time_to_next_respawn = 300 //Deciseconds.
	var/respawnwhen
	var/loadouts = list(/datum/slayernormal/)
	var/players = list()
	var/nospawn = list()

/datum/game_mode/slayer/proc/setup_antag(var/mob/h)

/datum/game_mode/slayer/post_setup()
	. = ..()
	respawnwhen = world.time + time_to_next_respawn
	for(var/obj/effect/spawnpoint/s in world)
		spwnpts += s

/datum/game_mode/slayer/proc/newplayer(var/mob/living/carbon/human/h,var/teamfaction = "neutral")
	var/spwn = list()
	if(h.faction == "neutral")
		spwn = spwnpts
	else
		for(var/obj/i in spwnpts) //Removed the check for mobs in view because it could easily lead to spawncamping.
			if(i.name == h.faction)
				spwn += i
				continue
	if(!spwn) // So we don't get an empty spawnlist
		to_world("No Team Spawnpoints found. Falling back to Free For All spawns.")
		spwn = spwnpts
	var/obj/location = pick(spwn)
	var/mob/living/carbon/human/p = new /mob/living/carbon/human(location.loc)
	var/l = pick(loadouts)
	p.real_name = h.real_name
	p.name = p.real_name
	p.ckey = h.ckey
	setup_antag(p)
	new l (p)

/datum/game_mode/slayer/proc/promptspawn(var/mob/m)
	if(m.ckey in nospawn) // Used for people who said 'not for this round'
		return
	var/i = input(m,"Spawn as a Slayer Participant?","Slayer Spawn","No") in list("Yes","No","Not for this round")
	if(!m.ckey)
		return
	if(i == "Yes")
		players += m.ckey
		newplayer(m)
	if(i == "No")
		if(m.ckey in players)
			players -=m.ckey
			return
		return
	if(i == "Not for this round")
		nospawn += m.ckey
		if(m.ckey in players)
			players -= m.ckey
			return
		return

/datum/game_mode/slayer/proc/update_scores(var/mob/h)
	if(h.ckey in players)
		players[h.ckey] += 1
	announce_score(h)

/datum/game_mode/slayer/proc/announce_score(var/mob/h)
	to_world("<span class = 'danger'>[h.ckey] has died. \n Current deaths: [players[h.ckey]]</span>")

/datum/game_mode/slayer/process()
	if(world.time >= respawnwhen)
		respawnwhen = world.time + time_to_next_respawn
		for(var/mob/m in world)
			if(m.ckey)
				if(m.type == /mob/observer/ghost) // This is checked first so people can quit playing and observe.
					spawn(0)
						promptspawn(m)
				if(m.type == /mob/new_player) //So we don't ask anyone in the lobby.
					continue
				if(m.stat == DEAD && m.ckey in players) //Autorespawn for dead players#
					update_scores(m)
					newplayer(m)

/datum/game_mode/slayer/team
	name = "Team Slayer"
	round_description = "Team Slayer - Fight to the death alongside your team."
	extended_round_description = "Free for all: fight to the death."
	config_tag = "Slayer TDM"
	votable = 1
	var/score = 0
	var/teams[0]

/datum/game_mode/slayer/team/pre_setup()
	. = ..()
	teams += new /datum/slayer/team/red //Team 1
	teams += new /datum/slayer/team/blue // Team 2

/datum/game_mode/slayer/team/setup_antag(var/mob/h)
	var/datum/antagonist/antag
	var/datum/slayer/team/team1 = teams[1]
	var/datum/slayer/team/team2 = teams[2]
	if(h.ckey in team1.members)
		antag = get_antag_data(team1.antag)
		antag.add_antagonist(h.mind,1,1)
		h.faction = team1.name //Temporary until proper antags for slayer GM is created
	if(h.ckey in team2.members)
		antag = get_antag_data(team2.antag)
		antag.add_antagonist(h.mind,1,1)
		h.faction = team2.name

/datum/game_mode/slayer/team/update_scores(var/mob/h)
	var/datum/slayer/team/team1 = teams[1]
	var/datum/slayer/team/team2 = teams[2]
	if(h.ckey in team1.members)
		team2.score += 10
		announce_score(team1,team2)
	if(h.ckey in team2.members)
		team1.score += 10
		announce_score(team1,team2)
		return

/datum/game_mode/slayer/team/announce_score(var/datum/slayer/team/team1 , var/datum/slayer/team/team2)
	to_world("<span classs = 'danger'>Scores: \n [team1.name] : [team1.score] \n [team2.name] : [team2.score]</span>")

/datum/game_mode/slayer/team/newplayer(var/mob/living/carbon/human/h,var/team_antag)
	var/datum/slayer/team/team1 = teams[1]
	var/datum/slayer/team/team2 = teams[2]
	if(!(h.ckey in team1.members) && !(h.ckey in team2.members))
		if(team1.members.len >= team2.members.len)
			h.faction = team2.name
			team2.members += h.ckey
			team1.members -= h.ckey
			team_antag = team2.antag
		else
			h.faction = team1.name
			team1.members += h.ckey
			team2.members -= h.ckey
			team_antag = team1.antag
	return ..(h,team_antag)

/datum/slayer/team
	var/name = "neutral" //Will also be the faction name.
	var/score = 0
	var/members[0]
	var/team_ident
	var/datum/antagonist/antag

/datum/slayer/team/red
	name = "Red Team"
	antag = MODE_INNIE

/datum/slayer/team/blue
	name = "Blue Team"
	antag = MODE_REVOLUTIONARY

/obj/effect/spawnpoint
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	name = "neutral"//For use by Team Deathmatch spawners. Faction corresponds to team faction eg. "Blue Team","Red Team".

/obj/effect/spawnpoint/red
	name = "Red Team"

/obj/effect/spawnpoint/blue
	name = "Blue Team"

/obj/effect/spawnpoint/New()
	invisibility = 100

/datum/slayernormal/New(var/mob/living/carbon/human/h)
	h.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(h),slot_shoes)
	h.equip_to_slot_or_del(new /obj/item/clothing/under/unsc/odst(h),slot_w_uniform)
	h.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/combat(h),slot_gloves)
	h.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/spartan(h),slot_wear_suit)
	h.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/syndicate(h),slot_wear_mask)
	h.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/spartan(h),slot_head)
	h.equip_to_slot_or_del(new /obj/item/weapon/tank/emergency/oxygen/unsc(h),slot_r_store)
	h.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/ma5b_ar(h),slot_back)
	h.equip_to_slot_or_del(new /obj/item/ammo_magazine/m762_ap(h),slot_l_store)
	h.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/m6d_magnum(h),slot_s_store)
	h.equip_to_slot_or_del(new /obj/item/weapon/grenade/frag/m9_hedp,slot_belt)
	qdel(src)
