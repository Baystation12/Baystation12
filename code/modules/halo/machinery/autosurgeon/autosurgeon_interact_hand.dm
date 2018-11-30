
/obj/machinery/autosurgeon/attack_hand(var/mob/user)
	if(user == buckled_mob)
		to_chat(user, "<span class='warning'>You cannot reach the controls or unbuckle yourself from where you are!</span>")
		return		//..() //uncomment this to allow the user to unbuckle themselves

	if(user && istype(user))// && can_use(user))
		add_fingerprint(user)
		user.set_machine(src)
		ui_interact(user)

/obj/machinery/autosurgeon/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if (!istype(target))
		return
	if (target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	user.visible_message("<span class='notice'>\The [user] begins placing \the [target] onto \the [src].</span>", "<span class='notice'>You start placing \the [target] onto \the [src].</span>")
	if(!do_after(user, 30, src))
		return
	if(put_mob(target))
		. = ..()

/obj/machinery/autosurgeon/proc/put_mob(mob/living/carbon/M as mob)
	if (stat & (NOPOWER|BROKEN))
		to_chat(usr, "<span class='warning'>[src] is not functioning.</span>")
		return
	if (!istype(M) || !M)
		to_chat(usr, "<span class='danger'>[src] cannot handle such a lifeform!</span>")
		return
	if (buckled_mob)
		to_chat(usr, "<span class='danger'>[src] is already occupied!</span>")
		return
	if (M.abiotic())
		to_chat(usr, "<span class='warning'>Subject may not have abiotic items on.</span>")
		return
	if(allowed_species.len)
		if(!M.species || !(M.species.type in allowed_species))
			to_chat(usr, "<span class='warning'>[src] cannot handle [M]'s species!</span>")
			return

	M.stop_pulling()
	M.forceMove(src.loc)
	add_fingerprint(usr)

	//if someone enters while surgery is ongoing...
	if(active)
		botch_surgery = 1
	return 1
