/** WOUND DEFINITIONS **/
//Note that the MINIMUM damage before a wound can be applied should correspond to
//the damage amount for the stage with the same name as the wound.
//e.g. /datum/wound/cut/deep should only be applied for 15 damage and up,
//because in it's stages list, "deep cut" = 15.
/proc/get_wound_type(var/type, var/damage)
	switch(type)
		if (INJURY_TYPE_CUT)
			switch(damage)
				if(70 to INFINITY)
					return /datum/wound/cut/massive
				if(60 to 70)
					return /datum/wound/cut/gaping_big
				if(50 to 60)
					return /datum/wound/cut/gaping
				if(25 to 50)
					return /datum/wound/cut/flesh
				if(15 to 25)
					return /datum/wound/cut/deep
				if(0 to 15)
					return /datum/wound/cut/small
		if (INJURY_TYPE_PIERCE)
			switch(damage)
				if(60 to INFINITY)
					return /datum/wound/puncture/massive
				if(50 to 60)
					return /datum/wound/puncture/gaping_big
				if(30 to 50)
					return /datum/wound/puncture/gaping
				if(15 to 30)
					return /datum/wound/puncture/flesh
				if(0 to 15)
					return /datum/wound/puncture/small
		if (INJURY_TYPE_BRUISE)
			return /datum/wound/bruise
		if (INJURY_TYPE_BURN, INJURY_TYPE_LASER)
			switch(damage)
				if(50 to INFINITY)
					return /datum/wound/burn/carbonised
				if(40 to 50)
					return /datum/wound/burn/deep
				if(30 to 40)
					return /datum/wound/burn/severe
				if(15 to 30)
					return /datum/wound/burn/large
				if(0 to 15)
					return /datum/wound/burn/moderate
		if (INJURY_TYPE_SHATTER)
			switch(damage)
				if(50 to INFINITY)
					return /datum/wound/shatter/smashed
				if(40 to 50)
					return /datum/wound/shatter/wide
				if(30 to 40)
					return /datum/wound/shatter/narrow
				if(15 to 30)
					return /datum/wound/shatter/cracked
				if(0 to 15)
					return /datum/wound/shatter/chipped

	return null //no wound

/datum/wound/proc/close()
	return

/** CUTS **/
/datum/wound/cut
	bleed_threshold = 5
	damage_type = INJURY_TYPE_CUT

/datum/wound/cut/bandage()
	..()
	if(!autoheal_cutoff)
		autoheal_cutoff = initial(autoheal_cutoff)

/datum/wound/cut/is_surgical()
	return autoheal_cutoff == 0

/datum/wound/cut/close()
	current_stage = max_bleeding_stage + 1
	desc = desc_list[current_stage]
	min_damage = damage_list[current_stage]
	if(damage > min_damage)
		heal_damage(damage-min_damage)

/datum/wound/cut/small
	// link wound descriptions to amounts of damage
	// Minor cuts have max_bleeding_stage set to the stage that bears the wound type's name.
	// The major cut types have the max_bleeding_stage set to the clot stage (which is accordingly given the "blood soaked" descriptor).
	max_bleeding_stage = 3
	stages = list(
		"ugly ripped cut" = 20,
		"ripped cut" = 10,
		"cut" = 5,
		"healing cut" = 2,
		"small scab" = 0
		)

/datum/wound/cut/deep
	max_bleeding_stage = 3
	stages = list(
		"ugly deep ripped cut" = 25,
		"deep ripped cut" = 20,
		"deep cut" = 15,
		"clotted cut" = 8,
		"scab" = 2,
		"fresh skin" = 0
		)

/datum/wound/cut/flesh
	max_bleeding_stage = 4
	stages = list(
		"ugly ripped flesh wound" = 35,
		"ugly flesh wound" = 30,
		"flesh wound" = 25,
		"blood soaked clot" = 15,
		"large scab" = 5,
		"fresh skin" = 0
		)

/datum/wound/cut/gaping
	max_bleeding_stage = 3
	stages = list(
		"gaping wound" = 50,
		"large blood soaked clot" = 25,
		"blood soaked clot" = 15,
		"small angry scar" = 5,
		"small straight scar" = 0
		)

/datum/wound/cut/gaping_big
	max_bleeding_stage = 3
	stages = list(
		"big gaping wound" = 60,
		"healing gaping wound" = 40,
		"large blood soaked clot" = 25,
		"large angry scar" = 10,
		"large straight scar" = 0
		)

/datum/wound/cut/massive
	max_bleeding_stage = 3
	stages = list(
		"massive wound" = 70,
		"massive healing wound" = 50,
		"massive blood soaked clot" = 25,
		"massive angry scar" = 10,
		"massive jagged scar" = 0
		)

/** PUNCTURES **/
/datum/wound/puncture
	bleed_threshold = 10
	damage_type = INJURY_TYPE_PIERCE

/datum/wound/puncture/can_worsen(damage_type, damage)
	return 0 //puncture wounds cannot be enlargened

