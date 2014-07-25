#define HYDRO_SPEED_MULTIPLIER 1

/obj/machinery/hydroponics
	name = "hydroponics tray"
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "hydrotray3"
	density = 1
	anchored = 1
	var/draw_warnings = 1 //Set to 0 to stop it from drawing the alert lights.

	// Plant maintenance vars.
	var/waterlevel = 100       // Water level (max 100)
	var/nutrilevel = 10        // Nutrient level (max 10)
	var/pestlevel = 0          // Pests (max 10)
	var/weedlevel = 0          // Weeds (max 10)s

	// Tray state vars.
	var/dead = 0               // Is it dead?
	var/harvest = 0            // Is it ready to harvest?
	var/age = 0                // Current plant age

	// Harvest/mutation mods.
	var/yield_mod = 0          // Modifier to yield
	var/mutation_mod = 0       // Modifier to mutation chance
	var/toxins = 0             // Toxicity in the tray?

	// Mechanical concerns.
	var/health = 0             // Plant health.
	var/lastproduce = 0        // Last time tray was harvested
	var/lastcycle = 0          // Cycle timing/tracking var.
	var/cycledelay = 150       // Delay per cycle.
	var/closed_system          // If set, the tray will attempt to take atmos from a pipe.
	var/obj/machinery/atmospherics/portables_connector/atmos_source //Used for above.

	// Seed details/line data.
	var/datum/seed/seed = null // The currently planted seed

	// Reagent information for attackby(), consider moving this to a controller along
	// with cycle information under 'mechanical concerns' at some point.
	// For all following lists, when called in attackby() the relevant value will be increased
	// by 1,val if val>0 or decreased by 1,val if val<0.

	var/global/list/toxic_reagents = list(
		"anti_toxin" = -2,
		"toxin" = 2,
		"fluorine" = 2.5,
		"chlorine" = 1.5,
		"sacid" = 1.5,
		"pacid" = 3,
		"plantbgone" = 3,
		"cryoxadone" = -3,
		"radium" = 2
		)
	var/global/list/nutrient_reagents = list(
		"milk" = 0.1,
		"beer" = 0.25,
		"phosphorus" = 0.1,
		"sugar" = 0.1,
		"sodawater" = 0.1,
		"ammonia" = 1,
		"diethylamine" = 2,
		"nutriment" = 1,
		"adminordrazine" = 1
		)
	var/global/list/weedkiller_reagents = list(
		"fluorine" = -4,
		"chlorine" = -3,
		"phosphorus" = -2,
		"sugar" = 2,
		"sacid" = -2,
		"pacid" = -4,
		"plantbgone" = -8,
		"adminordrazine" = -5
		)
	var/global/list/pestkiller_reagents = list(
		"sugar" = 2,
		"diethylamine" = -2,
		"adminordrazine" = -5
		)
	var/global/list/beneficial_reagents = list(
		"beer" = -0.05,
		"fluorine" = -2,
		"chlorine" = -1,
		"phosphorus" = -0.75,
		"sodawater" = 0.1,
		"sacid" = -1,
		"pacid" = -2,
		"plantbgone" = -2,
		"cryoxadone" = 3,
		"ammonia" = 0.5,
		"diethylamine" = 1,
		"nutriment" = 0.5,
		"radium" = -1.5,
		"adminordrazine" = 1
		)
	var/global/list/water_reagents = list(
		"adminordrazine" = 1,
		"milk" = 0.9,
		"beer" = 0.7,
		"flourine" = -0.5,
		"chlorine" = -0.5,
		"phosphorus" = -0.5,
		"water" = 1,
		"sodawater" = 1,
		)

	// Mutagen list specifies minimum value for the mutation to take place, rather
	// than a bound as the lists above specify.
	var/global/list/mutagenic_reagents = list(
		"radium" = 8,
		"mutagen" = 3
		)

/obj/machinery/hydroponics/New()
	..()
	if(closed_system)
		get_connector()
	updateicon()

/obj/machinery/hydroponics/proc/get_connector()
	atmos_source = null
	var/turf/T = get_turf(src)
	if(!T) return
	atmos_source = locate() in T.contents
	if(atmos_source)
		src.visible_message("[src] connects to [atmos_source] with a solid clunk.")

