/singleton/vv_set_handler/mob_confused
	handled_type = /mob
	predicates = list(GLOBAL_PROC_REF(is_num_predicate), GLOBAL_PROC_REF(is_non_negative_predicate), GLOBAL_PROC_REF(is_int_predicate))
	handled_vars = list("confused")


/singleton/vv_set_handler/mob_confused/handle_set_var(datum/O, variable, var_value, client)
	var/mob/mob = O
	mob.set_confused(var_value, var_value)
