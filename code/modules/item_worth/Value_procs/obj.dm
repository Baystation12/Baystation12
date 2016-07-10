/obj/Value()
	. = ..()
	for(var/a in contents)
		. += get_value(a)