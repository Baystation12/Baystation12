/datum/matter_synth
	var/name = "Generic Synthesizer"
	var/max_energy = 60000
	var/recharge_rate = 2000
	var/energy

/datum/matter_synth/New(var/store = 0)
	if(store)
		max_energy = store
	energy = max_energy
	return

/datum/matter_synth/proc/get_charge()
	return energy

/datum/matter_synth/proc/use_charge(var/amount)
	if (energy >= amount)
		energy -= amount
		return 1
	return 0

/datum/matter_synth/proc/add_charge(var/amount)
	energy = min(energy + amount, max_energy)

/datum/matter_synth/proc/emp_act(var/severity)
	use_charge(max_energy * 0.1 / severity)

/datum/matter_synth/medicine
	name = "Medicine Synthesizer"

/datum/matter_synth/nanite
	name = "Nanite Synthesizer"

/datum/matter_synth/metal
	name = "Metal Synthesizer"

/datum/matter_synth/plasteel
	name = "Plasteel Synthesizer"
	max_energy = 10000

/datum/matter_synth/glass
	name = "Glass Synthesizer"

/datum/matter_synth/wood
	name = "Wood Synthesizer"

/datum/matter_synth/plastic
	name = "Plastic Synthesizer"

/datum/matter_synth/wire
	name = "Wire Synthesizer"
	max_energy = 50
	recharge_rate = 2