
datum/game_mode/nations
	name = "nations"
	config_tag = "nations"
	required_players_secret = 25
	var/const/waittime_l = 3000 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 6000 //upper bound on time before intercept arrives (in tenths of seconds)

	var/list/cargonians = list("Quartermaster","Cargo Technician","Shaft Miner")

	var/global/list/atmosia = list()
	var/global/list/brigston = list()
	var/global/list/cargonia = list()
	var/global/list/command = list()
	var/global/list/medistan = list()
	var/global/list/scientopia = list()


/datum/game_mode/nations/post_setup()
	spawn (rand(waittime_l, waittime_h))
		remove_flags()
		spawn(50)
			spawn_flags()
			send_intercept()
			split_teams()

/datum/game_mode/nations/send_intercept()
	command_alert("Due to recent and COMPLETELY UNFOUNDED allegations of massive fraud and insider trading \
					affecting trillions of investors, the Nanotrasen Corporation has decided to liquidate all \
					assets of the Centcom Division in order to pay the massive legal fees that will be incurred \
					during the following centuries long court process. Therefore, all current employment contracts \
					are IMMEDIATELY TERMINATED. Nanotrasen will be unable to send a rescue shuttle to carry you home,\
					however they remain willing for the time being to continue trading cargo. Have a pleasant \
					day.", "FINAL TRANSMISSION, CENTCOM COMMAND.")


/datum/game_mode/nations/proc/remove_flags()
	for(var/obj/item/flag/F in world)
		del(F)

/datum/game_mode/nations/proc/spawn_flags()

	for(var/obj/effect/landmark/nations/N in landmarks_list)
		switch(N.name)
			if("Atmosia")
				new /obj/item/flag/nation/atmos(get_turf(N))
			if("Brigston")
				new /obj/item/flag/nation/sec(get_turf(N))
			if("Cargonia")
				new /obj/item/flag/nation/cargo(get_turf(N))
			if("Command")
				new /obj/item/flag/nation/command(get_turf(N))
			if("Medistan")
				new /obj/item/flag/nation/med(get_turf(N))
			if("Scientopia")
				new /obj/item/flag/nation/rnd(get_turf(N))

/datum/game_mode/nations/proc/split_teams()

	for(var/mob/living/carbon/human/H in player_list)
		if(H.mind)
			if(H.mind.assigned_role in engineering_positions)
				H.mind.nation = "Atmosia"
				H.verbs += /mob/proc/respawn_self
				H.verbs -= /mob/living/verb/ghost
				continue
			else if(H.mind.assigned_role in medical_positions)
				H.mind.nation = "Medistan"
				H.verbs += /mob/proc/respawn_self
				H.verbs -= /mob/living/verb/ghost
				continue
			else if(H.mind.assigned_role in science_positions)
				H.mind.nation = "Scientopia"
				H.verbs += /mob/proc/respawn_self
				H.verbs -= /mob/living/verb/ghost
				continue
			else if(H.mind.assigned_role in security_positions)
				H.mind.nation = "Brigston"
				H.verbs += /mob/proc/respawn_self
				H.verbs -= /mob/living/verb/ghost
				continue
			else if(H.mind.assigned_role in cargonians)
				H.mind.nation = "Cargonia"
				H.verbs += /mob/proc/respawn_self
				H.verbs -= /mob/living/verb/ghost
				continue
			else if(H.mind.assigned_role in civilian_positions)
				H.mind.nation = "Command"
				H.verbs += /mob/proc/respawn_self
				H.verbs -= /mob/living/verb/ghost
				continue
			else if(H.mind.assigned_role == "Captain")
				H.mind.nation = "Command"
				H.verbs += /mob/proc/respawn_self
				H.verbs -= /mob/living/verb/ghost
				continue
			else
				message_admins("[H.name] with [H.mind.assigned_role] could not find any nation to assign!")
				continue

/datum/game_mode/nations/proc/populate_datums()
	for(var/obj/effect/landmark/nations/N in landmarks_list)
		switch(N.name)
			if("Atmosia")
				var/datum/nations/atmosia/A
				A.landmark = N
				continue
			if("Brigston")
				var/datum/nations/brigston/B
				B.landmark = N
				continue
			if("Cargonia")
				var/datum/nations/cargonia/C
				C.landmark = N
				continue
			if("Command")
				var/datum/nations/command/D
				D.landmark = N
				continue
			if("Medistan")
				var/datum/nations/medistan/M
				M.landmark = N
				continue
			if("Scientopia")
				var/datum/nations/scientopia/S
				S.landmark = N
				continue

