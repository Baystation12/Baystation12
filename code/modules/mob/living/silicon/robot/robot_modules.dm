/obj/item/weapon/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 100.0
	item_state = "electronic"
	flags = FPRINT|TABLEPASS | CONDUCT
	var/channels = list()
	var/list/modules = list()
	var/obj/item/emag = null
	var/obj/item/borg/upgrade/jetpack = null

	emp_act(severity)
		if(modules)
			for(var/obj/O in modules)
				O.emp_act(severity)
		if(emag)
			emag.emp_act(severity)
		..()
		return


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.emag = new /obj/item/toy/sword(src)
		src.emag.name = "Placeholder Emag Item"
//		src.jetpack = new /obj/item/toy/sword(src)
//		src.jetpack.name = "Placeholder Upgrade Item"
		return


/obj/item/weapon/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R)
	return

/obj/item/weapon/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(O)
			modules += O

/obj/item/weapon/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	//full set of languages
	R.add_language("Sol Common", 0)
	R.add_language("Sinta'unathi", 0)
	R.add_language("Siik'maas", 0)
	R.add_language("Siik'tajr", 0)
	R.add_language("Skrellian", 0)
	R.add_language("Tradeband", 0)
	R.add_language("Gutter", 0)

/obj/item/weapon/robot_module/standard
	name = "standard robot module"

	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/weapon/melee/baton(src)
		src.modules += new /obj/item/weapon/extinguisher(src)
		src.modules += new /obj/item/weapon/wrench(src)
		src.modules += new /obj/item/weapon/crowbar(src)
		src.modules += new /obj/item/device/healthanalyzer(src)
		src.emag = new /obj/item/weapon/melee/energy/sword(src)
		return

/obj/item/weapon/robot_module/standard/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/melee/baton/B = locate() in src.modules
	if(B.charges < 10)
		B.charges += 1

/obj/item/weapon/robot_module/medical
	name = "medical robot module"

	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/borg/sight/hud/med(src)
		src.modules += new /obj/item/device/healthanalyzer(src)
		src.modules += new /obj/item/device/reagent_scanner/adv(src)
		src.modules += new /obj/item/weapon/reagent_containers/borghypo(src)
		src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
		src.modules += new /obj/item/weapon/reagent_containers/robodropper(src)
		src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
		src.modules += new /obj/item/weapon/extinguisher/mini(src)
		src.emag = new /obj/item/weapon/reagent_containers/spray(src)

		src.emag.reagents.add_reagent("pacid", 250)
		src.emag.name = "Polyacid spray"
		return

/obj/item/weapon/robot_module/medical/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)//SYRINGE_BROKEN
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2)

/obj/item/weapon/robot_module/engineering
	name = "engineering robot module"


	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/borg/sight/meson(src)
		src.emag = new /obj/item/borg/stun(src)
		src.modules += new /obj/item/weapon/rcd/borg(src)
		src.modules += new /obj/item/weapon/extinguisher(src)
//		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/weapon/weldingtool/largetank(src)
		src.modules += new /obj/item/weapon/screwdriver(src)
		src.modules += new /obj/item/weapon/wrench(src)
		src.modules += new /obj/item/weapon/crowbar(src)
		src.modules += new /obj/item/weapon/wirecutters(src)
		src.modules += new /obj/item/device/multitool(src)
		src.modules += new /obj/item/device/t_scanner(src)
		src.modules += new /obj/item/device/analyzer(src)
		src.modules += new /obj/item/taperoll/engineering(src)

		var/obj/item/stack/sheet/metal/cyborg/M = new /obj/item/stack/sheet/metal/cyborg(src)
		M.amount = 50
		src.modules += M

		var/obj/item/stack/sheet/rglass/cyborg/G = new /obj/item/stack/sheet/rglass/cyborg(src)
		G.amount = 50
		src.modules += G

		var/obj/item/weapon/cable_coil/W = new /obj/item/weapon/cable_coil(src)
		W.amount = 50
		src.modules += W

		return

/obj/item/weapon/robot_module/engineering/respawn_consumable(var/mob/living/silicon/robot/R)
	var/list/stacks = list (
		/obj/item/stack/sheet/metal,
		/obj/item/stack/sheet/rglass,
		/obj/item/weapon/cable_coil,
	)
	for(var/T in stacks)
		var/O = locate(T) in src.modules
		if(O)
			if(O:amount < 50)
				O:amount++
		else
			src.modules -= null
			O = new T(src)
			src.modules += O
			O:amount = 1
	return

