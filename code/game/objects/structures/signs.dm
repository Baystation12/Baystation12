/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = ABOVE_WINDOW_LAYER
	w_class = ITEM_SIZE_NORMAL

/obj/structure/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

/obj/structure/sign/attackby(obj/item/tool as obj, mob/user as mob)	//deconstruction
	if(istype(tool, /obj/item/weapon/screwdriver) && !istype(src, /obj/structure/sign/double))
		to_chat(user, "You unfasten the sign with your [tool.name].")
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		S.sign_state = icon_state
		qdel(src)
	else ..()

/obj/item/sign
	name = "sign"
	desc = ""
	icon = 'icons/obj/decals.dmi'
	w_class = ITEM_SIZE_NORMAL		//big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(istype(tool, /obj/item/weapon/screwdriver) && isturf(user.loc))
		var/direction = input("In which direction?", "Select direction.") in list("North", "East", "South", "West", "Cancel")
		if(direction == "Cancel") return
		var/obj/structure/sign/S = new(user.loc)
		switch(direction)
			if("North")
				S.pixel_y = 32
			if("East")
				S.pixel_x = 32
			if("South")
				S.pixel_y = -32
			if("West")
				S.pixel_x = -32
			else return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		to_chat(user, "You fasten \the [S] with your [tool].")
		qdel(src)
	else ..()

/obj/structure/sign/double/map
	name = "map"
	desc = "A framed map."

/obj/structure/sign/double/map/Initialize()
	. = ..()
	desc = "A framed map of the [station_name()]."

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/right
	icon_state = "map-right"

/obj/structure/sign/monkey_painting
	name = "\improper Mr. Deempisi portrait"
	desc = "Under the painting a plaque reads: 'While the meat grinder may not have spared you, fear not. Not one part of you has gone to waste... You were delicious.'"
	icon_state = "monkey_painting"

/obj/structure/sign/warning
	name = "\improper WARNING"
	icon_state = "securearea"

/obj/structure/sign/warning/detailed
	name = "\improper WARNING 2"
	icon_state = "securearea2"

/obj/structure/sign/warning/Initialize()
	. = ..()
	desc = "A warning sign which reads '[sanitize(name)]'."

/obj/structure/sign/warning/airlock
	name = "\improper EXTERNAL AIRLOCK"
	icon_state = "doors"

/obj/structure/sign/warning/biohazard
	name = "\improper BIOHAZARD"
	icon_state = "bio"

/obj/structure/sign/warning/bomb_range
	name = "\improper BOMB RANGE"
	icon_state = "blast"

/obj/structure/sign/warning/caution
	name = "\improper CAUTION"

/obj/structure/sign/warning/compressed_gas
	name = "\improper COMPRESSED GAS"
	icon_state = "hikpa"

/obj/structure/sign/warning/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	icon_state = "deathsposal"

/obj/structure/sign/warning/docking_area
	name = "\improper KEEP CLEAR: DOCKING AREA"

/obj/structure/sign/warning/engineering_access
	name = "\improper ENGINEERING ACCESS"

/obj/structure/sign/warning/fall
	name = "\improper FALL HAZARD"
	icon_state = "falling"

/obj/structure/sign/warning/fire
	name = "\improper DANGER: FIRE"
	icon_state = "fire"

/obj/structure/sign/warning/high_voltage
	name = "\improper HIGH VOLTAGE"
	icon_state = "shock"

/obj/structure/sign/warning/hot_exhaust
	name = "\improper HOT EXHAUST"
	icon_state = "fire"

/obj/structure/sign/warning/internals_required
	name = "\improper INTERNALS REQUIRED"

/obj/structure/sign/warning/lethal_turrets
	name = "\improper LETHAL TURRETS"
	icon_state = "turrets"

/obj/structure/sign/warning/lethal_turrets/Initialize()
	. = ..()
	desc += " Enter at own risk!."

/obj/structure/sign/warning/mail_delivery
	name = "\improper MAIL DELIVERY"
	icon_state = "mail"

/obj/structure/sign/warning/moving_parts
	name = "\improper MOVING PARTS"
	icon_state = "movingparts"

/obj/structure/sign/warning/nosmoking_1
	name = "\improper NO SMOKING"
	icon_state = "nosmoking"

/obj/structure/sign/warning/nosmoking_2
	name = "\improper NO SMOKING"
	icon_state = "nosmoking2"

/obj/structure/sign/warning/pods
	name = "\improper ESCAPE PODS"
	icon_state = "pods"

/obj/structure/sign/warning/radioactive
	name = "\improper RADIOACTIVE AREA"
	icon_state = "radiation"

/obj/structure/sign/warning/secure_area
	name = "\improper SECURE AREA"

/obj/structure/sign/warning/secure_area/armory
	name = "\improper ARMORY"
	icon_state = "armory"

/obj/structure/sign/warning/server_room
	name = "\improper SERVER ROOM"
	icon_state = "server"

/obj/structure/sign/warning/siphon_valve
	name = "\improper SIPHON VALVE"

/obj/structure/sign/warning/vacuum
	name = "\improper HARD VACUUM AHEAD"
	icon_state = "space"

/obj/structure/sign/warning/vent_port
	name = "\improper EJECTION/VENTING PORT"

/obj/structure/sign/redcross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "redcross"

/obj/structure/sign/greencross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "greencross"

/obj/structure/sign/bluecross_1
	name = "infirmary"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross"

