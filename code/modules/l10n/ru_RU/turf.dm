
/datum/lang/ru_RU/turf
	name = "турф"
	gender = MALE

	var/movement_disabled = "Передвижение заблокировано администрацией."
	proc/clean(var/args = null)
		return "\The [translation(args)] is too dry to wash that."

	simulated
		name = "турф с симуляцией воздуха"

		var/more_fuel = "You need more welding fuel to complete this task."
		var/no_dex = "You don't have the dexterity to do this!"

		floor
			name = "пол"

			var/replace_bulb = "Вы заменили лампу."
			var/bulb_fine = "Лампочка цела, нет необходимости её заменять."
			var/remove_broken = "You remove the broken plating."
			var/pry_off = "You forcefully pry off the planks, destroying them in the process."
			proc/remove(var/args = null)	return "You remove the [args ? translation(args) : "floor"]."
			var/unscrew = "You unscrew the planks."
			var/more_rods = "You need more rods."
			var/reinforcing = "Reinforcing the floor..."
			var/remove_first = "You must remove the plating first."
			var/too_damaged = "This section is too damaged to support a tile. Use a welder to fix the damage."
			var/shovel_grass = "You shovel the grass."
			var/cannot_shovel = "You cannot shovel this."
			var/fix_dents = "You fix some dents on the broken plating."

			airless
				name = "airless floor"
			light
				name = "light floor"
			engine
				name = "укреплённый пол"

				cult
					name = "гравированный пол"
				vacuum
					name = "vacuum floor"
			plating
				name = "обшивка"
				gender = FEMALE

				airless
					name = "внешняя обшивка"

					asteroid
						name = "астероид"
						gender = MALE

						var/been_dug = "This area has already been dug"
						var/digging = "You start digging."
						var/dug = "You dug a hole."
				ironsand
					name = "железистый песок"
					gender = MALE
				snow
					name = "снег"
					gender = MALE
			beach
				name = "beach"

				sand
					name = "sand"
				coastline
					name = "coastline"
				water
					name = "water"
			grass
				name = "grass patch"
			carpet
				name = "carpet"
		shuttle
			name = "shuttle"

			wall
				name = "стена"
				gender = FEMALE
			floor
				name = "пол"
			plating
				name = "обшивка"
				gender = FEMALE
			floor4
				name = "brig floor"

				vox
					name = "skipjack floor"
		wall
			name = "стена"
			gender = FEMALE
			proc/name()
				if(refObj:reinf_material)
					return "укреплённая [refObj:material.display_name] стена"
				else
					return "[refObj:material.display_name] стена"

			desc = "A huge chunk of metal used to seperate rooms."
			proc/desc()
				if(refObj:reinf_material)
					return "It seems to be a section of hull reinforced with [refObj:reinf_material.display_name] and plated with [refObj:material.display_name]."
				else
					return "It seems to be a section of hull plated with [refObj:material.display_name]."

			var/intact = "It looks fully intact."
			var/slightly = "It looks slightly damaged."
			var/moderately = "It looks moderately damaged."
			var/heavily = "It looks heavily damaged."
			proc/fungus()	return "There is fungus growing on [GetVar()]."
			proc/combusts_m()	return "\The [GetVar()] spontaneously combusts!."
			var/thermite = "The thermite starts melting through the wall."
			var/fail_smash = "You smash against the wall!"
			var/success_smash = "You smash through the wall!"
			proc/reinf_crumbly()	return "\The [refObj:reinf_material:display_name] feels porous and crumbly."
			proc/crumbles()	return "\The [refObj:material.display_name] crumbles under your touch!"
			var/push = "You push the wall, but nothing happens."
			proc/burn_fungi(var/args = null) return "You burn away the fungi with \the [args ? translation(args) : "welder"]."
			proc/crumbles_force(var/args = null) return "\The [GetVar()] crumbles away under the force of your [args ? translation(args) : "weapon"]."
			proc/thermit_eblade(var/args = null) return "You slash \the [GetVar()] with \the [args ? translation(args) : "energy blade"]; the thermite ignites!"
			proc/start_repear()	return "You start repairing the damage to [GetVar()]."
			proc/finish_repear()	return "You finish repairing the damage to [GetVar()]."
			proc/dismantle(var/args = null)	return "You begin [args ? args : "cutting"] through the outer plating."
			var/remove_plating = "You remove the outer plating."
			proc/dismantle_m(var/args = null)	return "<span class='warning'>The wall was torn open by [args ? args : "someone"]!</span>"
			var/cut_grille = "You cut the outer grille."
			var/removing_sup = "You begin removing the support lines."
			var/remove_sup = "You remove the support lines."
			var/replace_grille = "You replace the outer grille."
			var/slicing_cover = "You begin slicing through the metal cover."
			var/dislodging = "You press firmly on the cover, dislodging it."
			var/struggle_cover = "You struggle to pry off the cover."
			var/pry_off_cover = "You pry off the cover."
			var/losening = "You start loosening the anchoring bolts which secure the support rods to their frame."
			var/remove_bolts = "You remove the bolts anchoring the support rods."
			var/slicing_rods = "You begin slicing through the support rods."
			var/rods_drop = "The support rods drop out as you cut them loose from the frame."
			var/struggle_sheath = "You struggle to pry off the outer sheath."
			var/pry_off_sheat = "You pry off the outer sheath."

			cult
				name = "cult wall"
				desc = "Hideous images dance beneath the surface."
		mineral
			name = "скала"
			gender = FEMALE

			proc/name()
				if(refObj:mineral)
					return "месторождение [refObj:mineral.display_name]"
				else
					return "скала"
			proc/tape_m(var/args = null)	return "<span class='blue'>[args ? args["user"] : "user"] extends [args ? args["P"] : "measuring tape"] towards [GetVar()].</span>"
			proc/tape_sm(var/args = null)	return "<span class='blue'>You extend [args ? args["P"] : "measuring tape"] towards [GetVar()].</span>"
			proc/tape(var/args = null)	return "\icon[args ? args["P"] : null] [GetVar()] has been excavated to a depth of [2*(args ? args["excavation_level"] : 0)]cm."
			proc/fail_message(var/args = null)	return " <b>[pick("There is a crunching noise","[args ? translation(args) : "Pickaxe"] collides with some different rock","Part of the rock face crumbles away","Something breaks under [args ? translation(args) : "pickaxe"]")].</b>" //TODO:LANG name_capital
			proc/start_drill(var/args = null)	return "You start [args ? translation(args, "drill_verb") : "drilling"]."
			proc/finish_drill(var/args = null)	return "You finish [args ? translation(args, "drill_verb") : "drilling"] the rock."
			proc/artifact_fail()	return "[pick("A high pitched [pick("keening","wailing","whistle")]","A rumbling noise like [pick("thunder","heavy machinery")]")] somehow penetrates your mind before fading away!"
			proc/find_crate_m()	return "<span class='notice'>An old dusty crate was buried within!</span>"
			proc/find_break(var/args = null)	return "<span class='danger'><b>[pick("[args ? translation(args, "display_name") : "Something"] crumbles away into dust","[args ? translation(args, "display_name") : "Something"] breaks apart")].</b></span>"

			random
				name = "mineral deposit"

	space
		name = "космос"

		var/lattice = "Constructing support lattice ..."
		var/need_support = "The plating is going to need some support."
		var/nuke = "Something you are carrying is preventing you from leaving. Don't play stupid; you know exactly what it is."

	unsimulated
		name = "турф без симуляции воздуха"

		beach
			name = "пляж"

			sand
				name = "песок"
			coastline
				name = "берег"
			water
				name = "вода"
				gender = FEMALE
		floor
			name = "пол"
		mask
			name = "маска генерации астероида"
			gender = FEMALE
		wall
			name = "стена"
			gender = FEMALE

			fakeglass
				name = "окно"
				gender = NEUTER
			splashscreen
				name = "Космическая станция 13"