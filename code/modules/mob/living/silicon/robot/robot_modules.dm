/obj/item/weapon/robot_module
	name = "robot module"
	icon = 'module.dmi'
	icon_state = "std_module"
	w_class = 100.0
	item_state = "electronic"
	flags = FPRINT|TABLEPASS | CONDUCT
	var
		list/modules = list()
		obj/item/emag = null


	emp_act(severity)
		if(modules)
			for(var/obj/O in modules)
				O.emp_act(severity)
		if(emag)
			emag.emp_act(severity)
		..()
		return


	New()
		src.modules += new /obj/item/device/flash(src)
		src.emag = new /obj/item/toy/sword(src)
		src.emag.name = "Placeholder Emag Item"
		return


	proc/respawn_consumable(var/mob/living/silicon/robot/R)
		return



/obj/item/weapon/robot_module/standard
	name = "standard robot module"


	New()
		..()
		src.modules += new /obj/item/weapon/melee/baton(src)
		src.modules += new /obj/item/weapon/extinguisher(src)
		src.modules += new /obj/item/weapon/wrench(src)
		src.modules += new /obj/item/weapon/crowbar(src)
		src.modules += new /obj/item/device/healthanalyzer(src)
		src.emag = new /obj/item/weapon/melee/energy/sword(src)
		return



/obj/item/weapon/robot_module/medical
	name = "medical robot module"


	New()
		..()
		src.modules += new /obj/item/borg/sight/hud/med(src)
		src.modules += new /obj/item/device/healthanalyzer(src)
		src.modules += new /obj/item/weapon/reagent_containers/syringe/robot/antitoxin(src)
		src.modules += new /obj/item/weapon/reagent_containers/syringe/robot/inaprovaline(src)
		src.modules += new /obj/item/weapon/reagent_containers/syringe/robot/mixed(src)
		src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
		src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
		src.modules += new /obj/item/weapon/reagent_containers/glass/bottle/robot/inaprovaline(src)
		src.modules += new /obj/item/weapon/reagent_containers/glass/bottle/robot/antitoxin(src)
		src.modules += new /obj/item/weapon/reagent_containers/glass/beaker(src)
		src.modules += new /obj/item/weapon/reagent_containers/robodropper(src)
		src.emag = new /obj/item/weapon/reagent_containers/pill/cyanide(src)
		src.modules += new /obj/item/weapon/reagent_containers/pill/dexalin(src)
		src.modules += new /obj/item/weapon/reagent_containers/pill/antitox(src)
		src.modules += new /obj/item/weapon/reagent_containers/pill/kelotane(src)
		src.modules += new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
		return


	respawn_consumable(var/mob/living/silicon/robot/R)
		var/list/what = list (
			/obj/item/weapon/reagent_containers/pill/dexalin,
			/obj/item/weapon/reagent_containers/pill/antitox,
			/obj/item/weapon/reagent_containers/pill/kelotane,
			/obj/item/weapon/reagent_containers/pill/bicaridine
		)
		for (var/T in what)
			if (!(locate(T) in src.modules))
				src.modules -= null
				var/O = new T(src)
				src.modules += O
		if (R.emagged && !src.emag) //thanks to cyborg-900 for uncovering this
			src.emag = new /obj/item/weapon/reagent_containers/pill/cyanide(src)
		return



/obj/item/weapon/robot_module/engineering
	name = "engineering robot module"


	New()
		..()
		src.modules += new /obj/item/borg/sight/meson(src)
		src.emag = new /obj/item/borg/stun(src)
		src.modules += new /obj/item/borg/rcd(src)
		src.modules += new /obj/item/weapon/extinguisher(src)
		src.modules += new /obj/item/device/flashlight(src)
		src.modules += new /obj/item/weapon/weldingtool/largetank(src)
		src.modules += new /obj/item/weapon/screwdriver(src)
		src.modules += new /obj/item/weapon/wrench(src)
		src.modules += new /obj/item/weapon/crowbar(src)
		src.modules += new /obj/item/weapon/wirecutters(src)
		src.modules += new /obj/item/device/multitool(src)
		src.modules += new /obj/item/device/t_scanner(src)
		src.modules += new /obj/item/device/analyzer(src)

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


	respawn_consumable(var/mob/living/silicon/robot/R)
		var/list/what = list (
			/obj/item/stack/sheet/metal,
			/obj/item/stack/sheet/rglass,
			/obj/item/weapon/cable_coil,
		)
		for (var/T in what)
			if (!(locate(T) in src.modules))
				src.modules -= null
				var/O = new T(src)
				src.modules += O
				O:amount = 1
		return



/obj/item/weapon/robot_module/security
	name = "security robot module"


	New()
		..()
		src.modules += new /obj/item/borg/sight/hud/sec(src)
		src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
		src.modules += new /obj/item/weapon/melee/baton(src)
		src.modules += new /obj/item/weapon/gun/energy/taser/cyborg(src)
//		src.emag = new /obj/item/weapon/gun/energy/laser/cyborg(src)
		return



/obj/item/weapon/robot_module/janitor
	name = "janitorial robot module"


	New()
		..()
		src.modules += new /obj/item/weapon/cleaner(src)
		src.modules += new /obj/item/weapon/mop(src)
		src.modules += new /obj/item/weapon/reagent_containers/glass/bucket(src)
		src.modules += new /obj/item/weapon/trashbag(src)
		src.emag = new /obj/item/weapon/cleaner(src)

		var/datum/reagents/R = new/datum/reagents(1000)
		src.emag.reagents = R
		R.my_atom = src.emag
		R.add_reagent("lube", 1000)
		src.emag.name = "Lube spray"
		return



/obj/item/weapon/robot_module/butler
	name = "service robot module"


	New()
		..()
		src.modules += new /obj/item/weapon/reagent_containers/food/drinks/beer(src)
		src.modules += new /obj/item/weapon/reagent_containers/food/condiment/enzyme(src)
		src.modules += new /obj/item/weapon/pen(src)

		var/obj/item/weapon/rsf/M = new /obj/item/weapon/rsf(src)
		M.matter = 30
		src.modules += M

		src.modules += new /obj/item/weapon/reagent_containers/robodropper(src)
		src.modules += new /obj/item/weapon/zippo(src)

		src.modules += new /obj/item/weapon/tray(src)
		src.modules += new /obj/item/weapon/reagent_containers/food/drinks/shaker(src)
		src.emag = new /obj/item/weapon/reagent_containers/food/drinks/beer(src)

		var/datum/reagents/R = new/datum/reagents(50)
		src.emag.reagents = R
		R.my_atom = src.emag
		R.add_reagent("beer2", 50)
		src.emag.name = "Mickey Finn's Special Brew"
		return



/obj/item/weapon/robot_module/miner
	name = "miner robot module"


	New()
		..()
		src.modules += new /obj/item/borg/sight/meson(src)
		src.emag = new /obj/item/borg/stun(src)
		src.modules += new /obj/item/weapon/satchel(src)
		src.modules += new /obj/item/weapon/pickaxe/jackhammer(src)
		src.modules += new /obj/item/weapon/shovel(src)
		return


/obj/item/weapon/robot_module/syndicate
	name = "syndicate robot module"


	New()
		src.modules += new /obj/item/weapon/card/emag(src)
		return
