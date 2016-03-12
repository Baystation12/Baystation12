/****************
* Announcements *
*****************/
/datum/uplink_item/abstract/announcements
	category = /datum/uplink_category/services

/datum/uplink_item/abstract/announcements/buy(var/obj/item/device/uplink/U, var/mob/user)
	. = ..()
	if(.)
		log_and_message_admins("has triggered a falsified [src]", user)

/datum/uplink_item/abstract/announcements/fake_centcom/New()
	..()
	name = "[command_name()] Update Announcement"
	item_cost = round(DEFAULT_TELECRYSTAL_AMOUNT / 2)
	desc = "Causes a falsified [command_name()] Update. Triggers immediately after supplying additional data."

/datum/uplink_item/abstract/announcements/fake_centcom/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/user, var/list/args)
	command_announcement.Announce(args.["message"], args.["title"])
	return 1

/datum/uplink_item/abstract/announcements/fake_crew_arrival
	name = "Crew Arrival Announcement/Records"
	desc = "Creates a fake crew arrival announcement as well as fake crew records, using your current appearance (including held items!) and worn id card. Trigger with care!"
	item_cost = 8

/datum/uplink_item/abstract/announcements/fake_crew_arrival/New()
	..()
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/abstract/announcements/fake_crew_arrival/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/user, var/list/args)
	if(!user)
		return 0

	var/obj/item/weapon/card/id/I = user.GetIdCard()
	var/datum/data/record/random_general_record
	var/datum/data/record/random_medical_record
	if(data_core.general.len)
		random_general_record	= pick(data_core.general)
		random_medical_record	= find_medical_record("id", random_general_record.fields["id"])

	var/datum/data/record/general = data_core.CreateGeneralRecord(user)
	if(I)
		general.fields["age"] = I.age
		general.fields["rank"] = I.assignment
		general.fields["real_rank"] = I.assignment
		general.fields["name"] = I.registered_name
		general.fields["sex"] = I.sex
	else
		var/mob/living/carbon/human/H
		if(istype(user,/mob/living/carbon/human))
			H = user
			general.fields["age"] = H.age
		else
			general.fields["age"] = initial(H.age)
		var/assignment = GetAssignment(user)
		general.fields["rank"] = assignment
		general.fields["real_rank"] = assignment
		general.fields["name"] = user.real_name
		general.fields["sex"] = capitalize(user.gender)

	general.fields["species"] = user.get_species()
	var/datum/data/record/medical = data_core.CreateMedicalRecord(general.fields["name"], general.fields["id"])
	data_core.CreateSecurityRecord(general.fields["name"], general.fields["id"])

	if(!random_general_record)
		general.fields["citizenship"]	= random_general_record.fields["citizenship"]
		general.fields["faction"] 		= random_general_record.fields["faction"]
		general.fields["fingerprint"] 	= random_general_record.fields["fingerprint"]
		general.fields["home_system"] 	= random_general_record.fields["home_system"]
		general.fields["religion"] 		= random_general_record.fields["religion"]
	if(random_medical_record)
		medical.fields["b_type"]		= random_medical_record.fields["b_type"]
		medical.fields["b_dna"]			= random_medical_record.fields["b_type"]

	if(I)
		general.fields["fingerprint"] 	= I.fingerprint_hash
		medical.fields["b_type"]	= I.blood_type
		medical.fields["b_dna"]		= I.dna_hash

	AnnounceArrivalSimple(general.fields["name"], general.fields["rank"])
	return 1

/datum/uplink_item/abstract/announcements/fake_ion_storm
	name = "Ion Storm Announcement"
	desc = "Interferes with the station's ion sensors. Triggers immediately upon investment."
	item_cost = 2

/datum/uplink_item/abstract/announcements/fake_ion_storm/get_goods(var/obj/item/device/uplink/U, var/loc)
	ion_storm_announcement()
	return 1

/datum/uplink_item/abstract/announcements/fake_radiation
	name = "Radiation Storm Announcement"
	desc = "Interferes with the station's radiation sensors. Triggers immediately upon investment."
	item_cost = 6

/datum/uplink_item/abstract/announcements/fake_radiation/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/datum/event_meta/EM = new(EVENT_LEVEL_MUNDANE, "Fake Radiation Storm", add_to_queue = 0)
	new/datum/event/radiation_storm/syndicate(EM)
	return 1
