/datum/event/distress/proc/generate_wishlist(var/type)
	var/number_of_items = 0
	var/list/tempwishlist = list()

	switch(severity) // Determines the number of items the crew have to get
		if(EVENT_LEVEL_MUNDANE)
			number_of_items = rand(3,5)
		if(EVENT_LEVEL_MODERATE)
			number_of_items = rand(7,12)
		if(EVENT_LEVEL_MAJOR)
			number_of_items = rand(9,15)

	switch(type)
		if("cargo")
			var/cargolist = generate_cargolist()
			var/i = 0
			for(i, i<number_of_items, i++) //runs "numebr_of_items" times and picks random stuff from the list in more or less random quantaties.
				var/A = pick(cargolist)

				if(prob(25))
					tempwishlist += "[A] x 10"
				else if(prob(10))
					tempwishlist += "[A] x 25"
				else if(prob(1))
					tempwishlist += "[A] x 120"
				else
					tempwishlist += "[A] x [rand(1,5)]"
	return(tempwishlist)

/datum/event/distress/proc/generate_cargolist()
	var/list/cargolist = list(
	"Meson Googles" = /obj/item/clothing/glasses/meson,
	"Insulated Gloves" = /obj/item/clothing/gloves/insulated,
	"Screwdriver" = /obj/item/weapon/screwdriver,
	"Crowbar" = /obj/item/weapon/crowbar,
	"Wirecutters" = /obj/item/weapon/wirecutters,
	"Multitool" = /obj/item/device/multitool,
	"Wrench" = /obj/item/weapon/wrench,
	"T-scanner" = /obj/item/device/t_scanner,
	"Energy Cell" = /obj/item/weapon/cell,
	"Welder" = /obj/item/weapon/weldingtool,
	"Welding mask" = /obj/item/clothing/head/welding,
	"Light tube" = /obj/item/weapon/light/tube,
	"Scanning module" = /obj/item/weapon/stock_parts/scanning_module,
	"Matter bin" = /obj/item/weapon/stock_parts/matter_bin,
	"Console screen" = /obj/item/weapon/stock_parts/console_screen,
	"Capacitor" = /obj/item/weapon/stock_parts/capacitor,
	"Cable coil" = /obj/item/stack/cable_coil,
	"Pack of 50 metal sheets" = /obj/item/stack/material/steel/fifty,
	"Pack of 50 glass sheets" = /obj/item/stack/material/glass/fifty,
	"SMES coil" = /obj/item/weapon/smes_coil,
	"Hardhat" = /obj/item/clothing/head/hardhat,
	"Solar cell" = /obj/item/weapon/paper/solar,
	"Singularity generator" = /obj/machinery/the_singularitygen,
	"Particle accelerator control box" = /obj/machinery/particle_accelerator/control_box,
	"Particle accelerator power box" = /obj/structure/particle_accelerator/power_box,
	"PACMAN generator" = /obj/item/weapon/circuitboard/pacman,
	"Fueltank" = /obj/structure/reagent_dispensers/fueltank)

	return(cargolist)