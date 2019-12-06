/obj/item/clothing/accessory/watch
	name           = "watch"
	desc           = "A watch."
	icon           = 'icons/obj/clothing/obj_watches.dmi'
	icon_state     = "watch"
	attack_verb    = list("clocked")
	var/face_state = "face"
	var/face_color = "#ffffff"
	var/digital    = FALSE
	var/hour24     = FALSE
	var/inaccuracy = 5 MINUTES

/obj/item/clothing/accessory/watch/Initialize()
	. = ..()
	set_extension(src, /datum/extension/clock, digital, hour24, inaccuracy)
	verbs += /atom/proc/check_watch
	verbs += /atom/proc/calibrate_watch
	update_icon()

// Layer the band and the watch together. color is band color, face_color is watch face color
/obj/item/clothing/accessory/watch/on_update_icon()
	overlays.Cut()
	var/image/face = image(icon, face_state)
	face.appearance_flags |= NO_CLIENT_COLOR | RESET_COLOR
	face.color = face_color
	overlays += face

// Examine the watch to tell time
/obj/item/clothing/accessory/watch/examine(mob/user)
	. = ..()
	var/datum/extension/clock/C = get_extension(src, /datum/extension/clock)
	C.do_check(user)

// Add clock extension's verbs when attached to a thing and remove them when removed from that thing
/obj/item/clothing/accessory/watch/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /atom/proc/check_watch
	has_suit.verbs += /atom/proc/calibrate_watch

/obj/item/clothing/accessory/watch/on_removed(mob/user as mob)
	if(has_suit)
		var/remove_verb = TRUE
		for(var/obj/accessory in has_suit.accessories)
			if(accessory == src)
				continue
			if(has_extension(accessory, /datum/extension/clock))
				remove_verb = FALSE
		if(remove_verb)
			has_suit.verbs -= /atom/proc/check_watch
			has_suit.verbs -= /atom/proc/calibrate_watch
	..()

// Toggle 24-hour mode by activating a digital watch in hand
/obj/item/clothing/accessory/watch/attack_self(mob/user)
	if (digital)
		var/datum/extension/clock/C = get_extension(src, /datum/extension/clock)
		C.toggle24()
		to_chat(user, "You change the display to [C.hour24 ? "24" : "12"]-hour mode.")

// Define some watches

/obj/item/clothing/accessory/watch/digital
	name       = "digital watch"
	desc       = "A digital watch."
	face_state = "face-digital"
	color      = "#303040"
	color      = "#303040"
	digital    = TRUE
	inaccuracy = 3 MINUTES

// basic is just used to add color-select ones for loadout without screwing all the other entries up
/obj/item/clothing/accessory/watch/basic
	name       = "analog watch"
	desc       = "The Mahimaku Journeyman, a universal wrist accessory."

/obj/item/clothing/accessory/watch/digital/basic
	desc       = "The Ward-Takahashi 2300, a universal wrist accessory for those who can't tell time."

/obj/item/clothing/accessory/watch/cheap
	name = "cheap watch"
	inaccuracy = 10 MINUTES

/obj/item/clothing/accessory/watch/digital/cheap
	desc = "A black plastic Walton Timekeeper digital wristwatch, as universal as it is cheap. \
		Briefly went out of style due to the supposed widespread use of its internal circuitry as \
		a bomb detonation circuit by terrorist groups."
	color = "#202028"
	inaccuracy = 8 MINUTES

/obj/item/clothing/accessory/watch/fancy
	// watch/fancy also has an item value set
	name = "fancy watch"
	inaccuracy = 1 MINUTES

/obj/item/clothing/accessory/watch/fancy/random/Initialize()
	. = ..()
	randomize_icon()
	update_icon()
	randomize_name()
	var/watch_noun = pick("watch", "wristwatch", "timepiece")
	desc = pick("A genuine [name] [watch_noun]! Wow!", \
		"Holy shit! It's a real [name] [watch_noun]!", \
		"A [name] [watch_noun] - they don't make 'em like that anymore, no sir.")

