
/datum/antagonist/opredflag_hunter
	welcome_text = "You are a colony of sentient worms encased in armour and heavy weaponry. A living weapon that must protect the ship, protect the prophets."

	id = "hunter"
	role_text = "hunter"
	role_text_plural = "hunters"

	antaghud_indicator = "hudcovenant"
	/*
	var/antag_indicator                     // icon_state for icons/mob/mob.dm visual indicator.
	var/faction_indicator                   // See antag_indicator, but for factionalized people only.
	var/faction_invisible                   // Can members of the faction identify other antagonists?
	*/
	/*
	var/faction_role_text                   // Role for sub-antags. Mandatory for faction role.
	var/faction_descriptor                  // Description of the cause. Mandatory for faction role.
	var/faction_verb                        // Verb added when becoming a member of the faction, if any.
	var/faction_welcome                     // Message shown to faction members.
	*/
	faction = "Covenant"

	hard_cap = 10
	initial_spawn_req = 0
	initial_spawn_target = 0

	landmark_id = "hunter_start"
	mob_path = /mob/living/simple_animal/lekgolo/mgalekgolo
	minimum_player_age = 0
	suspicion_chance = 0
	flags = ANTAG_OVERRIDE_MOB | ANTAG_OVERRIDE_JOB | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED

	list/valid_species =       list()
	min_player_age = 0

	antag_text = "You are Mga'lekgolo, a colony of sentient worms encased in powerful armour and carrying heavy weaponry. Protect the ship and the prophets with all your being."

/datum/antagonist/opredflag_hunter/create_antagonist(var/datum/mind/target, var/move, var/gag_announcement, var/preserve_appearance)
 	. = ..()
 	var/list/syllables = list("rg","rx","ll","rk","ck","rt","tr","rl","sn","ns","sl","ls","sp","ps")
 	var/list/vowels = list("a","e","i","o","u")
 	var/syllables_left = rand(4,10)
 	var/final_name = ""
 	while(syllables_left > 0)
		syllables_left -= 1
		final_name += pick(vowels)
		final_name += pick(syllables)
 	target.current.name = final_name
