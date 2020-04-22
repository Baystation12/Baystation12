
/datum/job/opredflag_cov
	spawn_faction = "Covenant"
	track_players = TRUE
	account_allowed = FALSE            // Does this job type come with a station account?
	loadout_allowed = FALSE            // Whether or not loadout equipment is allowed and to be created when joining.
	announced = TRUE                   //If their arrival is announced on radio
	create_record = FALSE
	generate_email = FALSE
	//latejoin_at_spawnpoints = TRUE
	access = list(access_covenant)