/obj/machinery/hydroponics/bullet_act(var/obj/item/projectile/Proj)

	//Override for somatoray projectiles.
	if(istype(Proj ,/obj/item/projectile/energy/floramut) && prob(20))
		mutate(1)
		return
	else if(istype(Proj ,/obj/item/projectile/energy/florayield) && prob(20))
		yield_mod = min(10,yield_mod+rand(1,2))
		return

	..()

/obj/machinery/hydroponics/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/hydroponics/process()

	// Update values every cycle rather than every process() tick.
	if(world.time < (lastcycle + cycledelay))
		return
	lastcycle = world.time

	// Weeds like water and nutrients, there's a chance the weed population will increase.
	// Bonus chance if the tray is unoccupied.
	if(waterlevel > 10 && nutrilevel > 2 && prob(isnull(seed) ? 6 : 3))
		weedlevel += 1 * HYDRO_SPEED_MULTIPLIER

	// There's a chance for a weed explosion to happen if the weeds take over.
	// Plants that are themselves weeds (weed_tolernace > 10) are unaffected.
	if (weedlevel >= 10 && prob(10))
		if(!seed || weedlevel >= seed.weed_tolerance)
			weed_invasion()

	// If there is no seed data (and hence nothing planted),
	// or the plant is dead, process nothing further.
	if(!seed || dead)
		return

	// Advance plant age.
	age += 1 * HYDRO_SPEED_MULTIPLIER

	// Maintain tray nutrient and water levels.
	if(seed.nutrient_consumption > 0 && nutrilevel > 0 && prob(25))
		nutrilevel -= max(0,seed.nutrient_consumption * HYDRO_SPEED_MULTIPLIER)
	if(seed.water_consumption > 0 && waterlevel > 0  && prob(25))
		waterlevel -= max(0,seed.water_consumption * HYDRO_SPEED_MULTIPLIER)

	// Make sure the plant is not starving or thirsty. Adequate
	// water and nutrients will cause a plant to become healthier.
	var/healthmod = rand(1,3) * HYDRO_SPEED_MULTIPLIER
	if(seed.requires_nutrients && prob(35))
		health += (nutrilevel < 2 ? -healthmod : healthmod)
	if(seed.requires_water && prob(35))
		health += (waterlevel < 10 ? -healthmod : healthmod)

	// Check that pressure, heat and light are all within bounds.
	// First, handle an open system or an unconnected closed system.

	var/turf/T = loc
	var/datum/gas_mixture/environment

	// If we're a closed system, take from any connected network.
	if(closed_system && atmos_source)
		if(atmos_source.network)
			environment = atmos_source.network.air_transient

	// If atmos input is not there, grab from turf.
	if(!environment)
		if(istype(T))
			environment = T.return_air()
	if(!environment) //We're in a crate or nullspace, bail out.
		return

	// Process it.
	var/pressure = environment.return_pressure()
	if(pressure < seed.lowkpa_tolerance || pressure > seed.highkpa_tolerance)
		health -= healthmod

	if(abs(environment.temperature - seed.ideal_heat) > seed.heat_tolerance)
		health -= healthmod

	// Handle light requirements.
	var/area/A = T.loc
	if(A)
		var/light_available
		if(A.lighting_use_dynamic)
			light_available = max(0,min(10,T.lighting_lumcount)-5)
		else
			light_available =  5
		if(abs(light_available - seed.ideal_light) > seed.light_tolerance)
			health -= healthmod

	// Toxin levels beyond the plant's tolerance cause damage, but
	// toxins are sucked up each tick and slowly reduce over time.
	if(toxins > 0)
		var/toxin_uptake = max(1,round(toxins/10))
		if(toxins > seed.toxins_tolerance)
			health -= toxin_uptake
		toxins -= toxin_uptake

	// Check for pests and weeds.
	// Some carnivorous plants happily eat pests.
	if(pestlevel > 0)
		if(seed.carnivorous)
			health += HYDRO_SPEED_MULTIPLIER
			pestlevel -= HYDRO_SPEED_MULTIPLIER
		else if (pestlevel >= seed.pest_tolerance)
			health -= HYDRO_SPEED_MULTIPLIER

	// Some plants thrive and live off of weeds.
	if(weedlevel > 0)
		if(seed.parasite)
			health += HYDRO_SPEED_MULTIPLIER
			weedlevel -= HYDRO_SPEED_MULTIPLIER
		else if (weedlevel >= seed.weed_tolerance)
			health -= HYDRO_SPEED_MULTIPLIER

	// Handle life and death.
	// If the plant is too old, it loses health fast.
	if(age > seed.lifespan)
		health -= rand(3,5) * HYDRO_SPEED_MULTIPLIER

	// When the plant dies, weeds thrive and pests die off.
	if(health <= 0)
		dead = 1
		harvest = 0
		weedlevel += 1 * HYDRO_SPEED_MULTIPLIER
		pestlevel = 0

	// If enough time (in cycles, not ticks) has passed since the plant was harvested, we're ready to harvest again.
	else if(age > seed.production && (age - lastproduce) > seed.production && (!harvest && !dead))
		harvest = 1
		lastproduce = age

	if(prob(5))  // On each tick, there's a 5 percent chance the pest population will increase
		pestlevel += 1 * HYDRO_SPEED_MULTIPLIER

	check_level_sanity()
	updateicon()
	return

