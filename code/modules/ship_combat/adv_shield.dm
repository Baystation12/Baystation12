#define PHYSICAL 1
#define ENERGY 2
/obj/machinery/space_battle/shielding
	anchored = 1
	density = 1

/obj/machinery/space_battle/computer/shield
	name = "shield computer"
	desc = "Provides electrical charge to a shield generator."
	screen_icon = "shield_off"
	var/obj/machinery/space_battle/shield_generator/generator

/obj/machinery/space_battle/computer/shield/update_icon()
	if(stat & (BROKEN|NOPOWER))
		..()
		return
	if(generator.use_power == 2)
		screen_icon = "shield_on"
	else
		screen_icon = "shield_off"
	..()

/obj/machinery/space_battle/computer/shield/reconnect()
	for(var/obj/machinery/space_battle/shield_generator/S in world)
		if(S.id_tag == src.id_tag)
			generator = S
			S.computer = src
			break
	..()

/obj/machinery/space_battle/computer/shield/attack_hand(var/mob/user)
	if(stat & (BROKEN|NOPOWER))
		return 0
	if(!(generator && istype(generator)))
		reconnect()
		if(!generator)
			user << "<span class='warning'>\The [src] cannot find a generator to connect to!</span>"
			return 0
	ui_interact(user)

/obj/machinery/space_battle/computer/shield/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	data["online"] = (generator.use_power == 2)
	data["input"] = generator.get_available_power()
	data["power_use"] = generator.active_power_usage
	data["shields_maintained"] = generator.shields_maintained
	data["total_shields"] = generator.shields.len
	data["active_shields"] = generator.active_shields.len
	data["flux_frequency"] = generator.flux_frequency
	data["flux_allocation"] = generator.flux_allocation
	data["flux_rate"] = generator.flux_rate

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
		generator.toggle()
		return 1
	if(href_list["shields_maint"])
		var/new_maintain = input(usr, "Enter a new number of shields to maintain.", "Shield Generator") as num
		new_maintain = between(0, new_maintain, generator.shields.len)
		generator.shields_maintained = new_maintain
		return 1
	if(generator.use_power == 2)
		usr << "<span class='warning'>You have to turn \the [generator] off first!</span>"
		return 1
	if(href_list["freq"])
		var/new_freq = input(usr, "Enter a new flux frequency", "Shield Generator") as num
		new_freq = between(1, new_freq, 10)
		generator.flux_frequency = new_freq
		return 1
	if(href_list["rate"])
		var/new_rate = input(usr, "Enter a new flux rate.", "Shield Generator") as num
		new_rate = max(min(10, new_rate), 1)
		generator.flux_rate = new_rate
		return 1
	if(href_list["allocation"])
		var/new_num = input(usr, "Enter a new power storage allocation amount.", "Shield Generator") as num
		new_num = between(1, new_num, 100)
		generator.flux_allocation = new_num
	return 1


/obj/machinery/space_battle/shield_generator
	name = "shield generator"
	desc = "An advanced shield generator, producing fields of rapidly fluxing plasma-state phoron particles."
	icon_state = "ecm"
	var/obj/machinery/space_battle/computer/shield/computer
	use_power = 1
	var/list/shields = list()
	var/list/active_shields = list()
	var/list/inactive_shields = list()
	var/flux_frequency = 5
	var/flux_rate = 1
	var/shields_maintained = 0
	var/flux_allocation = 1

	var/inactivity_time = 0
	idle_power_usage = 200

/obj/machinery/space_battle/shield_generator/New()
	..()
	if(!linked)
		linked = map_sectors["[z]"]
	if(linked)
		linked.shielding = src
	if(!(src in processing_objects))
		processing_objects.Add(src)

