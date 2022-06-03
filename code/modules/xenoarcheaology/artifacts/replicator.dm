/obj/machinery/replicator
	name = "alien machine"
	desc = "It's some kind of pod with strange wires and gadgets all over it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "borgcharger0(old)"
	density = TRUE

	idle_power_usage = 100
	active_power_usage = 1000

	var/spawn_progress_time = 0
	var/max_spawn_time = 50
	var/last_process_time = 0

	var/list/construction = list()
	var/list/spawning_types = list()
	var/list/stored_materials = list()

	var/fail_message

/obj/machinery/replicator/New()
	..()

	var/list/viables = list(
	/obj/item/roller,
	/obj/structure/closet/crate,
	/obj/structure/closet/acloset,
	/mob/living/simple_animal/hostile/mimic,
	/mob/living/simple_animal/hostile/viscerator,
	/mob/living/simple_animal/hostile/hivebot,
	/obj/item/device/scanner/gas,
	/obj/item/device/camera,
	/obj/item/device/flash,
	/obj/item/device/flashlight,
	/obj/item/device/scanner/health,
	/obj/item/device/multitool,
	/obj/item/device/paicard,
	/obj/item/device/radio,
	/obj/item/device/radio/headset,
	/obj/item/autopsy_scanner,
	/obj/item/bikehorn,
	/obj/item/bonesetter,
	/obj/item/material/knife/kitchen/cleaver,
	/obj/item/caution,
	/obj/item/caution/cone,
	/obj/item/crowbar,
	/obj/item/material/clipboard,
	/obj/item/cell/standard,
	/obj/item/circular_saw,
	/obj/item/material/hatchet,
	/obj/item/handcuffs,
	/obj/item/hemostat,
	/obj/item/material/knife/kitchen,
	/obj/item/flame/lighter,
	/obj/item/light/bulb,
	/obj/item/light/tube,
	/obj/item/pickaxe,
	/obj/item/shovel,
	/obj/item/weldingtool,
	/obj/item/wirecutters,
	/obj/item/wrench,
	/obj/item/screwdriver,
	/obj/item/grenade/chem_grenade/cleaner,
	/obj/item/grenade/chem_grenade/metalfoam)

	var/quantity = rand(5, 15)
	for(var/i=0, i<quantity, i++)
		var/button_desc = "a [pick("yellow","purple","green","blue","red","orange","white")], "
		button_desc += "[pick("round","square","diamond","heart","dog","human")] shaped "
		button_desc += "[pick("toggle","switch","lever","button","pad","hole")]"
		var/type = pick(viables)
		viables.Remove(type)
		construction[button_desc] = type

	fail_message = "<span class='notice'>[icon2html(src, viewers(get_turf(src)))] a [pick("loud","soft","sinister","eery","triumphant","depressing","cheerful","angry")] \
		[pick("horn","beep","bing","bleep","blat","honk","hrumph","ding")] sounds and a \
		[pick("yellow","purple","green","blue","red","orange","white")] \
		[pick("light","dial","meter","window","protrusion","knob","antenna","swirly thing")] \
		[pick("swirls","flashes","whirrs","goes schwing","blinks","flickers","strobes","lights up")] on the \
		[pick("front","side","top","bottom","rear","inside")] of [src]. A [pick("slot","funnel","chute","tube")] opens up in the \
		[pick("front","side","top","bottom","rear","inside")].</span>"

/obj/machinery/replicator/Process()
	if(spawning_types.len && !(stat & NOPOWER))
		spawn_progress_time += world.time - last_process_time
		if(spawn_progress_time > max_spawn_time)
			src.visible_message("<span class='notice'>[icon2html(src, viewers(get_turf(src)))] [src] pings!</span>")

			var/obj/source_material = pop(stored_materials)
			var/spawn_type = pop(spawning_types)
			var/obj/spawned_obj = new spawn_type(src.loc)
			if(source_material)
				if(length(source_material.name) < MAX_MESSAGE_LEN)
					spawned_obj.SetName("[source_material] " +  spawned_obj.name)
				if(length(source_material.desc) < MAX_MESSAGE_LEN * 2)
					if(spawned_obj.desc)
						spawned_obj.desc += " It is made of [source_material]."
					else
						spawned_obj.desc = "It is made of [source_material]."
				qdel(source_material)

			spawn_progress_time = 0
			max_spawn_time = rand(30,100)

			if(!spawning_types.len || !stored_materials.len)
				update_use_power(POWER_USE_IDLE)
				icon_state = "borgcharger0(old)"

		else if(prob(5))
			src.visible_message("<span class='notice'>[icon2html(src, viewers(get_turf(src)))] [src] [pick("clicks","whizzes","whirrs","whooshes","clanks","clongs","clonks","bangs")].</span>")

	last_process_time = world.time

/obj/machinery/replicator/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/replicator/interact(mob/user)
	var/dat = "The control panel displays an incomprehensible selection of controls, many with unusual markings or text around them.<br>"
	dat += "<br>"
	for(var/index=1, index<=construction.len, index++)
		dat += "<A href='?src=\ref[src];activate=[index]'>\[[construction[index]]\]</a><br>"

	show_browser(user, dat, "window=alien_replicator")

/obj/machinery/replicator/attackby(obj/item/W as obj, mob/living/user as mob)
	if(!user.unEquip(W, src))
		return
	stored_materials.Add(W)
	src.visible_message("<span class='notice'>\The [user] inserts \the [W] into \the [src].</span>")

/obj/machinery/replicator/OnTopic(user, href_list)
	if(href_list["activate"])
		var/index = text2num(href_list["activate"])
		if(index > 0 && index <= construction.len)
			if(stored_materials.len > spawning_types.len)
				if(spawning_types.len)
					src.visible_message("<span class='notice'>[icon2html(src, viewers(get_turf(src)))] a [pick("light","dial","display","meter","pad")] on [src]'s front [pick("blinks","flashes")] [pick("red","yellow","blue","orange","purple","green","white")].</span>")
				else
					src.visible_message("<span class='notice'>[icon2html(src, viewers(get_turf(src)))] [src]'s front compartment slides shut.</span>")

				spawning_types.Add(construction[construction[index]])
				spawn_progress_time = 0
				update_use_power(POWER_USE_ACTIVE)
				icon_state = "borgcharger1(old)"
			else
				src.visible_message(fail_message)
		. = TOPIC_REFRESH
