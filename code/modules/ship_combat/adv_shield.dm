
#define CURRENT_FLUX_UPDATE round(min(max_flux_rate, (0.1 * flux_per_tick) + current_flux_rate), 0.01)
#define OPTIMAL_FLUX_UPDATE min(0.15 + optimal_flux_rate, max_flux_rate)
#define MAX_FLUX_UPDATE min(round(max(20, max_flux_rate + (1 * (0.5+current_flux_rate / (optimal_flux_rate ? optimal_flux_rate : 0.15)))), 0.01), optimal_flux_rate*2.5)

/obj/machinery/space_battle/shielding
	anchored = 1
	density = 1

/obj/machinery/space_battle/computer/shield
	name = "shield computer"
	desc = "Provides electrical charge to a shield generator."
	screen_icon = "shield_off"
	var/obj/machinery/space_battle/shield_generator/generator

/obj/machinery/space_battle/computer/shield/initialize()
	..()
	find_generator()

/obj/machinery/space_battle/computer/shield/update_icon()
	if(stat & (BROKEN|NOPOWER))
		..()
		return
	if(generator.online)
		if(generator.static_shield)
			screen_icon = "shield_maintain"
		else
			screen_icon = "shield_on"
	else
		screen_icon = "shield_off"
	..()

/obj/machinery/space_battle/computer/shield/proc/find_generator()
	for(var/obj/machinery/space_battle/shield_generator/S in world)
		if(S.id_tag == src.id_tag)
			generator = S
			S.computer = src
			break

/obj/machinery/space_battle/computer/shield/attack_hand(var/mob/user)
	if(stat & (BROKEN|NOPOWER))
		return 0
	if(!(generator && istype(generator)))
		find_generator()
		if(!generator)
			user << "<span class='warning'>\The [src] cannot find a generator to connect to!</span>"
			return 0
	ui_interact(user)

/obj/machinery/space_battle/computer/shield/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	data["flux_cost"] = generator.get_cost()
	data["input"] = generator.get_available_power()
	data["flux_capacity"] = round(generator.flux_capacity)
	data["max_flux_capacity"] = generator.max_flux_capacity
	data["static"] = generator.static_shield
	data["online"] = generator.online
	data["flux_optimal"] = generator.optimal_flux_rate
	data["flux_max"] = generator.max_flux_rate
	data["flux_current"] = generator.current_flux_rate
	data["generation_speed"] = generator.flux_per_tick
	data["max_generation_speed"] = generator.max_flux_per_tick
	data["shield_count"] = generator.shields.len
	data["damage_count"] = generator.shields.len - generator.damaged_shields.len
	data["feedback"] = generator.feedback
	data["max_feedback"] = generator.max_feedback
	data["shield_flux"] = generator.get_shield_rate()
	data["shield_max_flux"] = generator.get_shield_capacity()
	data["maintaining"] = generator.maintaining_num

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "adv_shield.tmpl", "Ship Shields", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/space_battle/computer/shield/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["toggle"])
		generator.online = !generator.online
	if(href_list["fps"])
		if(generator.flux_per_tick == generator.max_flux_per_tick)
			generator.flux_per_tick = 1
		else generator.flux_per_tick += 1
	if(href_list["static"])
		generator.static_shield = !generator.static_shield
	if(href_list["capacity"])
		var/new_capacity = input(usr, "Enter a new generator capacity.", "Shield Generator") as num
		new_capacity = between(10, new_capacity, 100000)
		generator.max_flux_capacity = new_capacity
	if(href_list["shield_capacity"])
		var/new_capacity = input(usr, "Enter a new shield capacity.", "Shield Generator") as num
		new_capacity = between(10, new_capacity, 500)
		for(var/obj/effect/adv_shield/shield in generator.shields)
			shield.max_flux_capacity = new_capacity
	if(href_list["shield_rate"])
		var/new_rate = input(usr, "Enter a new flux rate.", "Shield Generator") as num
		new_rate = between(0.1, new_rate, generator.max_flux_rate)
		for(var/obj/effect/adv_shield/shield in generator.shields)
			shield.current_flux_rate = new_rate
	if(href_list["maintaining"])
		var/new_num = input(usr, "Enter a new shield amount to support.", "Shield Generator") as num
		new_num = between(0, new_num, generator.shields.len)
		generator.maintaining_num = new_num

	return 1


