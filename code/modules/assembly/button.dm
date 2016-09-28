/obj/item/device/assembly/button
	name = "button"
	desc = "A big red button saying \"DO NOT PUSH\"..You better push it."
	icon_state = "button"
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 100, "waste" = 25)
	var/sensitive = 1
	wire_num = 3

	wires = WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND

/obj/item/device/assembly/button/proc/toggle_sensitivity()
	sensitive = !sensitive

/obj/item/device/assembly/button/verb/push_it()
	set name = "Push button"
	set desc = "Do it. I dare you."
	set category = "Object"
	set src in usr

	process_activation()
	if(usr)
		usr.visible_message("<span class='warning'>[usr] pressed \the [src]!</span>", "<span class='notice'>You press \the [src] with a satisfying click!</span>")

	else
		for(var/mob/M in range(1, src))
			M.show_message("<small>Click</small>", 2)

/obj/item/device/assembly/button/holder_attack_self(mob/user)
	if(sensitive)
		push_it()

/obj/item/device/assembly/button/holder_attack_hand()
	if(sensitive > 1)
		push_it()

/obj/item/device/assembly/button/get_data(var/mob/user, var/ui_key)
	var/list/data = list()
	data.Add("Sensitivity Level", sensitive)
	return data

/obj/item/device/assembly/button/Topic(href, href_list)
	if(href_list["option"])
		if(href_list["option"] == "Sensitivity Level")
			switch(sensitive)
				if(0)
					usr << "You set \the [src]'s sensitivity to 'Indirect Pressure'"
					sensitive++
				if(1)
					usr << "You set \the [src]'s sensitivity to 'Minimal Interaction'"
					sensitive++
				if(2)
					usr << "You set \the [src]'s sensitivity to 'Hard-Press only'"
					sensitive = 0
	..()





