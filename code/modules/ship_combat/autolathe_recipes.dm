/var/global/list/autolathe_recipes
/var/global/list/autolathe_categories

/proc/populate_lathe_recipes()

	//Create global autolathe recipe list if it hasn't been made already.
	autolathe_recipes = list()
	autolathe_categories = list()
	for(var/R in typesof(/datum/autolathe/recipe)-/datum/autolathe/recipe)
		var/datum/autolathe/recipe/recipe = new R
		autolathe_recipes += recipe
		autolathe_categories |= recipe.category

		var/obj/item/I = new recipe.path
		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = I.matter[material]*1.25 // More expensive to produce than they are to recycle.
		qdel(I)

/datum/autolathe/recipe
	var/name = "object"
	var/path
	var/list/resources
	var/hidden
	var/category
	var/power_use = 0
	var/is_stack

/datum/autolathe/recipe/bucket
	name = "bucket"
	path = /obj/item/weapon/reagent_containers/glass/bucket
	category = "General"

/datum/autolathe/recipe/drinkingglass
	name = "drinking glass"
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/square
	category = "General"
	New()
		..()
		var/obj/O = path
		name = initial(O.name) // generic recipes yay

/datum/autolathe/recipe/drinkingglass/rocks
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/rocks

/datum/autolathe/recipe/drinkingglass/shake
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shake

/datum/autolathe/recipe/drinkingglass/cocktail
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail

/datum/autolathe/recipe/drinkingglass/shot
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shot

/datum/autolathe/recipe/drinkingglass/pint
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/pint

/datum/autolathe/recipe/drinkingglass/mug
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/mug

/datum/autolathe/recipe/drinkingglass/wine
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/wine

/datum/autolathe/recipe/flashlight
	name = "flashlight"
	path = /obj/item/device/flashlight
	category = "General"

/datum/autolathe/recipe/floor_light
	name = "floor light"
	path = /obj/machinery/floor_light
	category = "General"

/datum/autolathe/recipe/extinguisher
	name = "extinguisher"
	path = /obj/item/weapon/extinguisher
	category = "General"

/datum/autolathe/recipe/jar
	name = "jar"
	path = /obj/item/glass_jar
	category = "General"

/datum/autolathe/recipe/crowbar
	name = "crowbar"
	path = /obj/item/weapon/crowbar
	category = "Tools"

/datum/autolathe/recipe/multitool
	name = "multitool"
	path = /obj/item/device/multitool
	category = "Tools"

/datum/autolathe/recipe/t_scanner
	name = "T-ray scanner"
	path = /obj/item/device/t_scanner
	category = "Tools"

/datum/autolathe/recipe/weldertool
	name = "welding tool"
	path = /obj/item/weapon/weldingtool
	category = "Tools"

/datum/autolathe/recipe/screwdriver
	name = "screwdriver"
	path = /obj/item/weapon/screwdriver
	category = "Tools"

/datum/autolathe/recipe/wirecutters
	name = "wirecutters"
	path = /obj/item/weapon/wirecutters
	category = "Tools"

/datum/autolathe/recipe/wrench
	name = "wrench"
	path = /obj/item/weapon/wrench
	category = "Tools"

/datum/autolathe/recipe/hatchet
	name = "hatchet"
	path = /obj/item/weapon/material/hatchet
	category = "Tools"

/datum/autolathe/recipe/minihoe
	name = "mini hoe"
	path = /obj/item/weapon/material/minihoe
	category = "Tools"

/datum/autolathe/recipe/radio_bounced
	name = "station bounced radio"
	path = /obj/item/device/radio/off
	category = "General"

/datum/autolathe/recipe/suit_cooler
	name = "suit cooling unit"
	path = /obj/item/device/suit_cooling_unit
	category = "General"

/datum/autolathe/recipe/weldermask
	name = "welding mask"
	path = /obj/item/clothing/head/welding
	category = "General"

/datum/autolathe/recipe/metal
	name = "steel sheets"
	path = /obj/item/stack/material/steel
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/glass
	name = "glass sheets"
	path = /obj/item/stack/material/glass
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/rglass
	name = "reinforced glass sheets"
	path = /obj/item/stack/material/glass/reinforced
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/rods
	name = "metal rods"
	path = /obj/item/stack/rods
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/knife
	name = "kitchen knife"
	path = /obj/item/weapon/material/knife
	category = "General"

/datum/autolathe/recipe/taperecorder
	name = "tape recorder"
	path = /obj/item/device/taperecorder/empty
	category = "General"

/datum/autolathe/recipe/tape
	name = "tape"
	path = /obj/item/device/tape
	category = "General"

