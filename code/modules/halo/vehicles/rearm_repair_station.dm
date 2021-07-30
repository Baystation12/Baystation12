#define REARM_RESOURCE_DRAIN 20 //Cost to reload 20% of the max rounds in a magazine
#define REPAIR_RESOURCE_DRAIN  30 //Full repair of 1 component
#define REARM_REPAIR_DELAY 10 SECONDS
#define REARM_REPAIR_RANGE 4

/obj/structure/rearm_repair_station
	name = "Rearm / Repair Station"
	desc = "A station to allow for the rearming and repairing of vehicles. Ammunition refill takes time."
	icon = 'code/modules/halo/icons/machinery/rearm_repair_station.dmi'
	icon_state = "human"
	anchored = 1
	density = 0

	var/list/sheets_to_materials = list("steel" = 10,"nanolaminate" = 10)
	var/max_material = 100
	var/material_stored = 0
	var/obj/vehicles/target_vic
	var/next_rearm_repair_tick = 0 //The next time we can perform a rearm/repair tick on our targeted vehicle.

/obj/structure/rearm_repair_station/examine(var/mob/examiner)
	. = ..()
	to_chat(examiner,"<span class = 'notice'>It has [material_stored] out of [max_material] fabrication matter left.</span>")

/obj/structure/rearm_repair_station/attack_hand(var/mob/attacker)
	if(target_vic)
		var/remove_targ = input(attacker,"Stop targeting [target_vic] for rearm / repair?","Rearm/Repair selection","No") in list("Yes","No")
		if(remove_targ == "Yes")
			target_vic = null
			GLOB.processing_objects -= src
		return

	var/list/vics_in_view = list()
	for(var/obj/vehicles/vic in view(attacker,REARM_REPAIR_RANGE))
		vics_in_view += vic
	var/repair_target = input(attacker,"Select a vehicle to rearm/repair","Rearm/Repair selection","Cancel") in vics_in_view + list("Cancel")
	if(repair_target == "Cancel")
		return
	target_vic = repair_target
	to_chat(attacker,"<span class = 'notice'>Rearm and Repair active on [target_vic]</span>")
	GLOB.processing_objects += src

/obj/structure/rearm_repair_station/proc/consume_material(var/amount)
	var/new_mat = material_stored - amount
	if(new_mat < 0)
		return 0
	if(new_mat > max_material)
		new_mat = max_material
	material_stored = new_mat
	return 1

/obj/structure/rearm_repair_station/attackby(var/obj/item/stack/I,var/mob/user)
	if(!istype(I))
		return
	if(material_stored == max_material)
		to_chat(user,"<span class = 'notice'>[src] is full on material.</span>")
		return
	if(I.get_material_name() in sheets_to_materials)
		if(!I.use(1))
			return
		var/to_add = sheets_to_materials[I.get_material_name()]
		consume_material(-to_add)
		to_chat(user,"<span class = 'notice'>[src] processes [I] into [to_add] units of fabricator materials.</span>")

/obj/structure/rearm_repair_station/process()
	if(world.time < next_rearm_repair_tick)
		return
	if(target_vic)
		if(get_dist(src,target_vic) > REARM_REPAIR_RANGE)
			target_vic = null
			GLOB.processing_objects -= src
			return
		var/did_something = 0
		if(target_vic.can_smoke && target_vic.smoke_ammo < target_vic.smoke_ammo_max)
			if(consume_material(REARM_RESOURCE_DRAIN))
				target_vic.smoke_ammo = target_vic.smoke_ammo_max
				did_something = 1
		for(var/m in target_vic.ammo_containers)
			var/obj/item/ammo_magazine/mag = m
			if(mag.stored_ammo.len >= mag.max_ammo)
				continue
			var/create_amt = min(mag.max_ammo-mag.stored_ammo.len,mag.max_ammo/5)
			if(!consume_material(REARM_RESOURCE_DRAIN))
				break
			for(var/i = 0,i<=create_amt,i++)
				mag.stored_ammo += new mag.ammo_type (mag)
			visible_message("<span class = 'notice'>[src] clunks as it refills 20% of [target_vic]'s [mag] ammunition</span>")
			did_something = 1
		for(var/c in target_vic.comp_prof.components + target_vic.comp_prof.vital_components)
			var/obj/item/vehicle_component/comp = c
			if(comp.integrity == initial(comp.integrity))
				continue
			if(!consume_material(REPAIR_RESOURCE_DRAIN))
				break
			comp.integrity_to_restore = initial(comp.integrity)
			comp.finalise_repair()
			visible_message("<span class = 'notice'>[src] hisses as it repairs [target_vic]'s [comp] integrity.</span>")
			did_something = 1
		if(!did_something)
			visible_message("<span class = 'notice'>[src] sounds a time-out warning, citing lack of action and de-targeting [target_vic]</span>")
			target_vic = null
			GLOB.processing_objects -= src
	else
		GLOB.processing_objects -= src //Why are we processing when we have no vehicle???
	next_rearm_repair_tick = world.time + REARM_REPAIR_DELAY
	//take material (steel?), allow selection of vehicle to resupply, take time to resupply / repair

/obj/structure/rearm_repair_station/human
	icon_state = "human"

/obj/structure/rearm_repair_station/covenant
	icon_state = "covenant"