/datum/wound/puncture/small
	max_bleeding_stage = 2
	stages = list(
		"puncture" = 5,
		"healing puncture" = 2,
		"small scab" = 0
		)

/datum/wound/puncture/flesh
	max_bleeding_stage = 2
	stages = list(
		"puncture wound" = 15,
		"blood soaked clot" = 5,
		"large scab" = 2,
		"small round scar" = 0
		)

/datum/wound/puncture/gaping
	max_bleeding_stage = 3
	stages = list(
		"gaping hole" = 30,
		"large blood soaked clot" = 15,
		"blood soaked clot" = 10,
		"small angry scar" = 5,
		"small round scar" = 0
		)

/datum/wound/puncture/gaping_big
	max_bleeding_stage = 3
	stages = list(
		"big gaping hole" = 50,
		"healing gaping hole" = 20,
		"large blood soaked clot" = 15,
		"large angry scar" = 10,
		"large round scar" = 0
		)

/datum/wound/puncture/massive
	max_bleeding_stage = 3
	stages = list(
		"massive wound" = 60,
		"massive healing wound" = 30,
		"massive blood soaked clot" = 25,
		"massive angry scar" = 10,
		"massive jagged scar" = 0
		)

/** BRUISES **/
/datum/wound/bruise
	stages = list(
		"monumental bruise" = 80,
		"huge bruise" = 50,
		"large bruise" = 30,
		"moderate bruise" = 20,
		"small bruise" = 10,
		"tiny bruise" = 5
		)

	bleed_threshold = 20
	max_bleeding_stage = 3 //only large bruise and above can bleed.
	autoheal_cutoff = 30
	damage_type = INJURY_TYPE_BRUISE

/** BURNS **/
/datum/wound/burn
	damage_type = INJURY_TYPE_BURN
	max_bleeding_stage = 0

/datum/wound/burn/bleeding()
	return 0

/datum/wound/burn/moderate
	stages = list(
		"ripped burn" = 10,
		"moderate burn" = 5,
		"healing moderate burn" = 2,
		"fresh skin" = 0
		)

/datum/wound/burn/large
	stages = list(
		"ripped large burn" = 20,
		"large burn" = 15,
		"healing large burn" = 5,
		"fresh skin" = 0
		)

/datum/wound/burn/severe
	stages = list(
		"ripped severe burn" = 35,
		"severe burn" = 30,
		"healing severe burn" = 10,
		"burn scar" = 0
		)

/datum/wound/burn/deep
	stages = list(
		"ripped deep burn" = 45,
		"deep burn" = 40,
		"healing deep burn" = 15,
		"large burn scar" = 0
		)

/datum/wound/burn/carbonised
	stages = list(
		"carbonised area" = 50,
		"healing carbonised area" = 20,
		"massive burn scar" = 0
		)

/** EXTERNAL ORGAN LOSS **/
/datum/wound/lost_limb

/datum/wound/lost_limb/New(var/obj/item/organ/external/lost_limb, var/losstype, var/clean)
	var/damage_amt = lost_limb.max_damage
	if(clean) damage_amt /= 2

	switch(losstype)
		if(DROPLIMB_EDGE, DROPLIMB_BLUNT)
			damage_type = INJURY_TYPE_CUT
			if(BP_IS_ROBOTIC(lost_limb))
				max_bleeding_stage = -1
				bleed_threshold = INFINITY
				stages = list("mangled robotic socket" = 0)
			else if(BP_IS_CRYSTAL(lost_limb))
				max_bleeding_stage = -1
				bleed_threshold = INFINITY
				stages = list("shattered stump" = 0)
			else
				max_bleeding_stage = 3 //clotted stump and above can bleed.
				stages = list(
					"ripped stump" = damage_amt*1.3,
					"bloody stump" = damage_amt,
					"clotted stump" = damage_amt*0.5,
					"scarred stump" = 0
				)
		if(DROPLIMB_BURN)
			damage_type = INJURY_TYPE_BURN
			stages = list(
				"mangled charred stump" = damage_amt*1.3,
				"charred stump" = damage_amt,
				"scarred stump" = damage_amt*0.5,
				"scarred stump" = 0
				)

	..(damage_amt)

/datum/wound/lost_limb/can_merge(var/datum/wound/other)
	return 0 //cannot be merged

/** CRYSTALLINE WOUNDS **/
/datum/wound/shatter
	bleed_threshold = INFINITY
	damage_type = INJURY_TYPE_SHATTER
	max_bleeding_stage = -1

/datum/wound/shatter/close()
	damage = 0
	qdel(src)

/datum/wound/shatter/bleeding()
	return FALSE

/datum/wound/shatter/can_autoheal()
	return FALSE

/datum/wound/shatter/infection_check()
	return FALSE

/datum/wound/shatter/smashed
	stages = list("shattered hole" = 0)

/datum/wound/shatter/wide
	stages = list("gaping crack" = 0)

/datum/wound/shatter/narrow
	stages = list("wide crack" = 0)

/datum/wound/shatter/cracked
	stages = list("narrow crack" = 0)

/datum/wound/shatter/chipped
	stages = list("chip" = 0)
