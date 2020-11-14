/////////
// debug apcs
/////////
/obj/machinery/power/apc/debug
	cell_type = /obj/item/weapon/cell/infinite

/////////
// toc apc
/////////
/obj/machinery/power/apc/hyper/toc
	req_access = list(list(access_engine_equip, access_bridge))
	emp_hardened = 1

/////////
// Skrell Solars
/////////

/obj/machinery/power/solar/skrell
	name = "improved solar panel"
	efficiency = 85 //incredibly high until a reactor is mapped in for the scout ship.

/////////
// Vox Point-Defence
/////////
/obj/machinery/pointdefense/ramshackle
	name = "ramshackle point defense battery"
	desc = "A Kuiper pattern anti-meteor battery. Capable of destroying most threats in a single salvo. \
	This one appears to be in a rather horrible state of disrepair."
	initial_id_tag = "voxpd"

/obj/machinery/pointdefense_control/ramshackle
	name = "old targeting matrix"
	desc = "A specialized computer designed to synchronize a variety of weapon systems to fire at a singular target. \
	This one appears to be in a rather horrible state of disrepair."
	initial_id_tag = "voxpd"

/////////
// coffee
/////////
/obj/machinery/chemical_dispenser/tac_coffee
	name = "old coffee maker"
	desc = "Singlehandedly kicking ass for just as long as the ship. Probably older than you."
	icon = 'icons/boh/structures/coffee.dmi'
	icon_state = "coffee_dispenser"
	ui_title = "Coffee Dispenser"
	accept_drinking = 1
	core_skill = SKILL_COOKING
	can_contaminate = FALSE //See above.

/obj/machinery/chemical_dispenser/tac_coffee/full
	spawn_cartridges = list(
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/coffee_old,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/cream
		)

/obj/machinery/chemical_dispenser/tac_coffee/full/good
	name = "coffee maker"
	spawn_cartridges = list(
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/cream
		)

/////////
// iccg
/////////
/obj/machinery/power/apc/hyper/iccg
	emp_hardened = 1

//pd
/obj/machinery/pointdefense_control/iccg
	name = "targeting matrix"
	desc = "A specialized computer designed to synchronize a variety of weapon systems to fire at a singular target."
	initial_id_tag = "iccgpd"

/obj/machinery/pointdefense/iccg
	name = "point defense battery"
	desc = "A Kuiper pattern anti-meteor battery. Capable of destroying most threats in a single salvo."
	initial_id_tag = "iccgpd"

/////////
// Vox Bioreactor
/////////
//temp
/obj/machinery/power/ascent_reactor/vox
	name = "bio fusion stack"
	desc = "A tall, gleaming assemblage of advanced alien machinery. It hums and crackles with restrained power."
	icon = 'icons/obj/machines/power/fusion_core.dmi'
	icon_state = "core1"
	color = COLOR_DARK_GREEN_GRAY
	output_power = 15 KILOWATTS //Temp number to make up for the fact that I'm too out of it to actually add a proper bio reactor rn. -Carl

/obj/machinery/power/ascent_reactor/attack_hand(mob/user)
	. = ..()

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.name != SPECIES_VOX && H.species.name != SPECIES_VOX_ARMALIS)
			to_chat(H, SPAN_WARNING("You have no idea how to use \the [src]."))
			return

	user.visible_message(SPAN_NOTICE("\The [user] switches \the [src] [on ? "off" : "on"]."))
	on = !on
	update_icon()

/obj/machinery/power/ascent_reactor/vox/on_update_icon()
	. = ..()

	if(!field_image)
		field_image = image(icon = 'icons/obj/machines/power/fusion.dmi', icon_state = "emfield_s1")
		field_image.color = COLOR_BOTTLE_GREEN
		field_image.alpha = 50
		field_image.layer = SINGULARITY_LAYER
		field_image.appearance_flags |= RESET_COLOR

		var/matrix/M = matrix()
		M.Scale(3)
		field_image.transform = M

	if(on)
		overlays |= field_image
		set_light(0.8, 1, 6, l_color = COLOR_BOTTLE_GREEN)
		icon_state = "core1"
	else
		overlays -= field_image
		set_light(0)
		icon_state = "core0"

/obj/machinery/power/ascent_reactor/vox/Initialize()
	. = ..()
	update_icon()

/obj/machinery/power/ascent_reactor/vox/Process()
	if(on)
		add_avail(output_power)