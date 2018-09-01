/obj/machinery/uniform_checker
	name = "uniform checker"
	desc= "A recruit's nightmare, Instructor 6-TA is programmed to spot uniform breaches and apply psychological pressure to correct them."
	icon = 'maps/torch/icons/obj/uniques.dmi'
	icon_state = "uniform_checker"
	layer = BELOW_OBJ_LAYER
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 10
	var/list/non_uniformed = list(/datum/mil_branch/civilian,/datum/mil_branch/solgov)
	var/voice_name = "Instructor 6-TA"

/obj/machinery/uniform_checker/attack_hand(mob/living/carbon/human/user)
	if(..())
		return
	if(istype(user))
		scan_user(user)

/obj/machinery/uniform_checker/state(msg)
	..("[voice_name] blares, \"[msg]\"")

/obj/machinery/uniform_checker/proc/scan_user(mob/living/carbon/human/user)
	var/obj/item/weapon/card/id/ID = user.GetIdCard()
	if(!istype(ID))
		state("Fix your ID!")
		return
	var/datum/job/job = job_master.GetJobByType(ID.job_access_type)
	if(job && ID.military_branch && ID.military_rank)
		if(is_type_in_list(ID.military_branch,non_uniformed))
			state("As you were, citizen!")
			return
		var/list/uniforms = SSuniforms.get_unform(ID.military_rank, ID.military_branch, job.department_flag)
		var/uniform_type = input("Select type of uniform:", "Uniform type") as null|anything in uniforms
		var/list/pieces = uniforms[uniform_type]
		var/list/infractions = list()

		//Missing items
		//some slots have alternative items, so have to keep track which slots are filled to not false positive
		var/list/missing_slots = list()
		var/list/ok_slots = list()
		var/list/wrinkled = list()
		for(var/piece in pieces)
			var/slot = pieces[piece]
			if(!slot)
				continue
			if(slot in ok_slots)
				continue
			var/obj/item/clothing/C = user.get_equipped_item(slot)
			if(istype(C, piece))
				missing_slots -= slot
				ok_slots |= slot
				if(C.ironed_state == WRINKLES_WRINKLY)
					wrinkled |= C.name
			else
				missing_slots |= slot
		if(missing_slots.len)
			var/list/missing = list()
			for(var/piece in pieces)
				if(pieces[piece] in missing_slots)
					var/obj/item/clothing/C = piece
					missing |= initial(C.name)
			infractions["missing"] = missing
		if(wrinkled.len)
			infractions["wrinkled"] = wrinkled

		var/obj/item/clothing/under/C = user.w_uniform
		if(istype(C))
			//Putting webbigs on dress/service
			if(uniform_type != "Utility")
				if(istype(C) && !(slot_w_uniform in missing_slots))
					for(var/obj/item/clothing/accessory/storage/S in C.accessories)
						if(!istype(S, /obj/item/clothing/accessory/storage/holster/))
							infractions["webbing"] = C.name

			//Putting ranks on wrong clothing items
			if(!istype(C, /obj/item/clothing/under/solgov/))
				for(var/obj/item/clothing/accessory/solgov/R in C.accessories)
					infractions["ranks"] = C.name
			else
				//Rolled down uniform
				if(C.rolled_down == 1)
					infractions["rolled"] = C.name
			
		var/is_officer = ID.military_rank.sort_order > 10
		var/greeting = is_officer ? ", good time of day, Sir." : ", atten-TION!"
		ping("[ID.military_rank.name] [ID.registered_name][greeting]")
		var/list/messages = list()
		var/opening
		for(var/infraction in infractions)
			var/address = prob(50) ? ", [ID.military_rank.name]" : ""
			switch(infraction)
				if("missing")
					if(is_officer) 
						opening = "Sir!"
					else
						opening = pick("Gosh darn, [ID.military_rank.name]!",
						"Surprised you manage to walk and breathe at the same time[address]!",
						"Are you even trying[address]?",
						"Did you escape the boot camp[address]!?",
						"Is dressing yourself too complex of a concept to you[address]?!",
						"I'm not even disappointed, just mad! Disappointed would mean I had a hope.")
					var/list/missing_items = infractions["missing"]
					messages += "[opening] Your [english_list(missing_items)] [missing_items.len > 1 ? "are" : "is"] missing!"
				if("wrinkled")
					if(is_officer) 
						opening = "Sir!"
					else
						opening = pick("Mommy isn't going to take care of you here[address]!",
						"Are you having trouble operating an iron[address]?!",
						"Are your eyes fixed on right[address]?!",
						"I've seen space carp maulings more tidy than you[address]!",
						"Pooolice those wrinkles[address]!")
					var/list/wrinkled_items = infractions["wrinkled"]
					messages += "[opening] Your [english_list(wrinkled_items)] [wrinkled_items.len > 1 ? "are" : "is"] wrinkled!"
				if("webbing")
					if(is_officer) 
						opening = "Sir!"
					else
						opening = pick("Just what the Hell do you think you're wearing[address]?!",
						"Have at least /some/ pride in your uniform[address]!",
						"Are you going to crawl in the dirt, wearing that[address]?")
					messages += "[opening] You are not to wear any webbings on your [infractions["webbing"]]!"
				if("ranks")
					if(is_officer) 
						opening = "Sir!"
					else
						opening = pick("Did you buy your rank at the store[address]?!",
						"Have at least /some/ pride in your uniform[address]!",
						"Does that look like an uniform piece to you[address]!?")
					messages += "[opening] Ranks go on uniform items, not [infractions["ranks"]]!"
				if("rolled")
					if(is_officer) 
						opening = "Sir!"
					else
						opening = pick("Just what the Hell do you think you're wearing[address]?!",
						"Have at least /some/ pride in your uniform[address]!",
						"Is dressing yourself too complex of a concept to you[address]?!")
					messages += "[opening] [capitalize(infractions["rolled"])] should not be worn rolled down!"
		if(!messages.len)
			messages+= "Everything seems to be in order!"
		else if (!is_officer)
			messages+= "Fix yourself!"
		if(messages.len == 6) //maximum infractions
			messages+= "<span class='danger'>*screams incoherently*</span>"
		for(var/msg in messages)
			state(msg)
			sleep(rand(3,6))
