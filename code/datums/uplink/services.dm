/***********
* Services *
************/
/datum/uplink_item/item/services
	category = /datum/uplink_category/services

/datum/uplink_item/item/services/fake_ion_storm
	name = "Ion Storm Announcement"
	desc = "Interferes with the station's ion sensors."
	item_cost = 8
	path = /obj/item/device/uplink_service/fake_ion_storm

/datum/uplink_item/item/services/suit_sensor_garble
	name = "Complete Suit Sensor Jamming"
	desc = "Garbles all suit sensor data for 10 minutes."
	item_cost = 16
	path = /obj/item/device/uplink_service/jamming/garble

/datum/uplink_item/item/services/fake_rad_storm
	name = "Radiation Storm Announcement"
	desc = "Interferes with the station's radiation sensors."
	item_cost = 24
	path = /obj/item/device/uplink_service/fake_rad_storm

/datum/uplink_item/item/services/fake_crew_annoncement
	name = "Crew Arrival Announcement and Records"
	desc = "Creates a fake crew arrival announcement as well as fake crew records, using your current appearance (including held items!) and worn id card. Prepare well!"
	item_cost = 32
	path = /obj/item/device/uplink_service/fake_crew_announcement

/datum/uplink_item/item/services/suit_sensor_shutdown
	name = "Complete Suit Sensor Shutdown"
	desc = "Completely disables all suit sensors for 10 minutes."
	item_cost = 40
	path = /obj/item/device/uplink_service/jamming

/datum/uplink_item/item/services/fake_update_annoncement
	item_cost = 40
	path = /obj/item/device/uplink_service/fake_update_announcement

/datum/uplink_item/item/services/fake_update_annoncement/New()
	..()
	item_cost = round(DEFAULT_TELECRYSTAL_AMOUNT / 2)

	spawn(2)
		name = "[command_name()] Update Announcement"
		desc = "Causes a falsified [command_name()] Update."

/***************
* Service Item *
***************/

#define AWAITING_ACTIVATION 0
#define CURRENTLY_ACTIVE 1
#define HAS_BEEN_ACTIVATED 2

/obj/item/device/uplink_service
	name = "tiny device"
	desc = "Press button to activate. Can be done once and only once."
	w_class = ITEM_SIZE_TINY
	icon_state = "sflash"
	var/state = AWAITING_ACTIVATION
	var/service_label = "Unnamed Service"
	var/service_duration = 0 SECONDS

/obj/item/device/uplink_service/Destroy()
	if(state == CURRENTLY_ACTIVE)
		deactivate()
	. = ..()

/obj/item/device/uplink_service/examine(var/user)
	. = ..(user, 1)
	if(.)
		switch(state)
			if(AWAITING_ACTIVATION)
				to_chat(user, "It is labeled '[service_label]' and appears to be awaiting activation.")
			if(CURRENTLY_ACTIVE)
				to_chat(user, "It is labeled '[service_label]' and appears to be active.")
			if(HAS_BEEN_ACTIVATED)
				to_chat(user, "It is labeled '[service_label]' and appears to be permanently disabled.")

/obj/item/device/uplink_service/attack_self(var/mob/user)
	if(state != AWAITING_ACTIVATION)
		to_chat(user, "<span class='warning'>\The [src] won't activate again.</span>")
		return
	if(!enable())
		return
	state = CURRENTLY_ACTIVE
	update_icon()
	user.visible_message("<span class='notice'>\The [user] activates \the [src].</span>", "<span class='notice'>You activate \the [src].</span>")
	log_and_message_admins("has activated the service '[service_label]'", user)

	if(service_duration)
		schedule_task_with_source_in(service_duration, src, /obj/item/device/uplink_service/proc/deactivate)
	else
		deactivate()

/obj/item/device/uplink_service/proc/deactivate()
	if(state != CURRENTLY_ACTIVE)
		return
	disable()
	state = HAS_BEEN_ACTIVATED
	update_icon()
	playsound(loc, "sparks", 50, 1)
	visible_message("<span class='warning'>\The [src] shuts down with a spark.</span>")

/obj/item/device/uplink_service/update_icon()
	switch(state)
		if(AWAITING_ACTIVATION)
			icon_state = initial(icon_state)
		if(CURRENTLY_ACTIVE)
			icon_state = "sflash2"
		if(HAS_BEEN_ACTIVATED)
			icon_state = "flashburnt"

/obj/item/device/uplink_service/proc/enable(var/mob/user = usr)
	return TRUE

/obj/item/device/uplink_service/proc/disable(var/mob/user = usr)
	return

/*****************
* Sensor Jamming *
*****************/
/obj/item/device/uplink_service/jamming
	service_duration = 10 MINUTES
	service_label = "Suit Sensor Shutdown"
	var/suit_sensor_jammer_method/ssjm = /suit_sensor_jammer_method/cap_off

/obj/item/device/uplink_service/jamming/New()
	..()
	ssjm = new ssjm()

/obj/item/device/uplink_service/jamming/Destroy()
	. = ..()
	qdel(ssjm)
	ssjm = null

/obj/item/device/uplink_service/jamming/enable(var/mob/user = usr)
	ssjm.enable()
	. = ..()

/obj/item/device/uplink_service/jamming/disable(var/mob/user = usr)
	ssjm.disable()

/obj/item/device/uplink_service/jamming/garble
	service_label = "Suit Sensor Garble"
	ssjm = /suit_sensor_jammer_method/random/moderate

/*****************
* Fake Ion storm *
*****************/
/obj/item/device/uplink_service/fake_ion_storm
	service_label = "Ion Storm Announcement"

/obj/item/device/uplink_service/fake_ion_storm/enable(var/mob/user = usr)
	ion_storm_announcement()
	. = ..()

/*****************
* Fake Rad storm *
*****************/
/obj/item/device/uplink_service/fake_rad_storm
	service_label = "Radiation Storm Announcement"

/obj/item/device/uplink_service/fake_rad_storm/enable(var/mob/user = usr)
	var/datum/event_meta/EM = new(EVENT_LEVEL_MUNDANE, "Fake Radiation Storm", add_to_queue = 0)
	new/datum/event/radiation_storm/syndicate(EM)
	. = ..()

/***************************
* Fake CentCom Annoncement *
***************************/
/obj/item/device/uplink_service/fake_update_announcement
	service_label = "Update Announcement"

/obj/item/device/uplink_service/fake_update_announcement/enable(var/mob/user = usr)
	var/title = sanitize(input(user, "Enter your announcement title.", "Announcement Title") as null|text)
	if(!title)
		return
	var/message = sanitize(input(user, "Enter your announcement message.", "Announcement Title") as null|text)
	if(!message)
		return

	if(CanUseTopic(user, hands_state) != STATUS_INTERACTIVE)
		return FALSE
	command_announcement.Announce(message, title, msg_sanitized = 1)
	return TRUE

/*********************************
* Fake Crew Records/Announcement *
*********************************/
/obj/item/device/uplink_service/fake_crew_announcement
	service_label = "Crew Arrival Announcement and Records"

/obj/item/device/uplink_service/fake_crew_announcement/enable(var/mob/user = usr)
	var/obj/item/weapon/card/id/I = user.GetIdCard()
	var/datum/data/record/random_general_record
	var/datum/data/record/random_medical_record

	while(null in data_core.general)
		data_core.general -= null
		log_error("Found a null entry in data_core.general")

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

	if(random_general_record)
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
	. = ..()
