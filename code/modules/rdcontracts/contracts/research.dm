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
	if(possible_techs.len == 0)
		return UKEY_ID_INVALID

	desired_tech = pick_n_take(possible_techs)
	return desired_tech

/datum/rdcontract/research/setup()
	. = ..()

	desired_level = rand(min_level,max_level)
	reward += (100 * desired_level)

	var/datum/research/techonly/R = new()
	var/datum/tech/T

	for(var/datum/tech/RT in R.known_tech)
		if(RT.id == desired_tech)
			T = RT
			break

	name = "Research [T.name] to level [desired_level]"
	desc = "Deliver a disk containing research data about [T.name]. The research on the disk must be of at least level [desired_level]."

/datum/rdcontract/research/check_completion(var/obj/item/weapon/disk/tech_disk/O)
	if(!istype(O))
		return 0

	var/datum/tech/T = O.stored

	if(T.level >= desired_level)
		return 1
	return 0

/datum/rdcontract/research/highend
	name = "heavily research something"
	desc = "get very intimate with a certain subject"

	reward = 600
	min_level = 4
	max_level = 6