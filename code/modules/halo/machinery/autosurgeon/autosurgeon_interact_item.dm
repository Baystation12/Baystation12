
/obj/machinery/autosurgeon/attackby(var/obj/item/I, var/mob/living/user)
	//obj/item/stack/proc/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	var/obj/item/stack/S = I
	if(S && istype(S))
		var/merged = 0
		switch(S.type)
			if(/obj/item/stack/medical/bruise_pack)
				if(!internal_bruise_pack)
					internal_bruise_pack = new()
					internal_bruise_pack.amount = 0
				internal_bruise_pack.amount += S.amount
				S.use(S.amount)
				merged = 1

			if(/obj/item/stack/medical/advanced/bruise_pack)
				if(!internal_bruise_pack)
					internal_bruise_pack = new()
					internal_bruise_pack.amount = 0
				internal_bruise_pack.amount += S.amount
				S.use(S.amount)
				merged = 1

			if(/obj/item/stack/medical/ointment)
				if(!internal_ointment)
					internal_ointment = new()
					internal_ointment.amount = 0
				internal_ointment.amount += S.amount
				S.use(S.amount)
				merged = 1

			if(/obj/item/stack/medical/advanced/ointment)
				if(!internal_ointment)
					internal_ointment = new()
					internal_ointment.amount = 0
				internal_ointment.amount += S.amount
				S.use(S.amount)
				merged = 1

			if(/obj/item/stack/medical/splint)
				if(!internal_splint)
					internal_splint = new()
					internal_splint.amount = 0
				internal_splint.amount += S.amount
				S.use(S.amount)
				merged = 1
		if(merged)
			if(S.amount > 0)
				to_chat(user,"<span class='info'>You stock up [src] with [S]. It is full.</span>")
			else
				to_chat(user,"<span class='info'>You stock up [src] with [S].</span>")
