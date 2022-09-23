/***********
* Services *
************/
/datum/uplink_item/item/services
	category = /datum/uplink_category/services

/datum/uplink_item/item/services/fake_ion_storm
	name = "Ion Storm Announcement"
	desc = "A single-use device, that when activated, fakes an announcement, so people think all their electronic readings are wrong."
	item_cost = 10
	path = /obj/item/device/uplink_service/fake_ion_storm

/datum/uplink_item/item/services/suit_sensor_garble
	name = "Complete Suit Sensor Jamming"
	desc = "A single-use device, that when activated, garbles all suit sensor data for 10 minutes."
	item_cost = 16
	path = /obj/item/device/uplink_service/jamming/garble

/datum/uplink_item/item/services/fake_rad_storm
	name = "Radiation Storm Announcement"
	desc = "A single-use device, that when activated, fakes an announcement, so people run to the tunnels in fear of being irradiated! "
	item_cost = 24
	path = /obj/item/device/uplink_service/fake_rad_storm

/datum/uplink_item/item/services/fake_crew_annoncement
	name = "Crew Arrival Announcement and Records"
	desc = "A single-use device, that when activated, creates a fake crew arrival announcement as well as fake crew records, using your current appearance (including held items!) and worn id card. Prepare well!"
	item_cost = 16
	path = /obj/item/device/uplink_service/fake_crew_announcement

/datum/uplink_item/item/services/fake_command_report
	name = "Fake Command Report"
	desc = "A single-use device, that when activated, fakes an custom configured command report! "
	item_cost = 24
	path = /obj/item/device/uplink_service/fake_command_report

/datum/uplink_item/item/services/suit_sensor_shutdown
	name = "Complete Suit Sensor Shutdown"
	desc = "A single-use device, that when activated, completely disables all suit sensors for 10 minutes."
	item_cost = 40
	path = /obj/item/device/uplink_service/jamming

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
	icon = 'icons/obj/flash_synthetic.dmi'
	icon_state = "sflash"
	var/state = AWAITING_ACTIVATION
	var/service_label = "Unnamed Service"
	var/service_duration = 0 SECONDS

/obj/item/device/uplink_service/Destroy()
	if(state == CURRENTLY_ACTIVE)
		deactivate()
	. = ..()

/obj/item/device/uplink_service/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
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
	var/obj/effect/overmap/visitable/O = map_sectors["[get_z(src)]"]
	var/choice = alert(user, "This will only affect your current location[istype(O) ? " ([O])" : ""]. Proceed?","Confirmation", "Yes", "No")
	if(choice != "Yes")
		return
	if(!enable())
		return
	state = CURRENTLY_ACTIVE
	update_icon()
	user.visible_message("<span class='notice'>\The [user] activates \the [src].</span>", "<span class='notice'>You activate \the [src].</span>")
	log_and_message_admins("has activated the service '[service_label]'", user)

	if(service_duration)
		addtimer(CALLBACK(src,/obj/item/device/uplink_service/proc/deactivate), service_duration)
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

/obj/item/device/uplink_service/on_update_icon()
	switch(state)
		if(AWAITING_ACTIVATION)
			icon_state = initial(icon_state)
		if(CURRENTLY_ACTIVE)
			icon_state = "sflash_on"
		if(HAS_BEEN_ACTIVATED)
			icon_state = "sflash_burnt"

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

/**********************
* Fake Command Report *
**********************/
/obj/item/device/uplink_service/fake_command_report
	service_label = "Fake Command Report"
	/// The message title displayed in the command report
	var/title
	/// The message contents of the command report
	var/message
	/// Whether the command report should be broadcast to the public or only to command control programs
	var/public_announce = FALSE


/obj/item/device/uplink_service/fake_command_report/Initialize()
	. = ..()
	title = "[GLOB.using_map.boss_name] Update"


