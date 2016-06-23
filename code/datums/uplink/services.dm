/***********
* Services *
************/
/datum/uplink_item/item/services
	category = /datum/uplink_category/services

/***************
* Service Item *
***************/

#define AWAITING_ACTIVATION 0
#define CURRENTLY_ACTIVE 1
#define HAS_BEEN_ACTIVATED 2

/obj/item/device/uplink_service
	name = "tiny device"
	desc = "Has a button that can be pressed. Once."
	w_class = 1
	icon_state = "sflash"
	var/state = AWAITING_ACTIVATION
	var/service_label = "Unnamed Service"
	var/service_duration = 0 SECONDS

/obj/item/device/uplink_service/Destroy()
	if(state == CURRENTLY_ACTIVE)
		deactivate()
	. = ..()

/obj/item/device/uplink_service/examine(var/user)
	. = ..(user, 3)
	if(.)
		switch(state)
			if(AWAITING_ACTIVATION)
				user << "It is labeled '[service_label]' and appears to be awaiting activation."
			if(CURRENTLY_ACTIVE)
				user << "It is labeled '[service_label]' and appears to be active."
			if(HAS_BEEN_ACTIVATED)
				user << "It is labeled '[service_label]' and appears to be permanently disabled."

/obj/item/device/uplink_service/attack_self(var/mob/user)
	if(state != AWAITING_ACTIVATION)
		user << "<span class='warning'>\The [src] won't activate again.</span>"
	state = CURRENTLY_ACTIVE
	update_icon()
	user.visible_message("<span class='notice'>\The [user] activates \the [src].</span>", "<span class='notice'>You activate \the [src].</span>")
	log_and_message_admins("has activated the service '[service_label]'", user)
	enable()

	if(service_duration)
		schedule_task_with_source_in(service_duration, src, /obj/item/device/uplink_service/proc/deactivate)
	else
		deactivate()

/obj/item/device/uplink_service/proc/deactivate()
	if(state != CURRENTLY_ACTIVE)
		return
	state = HAS_BEEN_ACTIVATED
	update_icon()
	playsound(loc, "sparks", 50, 1)
	visible_message("\The [src] shuts down with a spark.")
	disable()

/obj/item/device/uplink_service/update_icon()
	switch(state)
		if(AWAITING_ACTIVATION)
			icon_state = initial(icon_state)
		if(CURRENTLY_ACTIVE)
			icon_state = "sflash2"
		if(HAS_BEEN_ACTIVATED)
			icon_state = "flashburnt"

/obj/item/device/uplink_service/proc/enable(var/mob/user = usr)
	return

/obj/item/device/uplink_service/proc/disable(var/mob/user = usr)
	return

/***************
* Jammer Items *
***************/
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

/obj/item/device/uplink_service/jamming/disable(var/mob/user = usr)
	ssjm.disable()

/obj/item/device/uplink_service/jamming/garble
	service_label = "Suit Sensor Garble"
	ssjm = /suit_sensor_jammer_method/random/moderate
