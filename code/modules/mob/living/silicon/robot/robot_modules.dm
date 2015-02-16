/obj/item/weapon/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 100.0
	item_state = "electronic"
	flags = CONDUCT
	var/channels = list()
	var/list/modules = list()
	var/obj/item/emag = null
	var/obj/item/borg/upgrade/jetpack = null
	var/list/stacktypes

/obj/item/weapon/robot_module/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	..()
	return

/obj/item/weapon/robot_module/New()
	..()
	// Build initial inventory.
	if(stacktypes && stacktypes.len)
		for(var/stack_type in stacktypes)
			var/obj/item/stack/new_stack = new stack_type (src)
			new_stack.amount = stacktypes[stack_type]
			modules |= new_stack

/obj/item/weapon/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R)

	if(!stacktypes || !stacktypes.len) return

	for(var/T in stacktypes)
		var/obj/item/stack/S
		for(var/obj/O in src.modules)
			if(O.type == T)
				S = O
				break

		if(!S)
			src.modules -= null
			S = new T(src)
			src.modules |= S
			S.amount = 1

		if(!istype(S))
			continue

		if(S && S.amount < stacktypes[T])
			S.amount++

/obj/item/weapon/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(O)
			modules += O

/obj/item/weapon/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	//full set of languages
	R.add_language("Sol Common", 1)
	R.add_language("Tradeband", 1)
	R.add_language("Sinta'unathi", 0)
	R.add_language("Siik'tajr", 0)
	R.add_language("Skrellian", 0)
	R.add_language("Gutter", 0)

/obj/item/weapon/robot_module/standard
	name = "standard robot module"

/obj/item/weapon/robot_module/standard/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/melee/baton/loaded(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.emag = new /obj/item/weapon/melee/energy/sword(src)
	return

/obj/item/weapon/robot_module/surgeon
	name = "surgeon robot module"
	stacktypes = list(
		/obj/item/stack/medical/advanced/bruise_pack = 5,
		/obj/item/stack/nanopaste = 5
		)

/obj/item/weapon/robot_module/surgeon/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/surgeon(src)
	src.modules += new /obj/item/weapon/scalpel(src)
	src.modules += new /obj/item/weapon/hemostat(src)
	src.modules += new /obj/item/weapon/retractor(src)
	src.modules += new /obj/item/weapon/cautery(src)
	src.modules += new /obj/item/weapon/bonegel(src)
	src.modules += new /obj/item/weapon/FixOVein(src)
	src.modules += new /obj/item/weapon/bonesetter(src)
	src.modules += new /obj/item/weapon/circular_saw(src)
	src.modules += new /obj/item/weapon/surgicaldrill(src)
	src.modules += new /obj/item/weapon/extinguisher/mini(src)
	src.modules += new /obj/item/stack/medical/advanced/bruise_pack(src)
	src.modules += new /obj/item/stack/nanopaste(src)
	src.emag = new /obj/item/weapon/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"
	return

/obj/item/weapon/robot_module/surgeon/respawn_consumable(var/mob/living/silicon/robot/R)
	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2)
	..()

/obj/item/weapon/robot_module/crisis
	name = "crisis robot module"
	stacktypes = list(
		/obj/item/stack/medical/ointment = 5,
		/obj/item/stack/medical/bruise_pack = 5,
		/obj/item/stack/medical/splint = 5
		)