/obj/item/weapon/robot_module/security
	name = "security robot module"

	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/borg/sight/hud/sec(src)
		src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
		src.modules += new /obj/item/weapon/melee/baton(src)
		src.modules += new /obj/item/weapon/gun/energy/taser/cyborg(src)
		src.modules += new /obj/item/taperoll/police(src)
		src.emag = new /obj/item/weapon/gun/energy/laser/cyborg(src)
		return

/obj/item/weapon/robot_module/security/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/weapon/gun/energy/taser/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost)
		T.update_icon()
	else
		T.charge_tick = 0
	var/obj/item/weapon/melee/baton/B = locate() in src.modules
	if(B.charges < 10)
		B.charges += 1

/obj/item/weapon/robot_module/janitor
	name = "janitorial robot module"

	New()
		src.modules += new /obj/item/device/flashlight(src)
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

	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/weapon/reagent_containers/food/drinks/cans/beer(src)
		src.modules += new /obj/item/weapon/reagent_containers/food/condiment/enzyme(src)
		src.modules += new /obj/item/weapon/pen/robopen(src)

		var/obj/item/weapon/rsf/M = new /obj/item/weapon/rsf(src)
		M.matter = 30
		src.modules += M

		src.modules += new /obj/item/weapon/reagent_containers/robodropper(src)

		var/obj/item/weapon/lighter/zippo/L = new /obj/item/weapon/lighter/zippo(src)
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

	add_languages(var/mob/living/silicon/robot/R)
		//full set of languages
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

	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/borg/sight/meson(src)
		src.emag = new /obj/item/borg/stun(src)
		src.modules += new /obj/item/weapon/storage/bag/ore(src)
		src.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
		src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
//		src.modules += new /obj/item/weapon/shovel(src) Uneeded due to buffed drill
		return

/obj/item/weapon/robot_module/syndicate
	name = "syndicate robot module"

	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/weapon/melee/energy/sword(src)
		src.modules += new /obj/item/weapon/gun/energy/pulse_rifle/destroyer(src)
		src.modules += new /obj/item/weapon/card/emag(src)
		return

/obj/item/weapon/robot_module/combat
	name = "combat robot module"

	New()
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/device/flash(src)
		src.modules += new /obj/item/borg/sight/thermal(src)
		src.modules += new /obj/item/weapon/gun/energy/laser/cyborg(src)
		src.modules += new /obj/item/weapon/pickaxe/plasmacutter(src)
		src.modules += new /obj/item/borg/combat/shield(src)
		src.modules += new /obj/item/borg/combat/mobility(src)
		src.modules += new /obj/item/weapon/wrench(src) //Is a combat android really going to be stopped by a chair?
		src.emag = new /obj/item/weapon/gun/energy/lasercannon/cyborg(src)
		return


/obj/item/weapon/robot_module/drone
	name = "drone module"
	var/list/stacktypes = list(
		/obj/item/stack/sheet/wood/cyborg = 1,
		/obj/item/stack/sheet/mineral/plastic/cyborg = 1,
		/obj/item/stack/sheet/rglass/cyborg = 5,
		/obj/item/stack/tile/wood = 5,
		/obj/item/stack/rods = 15,
		/obj/item/stack/tile/plasteel = 15,
		/obj/item/stack/sheet/metal/cyborg = 20,
		/obj/item/stack/sheet/glass/cyborg = 20,
		/obj/item/weapon/cable_coil = 30
		)

	New()
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

		for(var/T in stacktypes)
			var/obj/item/stack/sheet/W = new T(src)
			W.amount = stacktypes[T]
			src.modules += W

		return

	add_languages(var/mob/living/silicon/robot/R)
		return	//not much ROM to spare in that tiny microprocessor!

/obj/item/weapon/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R)
	var/obj/item/weapon/reagent_containers/spray/cleaner/C = locate() in src.modules
	C.reagents.add_reagent("cleaner", 3)

	for(var/T in stacktypes)
		var/O = locate(T) in src.modules
		var/obj/item/stack/sheet/S = O

		if(!S)
			src.modules -= null
			S = new T(src)
			src.modules += S
			S.amount = 1

		if(S && S.amount < stacktypes[T])
			S.amount++

	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R)

	return

//checks whether this item is a module of the robot it is located in.
/obj/item/proc/is_robot_module()
	if (!istype(src.loc, /mob/living/silicon/robot))
		return 0
	
	var/mob/living/silicon/robot/R = src.loc
	
	return (src in R.module.modules)