/obj/machinery/space_battle/shield_generator/initialize()
	reconnect()
	for(var/obj/effect/landmark/shield/marker in world)
		if(marker.z == src.z)
			var/obj/effect/adv_shield/shield = new(src)
			shield.dir = marker.dir
			shield.forceMove(get_turf(marker))
			shield.generator = src
			shield.icon_state = "shieldwalloff"
			shields += shield
	if(linked && !linked.shielding)
		linked.shielding = src
	inactive_shields = shields.Copy()

/obj/machinery/space_battle/shield_generator/proc/toggle()
	if(use_power == 2)
		use_power = 1
	else use_power = 2
	if(use_power != 2)
		inactivity_time = world.timeofday
		for(var/S in active_shields)
			var/obj/effect/adv_shield/shield = S
			shield.density = 0
			shield.icon_state = "shieldwalloff"
			shield.damage_taken = 0
		active_shields.Cut()
		inactive_shields = shields.Copy()

/obj/machinery/space_battle/shield_generator/proc/full_recharge()
	for(var/S in inactive_shields)
		var/obj/effect/adv_shield/shield = S
		shield.density = 1
		shield.icon_state = "shieldwall"
	active_shields = shields.Copy()
	inactive_shields.Cut()
	shields_maintained = shields.len

/obj/machinery/space_battle/shield_generator/process()
	..()
	if(stat & BROKEN)
		use_power = 1
		return 0
	else if(use_power == 1 || 0)
		if(active_shields.len < shields_maintained && world.timeofday >= inactivity_time)
			var/obj/effect/adv_shield/S = pick(inactive_shields)
			inactive_shields.Remove(S)
			active_shields.Add(S)
			S.icon_state = "shieldwall"
			S.density = 1
			inactivity_time = world.timeofday+(50*get_efficiency(-1,1))
		active_power_usage = ((active_shields.len*(1+(abs(5-flux_frequency))*0.1)*flux_rate*5) + (flux_allocation*active_shields.len*10)*get_efficiency(-1,1))
		return 1

/obj/machinery/space_battle/shield_generator/proc/get_available_power()
	var/turf/T = src.loc
	var/datum/powernet/powernet
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)	powernet = C.powernet		// find the powernet of the connected cable
	if(powernet)
		return powernet.avail
	return 0

/obj/machinery/space_battle/shield_generator/emp_act(var/severity = 0)
	if(prob(100 / severity))
		flux_frequency = rand(1,10)
		use_power = pick(0,1)
		flux_allocation = rand(1,100)
	..()

/obj/machinery/space_battle/shield_generator/proc/take_damage(var/damage, damage_type = PHYSICAL)
	world << "Shield taking damage: [damage] : [damage_type == PHYSICAL ? "PHYSICAL" : "ENERGY"]"
	if(use_power != 2)
		return 0
	var/modifier = (damage_type == PHYSICAL ? (10-flux_frequency)/5 : (1+flux_frequency)/5)
	damage /= flux_rate
	damage *= modifier
	world << "Shield damage after modifiers: [damage] ([modifier])"
	var/obj/effect/adv_shield/S = pick(shields)
	if(!S.density)
		return 0
	if(S.damage_taken + damage > flux_allocation)
		active_shields.Remove(S)
		inactive_shields.Add(S)
		S.damage_taken = 0
		S.density = 0
		S.icon_state = "shieldwalloff"
	else
		S.damage_taken += damage
	return 1

/obj/effect/landmark/shield
	name = "shield marker"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwall"

/obj/effect/adv_shield
	name = "Flux Shield"
	desc = "A rapid flux field, you feel like touching it would end very badly."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldwalloff"
	density = 0
	anchored = 1
	var/obj/machinery/space_battle/shield_generator/generator
	var/damage_taken = 0
	var/list/affecting = list()

/obj/effect/adv_shield/ex_act()
	icon_state = "shieldwalloff"
	density = 0
	if(src in generator.active_shields)
		generator.active_shields.Remove(src)
		generator.inactive_shields.Add(src)

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
			H.electrocute_act(10, src)
	affecting.Add(AM)
	while(AM)
		if(curtiles >= rand(0,10))
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