//Harvests the product of a plant.
/obj/machinery/hydroponics/proc/harvest(var/mob/user)

	//Harvest the product of the plant,
	if(!seed || !harvest || !user)
		return

	if(closed_system)
		user << "You can't harvest from the plant while the lid is shut."
		return

	seed.harvest(user,yield_mod)

	// Reset values.
	harvest = 0
	lastproduce = age

	if(!seed.harvest_repeat)
		yield_mod = 0
		seed = null
		dead = 0
		age = 0

	check_level_sanity()
	updateicon()
	return

//Clears out a dead plant.
/obj/machinery/hydroponics/proc/remove_dead(var/mob/user)
	if(!user || !dead) return

	if(closed_system)
		user << "You can't remove the dead plant while the lid is shut."
		return

	seed = null
	dead = 0
	user << "You remove the dead plant from the [src]."
	check_level_sanity()
	updateicon()
	return

//Refreshes the icon and sets the luminosity
/obj/machinery/hydroponics/proc/updateicon()

	overlays.Cut()

	// Updates the plant overlay.
	if(!isnull(seed))

		if(draw_warnings && health <= (seed.endurance / 2))
			overlays += "over_lowhealth3"

		if(dead)
			overlays += "[seed.plant_icon]-dead"
		else if(harvest)
			overlays += "[seed.plant_icon]-harvest"
		else if(age < seed.maturation)

			var/t_growthstate
			if(age >= seed.maturation)
				t_growthstate = seed.growth_stages
			else
				t_growthstate = round(seed.maturation / seed.growth_stages)

			overlays += "[seed.plant_icon]-grow[t_growthstate]"
			lastproduce = age
		else
			overlays += "[seed.plant_icon]-grow[seed.growth_stages]"

	//Draw the cover.
	if(closed_system)
		overlays += "hydrocover"

	//Updated the various alert icons.
	if(draw_warnings)
		if(waterlevel <= 10)
			overlays += "over_lowwater3"
		if(nutrilevel <= 2)
			overlays += "over_lownutri3"
		if(weedlevel >= 5 || pestlevel >= 5 || toxins >= 40)
			overlays += "over_alert3"
		if(harvest)
			overlays += "over_harvest3"

	// Update bioluminescence.
	if(seed)
		if(seed.biolum)
			SetLuminosity(round(seed.potency/10))
			if(seed.biolum_colour)
				l_color = seed.biolum_colour
			else
				l_color = null
			return

	SetLuminosity(0)
	return

 // If a weed growth is sufficient, this proc is called.
obj/machinery/hydroponics/proc/weed_invasion()

	//Remove the seed if something is already planted.
	if(seed) seed = null
	seed = seed_types[pick(list("reishi","nettles","amanita","mushrooms","plumphelmet","towercap","harebells","weeds"))]
	if(!seed) return //Weed does not exist, someone fucked up.

	dead = 0
	age = 0
	health = seed.endurance
	lastcycle = world.time
	harvest = 0
	weedlevel = 0
	pestlevel = 0
	updateicon()
	visible_message("\blue [src] has been overtaken by [seed.display_name].")

	return

