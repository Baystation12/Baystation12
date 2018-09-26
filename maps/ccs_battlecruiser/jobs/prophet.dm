
/datum/antagonist/opredflag_prophet
	welcome_text = "You are a religious leader of the Covenant."
	leader_welcome_text = "You are a high ranking religious leader of the Covenant."
	victory_text = "The Prophet is victorious!"
	loss_text = "The Prophet has been defeated!"
	victory_feedback_tag = "prophet_win"
	loss_feedback_tag = "prophet_loss"

	id = "prophet"                      // Unique datum identifier.
	role_text = "Prophet"               // special_role text.
	role_text_plural = "Prophets"       // As above but plural.

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

	hard_cap = 1                        // Autotraitor var. Won't spawn more than this many antags.
	hard_cap_round = 1                  // As above but 'core' round antags ie. roundstart.
	initial_spawn_req = 1               // Gamemode using this template won't start without this # candidates.
	initial_spawn_target = 1            // Gamemode will attempt to spawn this many antags.

	landmark_id = "prophet_start"
	mob_path = /mob/living/simple_animal/prophet
	feedback_tag = "prophet_objective"
	minimum_player_age = 0
	suspicion_chance = 0
	flags = ANTAG_OVERRIDE_MOB | ANTAG_OVERRIDE_JOB | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED

	list/valid_species =       list()
	min_player_age = 0

	antag_text = "You are a Prophet of the Covenant! Not only are you a religious leader, but you hold a great deal of practical power too. \
		While the Shipmaster gives orders on the ship, you give orders to the Shipmaster. \
		No-one except another prophet would dare countermand or disobey you."

/datum/antagonist/opredflag_prophet/create_antagonist(var/datum/mind/target, var/move, var/gag_announcement, var/preserve_appearance)
 	. = ..()
 	target.current.name = "Lesser Prophet of [pick("Harmony","Charity","Hope","Temperance","Diligence","Patience","Humility","Reverence","Purity","Reverence")]"
