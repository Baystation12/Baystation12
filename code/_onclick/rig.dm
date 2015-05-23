
#define MIDDLE_CLICK 0
#define ALT_CLICK 1
#define CTRL_CLICK 2
#define MAX_HARDSUIT_CLICK_MODE 2

/client
	var/hardsuit_click_mode = MIDDLE_CLICK

/client/verb/toggle_hardsuit_mode()
	set name = "Toggle Hardsuit Activation Mode"
	set desc = "Switch between hardsuit activation modes."
	set category = "OOC"

	hardsuit_click_mode++
	if(hardsuit_click_mode > MAX_HARDSUIT_CLICK_MODE)
		hardsuit_click_mode = 0

	switch(hardsuit_click_mode)
		if(MIDDLE_CLICK)
			src << "Hardsuit activation mode set to middle-click."
		if(ALT_CLICK)
			src << "Hardsuit activation mode set to alt-click."
		if(CTRL_CLICK)
			src << "Hardsuit activation mode set to control-click."
		else
			src << "Somehow you bugged the system. Setting your hardsuit mode to middle-click."
			hardsuit_click_mode = MIDDLE_CLICK

/mob/living/carbon/human/MiddleClickOn(atom/A)
	if(client && client.hardsuit_click_mode == MIDDLE_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/living/carbon/human/AltClickOn(atom/A)
	if(client && client.hardsuit_click_mode == ALT_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/living/carbon/human/CtrlClickOn(atom/A)
	if(client && client.hardsuit_click_mode == CTRL_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/living/carbon/human/proc/HardsuitClickOn(atom/A)
	if(back)
		var/obj/item/weapon/rig/rig = back
		if(istype(rig) && rig.selected_module)
			if(world.time <= next_move) return 1
			next_move = world.time + 8
			rig.selected_module.engage(A)
			return 1
	return 0

#undef MIDDLE_CLICK
#undef ALT_CLICK
#undef CTRL_CLICK
#undef MAX_HARDSUIT_CLICK_MODE