/obj/item/clothing/accessory/watch/fancy/random/proc/randomize_icon()
	face_state = pick("face", "face-spaceman")
	color = pick(ACCESSORY_COLOR_GOLD, ACCESSORY_COLOR_IVORY, ACCESSORY_COLOR_PEACHPUFF, \
		ACCESSORY_COLOR_CUSTOM_ROSEGOLD, ACCESSORY_COLOR_MIDNIGHTBLUE, ACCESSORY_COLOR_SILVER, \
		ACCESSORY_COLOR_LIGHTSLATEGRAY, ACCESSORY_COLOR_LIGHTSTEELBLUE)
	face_color = pick(ACCESSORY_COLOR_WHITE, ACCESSORY_COLOR_LIGHTYELLOW, ACCESSORY_COLOR_AZURE, \
		ACCESSORY_COLOR_GHOSTWHITE, ACCESSORY_COLOR_OLDLACE, ACCESSORY_COLOR_MIDNIGHTBLUE)
	update_icon()

/obj/item/clothing/accessory/watch/fancy/random/proc/randomize_name()
	name = pick(pick(GLOB.greek_letters), "Mahimaku Instruments", "Chevron", "Sterling")
	if (prob(70))
		name += " [pick(pick(GLOB.phonetic_alphabet), "Classic", "Spacefarer", "Voidmaster", \
			"Titanium", "Raytona", "Patrician")]"
	if (prob(60))
		name += " [pick("[pick("Limited","Special","[rand(2,20)*10]th Anniversary","Platinum")] Edition", rand(1,999)*10, pick("III","IV","V","VI","VII","IX","X","XX","XXX","MMCCCIV"), pick("SX","XS","QQ"))]"

/obj/item/clothing/accessory/watch/fancy/random/digital
	name = "fancy digital watch"
	digital = TRUE 

/obj/item/clothing/accessory/watch/fancy/random/digital/randomize_icon()
	color = pick(ACCESSORY_COLOR_LIGHTSLATEGRAY, ACCESSORY_COLOR_SLATEGRAY, \
		ACCESSORY_COLOR_SLATEGRAY_25, ACCESSORY_COLOR_DARKGRAY, ACCESSORY_COLOR_DIMGRAY, \
		ACCESSORY_COLOR_GAINSBORO, ACCESSORY_COLOR_LAWNGREEN, ACCESSORY_COLOR_FIREBRICK, \
		ACCESSORY_COLOR_STEELBLUE, ACCESSORY_COLOR_DARKMAGENTA)

/obj/item/clothing/accessory/watch/fancy/random/digital/randomize_name()
	name = pick("Eclipse", "Takahashi", "Ward-Takahashi", "Mahimaku Instruments")
	if (prob(70))
		name += " [pick(pick(GLOB.phonetic_alphabet), "Classic", "Spacemaster", "Titanium", \
		"Raytona", "Patrician")]"
	if (prob(60))
		name += " [pick("\
			[pick("Limited","Special","[rand(2,20)*10]th Anniversary","Platinum")] Edition", \
			rand(1,999)*10, \
			pick("III","IV","V","VI","VII","IX","X","XX","XXX","MMCCCIV"), \
			pick("SX","XS","QQ")\
		)]"

/obj/item/clothing/accessory/watch/fancy/random/artifact
	inaccuracy = 12 HOURS

/obj/item/clothing/accessory/watch/fancy/random/artifact/Initialize()
	. = ..()
	desc += " [pick("It's a bit scuffed up.", "It's a miracle that it still works!")]"

/obj/item/clothing/accessory/watch/spaceman
	name = "Spaceman watch"
	desc = "A 24-hour automatic watch with an alloy case and a rugged webbing strap. The \
	phosphorescent dial and hands keep time even when pulling G's. Preferred by many infantry and \
	many more posers."
	face_state = "face-spaceman"
	color = ACCESSORY_COLOR_OLIVEDRAB
	hour24 = TRUE
	inaccuracy = 2 MINUTES

/obj/item/clothing/accessory/watch/spaceman/random/Initialize()
	. = ..()
	color = pick(ACCESSORY_COLOR_DARKKHAKI, ACCESSORY_COLOR_KHAKI, ACCESSORY_COLOR_OLIVEDRAB, \
		ACCESSORY_COLOR_OLIVE, ACCESSORY_COLOR_TAN)
	update_icon()