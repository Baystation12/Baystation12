mob/living/carbon/human/var
	autopsy_vacuum = 0
	autopsy_pressure = 0
	autopsy_choked = 0
	autopsy_shocked = 0
	list/autopsy_weapons

mob/living/carbon/human/proc
	BiopsyInfo()
		. = "<B>Special Information:</B><BR>"
		if(autopsy_vacuum)
			. += "Skin shows signs of extreme pressure damage.<br>"
		else if(autopsy_pressure)
			. += "Skin shows signs of pressure damage.<br>"
		if(autopsy_choked)
			. += "Airway shows signs of strangulation.<br>"
		if(autopsy_shocked)
			. += "Subject shows signs of electrocution.<br>"

		for(var/obj/item/I in autopsy_weapons)
			var/datum/autopsy_data/data = autopsy_weapons[I]
			var/weight = "unknown"
			switch(I.w_class)
				if(1.0)
					weight = "tiny"
				if(2.0)
					weight = "small"
				if(3.0)
					weight = "normal-sized"
				if(4.0)
					weight = "bulky"
				if(5.0)
					weight = "huge"
			var/method = "bashing"
			if(I.damtype == "fire")
				method = "burning"
			else if(is_sharp(I))
				method = "stabbing"

			. += text("Subject shows [] wounds to the [] from a [][] weapon.",data.hit_times,dd_list2text(data.hit_areas,", "),weight,method)

		switch(appendix_op_stage)
			if(1)
				. += "Abdominal incision made, subject is bleeding.<br>"
			if(2)
				. += "Abdominal incision made, subject is cauterized.<br>"
			if(3)
				. += "Abdominal incision made, all organs visible.<br>"
			if(4)
				. += "Abdominal organs visible, appendix cut.<br>"
			if(5)
				. += "Abdominal organs visible, appendix removed.<br>"

		switch(brain_op_stage)
			if(1)
				. += "Cranial incision made.<br>"
			if(2)
				. += "Skull sawed open.<br>"
			if(3)
				. += "Brain connections severed.<br>"
			if(4)
				. += "Brain removed.<br>"

		switch(eye_op_stage)
			if(1)
				. += "Ocular incision made.<br>"
			if(2)
				. += "Eye sockets retracted.<br>"
			if(3)
				. += "Eye sockets retracted, eyes repaired.<br>"

		if(!isnull(reagents))
			if(reagents.reagent_list.len > 0)
				var/reagents_length = reagents.reagent_list.len
				. += "<b>[reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found: </b><br>"
				for (var/re in reagents.reagent_list)
					. += "[re]<br>"
			else
				. += "No active chemical agents found in subject."
		else
			. += "No significant chemical agents found in subject."

	add_autopsy_weapon(obj/item/I,hit_location)
		if(I)
			if(!autopsy_weapons) autopsy_weapons = list()
			if(I in autopsy_weapons)
				var/datum/autopsy_data/data = autopsy_weapons[I]
				data.hit_times++
				if(!(hit_location in data.hit_areas))
					data.hit_areas += hit_location
			else
				autopsy_weapons.Insert(I,1)
				var/datum/autopsy_data/data = new
				autopsy_weapons[I] = data
				data.hit_times = 1
				data.hit_areas += hit_location
			if(autopsy_weapons.len > 3)
				autopsy_weapons.len--

datum/autopsy_data
	var
		hit_times = 0
		hit_areas = list()


mob/adjustOxyLoss(var/amount)
	. = ..()
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if(oxyloss <= 0 && amount < 0)
			H.autopsy_vacuum = 0
			H.autopsy_pressure = 0
			H.autopsy_choked = 0
		else
			if(istype(loc,/turf/space))
				H.autopsy_vacuum = 1
			if(isturf(loc))
				var/datum/gas_mixture/environment = loc.return_air()
				if(environment.return_pressure() < 45)
					H.autopsy_pressure = 1
mob/adjustBruteLoss(var/amount)
	. = ..()
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if(amount < 0)
			if(prob(25)) H.autopsy_shocked = 0
			if(prob(50) && length(H.autopsy_weapons))
				var/obj/item/I = pick(H.autopsy_weapons)
				var/datum/autopsy_data/data = H.autopsy_weapons[I]
				data.hit_times -= rand(1,min(2,amount/5))
				if(data.hit_times <= 0)
					H.autopsy_weapons -= I

/mob/adjustFireLoss(var/amount)
	. = ..()
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		if(amount < 0)
			if(prob(25)) H.autopsy_shocked = 0
			if(prob(50) && length(H.autopsy_weapons))
				var/obj/item/I = pick(H.autopsy_weapons)
				var/datum/autopsy_data/data = H.autopsy_weapons[I]
				data.hit_times -= rand(1,min(2,amount/5))
				if(data.hit_times <= 0)
					H.autopsy_weapons -= I