/mob/living/proc/ventcrawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Abilities"
	handle_ventcrawl()
	return

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if (layer != TURF_LAYER+0.2)
		layer = TURF_LAYER+0.2
		src << text("\blue You are now hiding.")
	else
		layer = MOB_LAYER
		src << text("\blue You have stopped hiding.")

// Hardsuit interface proc for AI. Defined here so MMIs can also use it.
/mob/living/proc/hardsuit_interface_ai()

	set name = "Open Hardsuit Interface"
	set desc = "Open the hardsuit system interface."
	set category = "Hardsuit"

	var/obj/item/rig_module/module = src.loc

	if(!istype(module) || !module.holder)
		verbs -= /mob/living/proc/hardsuit_interface_ai
		return 0

	if(module.holder.check_power_cost(src, 0, 0, 0, 1))
		ui_interact(src)