/obj/machinery/space_battle/shield_generator
	name = "shield generator"
	desc = "An advanced shield generator, producing fields of rapidly fluxing plasma-state phoron particles."
	icon_state = "ecm"
	var/obj/machinery/space_battle/computer/shield/computer
	var/datum/powernet/powernet
	var/online = 0
	idle_power_usage = 500
	//RECHARGING
	var/current_flux_rate = 0 // Increases depending on power input
	var/optimal_flux_rate = 0 // Increases depending on flux rate
	var/max_flux_rate = 25 // Increases depending on the ratio of current to optimal flux.
	var/flux_per_tick = 5 // Generation modifier.
	var/max_flux_per_tick = 10
	//DISTRIBUTION
	var/flux_capacity = 0 // Still needs to be maintained, but at a fifth of the cost of generating flux.
	var/max_flux_capacity = 500 // Set by the computer.
	var/list/shields = list()
	var/static_shield = 0
	var/maintaining_num = 0
	//MAINTENANCE
	var/max_feedback = 150 // The maximum amount of feedback the generator can sustain.
	var/feedback = 0 // Overheating. Once this exceeds the max_feedback, all feedback is discharged.
	var/feedback_dissipation = 1 // Amount of feedback dissipated per tick. Modified by intake of inert gases.
	var/obj/machinery/atmospherics/pipe/tank/shield/gas_tank
	var/list/damaged_shields = list()

/obj/machinery/space_battle/shield_generator/New()
	..()
	locate_tank()
	if(linked)
		linked.shielding = src

/obj/machinery/space_battle/shield_generator/initialize()
	for(var/obj/effect/landmark/shield/marker in world)
		if(marker.z == src.z)
			var/obj/effect/adv_shield/shield = new(src)
			shield.dir = marker.dir
			shield.forceMove(get_turf(marker))
			shields += shield
	for(var/obj/effect/adv_shield/placed_shield in shields)
		placed_shield.update_connections()
	if(linked && !linked.shielding)
		linked.shielding = src


/obj/machinery/space_battle/shield_generator/process()
	if(stat & (BROKEN|NOPOWER))
		online = 0
	var/powered = 0
	var/turf/T = src.loc
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)	powernet = C.powernet		// find the powernet of the connected cable
	if(online)
		powered = powernet ? powernet.avail : 0
		if(!powered)
			online = 0
			visible_message("<span class='warning'>\icon[src] \The [src] beeps, \"Warning! Power intake insufficient! Shutting down.\"</span>")
	var/cost = update_flux(powered) // Will be used for capacitors later.
	powernet.draw_power(cost)
	update_feedback()
	..()

/obj/machinery/space_battle/shield_generator/proc/get_cost()
	return round((current_flux_rate * 10 * flux_per_tick * get_efficiency(-1,1)) + (flux_capacity *  2 * get_efficiency(-1,1)), 1)

/obj/machinery/space_battle/shield_generator/proc/get_shield_rate()
	var/obj/effect/adv_shield/shield = shields[1]
	if(shield && istype(shield))
		return shield.current_flux_rate

/obj/machinery/space_battle/shield_generator/proc/get_shield_capacity()
	var/obj/effect/adv_shield/shield = shields[1]
	if(shield && istype(shield))
		return shield.max_flux_capacity

/obj/machinery/space_battle/shield_generator/proc/get_available_power()
	var/turf/T = src.loc

	var/obj/structure/cable/C = T.get_cable_node()
	if(C)	powernet = C.powernet		// find the powernet of the connected cable
	if(powernet)
		return powernet.avail
	return 0

/obj/machinery/space_battle/shield_generator/proc/locate_tank()
	if(gas_tank && istype(gas_tank)) return
	gas_tank = locate() in orange(1)
	if(gas_tank)
		gas_tank.generator = src

