/datum/rdcontract/research
	name = "research something"
	desc = "attain a research level in something and deliver a disk"
	ukey_name = "research"

	// we add to this reward based on the desired research level
	reward = 100
	delivery_type = /obj/item/weapon/disk/tech_disk

	var/list/possible_techs = list(
		TECH_MATERIAL,
		TECH_ENGINEERING,
		TECH_PHORON,
		TECH_POWER,
		TECH_BLUESPACE,
		TECH_BIO,
		TECH_MAGNET,
		TECH_DATA
	)
	var/desired_tech
	var/desired_level

	var/min_level = 2
	var/max_level = 3

/datum/rdcontract/research/get_ukey_id()
	if(LAZYLEN(possible_techs) == 0)
		return null

	desired_tech = pick_n_take(possible_techs)
	return desired_tech

/datum/rdcontract/research/setup()
	. = ..()

	desired_level = rand(min_level,max_level)
	reward += (100 * desired_level)

	for(var/tech in subtypesof(/datum/tech))
		var/datum/tech/T = tech
		if(initial(T.id) == desired_tech)
			name = "Research [initial(T.name)] to level [desired_level]"
			desc = "Deliver a disk containing research data about [initial(T.name)]. The research on the disk must be of at least level [desired_level]."
			return

/datum/rdcontract/research/check_completion(var/obj/item/weapon/disk/tech_disk/O)
	if(!istype(O))
		return 0

	var/datum/tech/T = O.stored

	if(T.id != desired_tech)
		return 0

	if(T.level >= desired_level)
		return 1
	return 0

/datum/rdcontract/research/highend
	name = "heavily research something"
	desc = "get very intimate with a certain subject"
	highend = 1
	
	reward = 600
	min_level = 4
	max_level = 6