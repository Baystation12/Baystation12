/obj/mecha/working/hoverpod
	desc = "Stubby and round, this space-capable craft is an ancient favorite."
	name = "Hover Pod"
	icon_state = "engineering_pod"
	initial_icon = "engineering_pod"
	internal_damage_threshold = 80
	step_in = 4
	step_energy_drain = 400
	max_temperature = 20000
	health = 150
	infra_luminosity = 6
	wreckage = /obj/effect/decal/mecha_wreckage/hoverpod
	cargo_capacity = 5
	max_equip = 3
	var/datum/effect/effect/system/trail/ion_trail
	var/stabilization_enabled = 1

/obj/mecha/working/hoverpod/New()
	..()
	ion_trail = new /datum/effect/effect/system/trail/ion()
	ion_trail.set_up(src)
	ion_trail.start()

//Modified phazon code
/obj/mecha/working/hoverpod/Topic(href, href_list)
	..()
	if (href_list["toggle_stabilization"])
		stabilization_enabled = !stabilization_enabled
		send_byjax(src.occupant,"exosuit.browser","stabilization_command","[stabilization_enabled?"Dis":"En"]able thruster stabilization")
		src.occupant_message("<span class='notice'>Thruster stabilization [stabilization_enabled? "enabled" : "disabled"].</span>")
		return

/obj/mecha/working/hoverpod/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_stabilization=1'><span id="stabilization_command">[stabilization_enabled?"Dis":"En"]able thruster stabilization</span></a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

//No space drifting
/obj/mecha/working/hoverpod/check_for_support()
	//does the hoverpod have enough charge left to stabilize itself?
	if (!has_charge(step_energy_drain))
		ion_trail.stop()
	else
		if (!ion_trail.on)
			ion_trail.start()
		if (stabilization_enabled)
			return 1

	return ..()

//these three procs overriden to play different sounds
/obj/mecha/working/hoverpod/mechturn(direction)
	set_dir(direction)
	//playsound(src,'sound/machines/hiss.ogg',40,1)
	return 1

/obj/mecha/working/hoverpod/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		playsound(src,'sound/machines/hiss.ogg',40,1)
	return result


/obj/mecha/working/hoverpod/mechsteprand()
	var/result = step_rand(src)
	if(result)
		playsound(src,'sound/machines/hiss.ogg',40,1)
	return result


//Hoverpod variants
/obj/mecha/working/hoverpod/combatpod
	desc = "An ancient, run-down combat spacecraft." // Ideally would have a seperate icon.
	name = "Combat Hoverpod"
	health = 200
	internal_damage_threshold = 35
	cargo_capacity = 2
	max_equip = 2

/obj/mecha/working/hoverpod/combatpod/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)


/obj/mecha/working/hoverpod/shuttlepod
	desc = "Who knew a tiny ball could fit three people?"

/obj/mecha/working/hoverpod/shuttlepod/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)