/obj/item/device/uplink_service/fake_command_report/get_antag_info()
	. = ..()
	. += {"
		<p>The fake command report service allows you to send a fake command report to whatever z level you're currently on. You can set the command report's title, message, and whether the full message is broadcast to everyone on the ship, or only to command communications software. The message will appear formatted the same was as legitimate command reports.</p>
		<p>The fake command report service is one-use and becomes useless once used.</p>
		<p>Use the device in-hand for a selection of options to configure the fake report and to send the report once configured.</p>
		<p>You can examine the device in-hand to view the configured title, message, and publicity. Be warned: These are visible even after the device is used. Be sure to properly dispose of it after use!</p>
	"}


/obj/item/device/uplink_service/fake_command_report/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The message title is set to '<b>[title]</b>'. The message will be [public_announce ? "broadcast to the public" : "sent only to command consoles"].")
		to_chat(user, "The message contents are set to:<br />[SPAN_NOTICE(message)]")


/obj/item/device/uplink_service/fake_command_report/attack_self(mob/user)
	if (state != AWAITING_ACTIVATION)
		to_chat(user, SPAN_WARNING("\The [src] won't activate again."))
		return

	var/selection = input(user, "What would you like to do?", "Fake Command Report") as anything in list("Set Title", "Set Message", "Set Publicity", "Send Command Report")
	switch (selection)
		if ("Set Title")
			var/new_title = sanitize(input(user, "What would you like the title to be?", "Fake Command Report", title) as text|null)
			if (!new_title || new_title == title)
				return
			title = new_title
			to_chat(user, SPAN_NOTICE("You set the [service_label]'s title to '[title]'."))

		if ("Set Message")
			var/old_message = replacetext(message, "<br />", "\n")
			var/new_message = sanitizeSafe(input(user, "What would you like the message to be?", "Fake Command Report", old_message) as message|null, extra = FALSE)
			if (!new_message || new_message == message)
				return
			message = replacetext(new_message, "\n", "<br />")
			to_chat(user, SPAN_NOTICE("You set the [service_label]'s message to '[message]'."))

		if ("Set Publicity")
			var/new_public = alert(user, "Should the command report be public?", "Fake Command Report", "Yes", "No")
			if (new_public == "Yes") new_public = TRUE
			else if (new_public == "No") new_public = FALSE
			if (isnull(new_public) || new_public == public_announce)
				return
			public_announce = new_public
			to_chat(user, SPAN_NOTICE("You set the [service_label]'s publicitiy to '[public_announce ? "public" : "private"]'."))

		if ("Send Command Report")
			if (!message)
				to_chat(user, SPAN_WARNING("\The [src] has no message to send. Set a message first!"))
				return
			state = HAS_BEEN_ACTIVATED
			update_icon()
			user.visible_message(
				SPAN_NOTICE("\The [user] activates \the [src]."),
				SPAN_NOTICE("You activate the [service_label] device.")
			)
			log_and_message_admins("has activated the fake command report service: [title]", user)
			enable(user)


/obj/item/device/uplink_service/fake_command_report/enable(mob/user)
	var/z_levels = GetConnectedZlevels(get_z(user))
	post_comm_message(title, message)
	if (public_announce)
		command_announcement.Announce(message, title, GLOB.using_map.command_report_sound, msg_sanitized = TRUE, zlevels = z_levels)
	else
		minor_announcement.Announce("Новое объявление от [GLOB.using_map.company_name_ru] доступно на всех консолях связи.", zlevels = z_levels)
	. = ..()


/*****************
* Fake Ion storm *
*****************/
/obj/item/device/uplink_service/fake_ion_storm
	service_label = "Ion Storm Announcement"

/obj/item/device/uplink_service/fake_ion_storm/enable(var/mob/user = usr)
	ion_storm_announcement(GetConnectedZlevels(get_z(src)))
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
	command_announcement.Announce(message, title, msg_sanitized = 1, zlevels = GetConnectedZlevels(get_z(src)))
	return TRUE

/*********************************
* Fake Crew Records/Announcement *
*********************************/
/obj/item/device/uplink_service/fake_crew_announcement
	service_label = "Crew Arrival Announcement and Records"

#define COPY_VALUE(KEY) new_record.set_##KEY(random_record.get_##KEY())

/obj/item/device/uplink_service/fake_crew_announcement/enable(var/mob/user = usr)

	var/datum/computer_file/report/crew_record/random_record
	var/obj/item/card/id/I = user.GetIdCard()
	if(GLOB.all_crew_records.len)
		random_record = pick(GLOB.all_crew_records)
	var/datum/computer_file/report/crew_record/new_record = CreateModularRecord(user)
	if(I)
		new_record.set_name(I.registered_name)
		new_record.set_formal_name("[I.formal_name_prefix][I.registered_name][I.formal_name_suffix]")
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
				new_record.set_formal_name("[I.registered_name][I.formal_name_suffix]") // Rank replaces formal name prefix in real manifest entries
	if(random_record)
		COPY_VALUE(faction)
		COPY_VALUE(religion)
		COPY_VALUE(homeSystem)
		COPY_VALUE(fingerprint)
		COPY_VALUE(dna)
		COPY_VALUE(bloodtype)
	var/datum/job/job = SSjobs.get_by_title(new_record.get_job())
	if(job)
		var/skills = list()
		for(var/decl/hierarchy/skill/S in GLOB.skills)
			var/level = job.min_skill[S.type]
			if(prob(10))
				level = min(rand(1,3), job.max_skill[S.type])
			if(level > SKILL_NONE)
				skills += "[S.name], [S.levels[level]]"
		new_record.set_skillset(jointext(skills,"\n"))

	if(istype(job) && job.announced)
		AnnounceArrivalSimple(new_record.get_name(), new_record.get_job(), "has completed cryogenic revival", get_announcement_frequency(job))
	. = ..()

#undef COPY_VALUE