/obj/machinery/hydroponics/proc/mutate(var/severity)

	// No seed, no mutations.
	if(!seed)
		return

	// Check if we should even bother working on the current seed datum.
	if(seed.mutants.len && severity > 1 && prob(10+mutation_mod))
		world << "Mutating species instead."
		mutate_species()
		return

	// We need to make sure we're not modifying one of the global seed datums.
	// If it's not in the global list, then no products of the line have been
	// harvested yet and it's safe to assume it's restricted to this tray.
	if(!isnull(seed_types[seed.name]))
		seed = seed.diverge()
	seed.mutate(severity,get_turf(src))

	return

/obj/machinery/hydroponics/proc/check_level_sanity()
	//Make sure various values are sane.
	if(seed)
		health =     max(0,min(seed.endurance,health))
	else
		health = 0
		dead = 0

	nutrilevel = max(0,min(nutrilevel,10))
	waterlevel = max(0,min(waterlevel,100))
	pestlevel =  max(0,min(pestlevel,10))
	weedlevel =  max(0,min(weedlevel,10))
	toxins =     max(0,min(toxins,10))


/obj/machinery/hydroponics/proc/mutate_species()

	var/previous_plant = seed.display_name
	var/newseed = seed.get_mutant_variant()
	if(newseed in seed_types)
		seed = seed_types[newseed]
	else
		return

	dead = 0
	mutate(1)
	age = 0
	health = seed.endurance
	lastcycle = world.time
	harvest = 0
	weedlevel = 0

	updateicon()
	visible_message("\red The \blue [previous_plant] \red has suddenly mutated into \blue [seed.display_name]!")

	return