/datum/autolathe/recipe/airlockmodule
	name = "airlock electronics"
	path = /obj/item/weapon/airlock_electronics
	category = "Engineering"

/datum/autolathe/recipe/airalarm
	name = "air alarm electronics"
	path = /obj/item/weapon/airalarm_electronics
	category = "Engineering"

/datum/autolathe/recipe/firealarm
	name = "fire alarm electronics"
	path = /obj/item/weapon/firealarm_electronics
	category = "Engineering"

/datum/autolathe/recipe/powermodule
	name = "power control module"
	path = /obj/item/weapon/module/power_control
	category = "Engineering"

/datum/autolathe/recipe/rcd_ammo
	name = "matter cartridge"
	path = /obj/item/weapon/rcd_ammo
	category = "Engineering"

/datum/autolathe/recipe/scalpel
	name = "scalpel"
	path = /obj/item/weapon/scalpel
	category = "Medical"

/datum/autolathe/recipe/circularsaw
	name = "circular saw"
	path = /obj/item/weapon/circular_saw
	category = "Medical"

/datum/autolathe/recipe/surgicaldrill
	name = "surgical drill"
	path = /obj/item/weapon/surgicaldrill
	category = "Medical"

/datum/autolathe/recipe/retractor
	name = "retractor"
	path = /obj/item/weapon/retractor
	category = "Medical"

/datum/autolathe/recipe/cautery
	name = "cautery"
	path = /obj/item/weapon/cautery
	category = "Medical"

/datum/autolathe/recipe/hemostat
	name = "hemostat"
	path = /obj/item/weapon/hemostat
	category = "Medical"

/datum/autolathe/recipe/beaker
	name = "glass beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker
	category = "Medical"

/datum/autolathe/recipe/beaker_large
	name = "large glass beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker/large
	category = "Medical"

/datum/autolathe/recipe/vial
	name = "glass vial"
	path = /obj/item/weapon/reagent_containers/glass/beaker/vial
	category = "Medical"

/datum/autolathe/recipe/syringe
	name = "syringe"
	path = /obj/item/weapon/reagent_containers/syringe
	category = "Medical"

/datum/autolathe/recipe/syringegun_ammo
	name = "syringe gun cartridge"
	path = /obj/item/weapon/syringe_cartridge
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_blanks
	name = "ammunition (shotgun, blank)"
	path = /obj/item/ammo_casing/shotgun/blank
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_beanbag
	name = "ammunition (shotgun, beanbag)"
	path = /obj/item/ammo_casing/shotgun/beanbag
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_flash
	name = "ammunition (shotgun, flash)"
	path = /obj/item/ammo_casing/shotgun/flash
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_rubber
	name = "ammunition (.45, rubber)"
	path = /obj/item/ammo_magazine/c45m/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_flash
	name = "ammunition (.45, flash)"
	path = /obj/item/ammo_magazine/c45m/flash
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_smg_rubber
	name = "ammunition (9mm rubber top mounted)"
	path = /obj/item/ammo_magazine/mc9mmt/rubber
	category = "Arms and Ammunition"

/datum/autolathe/recipe/consolescreen
	name = "console screen"
	path = /obj/item/weapon/stock_parts/console_screen
	category = "Devices and Components"

/datum/autolathe/recipe/igniter
	name = "igniter"
	path = /obj/item/device/assembly/igniter
	category = "Devices and Components"

/datum/autolathe/recipe/signaler
	name = "signaler"
	path = /obj/item/device/assembly/signaler
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_infra
	name = "infrared sensor"
	path = /obj/item/device/assembly/infra
	category = "Devices and Components"

/datum/autolathe/recipe/timer
	name = "timer"
	path = /obj/item/device/assembly/timer
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_prox
	name = "proximity sensor"
	path = /obj/item/device/assembly/prox_sensor
	category = "Devices and Components"

/datum/autolathe/recipe/tube
	name = "light tube"
	path = /obj/item/weapon/light/tube
	category = "General"

/datum/autolathe/recipe/bulb
	name = "light bulb"
	path = /obj/item/weapon/light/bulb
	category = "General"

/datum/autolathe/recipe/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/weapon/material/ashtray/glass
	category = "General"

/datum/autolathe/recipe/camera_assembly
	name = "camera assembly"
	path = /obj/item/weapon/camera_assembly
	category = "Engineering"

/datum/autolathe/recipe/weldinggoggles
	name = "welding goggles"
	path = /obj/item/clothing/glasses/welding
	category = "General"

