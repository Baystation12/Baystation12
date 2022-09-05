/obj/item/paper/talisman/emp
	talisman_name = "emp"
	talisman_desc = "invokes a localized EMP effect on the target. Can be used on machinery or mobs"
	talisman_sound = 'sound/effects/EMPulse.ogg'
	valid_target_type = list(
		/mob,
		/obj/machinery
	)


/obj/item/paper/talisman/emp/invoke(atom/target, mob/user)
	target.emp_act(1)