/obj/item/weapon/robot_module/crisis/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/med(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/roller_holder(src)
	src.modules += new /obj/item/stack/medical/ointment(src)
	src.modules += new /obj/item/stack/medical/bruise_pack(src)
	src.modules += new /obj/item/stack/medical/splint(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/crisis(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/weapon/reagent_containers/robodropper(src)
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.modules += new /obj/item/weapon/extinguisher/mini(src)
	src.emag = new /obj/item/weapon/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"
	return

/obj/item/weapon/robot_module/crisis/respawn_consumable(var/mob/living/silicon/robot/R)

	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2)

	..()

/obj/item/weapon/robot_module/construction
	name = "construction robot module"

	stacktypes = list(
		/obj/item/stack/sheet/metal = 50,
		/obj/item/stack/sheet/plasteel = 10,
		/obj/item/stack/sheet/glass/reinforced = 50,
		/obj/item/stack/rods = 50
		)

/obj/item/weapon/robot_module/construction/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/weapon/rcd/borg(src)
	src.modules += new /obj/item/weapon/screwdriver(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/weapon/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/device/pipe_painter(src)

/obj/item/weapon/robot_module/engineering
	name = "engineering robot module"

	stacktypes = list(
		/obj/item/stack/sheet/metal = 50,
		/obj/item/stack/sheet/glass = 50,
		/obj/item/stack/sheet/glass/reinforced = 50,
		/obj/item/stack/cable_coil/robot = 50,
		/obj/item/stack/rods = 15,
		/obj/item/stack/tile/plasteel = 15
		)

/obj/item/weapon/robot_module/engineering/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/weapon/weldingtool/largetank(src)
	src.modules += new /obj/item/weapon/screwdriver(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/weapon/wirecutters(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/device/t_scanner(src)
	src.modules += new /obj/item/device/analyzer(src)
	src.modules += new /obj/item/taperoll/engineering(src)
	src.modules += new /obj/item/weapon/gripper(src)
	src.modules += new /obj/item/weapon/matter_decompiler(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.emag = new /obj/item/borg/stun(src)
	return

/obj/item/weapon/robot_module/security
	name = "security robot module"

/obj/item/weapon/robot_module/security/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/hud/sec(src)
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
	src.modules += new /obj/item/weapon/melee/baton/robot(src)
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg(src)
	src.modules += new /obj/item/taperoll/police(src)
	src.emag = new /obj/item/weapon/gun/energy/laser/mounted(src)
	return

/obj/item/weapon/robot_module/security/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/weapon/gun/energy/taser/mounted/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost)
		T.update_icon()
	else
		T.charge_tick = 0

/obj/item/weapon/robot_module/janitor
	name = "janitorial robot module"

/obj/item/weapon/robot_module/janitor/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/soap/nanotrasen(src)
	src.modules += new /obj/item/weapon/storage/bag/trash(src)
	src.modules += new /obj/item/weapon/mop(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.emag = new /obj/item/weapon/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("lube", 250)
	src.emag.name = "Lube spray"
	return

/obj/item/weapon/robot_module/janitor/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R)
	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2)

/obj/item/weapon/robot_module/butler
	name = "service robot module"

/obj/item/weapon/robot_module/butler/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/reagent_containers/food/drinks/cans/beer(src)
	src.modules += new /obj/item/weapon/reagent_containers/food/condiment/enzyme(src)

	var/obj/item/weapon/rsf/M = new /obj/item/weapon/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/weapon/reagent_containers/robodropper(src)

	var/obj/item/weapon/flame/lighter/zippo/L = new /obj/item/weapon/flame/lighter/zippo(src)
	L.lit = 1
	src.modules += L

	src.modules += new /obj/item/weapon/tray/robotray(src)
	src.modules += new /obj/item/weapon/reagent_containers/food/drinks/shaker(src)
	src.emag = new /obj/item/weapon/reagent_containers/food/drinks/cans/beer(src)

	var/datum/reagents/R = new/datum/reagents(50)
	src.emag.reagents = R
	R.my_atom = src.emag
	R.add_reagent("beer2", 50)
	src.emag.name = "Mickey Finn's Special Brew"
	return

/obj/item/weapon/robot_module/butler/add_languages(var/mob/living/silicon/robot/R)
	//full set of languages
	R.add_language("Sol Common", 1)
	R.add_language("Sinta'unathi", 1)
	R.add_language("Siik'maas", 1)
	R.add_language("Siik'tajr", 0)
	R.add_language("Skrellian", 1)
	R.add_language("Rootspeak", 1)
	R.add_language("Tradeband", 1)
	R.add_language("Gutter", 1)

/obj/item/weapon/robot_module/clerical
	name = "clerical robot module"

/obj/item/weapon/robot_module/clerical/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/pen/robopen(src)
	src.modules += new /obj/item/weapon/form_printer(src)
	src.modules += new /obj/item/weapon/gripper/paperwork(src)
	src.emag = new /obj/item/weapon/stamp/denied(src)

/obj/item/weapon/robot_module/clerical/add_languages(var/mob/living/silicon/robot/R)
	R.add_language("Sol Common", 1)
	R.add_language("Sinta'unathi", 1)
	R.add_language("Siik'maas", 1)
	R.add_language("Siik'tajr", 0)
	R.add_language("Skrellian", 1)
	R.add_language("Rootspeak", 1)
	R.add_language("Tradeband", 1)
	R.add_language("Gutter", 1)

/obj/item/weapon/robot_module/butler/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2)
	if(src.emag)
		var/obj/item/weapon/reagent_containers/food/drinks/cans/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2)

/obj/item/weapon/robot_module/miner
	name = "miner robot module"

/obj/item/weapon/robot_module/miner/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/screwdriver(src)
	src.modules += new /obj/item/weapon/storage/bag/ore(src)
	src.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/weapon/gripper/miner(src)
	src.modules += new /obj/item/weapon/mining_scanner(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.emag = new /obj/item/weapon/pickaxe/plasmacutter(src)
	return

/obj/item/weapon/robot_module/syndicate
	name = "illegal robot module"

/obj/item/weapon/robot_module/syndicate/New(var/mob/living/silicon/robot/R)
	..()
	loc = R
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/weapon/melee/energy/sword(src)
	src.modules += new /obj/item/weapon/gun/energy/pulse_rifle/destroyer(src)
	src.modules += new /obj/item/weapon/card/emag(src)
	var/jetpack = new/obj/item/weapon/tank/jetpack/carbondioxide(src)
	src.modules += jetpack
	R.internals = jetpack
	return

/obj/item/weapon/robot_module/syndicate/add_languages(var/mob/living/silicon/robot/R)
	//full set of languages
	R.add_language("Sol Common", 1)
	R.add_language("Tradeband", 1)
	R.add_language("Sinta'unathi", 0)
	R.add_language("Siik'tajr", 0)
	R.add_language("Skrellian", 0)
	R.add_language("Gutter", 1)

/obj/item/weapon/robot_module/combat
	name = "combat robot module"

/obj/item/weapon/robot_module/combat/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	src.modules += new /obj/item/borg/sight/thermal(src)
	src.modules += new /obj/item/weapon/gun/energy/laser/mounted(src)
	src.modules += new /obj/item/weapon/pickaxe/plasmacutter(src)
	src.modules += new /obj/item/borg/combat/shield(src)
	src.modules += new /obj/item/borg/combat/mobility(src)
	src.emag = new /obj/item/weapon/gun/energy/lasercannon/mounted(src)
	return

/obj/item/weapon/robot_module/drone
	name = "drone module"
	stacktypes = list(
		/obj/item/stack/sheet/wood = 1,
		/obj/item/stack/sheet/mineral/plastic = 1,
		/obj/item/stack/sheet/glass/reinforced = 5,
		/obj/item/stack/tile/wood = 5,
		/obj/item/stack/rods = 15,
		/obj/item/stack/tile/plasteel = 15,
		/obj/item/stack/sheet/metal = 20,
		/obj/item/stack/sheet/glass = 20,
		/obj/item/stack/cable_coil/robot = 30
		)

/obj/item/weapon/robot_module/drone/New()
	..()
	src.modules += new /obj/item/weapon/weldingtool(src)
	src.modules += new /obj/item/weapon/screwdriver(src)
	src.modules += new /obj/item/weapon/wrench(src)
	src.modules += new /obj/item/weapon/crowbar(src)
	src.modules += new /obj/item/weapon/wirecutters(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/weapon/gripper(src)
	src.modules += new /obj/item/weapon/matter_decompiler(src)
	src.modules += new /obj/item/weapon/reagent_containers/spray/cleaner/drone(src)
	src.emag = new /obj/item/weapon/pickaxe/plasmacutter(src)
	src.emag.name = "Plasma Cutter"

/obj/item/weapon/robot_module/drone/add_languages(var/mob/living/silicon/robot/R)
	return	//not much ROM to spare in that tiny microprocessor!

/obj/item/weapon/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/spray/cleaner/C = locate() in src.modules
	C.reagents.add_reagent("cleaner", 3)

	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R)

	..()
	return

//checks whether this item is a module of the robot it is located in.
/obj/item/proc/is_robot_module()
	if (!istype(src.loc, /mob/living/silicon/robot))
		return 0

	var/mob/living/silicon/robot/R = src.loc

	return (src in R.module.modules)
