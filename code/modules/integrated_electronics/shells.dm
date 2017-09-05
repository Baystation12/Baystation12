/obj/item/electronic_assembly_shell
	name = "plastic shell"
	w_class = 1
	matter = list("plastic" = 100)
	var/applied_description

/obj/item/electronic_assembly_shell/proc/can_apply_shell(var/obj/item/device/electronic_assembly/assembly, var/mob/user)
	if(!istype(assembly))
		to_chat(user, "<span class='warning'>This is not an assembly.</span>")
		return FALSE
	if(w_class < assembly.w_class)
		to_chat(user, "<span class='warning'>This shell is too small for the assembly.</span>")
		return FALSE
	if(w_class > assembly.w_class)
		to_chat(user, "<span class='warning'>This shell is too large for the assembly.</span>")
		return FALSE
	return TRUE

/obj/item/electronic_assembly_shell/hand_teleporter
	icon = 'icons/obj/device.dmi'
	icon_state = "hand_tele"
	applied_description = "A portable item which likely has one or more uses for antennas."
	w_class = 2