/mob/proc/respawn_self()
	set category = "OOC"
	set name = "Respawn Character"
	set desc = "Respawn yourself (10 minute cooldown)."

	if ((stat != 2 || !( ticker )))
		usr << "\blue <B>You must be dead to use this!</B>"
		return
	if (ticker.mode.name != "nations")
		usr << "\blue Respawn is disabled."
		return
	else
		var/deathtime = world.time - src.timeofdeath
		var/deathtimeminutes = round(deathtime / 600)
		var/pluralcheck = "minute"
		if(deathtimeminutes == 0)
			pluralcheck = ""
		else if(deathtimeminutes == 1)
			pluralcheck = " [deathtimeminutes] minute and"
		else if(deathtimeminutes > 1)
			pluralcheck = " [deathtimeminutes] minutes and"
		var/deathtimeseconds = round((deathtime - deathtimeminutes * 600) / 10,1)
		usr << "You have been dead for[pluralcheck] [deathtimeseconds] seconds."
		if (deathtime < 6000)
			usr << "You must wait 10 minutes to respawn!"
			return
		else

			var/mob/G_found = src

			if(!G_found)//If a ghost was not found.
				return

			if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
				//Check if they were an alien
				if(G_found.mind.assigned_role=="Alien")
					usr << "As an Alien, you're no longer part of a nation. Use Respawn as NPC instead."
					return

				//check if they were a monkey
				else if(findtext(G_found.real_name,"monkey"))
					usr << "As a monkey, you're no longer part of a nation. Use Respawn as NPC instead."
					return


			//Ok, it's not a xeno or a monkey. So, spawn a human.
			var/mob/living/carbon/human/new_character = new(pick(latejoin))//The mob being spawned.

			var/datum/data/record/record_found			//Referenced to later to either randomize or not randomize the character.
			if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
				/*Try and locate a record for the person being respawned through data_core.
				This isn't an exact science but it does the trick more often than not.*/
				var/id = md5("[G_found.real_name][G_found.mind.assigned_role]")
				for(var/datum/data/record/t in data_core.locked)
					if(t.fields["id"]==id)
						record_found = t//We shall now reference the record.
						break

			if(record_found)//If they have a record we can determine a few things.
				new_character.real_name = record_found.fields["name"]
				new_character.gender = record_found.fields["sex"]
				new_character.age = record_found.fields["age"]
				new_character.b_type = record_found.fields["b_type"]
			else
				new_character.gender = pick(MALE,FEMALE)
				var/datum/preferences/A = new()
				A.randomize_appearance_for(new_character)
				new_character.real_name = G_found.real_name

			if(!new_character.real_name)
				if(new_character.gender == MALE)
					new_character.real_name = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
				else
					new_character.real_name = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
			new_character.name = new_character.real_name

			if(G_found.mind && !G_found.mind.active)
				G_found.mind.transfer_to(new_character)	//be careful when doing stuff like this! I've already checked the mind isn't in use
				new_character.mind.special_verbs = list()
			else
				new_character.mind_initialize()
			if(!new_character.mind.assigned_role)	new_character.mind.assigned_role = "Assistant"//If they somehow got a null assigned role.

			//DNA
			if(record_found)//Pull up their name from database records if they did have a mind.
				new_character.dna = new()//Let's first give them a new DNA.
				new_character.dna.unique_enzymes = record_found.fields["b_dna"]//Enzymes are based on real name but we'll use the record for conformity.

				// I HATE BYOND.  HATE.  HATE. - N3X
				var/list/newSE= record_found.fields["enzymes"]
				var/list/newUI = record_found.fields["identity"]
				new_character.dna.SE = newSE.Copy() //This is the default of enzymes so I think it's safe to go with.
				new_character.dna.UpdateSE()
				new_character.UpdateAppearance(newUI.Copy())//Now we configure their appearance based on their unique identity, same as with a DNA machine or somesuch.
			else//If they have no records, we just do a random DNA for them, based on their random appearance/savefile.
				new_character.dna.ready_dna(new_character)

			new_character.key = G_found.key


			//Now for special roles and equipment.
			if(new_character.mind.special_role)
				usr << "It appears you're no longer part of a nation. Use Respawn as NPC instead."
				return
			else//They may also be a cyborg or AI.
				switch(new_character.mind.assigned_role)
					if("Cyborg")//More rigging to make em' work and check if they're traitor.
						usr << "It appears you're not part of a nation. Use Respawn as NPC instead."
						return
					if("AI")
						usr << "It appears you're not part of a nation. Use Respawn as NPC instead."
						return
					else
						job_master.EquipRank(new_character, new_character.mind.assigned_role, 1)//Or we simply equip them.

				if(!record_found)//If there are no records for them. If they have a record, this info is already in there. MODE people are not announced anyway.
					data_core.manifest_inject(new_character)

			new_character << "You have been fully respawned. Get back in the fight!."
			return new_character