/datum/autolathe/recipe/flamethrower
	name = "flamethrower"
	path = /obj/item/weapon/flamethrower/full
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/tacknife
	name = "tactical knife"
	path = /obj/item/weapon/material/hatchet/tacknife
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/stunshell
	name = "ammunition (stun cartridge, shotgun)"
	path = /obj/item/ammo_casing/shotgun/stunshell
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/rcd
	name = "rapid construction device"
	path = /obj/item/weapon/rcd
	hidden = 1
	category = "Engineering"

/datum/autolathe/recipe/electropack
	name = "electropack"
	path = /obj/item/device/radio/electropack
	hidden = 1
	category = "Devices and Components"

/datum/autolathe/recipe/beartrap
	name = "mechanical trap"
	path = /obj/item/weapon/beartrap
	hidden = 1
	category = "Devices and Components"

/datum/autolathe/recipe/welder_industrial
	name = "industrial welding tool"
	path = /obj/item/weapon/weldingtool/largetank
	hidden = 1
	category = "Tools"

/datum/autolathe/recipe/handcuffs
	name = "handcuffs"
	path = /obj/item/weapon/handcuffs
	hidden = 0
	category = "General"

/datum/autolathe/recipe/upgrade_module
	name = "efficiency circuit"
	path = /obj/item/upgrade_module
	hidden = 0
	category = "Engineering"
	resources = list(DEFAULT_WALL_MATERIAL = 500,
					 "glass" = 1000)

/datum/autolathe/recipe/light_missile
	name = "light missile"
	path = /obj/machinery/missile
	hidden = 0
	category = "Arms and Ammunition"
	resources = list(DEFAULT_WALL_MATERIAL = 10000,
					 "glass" = 50)

/datum/autolathe/recipe/standard_missile
	name = "standard missile"
	path = /obj/machinery/missile/standard
	hidden = 0
	category = "Arms and Ammunition"
	resources = list(DEFAULT_WALL_MATERIAL = 22500,
					 "glass" = 100)

/datum/autolathe/recipe/heavy_missile
	name = "heavy missile"
	path = /obj/machinery/missile/heavy
	hidden = 0
	category = "Arms and Ammunition"
	resources = list(DEFAULT_WALL_MATERIAL = 55250,
					 "plasteel" = 8000,
					 "glass" = 500)

/datum/autolathe/recipe/scatter_missile
	name = "scatter missile"
	path = /obj/machinery/missile/scatter
	hidden = 0
	category = "Arms and Ammunition"
	resources = list(DEFAULT_WALL_MATERIAL = 60000,
					 "plasteel" = 5000,
					 "glass" = 200)

/datum/autolathe/recipe/emp_bomb
	name = "emp bomb"
	path = /obj/machinery/missile/bomb/emp
	hidden = 0
	category = "Arms and Ammunition"
	resources = list(DEFAULT_WALL_MATERIAL = 15000,
					 "glass" = 500)

/datum/autolathe/recipe/incendiary_bomb
	name = "incendiary bomb"
	path = /obj/machinery/missile/bomb/incendiary
	hidden = 0
	category = "Arms and Ammunition"
	resources = list(DEFAULT_WALL_MATERIAL = 15000,
					 "phoron" = 500,
					 "glass" = 50)

/datum/autolathe/recipe/necrosis_bomb
	name = "necrosis bomb"
	path = /obj/machinery/missile/bomb/necrosis
	hidden = 0
	category = "Arms and Ammunition"
	resources = list(DEFAULT_WALL_MATERIAL = 15000,
					 "glass" = 50)

/datum/autolathe/recipe/gravity_bomb
	name = "gravity bomb"
	path = /obj/machinery/missile/bomb/grav
	hidden = 0
	category = "Arms and Ammunition"
	resources = list(DEFAULT_WALL_MATERIAL = 15000,
					 "uranium" = 500,
					 "glass" = 50)

/datum/autolathe/recipe/vine_bomb
	name = "vine bomb"
	path = /obj/item/missile/ship/bomb/plant
	hidden = 0
	category = "Arms and Ammunition"
	resources = list(DEFAULT_WALL_MATERIAL = 15000,
					 "wood" = 500,
					 "glass" = 50)

/datum/autolathe/recipe/conveyor_belt
	name = "conveyor belt"
	path = /obj/item/conveyor_construct
	hidden = 0
	category = "Devices and Components"
	resources = list(DEFAULT_WALL_MATERIAL = 4000)

/datum/autolathe/recipe/conveyor_switch
	name = "conveyor switch"
	path = /obj/item/conveyor_switch_construct
	hidden = 0
	category = "Devices and Components"
	resources = list(DEFAULT_WALL_MATERIAL = 1500)




