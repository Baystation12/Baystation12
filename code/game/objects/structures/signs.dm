/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = 3.5
	w_class = 3

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
		user << "[translation(src,"unfasten",tool)]"
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		//var/icon/I = icon('icons/obj/decals.dmi', icon_state)
		//S.icon = I.Scale(24, 24)
		S.sign_state = icon_state
		qdel(src)
	else ..()

/obj/item/sign
	name = "sign"
	desc = ""
	icon = 'icons/obj/decals.dmi'
	w_class = 3		//big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(istype(tool, /obj/item/weapon/screwdriver) && isturf(user.loc))
		var/list/direction = input("[translation(src,"which_direction")]", "[translation(src,"select_direction")]") in translation(src,"directions")
		direction = translation(src,"directions_return",direction)
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
		user << "[translation(src,"fasten",list("sign"=S,"tool"=tool))]"
		qdel(src)
	else ..()

/obj/structure/sign/double/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/double/map/efficiency
	icon_state = "map_efficiency"

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/left/meta
	icon_state = "map-left-MS"

/obj/structure/sign/double/map/left/taxi
	icon_state = "map-left-taxi"

/obj/structure/sign/double/map/right
	icon_state = "map-right"

/obj/structure/sign/double/map/right/meta
	icon_state = "map-right-MS"

/obj/structure/sign/double/map/right/taxi
	icon_state = "map-right-taxi"

/obj/structure/sign/double/maltesefalcon
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio"

/obj/structure/sign/biohazard2
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio-danger"

/obj/structure/sign/biohazard3
	name = "BIOLOGICAL HAZARD"
	desc = "Warning: Biological and-or toxic hazards present in this area!"
	icon_state = "biohazard"

/obj/structure/sign/canisters
	name = "PRESSURIZED CANISTERS"
	desc = "Warning: Highly pressurized canister storage."
	icon_state = "canisters"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'."
	icon_state = "chemistry1"

/obj/structure/sign/chemistry2
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'."
	icon_state = "chemistry2"

/obj/structure/sign/corrosives
	name = "CORROSIVE SUBSTANCES"
	desc = "Warning: Corrosive substances prezent in this area!"
	icon_state = "corrosives"

/obj/structure/sign/cryogenics
	name = "CRYOGENIC TEMPERATURES"
	desc = "Warning: Extremely low temperatures in this area."
	icon_state = "cryogenics"

/obj/structure/sign/danger
	name = "DANGEROUS AREA"
	desc = "Warning: Generally hazardous area! Exercise caution."
	icon_state = "danger"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'."
	icon_state = "deathsposal"

/obj/structure/sign/directions
	name = "direction sign"
	desc = "A direction sign, claiming to know the way."
	icon_state = "direction"

/obj/structure/sign/directions/engineering
	name = "\improper Engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/evac
	name = "\improper Escape Arm"
	desc = "A direction sign, pointing out which way the escape shuttle dock is."
	icon_state = "direction_evac"

/obj/structure/sign/directions/medical
	name = "\improper Medical Bay"
	desc = "A direction sign, pointing out which way the Medical Bay is."
	icon_state = "direction_med"

/obj/structure/sign/directions/science
	name = "\improper Science department"
	desc = "A direction sign, pointing out which way the Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/security
	name = "\improper Security department"
	desc = "A direction sign, pointing out which way the Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/supply
	name = "\improper Supply department"
	desc = "A direction sign, pointing out which way the Supply department is."
	icon_state = "direction_supply"

/obj/structure/sign/electrical
	name = "ELECTRICAL HAZARD"
	desc = "Warning: Electrical hazards! Wear protective equipment."
	icon_state = "electrical"

/obj/structure/sign/examroom
	name = "\improper EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'."
	icon_state = "examroom"

/obj/structure/sign/explosives
	name = "EXPLOSIVE SUBSTANCES"
	desc = "Warning: Explosive substances present in this area!"
	icon_state = "explosives"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'."
	icon_state = "fire"

