
/datum/lang/main/turf
	name = "turf"

	var/movement_disabled = "Movement is admin-disabled."
	proc/clean(var/args = null)
		return "\The [translation(args)] is too dry to wash that."

	simulated
		name = "station"

		var/more_fuel = "You need more welding fuel to complete this task."
		var/no_dex = "You don't have the dexterity to do this!"

		floor
			name = "floor"

			var/replace_bulb = "You replace the light bulb."
			var/bulb_fine = "The lightbulb seems fine, no need to replace it."
			var/remove_broken = "You remove the broken plating."
			var/pry_off = "You forcefully pry off the planks, destroying them in the process."
			proc/remove(var/args = null)	return "You remove the [args ? translation(args) : args]."
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
				name = "reinforced floor"

				cult
					name = "engraved floor"
				vacuum
					name = "vacuum floor"
			plating
				name = "plating"

				airless
					name = "airless plating"

					asteroid
						name = "asteroid"

						var/been_dug = "This area has already been dug"
						var/digging = "You start digging."
						var/dug = "You dug a hole."
				ironsand
					name = "iron sand"
				snow
					name = "snow"
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
				name = "wall"
			floor
				name = "floor"
			plating
				name = "plating"
			floor4
				name = "brig floor"

				vox
					name = "skipjack floor"
		wall
			name = "wall"
			proc/name()
				if(refObj:reinf_material)
					return "reinforced [refObj:material.display_name] wall"
				else
					return "[refObj:material.display_name] wall"

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
			proc/burn_fungi(var/args = null) return "You burn away the fungi with \the [args ? translation(args) : args]."
			proc/crumbles_force(var/args = null) return "\The [GetVar()] crumbles away under the force of your [args ? translation(args) : args]."
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
			name = "rock"

			proc/name()
				if(refObj:mineral)
					return "[refObj:mineral.display_name] deposit"
				else
					return "rock"
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
		name = "space"

		var/lattice = "Constructing support lattice ..."
		var/need_support = "The plating is going to need some support."
		var/nuke = "Something you are carrying is preventing you from leaving. Don't play stupid; you know exactly what it is."

	unsimulated
		name = "command"

		beach
			name = "beach"

			sand
				name = "sand"
			coastline
				name = "coastline"
			water
				name = "water"
		floor
			name = "floor"
		mask
			name = "mask"
		wall
			name = "wall"

			fakeglass
				name = "window"
			splashscreen
				name = "Space Station 13"