/obj/structure/sign/bluecross_2
	name = "infirmary"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross2"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/goldenplaque/security
	name = "motivational plaque"
	desc = "A plaque engraved with a generic motivational quote and picture. ' Greater love hath no man than this, that a man lay down his life for his friends. John 15:13 "

/obj/structure/sign/goldenplaque/medical
	name = "medical certificate"
	desc = "A picture next to a long winded description of medical certifications and degrees."

/obj/structure/sign/kiddieplaque
	name = "\improper AI developers plaque"
	desc = "An extremely long list of names and job titles and a picture of the design team responsible for building this AI Core."
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper engineering memorial plaque"
	desc = "This plaque memorializes those engineers and technicians who made the ultimate sacrifice to save their vessel and its crew."
	icon_state = "atmosplaque"

/obj/structure/sign/floorplaque
	name = "\improper commemorative plaque"
	desc = "A list of dead explorers who gave their lives in search of the next great discovery. Hope you don't join them."
	icon_state = "floorplaque"

/obj/structure/sign/double/solgovflag
	name = "Sol Central Government Flag"
	desc = "The flag of the Sol Central Government, a symbol of many things to many people."

/obj/structure/sign/double/solgovflag/left
	icon_state = "solgovflag-left"

/obj/structure/sign/double/solgovflag/right
	icon_state = "solgovflag-right"

/obj/structure/sign/double/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/warning/science
	name = "\improper SCIENCE!"
	icon_state = "science1"

/obj/structure/sign/warning/science/anomalous_materials
	name = "\improper ANOMALOUS MATERIALS"

/obj/structure/sign/warning/science/mass_spectrometry
	name = "\improper MASS SPECTROMETRY"

/obj/structure/sign/science_1
	name = "\improper RESEARCH WING"
	desc = "A sign labelling the research wing."
	icon_state = "science1"

/obj/structure/sign/science_2
	name = "\improper RESEARCH"
	desc = "A sign labelling an area where research is performed."
	icon_state = "science2"

/obj/structure/sign/xenobio_1
	name = "\improper XENOBIOLOGY"
	desc = "A sign labelling an area as a place where xenobiological entites are researched."
	icon_state = "xenobio"

/obj/structure/sign/xenobio_2
	name = "\improper XENOBIOLOGY"
	desc = "A sign labelling an area as a place where xenobiological entites are researched."
	icon_state = "xenobio2"

/obj/structure/sign/xenobio_3
	name = "\improper XENOBIOLOGY"
	desc = "A sign labelling an area as a place where xenobiological entites are researched."
	icon_state = "xenobio3"

/obj/structure/sign/xenobio_4
	name = "\improper XENOBIOLOGY"
	desc = "A sign labelling an area as a place where xenobiological entites are researched."
	icon_state = "xenobio4"

/obj/structure/sign/xenoarch
	name = "\improper XENOARCHAEOLOGY"
	desc = "A sign labelling an area as a place where xenoarchaeological finds are researched."
	icon_state = "xenobio4"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A sign labelling an area containing chemical equipment."
	icon_state = "chemistry1"

/obj/structure/sign/xenoflora
	name = "\improper XENOFLORA"
	desc = "A sign labelling an area as a place where xenobiological plants are researched."
	icon_state = "hydro4"

/obj/structure/sign/botany
	name = "\improper BOTANY"
	desc = "A warning sign which reads 'BOTANY!'."
	icon_state = "hydro3"

/obj/structure/sign/hydro
	name = "\improper HYDROPONICS"
	desc = "A sign labelling an area as a place where plants are grown."
	icon_state = "hydro1"

/obj/structure/sign/hydrostorage
	name = "\improper HYDROPONICS STORAGE"
	desc = "A sign labelling an area as a place where plant growing supplies are kept."
	icon_state = "hydro3"

/obj/structure/sign/solgov
	name = "\improper SolGov Seal"
	desc = "A sign which signifies who this vessel belongs to."
	icon_state = "solgovseal"

/obj/structure/sign/directions
	name = "direction sign"
	desc = "A direction sign, claiming to know the way."
	icon_state = "direction"

/obj/structure/sign/directions/Initialize()
	. = ..()
	desc = "A direction sign, pointing out which way \the [src] is."

/obj/structure/sign/directions/science
	name = "\improper Research Division"
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "\improper Engineering Bay"
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "\improper Security Wing"
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "\improper Medical Bay"
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name = "\improper Evacuation Wing"
	icon_state = "direction_evac"

/obj/structure/sign/directions/bridge
	name = "\improper Bridge"
	icon_state = "direction_bridge"

/obj/structure/sign/directions/supply
	name = "\improper Supply Office"
	icon_state = "direction_supply"

/obj/structure/sign/directions/infirmary
	name = "\improper Infirmary"
	icon_state = "direction_infirm"

/obj/structure/sign/directions/examroom
	name = "\improper Exam Room"
	icon_state = "examroom"

/obj/structure/sign/deck/bridge
	name = "\improper Bridge Deck"
	icon_state = "deck-b"

/obj/structure/sign/deck/first
	name = "\improper First Deck"
	icon_state = "deck-1"

/obj/structure/sign/deck/second
	name = "\improper Second Deck"
	icon_state = "deck-2"

/obj/structure/sign/deck/third
	name = "\improper Third Deck"
	icon_state = "deck-3"

/obj/structure/sign/deck/fourth
	name = "\improper Fourth Deck"
	icon_state = "deck-4"

