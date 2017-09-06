//Geiger counter
//Rewritten version of TG's geiger counter
//I opted to show exact radiation levels

/obj/item/device/geiger
	name = "geiger counter"
	desc = "A handheld device used for detecting and measuring radiation in an area."
	description_info = "By using this item, you may toggle its scanning mode on and off. Examine it while it's on to check for ambient radiation."
	description_fluff = "For centuries geiger counters have been saving the lives of unsuspecting laborers and technicians. You can never be too careful around radiation."
	icon_state = "geiger_off"
	item_state = "multitool"
	w_class = ITEM_SIZE_SMALL
	var/scanning = 0
	var/radiation_count = 0

/obj/item/device/geiger/New()
	GLOB.processing_objects |= src

/obj/item/device/geiger/process()
	if(!scanning)
		return
	radiation_count = radiation_repository.get_rads_at_turf(get_turf(src))
	update_icon()

/obj/item/device/geiger/examine(mob/user)
	. = ..(user)
	var/msg = "[scanning ? "ambient" : "stored"] Radiation level: [radiation_count ? radiation_count : "0"] Bq."
	if(radiation_count > RAD_LEVEL_LOW)
		to_chat(user, "<span class='warning'>[msg]</span>")
	else
		to_chat(user, "<span class='notice'>[msg]</span>")

/obj/item/device/geiger/attack_self(var/mob/user)
	scanning = !scanning
	update_icon()
	to_chat(user, "<span class='notice'>[icon2html(src, user)] You switch [scanning ? "on" : "off"] [src].</span>")

/obj/item/device/geiger/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
		return 1

	switch(radiation_count)
		if(null) icon_state = "geiger_on_1"
		if(-INFINITY to RAD_LEVEL_LOW) icon_state = "geiger_on_1"
		if(RAD_LEVEL_LOW + 0.01 to RAD_LEVEL_MODERATE) icon_state = "geiger_on_2"
		if(RAD_LEVEL_MODERATE + 0.1 to RAD_LEVEL_HIGH) icon_state = "geiger_on_3"
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH) icon_state = "geiger_on_4"
		if(RAD_LEVEL_VERY_HIGH + 1 to INFINITY) icon_state = "geiger_on_5"

