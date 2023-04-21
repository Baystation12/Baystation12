/obj/item/storage/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon_state = "briefcase"
	item_state = "briefcase"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	allow_slow_dump = TRUE

/obj/item/storage/briefcase/psinull
	name = "\improper Foundation psi-null case"
	desc = "A handsome black leather case designed for carry psi-null implants by Cuchulain Foundation."
	icon_state = "psicase"
	item_state = "psicase"

/obj/item/storage/briefcase/psinull/New()
	..()
	new /obj/item/implantcase/psi(src)
	new /obj/item/implantcase/psi(src)
	new /obj/item/implantcase/psi(src)
	new /obj/item/implanter/psi(src)
	new /obj/item/implantpad(src)
	make_exact_fit()