/obj/machinery/space_battle/shield_generator/proc/update_flux(var/power_input = 1)
	var/current_flux_cost = get_cost()
	if(power_input > current_flux_cost && online)
		if(!static_shield)
			current_flux_rate = CURRENT_FLUX_UPDATE
		max_flux_rate = MAX_FLUX_UPDATE
		optimal_flux_rate = OPTIMAL_FLUX_UPDATE
		flux_capacity += current_flux_rate
	else
		current_flux_rate = max(0, current_flux_rate - rand(0.1,1))
		optimal_flux_rate = max(5, current_flux_rate - rand(0,0.5))
		max_flux_rate = max(20, current_flux_rate - rand(0, 0.5))
		flux_capacity = max(0, flux_capacity - rand(0,10))

	for(var/obj/effect/adv_shield/S in shields)
		if(S.shield_process() != 1 && !S in damaged_shields) // If it's damaged,
			damaged_shields.Add(S)  // Store it for later.
	for(var/obj/effect/adv_shield/shield in damaged_shields)
		if(shields.Find(shield) > maintaining_num) continue
		if(flux_capacity <= 0)
			break
		flux_capacity = shield.charged(flux_capacity)
		if(shield.flux_capacity == shield.max_flux_capacity && shield.shutdown_time > 0)
			damaged_shields.Cut(damaged_shields.Find(shield), (damaged_shields.Find(shield)+1)) // Cut it out of here.

	if(flux_capacity > max_flux_capacity)
		feedback += min(10, (max_flux_capacity - flux_capacity))
		flux_capacity = max_flux_capacity

	return current_flux_cost


/obj/machinery/space_battle/shield_generator/proc/consume_flux(var/amount, var/obj/effect/adv_shield/user)
	if(user)
		var/index = shields.Find(user)
		if(index > maintaining_num)
			return amount
	var/diff = amount
	amount = max(0, amount-flux_capacity)
	diff = diff - amount
	flux_capacity -= diff
	return amount

/obj/machinery/space_battle/shield_generator/proc/update_feedback()
	if(feedback <= 0)
		feedback = 0
		return
	if(flux_capacity > max_flux_capacity)
		var/extra_feedback = flux_capacity
		flux_capacity = max_flux_capacity
		extra_feedback = extra_feedback - flux_capacity
		feedback += extra_feedback
	feedback -= feedback_dissipation
	if(feedback && gas_tank)
		//Cooled gases aid in negating feedback
		var/datum/gas_mixture/removed = gas_tank.fetch_gas(5, list("nitrogen", "carbon_dioxide", "oxygen"))
		var/pressure_modifier = round(removed.total_moles / 5)
		var/temperature_modifier = (removed.temperature < T0C ? abs(removed.temperature) / 2 : 0)
		feedback -= 1*pressure_modifier*temperature_modifier
		loc.assume_air(removed)

	if(feedback >= max_feedback) // We're running too hot!
		if(prob(feedback))
			if(powernet) // Discharge all the feedback into the grid.
				for(var/obj/machinery/power/terminal/terminal in powernet.nodes)
					if(feedback <= 0)
						feedback = 0
						break
					if(istype(terminal.master, /obj/machinery/power/apc))
						var/obj/machinery/power/apc/A = terminal.master
						if (prob(75))
							A.overload_lighting()
							feedback -= rand(1,5)
						if (prob(50))
							A.set_broken()
							feedback -= rand(3,15)
						if(prob(95))
							A.energy_fail(rand(20,100))
							feedback -= rand(2,10)
			if(feedback) // We couldn't discharge enough into the grid.	Fry anybody on the ship.
				for(var/mob/living/carbon/human/H)
					if(feedback <= 0)
						feedback = 0
						break
					if(!(H.stat || istype(get_turf(H), /turf/space))) // Cant reach them in space
						var/num = rand(1, feedback)
						H.electrocute_act(num, src)
						feedback -= num

/obj/machinery/space_battle/shield_generator/emp_act(var/severity = 0)
	if(severity == 1)
		online = pick(1,0)
		current_flux_rate /= 2
		optimal_flux_rate /= 2
		max_flux_rate /= 2
		flux_capacity = rand(0, flux_capacity)
		static_shield = pick(0,1)
		maintaining_num = rand(1,shields.len)
		feedback += rand(0,50)

/obj/effect/landmark/shield
	name = "shield marker"
	icon_state = "shieldwall"

