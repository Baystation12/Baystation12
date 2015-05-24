/proc/get_access(job)
	switch(job)
		if("Geneticist")
			return list(access_medical, access_morgue, access_genetics)
		if("Station Engineer")
			return list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)
		if("Assistant")
			if(config.assistant_maint)
				return list(access_maint_tunnels)
			else
				return list()
		if("Chaplain")
			return list(access_morgue, access_chapel_office, access_crematorium)
		if("Detective")
			return list(access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court)
		if("Medical Doctor")
			return list(access_medical, access_morgue, access_surgery)
		if("Gardener")	// -- TLE
			return list(access_hydroponics, access_morgue) // Removed tox and chem access because STOP PISSING OFF THE CHEMIST GUYS // //Removed medical access because WHAT THE FUCK YOU AREN'T A DOCTOR YOU GROW WHEAT //Given Morgue access because they have a viable means of cloning.
		if("Librarian") // -- TLE
			return list(access_library)
		if("Lawyer") //Muskets 160910
			return list(access_lawyer, access_court, access_sec_doors)
		if("Captain")
			return get_all_accesses()
		if("Crew Supervisor")
			return list(access_security, access_sec_doors, access_brig, access_court)
		if("Correctional Advisor")
			return list(access_security, access_sec_doors, access_brig, access_armory, access_court)
		if("Scientist")
			return list(access_tox, access_tox_storage, access_research, access_xenobiology)
		if("Safety Administrator")
			return list(access_medical, access_morgue, access_tox, access_tox_storage, access_chemistry, access_genetics, access_court,
			            access_teleporter, access_heads, access_tech_storage, access_security, access_sec_doors, access_brig, access_atmospherics,
			            access_maint_tunnels, access_bar, access_janitor, access_kitchen, access_robotics, access_armory, access_hydroponics,
			            access_theatre, access_research, access_hos, access_RC_announce, access_forensics_lockers, access_keycard_auth, access_gateway)
		if("Head of Personnel")
			return list(access_security, access_sec_doors, access_brig, access_court, access_forensics_lockers,
			            access_tox, access_tox_storage, access_chemistry, access_medical, access_genetics, access_engine,
			            access_emergency_storage, access_change_ids, access_ai_upload, access_eva, access_heads,
			            access_all_personal_lockers, access_tech_storage, access_maint_tunnels, access_bar, access_janitor,
			            access_crematorium, access_kitchen, access_robotics, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_theatre, access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_clown, access_mime, access_hop, access_RC_announce, access_keycard_auth, access_gateway)
		if("Atmospheric Technician")
			return list(access_atmospherics, access_maint_tunnels, access_emergency_storage, access_construction)
		if("Bartender")
			return list(access_bar)
		if("Chemist")
			return list(access_medical, access_chemistry)
		if("Janitor")
			return list(access_janitor, access_maint_tunnels)
		if("Clown")
			return list(access_clown, access_theatre)
		if("Mime")
			return list(access_mime, access_theatre)
		if("Chef")
			return list(access_kitchen, access_morgue)
		if("Roboticist")
			return list(access_robotics, access_tech_storage, access_morgue) //As a job that handles so many corpses, it makes sense for them to have morgue access.
		if("Cargo Technician")
			return list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)
		if("Shaft Miner")
			return list(access_mining, access_mint, access_mining_station)
		if("Quartermaster")
			return list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station)
		if("Chief Engineer")
			return list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_ai_upload, access_construction, access_robotics,
			            access_mint, access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_sec_doors)
		if("Research Director")
			return list(access_rd, access_heads, access_tox, access_genetics,
			            access_tox_storage, access_teleporter,
			            access_research, access_robotics, access_xenobiology,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_sec_doors)
		if("Virologist")
			return list(access_medical, access_virology)
		if("Chief Medical Officer")
			return list(access_medical, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors)
		else
			return list()

/client/proc/admincryo(mob/living/M as mob in mob_list)
	set category = "Special Verbs"
	set name = "Admin Cryo"
	if(!holder)
		src << "Only administrators may use this command."
		return
	if(!mob)
		return
	if(!istype(M))
		alert("Cannot cryo a ghost")
		return

	if(usr)
		var/confirm = alert(src, "You will be removing [M] from the round, are you sure?", "Message", "Yes", "No")
		if(confirm != "Yes")
			return
		if (usr.client)
			if(usr.client.holder)
				var/job = M.mind.assigned_role

				for(var/obj/item/weapon/card/id/Z in M)
					del(Z)
				for(var/obj/item/device/pda/Y in M)
					del(Y)
				for(var/obj/item/clothing/under/X in M)
					del(X)
				for(var/obj/item/W in M)
					M.drop_from_inventory(W)

				var/obj/structure/closet/crate/secure/K = new /obj/structure/closet/crate/secure/(M.loc)
				K.req_access += get_access(job)
				K.name = (M.real_name + " - " + job + " - SSD Crate")
				K.health = 1000000
				for(var/datum/objective/O in all_objectives)
				// We don't want revs to get objectives that aren't for heads of staff. Letting
				// them win or lose based on cryo is silly so we remove the objective.
					if(istype(O,/datum/objective/mutiny) && O.target == M.mind)
						del(O)
					else if(O.target && istype(O.target,/datum/mind))
						if(O.target == M.mind)
							if(O.owner && O.owner.current)
								O.owner.current << "\red You get the feeling your target is no longer within your reach. Time for Plan [pick(list("A","B","C","D","X","Y","Z"))]..."
							O.target = null
							spawn(1) //This should ideally fire after the M is deleted.
								if(!O) return
								O.find_target()
								if(!(O.target))
									all_objectives -= O
									O.owner.objectives -= O
									del(O)

				//Handle job slot/tater cleanup.
				if(job == "Department Guard")
					job_master.FreeDGRole(job,M.mind.assigned_DG_dept)
				else
					job_master.FreeRole(job)

				if(M.mind.objectives.len)
					del(M.mind.objectives)
					M.mind.special_role = null
				else
					if(ticker.mode.name == "AutoTraitor")
						var/datum/game_mode/traitor/autotraitor/current_mode = ticker.mode
						current_mode.possible_traitors.Remove(M)

				// Delete them from datacore.

				if(PDA_Manifest.len)
					PDA_Manifest.Cut()
				for(var/datum/data/record/R in data_core.medical)
					if ((R.fields["name"] == M.real_name))
						del(R)
				for(var/datum/data/record/T in data_core.security)
					if ((T.fields["name"] == M.real_name))
						del(T)
				for(var/datum/data/record/G in data_core.general)
					if ((G.fields["name"] == M.real_name))
						del(G)

				//Make an announcement and log the person entering storage.
				//frozen_crew += "[M.real_name]"

				message_admins("\blue [key_name_admin(usr)] has admin cryoed [key_name(M)]")
				log_admin("[key_name(usr)] admin cryoed [key_name(M)]")
				log_admin_single("[key_name(usr)] admin cryoed [key_name(M)]")

				// Delete the mob.
				//This should guarantee that ghosts don't spawn.
				M.ckey = null
				del(M)
				M = null
		return