/obj/structure/sign/flammables
	name = "FLAMMABLE SUBSTANCES"
	desc = "Warning: Flammable substances present in this area!"
	icon_state = "flammable"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'."
	icon_state = "hydro1"

/obj/structure/sign/botany2
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'."
	icon_state = "hydro2"

/obj/structure/sign/botany3
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'."
	icon_state = "hydro3"

/obj/structure/sign/laserhazard
	name = "LASER HAZARD"
	desc = "Warning: High powered laser emitters operating in this area!"
	icon_state = "laser"

/obj/structure/sign/lifestar
	name = "Medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "lifestar"

/obj/structure/sign/magnetics
	name = "MAGNETIC FIELD HAZARD"
	desc = "Warning: Extremely powerful magnetic fields present in this area!"
	icon_state = "magnetics"

/obj/structure/sign/memetic
	name = "MEMETIC HAZARD"
	desc = "Warning: Memetic hazard, wear meson goggles!"
	icon_state = "memetic"

/obj/structure/sign/monkey
	name = "Mr. Deempisi portrait"
	desc = "Under the painting a plaque reads: 'While the meat grinder may not have spared you, fear not. Not one part of you has gone to waste... You were delicious."
	icon_state = "monkey_painting"

/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking2"

/obj/structure/sign/nanotrasen
	name = "\improper NanoTrasen"
	desc = "An old metal sign which reads 'NanoTrasen'."
	icon_state = "NT"

/obj/structure/sign/opticals
	name = "OPTICAL HAZARD"
	desc = "Warning: Optical hazards present in this area!"
	icon_state = "optical"

/obj/structure/sign/oxidants
	name = "OXIDIZING AGENTS"
	desc = "Warning: Oxidizing agents in this area, do not start fires!"
	icon_state = "oxidants"

/obj/structure/sign/atmosplaque
	name = "\improper FEA atmospherics division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "plaque_atmos"

/obj/structure/sign/goldenplaque
	name = "\improper The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "plaque_golden"

/obj/structure/sign/kiddieplaque
	name = "\improper AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "plaque_kiddie"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'."
	icon_state = "pods"

/obj/structure/sign/radiation
	name = "\improper RADIOACTIVE AREA"
	desc = "A warning sign which reads 'RADIOACTIVE AREA'."
	icon_state = "radiation1"

/obj/structure/sign/radiation2
	name = "RADIATION HAZARD"
	desc = "Warning: Significant levels of radiation present in this area!"
	icon_state = "radiation2"

/obj/structure/sign/science
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'."
	icon_state = "science1"

/obj/structure/sign/science2
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'."
	icon_state = "science2"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea1"

/obj/structure/sign/securearea2
	name = "SECURE AREA"
	desc = "Warning: Secure Area! Do not enter without authorization!"
	icon_state = "securearea2"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'."
	icon_state = "shock"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'."
	icon_state = "space"

/obj/structure/sign/xenobio
	name = "\improper XENOBIOLOGY"
	desc = "A warning sign which reads 'XENOBIOLOGY'."
	icon_state = "xenobio1"

/obj/structure/sign/xenobio2
	name = "\improper XENOBIOLOGY"
	desc = "A warning sign which reads 'XENOBIOLOGY'."
	icon_state = "xenobio2"

/obj/structure/sign/xenobio3
	name = "\improper XENOBIOLOGY"
	desc = "A warning sign which reads 'XENOBIOLOGY'."
	icon_state = "xenobio3"

/obj/structure/sign/xenobio4
	name = "\improper XENOBIOLOGY"
	desc = "A warning sign which reads 'XENOBIOLOGY'."
	icon_state = "xenobio4"

/obj/structure/sign/redcross
	name = "Medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "redcross"

/obj/structure/sign/greencross
	name = "Medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "greencross"

/obj/structure/sign/bluecross
	name = "Medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross"

/obj/structure/sign/bluecross2
	name = "Medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "bluecross2"