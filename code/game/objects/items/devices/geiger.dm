#define RAD_LEVEL_LOW 1 // Around the level at which radiation starts to become harmful
#define RAD_LEVEL_MODERATE 5
#define RAD_LEVEL_HIGH 25
#define RAD_LEVEL_VERY_HIGH 75

//Geiger counter
//Rewritten version of TG's geiger counter
//I opted to show exact radiation levels

/obj/item/device/geiger
	name = "geiger counter"
	desc = "A handheld device used for detecting and measuring radiation in an area."
	icon_state = "geiger_off"
	item_state = "multitool"
	w_class = ITEM_SIZE_SMALL
	var/scanning = 0
	var/radiation_count = 0

/obj/item/device/geiger/New()
	processing_objects |= src

/obj/item/device/geiger/process()
	if(!scanning)
		return
	radiation_count = radiation_repository.report_rads(get_turf(src))
	update_icon()

/obj/item/device/geiger/examine(mob/user)
	. = ..(user)
	to_chat(user, "<span class='warning'>[scanning ? "ambient" : "stored"] radiation level: [radiation_count ? radiation_count : "0"]Bq.</span>")

/obj/item/device/geiger/attack_self(var/mob/user)
	scanning = !scanning
	update_icon()
	to_chat(user, "<span class='notice'>\icon[src] You switch [scanning ? "on" : "off"] [src].</span>")

/obj/item/device/geiger/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
		return 1

	switch(radiation_count)
		if(null) icon_state = "geiger_on_1"
		if(-INFINITY to RAD_LEVEL_LOW) icon_state = "geiger_on_1"
		if(RAD_LEVEL_LOW + 1 to RAD_LEVEL_MODERATE) icon_state = "geiger_on_2"
		if(RAD_LEVEL_MODERATE + 1 to RAD_LEVEL_HIGH) icon_state = "geiger_on_3"
		if(RAD_LEVEL_HIGH + 1 to RAD_LEVEL_VERY_HIGH) icon_state = "geiger_on_4"
		if(RAD_LEVEL_VERY_HIGH + 1 to INFINITY) icon_state = "geiger_on_5"

#undef RAD_LEVEL_LOW
#undef RAD_LEVEL_MODERATE
#undef RAD_LEVEL_HIGH
#undef RAD_LEVEL_VERY_HIGH