/obj/effect/adv_shield
	name = "Flux Shield"
	desc = "A rapid flux field, you feel like touching it would end very badly."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwall"
	density = 1
	anchored = 1
	var/current_flux_rate = 0
	var/flux_capacity = 0
	var/max_flux_capacity = 5

	var/list/affecting = list()
	var/obj/machinery/space_battle/shield_generator/generator
	var/shutdown_time = 0

	New(var/obj/machinery/space_battle/shield_generator/created_by)
		..()
		generator = created_by

	Destroy()
		if(generator)
			generator.shields.Cut(generator.shields.Find(src), (generator.shields.Find(src)+1))
			generator = null
		if(affecting.len)
			for(var/mob/M in affecting)
				M.canmove = 1
			affecting.Cut()
		return ..()

	proc/die()
		icon_state = "shieldwall_off"
		shutdown_time =	world.timeofday + 400
		if(!(src in generator.damaged_shields))
			generator.damaged_shields += src
		density = 0

//Returns 0 if it's dead, 1 if it's fine, 2 if it needs charging.
/obj/effect/adv_shield/proc/shield_process()
	if(shutdown_time > 0 && shutdown_time <= world.timeofday)
		shutdown_time = 0
		icon_state = "shieldwall"
		density = 1
	if(shutdown_time > 0) return 0
	return consume_flux(current_flux_rate*0.1 + flux_capacity*0.05) // Maintain our status

/obj/effect/adv_shield/proc/consume_flux(var/amount = 0)
	if(!generator)
		qdel(src)
		return 0
	var/absorbed = generator.consume_flux(amount, src) // See if the generator will help us out
	amount -= absorbed
	if(amount) // Looks like we need to use our own storage.
		flux_capacity -= amount
	if(flux_capacity <= 0) // We're dead.
		flux_capacity = 0
		die()
		return 0
	return flux_capacity < max_flux_capacity ? 2 : 1

//If the shield is on and the flux rate is high enough, it'll block the shot entirely even if the shield dies afterwards.
//Returns 0 if blocked
/obj/effect/adv_shield/proc/take_damage(var/damage)
	if(!density || current_flux_rate < damage)
		return 1
	else
		consume_flux(damage)
		return 0

//The generator is attempting to repair us. Return the amount given minus what was used.
/obj/effect/adv_shield/proc/charged(var/flux_rate)
	if(flux_capacity < max_flux_capacity)
		var/diff = flux_capacity
		flux_capacity = between(flux_capacity, flux_capacity+(max_flux_capacity - flux_capacity), flux_rate)
		diff = flux_capacity - diff
		return flux_rate - diff > 0 ? flux_rate - diff : 0



// Shameless copy pasta.
/obj/effect/adv_shield/Bump(A as mob|obj) // Gets flung out.
	if(!A || !istype(A, /atom/movable))
		return
	var/atom/movable/AM = A
	var/curtiles = 0
	for(var/obj/effect/adv_shield/S in orange(2, src))
		if(AM in S.affecting)
			return
	if(ismob(AM))
		var/mob/M = AM
		M.canmove = 0
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/damage = H.electrocute_act(current_flux_rate, src)
			consume_flux(damage*20)
	affecting.Add(AM)
	while(AM)
		if(curtiles >= current_flux_rate)
			break
		if(AM.z != src.z)
			break
		curtiles++
		sleep(1)

		var/predir = AM.dir
		step(AM, dir)
		AM.set_dir(predir)

	affecting.Remove(AM)

	if(ismob(AM))
		var/mob/M = AM
		M.canmove = 1

/obj/effect/adv_shield/proc/update_connections()
	var/list/neighbours = list()
	for(var/obj/effect/adv_shield/S in orange(src, 1))
		neighbours += get_dir(src, S)
//	var/image/I
//	for(var/i=1 to 4)
//		I = image('icons/effects/effects.dmi', "[icon_state][neighbours[i]]", dir = 1<<(i-1))
//		overlays += I


//Has an automatic filter. If you do not wish to modify temperature, you can simply combine the gases into one tank.
/obj/machinery/atmospherics/pipe/tank/shield
	name = "shield gas tank"
	desc = "Holds gases for use in a shield generator."
	var/obj/machinery/space_battle/shield_generator/generator

/obj/machinery/atmospherics/pipe/tank/shield/proc/fetch_gas(var/amount, var/list/desired_gases)
	var/datum/gas_mixture/air_contents = src.return_air()
	var/transfer_moles = amount * air_contents.volume/max(air_contents.temperature * R_IDEAL_GAS_EQUATION, 0,01)
	if(transfer_moles > air_contents.total_moles)
		return 0
	var/datum/gas_mixture/removed = new()
	filter_gas(src, desired_gases, air_contents, removed, transfer_moles)
	return removed