/obj/machinery/hydroponics/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if(closed_system && !istype(O,/obj/item/weapon/wrench))
		user << "You can't reach the interior while the lid is shut."
		return

	if (istype(O, /obj/item/weapon/reagent_containers/glass))
		var/b_amount = O.reagents.get_reagent_amount("water")
		if(b_amount > 0 && waterlevel < 100)
			if(b_amount + waterlevel > 100)
				b_amount = 100 - waterlevel
			O.reagents.remove_reagent("water", b_amount)
			waterlevel += b_amount
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
			user << "You fill \the [src] with [round(b_amount,0.1)] units of water."

			// The more water you put in, the more diluted the toxins become.
			toxins -= round(b_amount/4)

		else if(waterlevel >= 100)
			user << "\red \The [src] is already full."
		else
			user << "\red \The [O] is not filled with water."

		check_level_sanity()
		updateicon()

	// Nutrient fluid replacement. TODO: Consider rolling this into a proper reagent-processing proc.
	else if ( istype(O, /obj/item/nutrient) )
		var/obj/item/nutrient/nutrient = O
		user.u_equip(O)
		nutrilevel = 10
		yield_mod = nutrient.yieldmod
		mutation_mod = nutrient.mutmod
		user << "You replace the nutrient solution in the [src]."
		del(O)
		updateicon()

	 // Syringe stuff
	else if(istype(O, /obj/item/weapon/reagent_containers/syringe))

		var/obj/item/weapon/reagent_containers/syringe/S = O

		if(seed)
			// Injecting into the plant.
			if (S.mode == 1)
				if(!S.reagents.total_volume)
					user << "\red [O] is empty."
					return

				user << "\red You inject the [seed.display_name] with a chemical solution."

				// Uuuuuugh this whole chunk is going to be awful. TODO: condense it down somehow.
				// Run through the various reagents in the lists and apply their effects as needed.
				for(var/datum/reagent/R in S.reagents.reagent_list)

					var/reagent_value = 0

					if(toxic_reagents[R.id])
						reagent_value = toxic_reagents[R.id]
						if(reagent_value > 0)
							if(reagent_value < 1)
								toxins += reagent_value
							else
								toxins += round(S.reagents.get_reagent_amount(R.id)*rand(1,reagent_value))
						else
							if(reagent_value > -1)
								toxins += reagent_value
							else
								toxins -= abs(round(S.reagents.get_reagent_amount(R.id)*rand(1,abs(reagent_value))))

					if(nutrient_reagents[R.id])
						reagent_value = nutrient_reagents[R.id]
						if(reagent_value > 0)
							if(reagent_value < 1)
								nutrilevel += reagent_value
							else
								nutrilevel += round(S.reagents.get_reagent_amount(R.id)*rand(1,reagent_value))
						else
							if(reagent_value > -1)
								nutrilevel += reagent_value
							else
								nutrilevel -= abs(round(S.reagents.get_reagent_amount(R.id)*rand(1,abs(reagent_value))))

					if(weedkiller_reagents[R.id])
						reagent_value = weedkiller_reagents[R.id]
						if(reagent_value > 0)
							if(reagent_value < 1)
								weedlevel += reagent_value
							else
								weedlevel += round(S.reagents.get_reagent_amount(R.id)*rand(1,reagent_value))
						else
							if(reagent_value > -1)
								weedlevel += reagent_value
							else
								weedlevel -= abs(round(S.reagents.get_reagent_amount(R.id)*rand(1,abs(reagent_value))))

					if(pestkiller_reagents[R.id])
						reagent_value = pestkiller_reagents[R.id]
						if(reagent_value > 0)
							if(reagent_value < 1)
								pestlevel += reagent_value
							else
								pestlevel += round(S.reagents.get_reagent_amount(R.id)*rand(1,reagent_value))
						else
							if(reagent_value > -1)
								pestlevel += reagent_value
							else
								pestlevel -= abs(round(S.reagents.get_reagent_amount(R.id)*rand(1,abs(reagent_value))))

					if(beneficial_reagents[R.id])
						reagent_value = beneficial_reagents[R.id]
						if(reagent_value > 0)
							if(reagent_value < 1)
								health += reagent_value
							else
								health += round(S.reagents.get_reagent_amount(R.id)*rand(1,reagent_value))
						else
							if(reagent_value > -1)
								health += reagent_value
							else
								health -= abs(round(S.reagents.get_reagent_amount(R.id)*rand(1,abs(reagent_value))))

					if(water_reagents[R.id])
						reagent_value = water_reagents[R.id]
						if(reagent_value > 0)
							if(reagent_value < 1)
								waterlevel += reagent_value
							else
								waterlevel += round(S.reagents.get_reagent_amount(R.id)*rand(1,reagent_value))
						else
							if(reagent_value > -1)
								waterlevel += reagent_value
							else
								waterlevel -= abs(round(S.reagents.get_reagent_amount(R.id)*rand(1,abs(reagent_value))))

					// Mutagen is distinct from the previous types and mostly has a chance of proccing a mutation.
					if(mutagenic_reagents[R.id])
						var/reagent_total = S.reagents.get_reagent_amount(R.id)
						reagent_value = mutagenic_reagents[R.id]+mutation_mod
						if(reagent_total >= reagent_value)
							if(prob(min(reagent_total*reagent_value,100)))
								mutate(reagent_value > 10 ? 2 : 1)

				S.reagents.clear_reagents()

			else
				user << "You can't get any extract out of this plant."
		else
			user << "There's nothing to inject the solution into."

		check_level_sanity()
		updateicon()

	else if (istype(O, /obj/item/seeds))

		if(!seed)

			var/obj/item/seeds/S = O
			user.drop_item(O)

			if(!S.seed)
				user << "The packet seems to be empty. You throw it away."
				del(O)
				return

			user << "You plant the [S.seed.seed_name] [S.seed.seed_noun]."

			if(S.seed.spread == 1)
				msg_admin_attack("[key_name(user)] has planted a creeper packet.")
				var/obj/effect/plant_controller/creeper/PC = new(get_turf(src))
				if(PC)
					PC.seed = S.seed
			else if(S.seed.spread == 2)
				msg_admin_attack("[key_name(user)] has planted a spreading vine packet.")
				var/obj/effect/plant_controller/PC = new(get_turf(src))
				if(PC)
					PC.seed = S.seed
			else
				seed = S.seed //Grab the seed datum.
				dead = 0
				age = 1
				health = seed.endurance
				lastcycle = world.time

			del(O)

			check_level_sanity()
			updateicon()

		else
			user << "\red The [src] already has seeds in it!"

	else if (istype(O, /obj/item/weapon/reagent_containers/spray/plantbgone))
		if(seed)
			health -= rand(5,20)

			if(pestlevel > 0)
				pestlevel -= 2

			if(weedlevel > 0)
				weedlevel -= 3

			toxins += 4

			check_level_sanity()

			visible_message("\red <B>\The [src] has been sprayed with \the [O][(user ? " by [user]." : ".")]")
			playsound(loc, 'sound/effects/spray3.ogg', 50, 1, -6)
			updateicon()
		else
			user << "There's nothing in [src] to spray!"

	else if (istype(O, /obj/item/weapon/minihoe))  // The minihoe
		//var/deweeding
		if(weedlevel > 0)
			user.visible_message("\red [user] starts uprooting the weeds.", "\red You remove the weeds from the [src].")
			weedlevel = 0
			updateicon()
		else
			user << "\red This plot is completely devoid of weeds. It doesn't need uprooting."

	else if (istype(O, /obj/item/weapon/storage/bag/plants))

		attack_hand(user)

		var/obj/item/weapon/storage/bag/plants/S = O
		for (var/obj/item/weapon/reagent_containers/food/snacks/grown/G in locate(user.x,user.y,user.z))
			if(!S.can_be_inserted(G))
				return
			S.handle_item_insertion(G, 1)

	else if ( istype(O, /obj/item/weapon/plantspray) )

		var/obj/item/weapon/plantspray/spray = O
		user.drop_item(O)
		toxins += spray.toxicity
		pestlevel -= spray.pest_kill_str
		weedlevel -= spray.weed_kill_str
		user << "You spray [src] with [O]."
		playsound(loc, 'sound/effects/spray3.ogg', 50, 1, -6)
		del(O)

		check_level_sanity()
		updateicon()

	else if(istype(O, /obj/item/weapon/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		anchored = !anchored
		user << "You [anchored ? "wrench" : "unwrench"] \the [src]."

		//Update atmos feed, if needed.
		if(anchored && closed_system)
			get_connector()

	else if(istype(O, /obj/item/apiary))

		if(seed)
			user << "\red [src] is already occupied!"
		else
			user.drop_item()
			del(O)

			var/obj/machinery/apiary/A = new(src.loc)
			A.icon = src.icon
			A.icon_state = src.icon_state
			A.hydrotray_type = src.type
			del(src)
	return

/obj/machinery/hydroponics/attack_tk(mob/user as mob)

	if(harvest)
		harvest(user)

	else if(dead)
		remove_dead(user)

/obj/machinery/hydroponics/attack_hand(mob/user as mob)

	if(istype(usr,/mob/living/silicon))
		return

	if(harvest)
		harvest(user)
	else if(dead)
		remove_dead(user)

	else
		if(seed && !dead)
			usr << "[src] has \blue [seed.display_name] \black planted."
			if(health <= (seed.endurance / 2))
				usr << "The plant looks \red unhealthy."
		else
			usr << "[src] is empty."
		usr << "Water: [round(waterlevel,0.1)]/100"
		usr << "Nutrient: [round(nutrilevel,0.1)]/10"
		if(weedlevel >= 5)
			usr << "[src] is \red filled with weeds!"
		if(pestlevel >= 5)
			usr << "[src] is \red filled with tiny worms!"
		usr << text ("")

/obj/machinery/hydroponics/verb/close_lid()
	set name = "Toggle Tray Lid"
	set category = "Object"
	set src in view(1)

	if(!usr || usr.stat || usr.restrained())
		return

	closed_system = !closed_system
	usr << "You [closed_system ? "close" : "open"] the tray's lid."
	updateicon()

	if(anchored && closed_system)
		get_connector()

/obj/machinery/hydroponics/soil
	name = "soil"
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "soil"
	density = 0
	use_power = 0
	draw_warnings = 0

/obj/machinery/hydroponics/soil/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/shovel))
		user << "You clear up [src]!"
		del(src)
	else
		..()

/obj/machinery/hydroponics/soil/New()
	..()
	verbs -= /obj/machinery/hydroponics/verb/close_lid

#undef HYDRO_SPEED_MULTIPLIER