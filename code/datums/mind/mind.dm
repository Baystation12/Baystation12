/*	Note from Carnie:
		The way datum/mind stuff works has been changed a lot.
		Minds now represent IC characters rather than following a client around constantly.

	Guidelines for using minds properly:

	-	Never mind.transfer_to(ghost). The var/current and var/original of a mind must always be of type mob/living!
		ghost.mind is however used as a reference to the ghost's corpse

	-	When creating a new mob for an existing IC character (e.g. cloning a dead guy or borging a brain of a human)
		the existing mind of the old mob should be transfered to the new mob like so:

			mind.transfer_to(new_mob)

	-	You must not assign key= or ckey= after transfer_to() since the transfer_to transfers the client for you.
		By setting key or ckey explicitly after transfering the mind with transfer_to you will cause bugs like DCing
		the player.

	-	IMPORTANT NOTE 2, if you want a player to become a ghost, use mob.ghostize() It does all the hard work for you.

	-	When creating a new mob which will be a new IC character (e.g. putting a shade in a construct or randomly selecting
		a ghost to become a xeno during an event). Simply assign the key or ckey like you've always done.

			new_mob.key = key

		The Login proc will handle making a new mob for that mobtype (including setting up stuff like mind.name). Simple!
		However if you want that mind to have any special properties like being a traitor etc you will have to do that
		yourself.

*/

/datum/mind
	var/key
	var/name				//replaces mob/var/original_name
	var/mob/living/current
	var/mob/living/original	//TODO: remove.not used in any meaningful way ~Carn. First I'll need to tweak the way silicon-mobs handle minds.
	var/active = 0

	var/list/known_connections //list of known (RNG) relations between people
	var/gen_relations_info

	var/assigned_role
	var/special_role

	var/role_alt_title

	var/datum/job/assigned_job

	var/list/datum/objective/objectives = list()
	var/list/datum/objective/special_verbs = list()

	var/has_been_rev = 0//Tracks if this mind has been a rev or not

	var/faction 			//associated faction
	var/datum/changeling/changeling		//changeling holder

	var/rev_cooldown = 0

	// the world.time since the mob has been brigged, or -1 if not at all
	var/brigged_since = -1

	//put this here for easier tracking ingame
	var/datum/money_account/initial_account

	var/list/initial_email_login = list("login" = "", "password" = "")

/datum/mind/New(var/key)
	src.key = key
	..()

/datum/mind/Destroy()
	QDEL_NULL_LIST(memories)
	SSticker.minds -= src
	. = ..()

/datum/mind/proc/transfer_to(mob/living/new_character)
	if(!istype(new_character))
		to_world_log("## DEBUG: transfer_to(): Some idiot has tried to transfer_to() a non mob/living mob. Please inform Carn.")
	if(current)					//remove ourself from our old body's mind variable
		if(changeling)
			current.remove_changeling_powers()
			current.verbs -= /datum/changeling/proc/EvolutionMenu
		current.mind = null

		SSnano.user_transferred(current, new_character) // transfer active NanoUI instances to new user
	if(new_character.mind)		//remove any mind currently in our new body's mind variable
		new_character.mind.current = null

	new_character.skillset.obtain_from_mob(current)	//handles moving skills over.

	current = new_character		//link ourself to our new body
	new_character.mind = src	//and link our new body to ourself

	if(learned_spells && learned_spells.len)
		restore_spells(new_character)

	if(changeling)
		new_character.make_changeling()

	if(active)
		new_character.key = key		//now transfer the key to link the client to our new body

/datum/mind/proc/edit_memory()
	if(GAME_STATE <= RUNLEVEL_SETUP)
		alert("Not before round-start!", "Alert")
		return

	var/out = "<B>[name]</B>[(current&&(current.real_name!=name))?" (as [current.real_name])":""]<br>"
	out += "Mind currently owned by key: [key] [active?"(synced)":"(not synced)"]<br>"
	out += "Assigned role: [assigned_role]. <a href='?src=\ref[src];role_edit=1'>Edit</a><br>"
	out += "<hr>"
	out += "Factions and special roles:<br><table>"
	var/list/all_antag_types = GLOB.all_antag_types_
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		out += "[antag.get_panel_entry(src)]"
	out += "</table><hr>"
	out += "<b>Objectives</b></br>"

	if(objectives && objectives.len)
		var/num = 1
		for(var/datum/objective/O in objectives)
			out += "<b>Objective #[num]:</b> [O.explanation_text] "
			out += " <a href='?src=\ref[src];obj_delete=\ref[O]'>\[remove\]</a><br>"
			num++
		out += "<br><a href='?src=\ref[src];obj_announce=1'>\[announce objectives\]</a>"

	else
		out += "None."
	out += "<br><a href='?src=\ref[src];obj_add=1'>\[add\]</a><br><br>"

	var/datum/goal/ambition/ambition = SSgoals.ambitions[src]
	out += "<b>Ambitions:</b> [ambition ? ambition.description : "None"] <a href='?src=\ref[src];amb_edit=\ref[src]'>\[edit\]</a></br>"
	show_browser(usr, out, "window=edit_memory[src]")

