/***********
* Services *
************/
/datum/uplink_item/item/services
	category = /datum/uplink_category/services

/datum/uplink_item/item/services/fake_ion_storm
	name = "Ion Storm Announcement"
	desc = "Interferes with ion sensors."
	item_cost = 8
	path = /obj/item/device/uplink_service/fake_ion_storm

/datum/uplink_item/item/services/suit_sensor_garble
	name = "Complete Suit Sensor Jamming"
	desc = "Garbles all suit sensor data for 10 minutes."
	item_cost = 16
	path = /obj/item/device/uplink_service/jamming/garble

/datum/uplink_item/item/services/fake_rad_storm
	name = "Radiation Storm Announcement"
	desc = "Interferes with radiation sensors."
	item_cost = 24
	path = /obj/item/device/uplink_service/fake_rad_storm

/datum/uplink_item/item/services/fake_crew_annoncement
	name = "Crew Arrival Announcement and Records"
	desc = "Creates a fake crew arrival announcement as well as fake crew records, using your current appearance (including held items!) and worn id card. Prepare well!"
	item_cost = 16
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
	qdel(ssjm)
	ssjm = null
	. = ..()

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

	if(CanUseTopic(user, GLOB.hands_state) != STATUS_INTERACTIVE)
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
	var/datum/computer_file/crew_record/random_record

	if(GLOB.all_crew_records.len)
		random_record = pick(GLOB.all_crew_records)

	var/datum/computer_file/crew_record/new_record = CreateModularRecord(user)
	if(I)
		new_record.set_name(I.registered_name)
		new_record.set_sex(I.sex)
		new_record.set_age(I.age)
		new_record.set_job(I.assignment)
		new_record.set_fingerprint(I.fingerprint_hash)
		new_record.set_bloodtype(I.blood_type)
		new_record.set_dna(I.dna_hash)
		if(I.military_branch)
			new_record.set_branch(I.military_branch.name)
			if(I.military_rank)
				new_record.set_rank(I.military_rank.name)
	else
		var/mob/living/carbon/human/H = user
		var/age = istype(H) ? H.age : 30
		var/assignment = GetAssignment(user)
		new_record.set_name(user.real_name)
		new_record.set_sex(capitalize(user.gender))
		new_record.set_age(age)
		new_record.set_job(assignment)
	new_record.set_species(user.get_species())

	if(random_record)
		var/list/to_copy = list(REC_FIELD(citizenship),REC_FIELD(faction),REC_FIELD(religion),REC_FIELD(homeSystem),REC_FIELD(fingerprint),REC_FIELD(dna),REC_FIELD(bloodtype))
		for(var/field in to_copy)
			new_record.set_field(field, random_record.get_field(field))

	var/datum/job/job = job_master.GetJob(new_record.get_job())
	if(istype(job) && job.announced)
		AnnounceArrivalSimple(new_record.get_name(), new_record.get_job(), get_announcement_frequency(job))
	. = ..()
