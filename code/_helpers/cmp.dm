/proc/cmp_appearance_data(datum/appearance_data/a, datum/appearance_data/b)
	return b.priority - a.priority

/proc/cmp_camera_ctag_asc(obj/machinery/camera/a, obj/machinery/camera/b)
	return sorttext(b.c_tag, a.c_tag)

/proc/cmp_camera_ctag_dsc(obj/machinery/camera/a, obj/machinery/camera/b)
	return sorttext(a.c_tag, b.c_tag)

/proc/cmp_crew_sensor_modifier(crew_sensor_modifier/a, crew_sensor_modifier/b)
	return b.priority - a.priority

/proc/cmp_follow_holder(datum/follow_holder/a, datum/follow_holder/b)
	if(a.sort_order == b.sort_order)
		return sorttext(b.get_name(), a.get_name())

	return a.sort_order - b.sort_order

/proc/cmp_name_or_type_asc(atom/a, atom/b)
	return sorttext(istype(b) || ("name" in b.vars) ? b.name : b.type, istype(a) || ("name" in a.vars) ? a.name : a.type)

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

/proc/cmp_numeric_asc(a,b)
	return a - b

/proc/cmp_numeric_dsc(a,b)
	return b - a

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	var/a_init_order = ispath(a) ? initial(a.init_order) : a.init_order
	var/b_init_order = ispath(b) ? initial(b.init_order) : b.init_order

	return b_init_order - a_init_order	//uses initial() so it can be used on types

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

/proc/cmp_text_asc(a,b)
	return sorttext(b, a)

/proc/cmp_text_dsc(a,b)
	return sorttext(a, b)

/proc/cmp_clientcolor_priority(datum/client_color/A, datum/client_color/B)
	return B.priority - A.priority

/proc/cmp_power_component_priority(obj/item/stock_parts/power/A, obj/item/stock_parts/power/B)
	return B.priority - A.priority

/proc/cmp_fusion_reaction_asc(singleton/fusion_reaction/A, singleton/fusion_reaction/B)
	return A.priority - B.priority

/proc/cmp_fusion_reaction_des(singleton/fusion_reaction/A, singleton/fusion_reaction/B)
	return B.priority - A.priority

/proc/cmp_program(datum/computer_file/program/A, datum/computer_file/program/B)
	return cmp_text_asc(A.filedesc, B.filedesc)

/proc/cmp_emails_asc(datum/computer_file/data/email_account/A, datum/computer_file/data/email_account/B)
	return cmp_text_asc(A.login,B.login)

/proc/cmp_planelayer(atom/A, atom/B)
	return (B.plane - A.plane) || (B.layer - A.layer)

/proc/cmp_mob_key(mob/A, mob/B)
	if (!A && !B)
		return 0

	if (!A && B)
		return -1

	if (A && !B)
		return 1

	return sorttext(B.key, A.key)

/proc/cmp_marking_order(list/A, list/B)
	return A[1] - B[1][1]