/datum/mind/proc/get_goal_from_href(var/href)
	var/ind = isnum(href) ? href : text2num(href)
	if(ind > 0 && ind <= LAZYLEN(goals))
		return goals[ind]

/datum/mind/Topic(href, href_list)

	var/is_admin =   FALSE
	var/can_modify = FALSE
	is_admin = check_rights(R_ADMIN, FALSE)
	can_modify = is_admin

	if(href_list["add_goal"])

		var/mob/caller = locate(href_list["add_goal_caller"])
		if(caller && caller == current) can_modify = TRUE

		if(can_modify)
			if(is_admin)
				log_admin("[key_name_admin(usr)] added a random goal to [key_name(current)].")
			var/did_generate_goal = generate_goals(assigned_job, TRUE, 1)
			if(did_generate_goal)
				to_chat(current, SPAN_NOTICE("You have received a new goal. Use <b>Show Goals</b> to view it."))
		return TRUE // To avoid 'you are not an admin' spam.

	if(href_list["remove_memory"])
		var/memory = locate(href_list["remove_memory"]) in memories
		RemoveMemory(memory, usr)
		return TRUE

	if(href_list["abandon_goal"])
		var/datum/goal/goal = get_goal_from_href(href_list["abandon_goal"])

		var/mob/caller = locate(href_list["abandon_goal_caller"])
		if(caller && caller == current) can_modify = TRUE

		if(goal && can_modify)
			if(usr == current)
				to_chat(current, SPAN_NOTICE("<b>You have abandoned your goal:</b> '[goal.summarize(FALSE, FALSE)]'."))
			else
				to_chat(usr, SPAN_NOTICE("<b>You have removed a goal from \the [current]:</b> '[goal.summarize(FALSE, FALSE)]'."))
				to_chat(current, SPAN_NOTICE("<b>A goal has been removed:</b> '[goal.summarize(FALSE, FALSE)]'."))
			qdel(goal)
		return TRUE

	if(href_list["reroll_goal"])
		var/datum/goal/goal = get_goal_from_href(href_list["reroll_goal"])

		var/mob/caller = locate(href_list["reroll_goal_caller"])
		if(caller && caller == current) can_modify = TRUE

		if(goal && (goal in goals) && can_modify)
			qdel(goal)
			generate_goals(assigned_job, TRUE, 1)
			if(goals)
				goal = goals[LAZYLEN(goals)]
				if(usr == current)
					to_chat(usr, SPAN_NOTICE("<b>You have re-rolled a goal. Your new goal is:</b> '[goal.summarize(FALSE, FALSE)]'."))
				else
					to_chat(usr, SPAN_NOTICE("<b>You have re-rolled a goal for \the [current]. Their new goal is:</b> '[goal.summarize(FALSE, FALSE)]'."))
					to_chat(current, SPAN_NOTICE("<b>A goal has been re-rolled. Your new goal is:</b> '[goal.summarize(FALSE, FALSE)]'."))
		return TRUE

	if(!is_admin) return

	if(current && isliving(current))
		if(href_list["set_psi_faculty"] && href_list["set_psi_faculty_rank"])
			current.set_psi_rank(href_list["set_psi_faculty"], text2num(href_list["set_psi_faculty_rank"]))
			log_and_message_admins("set [key_name(current)]'s [href_list["set_psi_faculty"]] faculty to [text2num(href_list["set_psi_faculty_rank"])].")
			var/datum/admins/admin = GLOB.admins[usr.key]
			if(istype(admin)) admin.show_player_panel(current)
			return TRUE

	if(href_list["add_antagonist"])
		var/datum/antagonist/antag = GLOB.all_antag_types_[href_list["add_antagonist"]]
		if(antag)
			if(antag.add_antagonist(src, 1, 1, 0, 1, 1)) // Ignore equipment and role type for this.
				log_admin("[key_name_admin(usr)] made [key_name(src)] into a [antag.role_text].")
			else
				to_chat(usr, "<span class='warning'>[src] could not be made into a [antag.role_text]!</span>")

	else if(href_list["remove_antagonist"])
		var/datum/antagonist/antag = GLOB.all_antag_types_[href_list["remove_antagonist"]]
		if(antag) antag.remove_antagonist(src)

	else if(href_list["equip_antagonist"])
		var/datum/antagonist/antag = GLOB.all_antag_types_[href_list["equip_antagonist"]]
		if(antag) antag.equip(src.current)

	else if(href_list["unequip_antagonist"])
		var/datum/antagonist/antag = GLOB.all_antag_types_[href_list["unequip_antagonist"]]
		if(antag) antag.unequip(src.current)

	else if(href_list["move_antag_to_spawn"])
		var/datum/antagonist/antag = GLOB.all_antag_types_[href_list["move_antag_to_spawn"]]
		if(antag) antag.place_mob(src.current)

	else if (href_list["role_edit"])
		var/new_role = input("Select new role", "Assigned role", assigned_role) as null|anything in SSjobs.titles_to_datums
		if (!new_role) return
		var/datum/job/job = SSjobs.get_by_title(new_role)
		if(job)
			assigned_job = job
			assigned_role = job.title
			role_alt_title = new_role
			if(current)
				current.skillset.obtain_from_client(job, current.client)

	else if (href_list["amb_edit"])
		var/datum/mind/mind = locate(href_list["amb_edit"])
		if(!mind)
			return

		var/datum/goal/ambition/ambition = SSgoals.ambitions[src]
		var/new_ambition = input("Enter a new ambition", "Memory", ambition ? html_decode(ambition.description) : "") as null|message
		if(isnull(new_ambition))
			return
		new_ambition = sanitize(new_ambition)
		if(mind)
			if(new_ambition)
				if(!ambition)
					ambition = new /datum/goal/ambition(mind)
				ambition.description = new_ambition
				to_chat(mind.current, "<span class='warning'>Your ambitions have been changed by higher powers, they are now: [ambition.description]</span>")
				log_and_message_admins("made [key_name(mind.current)]'s ambitions be '[ambition.description]'.")
			else
				to_chat(mind.current, "<span class='warning'>Your ambitions have been unmade by higher powers.</span>")
				log_and_message_admins("has cleared [key_name(mind.current)]'s ambitions.")
				if(ambition)
					qdel(ambition)
		else
			to_chat(usr, "<span class='warning'>The mind has ceased to be.</span>")

	else if (href_list["obj_edit"] || href_list["obj_add"])
		var/datum/objective/objective
		var/objective_pos
		var/def_value

		if (href_list["obj_edit"])
			objective = locate(href_list["obj_edit"])
			if (!objective) return
			objective_pos = objectives.Find(objective)

			//Text strings are easy to manipulate. Revised for simplicity.
			var/temp_obj_type = "[objective.type]"//Convert path into a text string.
			def_value = copytext(temp_obj_type, 19)//Convert last part of path into an objective keyword.
			if(!def_value)//If it's a custom objective, it will be an empty string.
				def_value = "custom"

		var/new_obj_type = input("Select objective type:", "Objective type", def_value) as null|anything in list("assassinate", "debrain", "protect", "prevent", "harm", "brig", "hijack", "escape", "survive", "steal", "download", "mercenary", "capture", "absorb", "custom")
		if (!new_obj_type) return

		var/datum/objective/new_objective = null

		switch (new_obj_type)
			if ("assassinate","protect","debrain", "harm", "brig")
				//To determine what to name the objective in explanation text.
				var/objective_type_capital = uppertext(copytext(new_obj_type, 1,2))//Capitalize first letter.
				var/objective_type_text = copytext(new_obj_type, 2)//Leave the rest of the text.
				var/objective_type = "[objective_type_capital][objective_type_text]"//Add them together into a text string.

				var/list/possible_targets = list("Free objective")
				for(var/datum/mind/possible_target in SSticker.minds)
					if ((possible_target != src) && istype(possible_target.current, /mob/living/carbon/human))
						possible_targets += possible_target.current

				var/mob/def_target = null
				var/objective_list[] = list(/datum/objective/assassinate, /datum/objective/protect, /datum/objective/debrain)
				if (objective&&(objective.type in objective_list) && objective:target)
					def_target = objective.target?.current

				var/new_target = input("Select target:", "Objective target", def_target) as null|anything in possible_targets
				if (!new_target) return

				var/objective_path = text2path("/datum/objective/[new_obj_type]")
				var/mob/living/M = new_target
				if (!istype(M) || !M.mind || new_target == "Free objective")
					new_objective = new objective_path
					new_objective.owner = src
					new_objective:target = null
					new_objective.explanation_text = "Free objective"
				else
					new_objective = new objective_path
					new_objective.owner = src
					new_objective:target = M.mind
					new_objective.explanation_text = "[objective_type] [M.real_name], the [M.mind.special_role ? M.mind:special_role : M.mind:assigned_role]."

			if ("hijack")
				new_objective = new /datum/objective/hijack
				new_objective.owner = src

			if ("escape")
				new_objective = new /datum/objective/escape
				new_objective.owner = src

			if ("survive")
				new_objective = new /datum/objective/survive
				new_objective.owner = src

			if ("mercenary")
				new_objective = new /datum/objective/nuclear
				new_objective.owner = src

			if ("steal")
				if (!istype(objective, /datum/objective/steal))
					new_objective = new /datum/objective/steal
					new_objective.owner = src
				else
					new_objective = objective
				var/datum/objective/steal/steal = new_objective
				if (!steal.select_target())
					return

			if("download","capture","absorb")
				var/def_num
				if(objective&&objective.type==text2path("/datum/objective/[new_obj_type]"))
					def_num = objective.target_amount

				var/target_number = input("Input target number:", "Objective", def_num) as num|null
				if (isnull(target_number))//Ordinarily, you wouldn't need isnull. In this case, the value may already exist.
					return

				switch(new_obj_type)
					if("download")
						new_objective = new /datum/objective/download
						new_objective.explanation_text = "Download [target_number] research levels."
					if("capture")
						new_objective = new /datum/objective/capture
						new_objective.explanation_text = "Accumulate [target_number] capture points."
					if("absorb")
						new_objective = new /datum/objective/absorb
						new_objective.explanation_text = "Absorb [target_number] compatible genomes."
				new_objective.owner = src
				new_objective.target_amount = target_number

			if ("custom")
				var/expl = sanitize(input("Custom objective:", "Objective", objective ? objective.explanation_text : "") as text|null)
				if (!expl) return
				new_objective = new /datum/objective
				new_objective.owner = src
				new_objective.explanation_text = expl

		if (!new_objective) return

		if (objective)
			objectives -= objective
			objectives.Insert(objective_pos, new_objective)
		else
			objectives += new_objective

	else if (href_list["obj_delete"])
		var/datum/objective/objective = locate(href_list["obj_delete"])
		if(!istype(objective))	return
		objectives -= objective

	else if(href_list["implant"])
		var/mob/living/carbon/human/H = current

		BITSET(H.hud_updateflag, IMPLOYAL_HUD)   // updates that players HUD images so secHUD's pick up they are implanted or not.

		switch(href_list["implant"])
			if("remove")
				for(var/obj/item/weapon/implant/loyalty/I in H.contents)
					for(var/obj/item/organ/external/organs in H.organs)
						if(I in organs.implants)
							qdel(I)
							break
				to_chat(H, "<span class='notice'><font size =3><B>Your loyalty implant has been deactivated.</B></font></span>")
				log_admin("[key_name_admin(usr)] has de-loyalty implanted [current].")
			if("add")
				to_chat(H, "<span class='danger'><font size =3>You somehow have become the recepient of a loyalty transplant, and it just activated!</font></span>")
				H.implant_loyalty(H, override = TRUE)
				log_admin("[key_name_admin(usr)] has loyalty implanted [current].")
			else
	else if (href_list["silicon"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["silicon"])

			if("unemag")
				var/mob/living/silicon/robot/R = current
				if (istype(R))
					R.emagged = 0
					if (R.activated(R.module.emag))
						R.module_active = null
					if(R.module_state_1 == R.module.emag)
						R.module_state_1 = null
						R.module.emag.forceMove(null)
					else if(R.module_state_2 == R.module.emag)
						R.module_state_2 = null
						R.module.emag.forceMove(null)
					else if(R.module_state_3 == R.module.emag)
						R.module_state_3 = null
						R.module.emag.forceMove(null)
					log_admin("[key_name_admin(usr)] has unemag'ed [R].")

			if("unemagcyborgs")
				if (istype(current, /mob/living/silicon/ai))
					var/mob/living/silicon/ai/ai = current
					for (var/mob/living/silicon/robot/R in ai.connected_robots)
						R.emagged = 0
						if (R.module)
							if (R.activated(R.module.emag))
								R.module_active = null
							if(R.module_state_1 == R.module.emag)
								R.module_state_1 = null
								R.module.emag.forceMove(null)
							else if(R.module_state_2 == R.module.emag)
								R.module_state_2 = null
								R.module.emag.forceMove(null)
							else if(R.module_state_3 == R.module.emag)
								R.module_state_3 = null
								R.module.emag.forceMove(null)
					log_admin("[key_name_admin(usr)] has unemag'ed [ai]'s Cyborgs.")

	else if (href_list["common"])
		switch(href_list["common"])
			if("undress")
				for(var/obj/item/W in current)
					current.drop_from_inventory(W)
			if("takeuplink")
				take_uplink()
			if("crystals")
				if (usr.client.holder.rights & R_FUN)
					var/obj/item/device/uplink/suplink = find_syndicate_uplink()
					if(!suplink)
						to_chat(usr, "<span class='warning'>Failed to find an uplink.</span>")
						return
					var/crystals = suplink.uses
					crystals = input("Amount of telecrystals for [key]","Operative uplink", crystals) as null|num
					if (!isnull(crystals) && !QDELETED(suplink))
						suplink.uses = crystals
						log_and_message_admins("set the telecrystals for [key] to [crystals]")

	else if (href_list["obj_announce"])
		var/obj_count = 1
		to_chat(current, "<span class='notice'>Your current objectives:</span>")
		for(var/datum/objective/objective in objectives)
			to_chat(current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++

/datum/mind/proc/find_syndicate_uplink()
	var/list/L = current.get_contents()
	for (var/obj/item/I in L)
		if (I.hidden_uplink)
			return I.hidden_uplink
	return null

/datum/mind/proc/take_uplink()
	var/obj/item/device/uplink/H = find_syndicate_uplink()
	if(H)
		qdel(H)


// check whether this mind's mob has been brigged for the given duration
// have to call this periodically for the duration to work properly
/datum/mind/proc/is_brigged(duration)
	var/turf/T = current.loc
	if(!istype(T))
		brigged_since = -1
		return 0
	var/is_currently_brigged = 0
	if(istype(T.loc,/area/security/brig))
		is_currently_brigged = 1
		if(current.GetIdCard())
			is_currently_brigged = 0

	if(!is_currently_brigged)
		brigged_since = -1
		return 0

	if(brigged_since == -1)
		brigged_since = world.time

	return (duration <= world.time - brigged_since)

/datum/mind/proc/reset()
	assigned_role =   null
	special_role =    null
	role_alt_title =  null
	assigned_job =    null
	//faction =       null //Uncommenting this causes a compile error due to 'undefined type', fucked if I know.
	changeling =      null
	initial_account = null
	objectives =      list()
	special_verbs =   list()
	has_been_rev =    0
	rev_cooldown =    0
	brigged_since =   -1

//Antagonist role check
/mob/living/proc/check_special_role(role)
	if(mind)
		if(!role)
			return mind.special_role
		else
			return (mind.special_role == role) ? 1 : 0
	else
		return 0

//Initialisation procs
/mob/living/proc/mind_initialize()
	if(mind)
		mind.key = key
	else
		mind = new /datum/mind(key)
		mind.original = src
		SSticker.minds += mind
	if(!mind.name)	mind.name = real_name
	mind.current = src
	if(player_is_antag(mind))
		src.client.verbs += /client/proc/aooc

//HUMAN
/mob/living/carbon/human/mind_initialize()
	..()
	if(!mind.assigned_role)
		mind.assigned_role = GLOB.using_map.default_assistant_title

//slime
/mob/living/carbon/slime/mind_initialize()
	..()
	mind.assigned_role = "slime"

//AI
/mob/living/silicon/ai/mind_initialize()
	..()
	mind.assigned_role = "AI"

//BORG
/mob/living/silicon/robot/mind_initialize()
	..()
	mind.assigned_role = "Robot"

//PAI
/mob/living/silicon/pai/mind_initialize()
	..()
	mind.assigned_role = "pAI"
	mind.special_role = ""

//Animals
/mob/living/simple_animal/mind_initialize()
	..()
	mind.assigned_role = "Animal"

/mob/living/simple_animal/corgi/mind_initialize()
	..()
	mind.assigned_role = "Corgi"

/mob/living/simple_animal/shade/mind_initialize()
	..()
	mind.assigned_role = "Shade"

/mob/living/simple_animal/construct/builder/mind_initialize()
	..()
	mind.assigned_role = "Artificer"
	mind.special_role = "Cultist"

/mob/living/simple_animal/construct/wraith/mind_initialize()
	..()
	mind.assigned_role = "Wraith"
	mind.special_role = "Cultist"

/mob/living/simple_animal/construct/armoured/mind_initialize()
	..()
	mind.assigned_role = "Juggernaut"
	mind.special_role = "Cultist"
