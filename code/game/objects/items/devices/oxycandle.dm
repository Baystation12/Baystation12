/obj/item/device/oxycandle
	name = "oxygen candle"
	desc = "A steel tube with the words 'OXYGEN - PULL CORD TO IGNITE' stamped on the side.\nA small label reads <span class='warning'>'WARNING: NOT FOR LIGHTING USE. WILL IGNITE FLAMMABLE GASSES'</span>"
	icon = 'icons/obj/oxygen_candle.dmi'
	icon_state = "oxycandle"
	item_state = "oxycandle"
	w_class = ITEM_SIZE_SMALL // Should fit into internal's box or maybe pocket
	var/target_pressure = ONE_ATMOSPHERE
	var/datum/gas_mixture/air_contents = null
	var/volume = 4600
	var/on = 0
	var/activation_sound = 'sound/effects/flare.ogg'
	light_color = "#e58775"
	light_outer_range = 2
	light_max_bright = 1
	var/brightness_on = 1 // Moderate-low bright.
	action_button_name = null

/obj/item/device/oxycandle/New()
	..()
	update_icon()

/obj/item/device/oxycandle/afterattack(var/obj/O, var/mob/user, var/proximity)
	if(proximity && istype(O) && on)
		O.HandleObjectHeating(src, user, 500)
	..()

/obj/item/device/oxycandle/attack_self(mob/user)
	if(!on)
		to_chat(user, "<span class='notice'>You pull the cord and [src] ignites.</span>")
		on = 1
		update_icon()
		playsound(src.loc, activation_sound, 75, 1)
		air_contents = new /datum/gas_mixture()
		air_contents.volume = 200 //liters
		air_contents.temperature = T20C
		var/list/air_mix = list(GAS_OXYGEN = 1 * (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
		air_contents.adjust_multi(GAS_OXYGEN, air_mix[GAS_OXYGEN])
		START_PROCESSING(SSprocessing, src)

// Process of Oxygen candles releasing air. Makes 200 volume of oxygen
/obj/item/device/oxycandle/Process()
	if(!loc)
		return
	var/turf/pos = get_turf(src)
	if(volume <= 0 || !pos || (pos.turf_flags & TURF_IS_WET)) //Now uses turf flags instead of whatever aurora did
		STOP_PROCESSING(SSprocessing, src)
		on = 2
		update_icon()
		update_held_icon()
		SetName("burnt oxygen candle")
		desc += "This tube has exhausted its chemicals."
		return
	if(pos)
		pos.hotspot_expose(1500, 5)
	var/datum/gas_mixture/environment = loc.return_air()
	var/pressure_delta = target_pressure - environment.return_pressure()
	var/output_volume = environment.volume * environment.group_multiplier
	var/air_temperature = air_contents.temperature? air_contents.temperature : environment.temperature
	var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)
	var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
	if (!removed) //Just in case
		return
	environment.merge(removed)
	volume -= 200
	var/list/air_mix = list(GAS_OXYGEN = 1 * (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	air_contents.adjust_multi(GAS_OXYGEN, air_mix[GAS_OXYGEN])

/obj/item/device/oxycandle/on_update_icon()
	if(on == 1)
		icon_state = "oxycandle_on"
		item_state = icon_state
		set_light(brightness_on)
	else if(on == 2)
		icon_state = "oxycandle_burnt"
		item_state = icon_state
		set_light(0)
	else
		icon_state = "oxycandle"
		item_state = icon_state
		set_light(0)
	update_held_icon()

/obj/item/device/oxycandle/Destroy()
	QDEL_NULL(air_contents)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()
