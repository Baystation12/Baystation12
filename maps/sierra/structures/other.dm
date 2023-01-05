/obj/structure/bookcase/manuals/security
	name = "Law Manuals bookcase"

/obj/structure/bookcase/manuals/security/New()
		..()
		new /obj/item/book/manual/detective(src)
		new /obj/item/book/manual/nt_regs(src)
		new /obj/item/book/manual/solgov_law(src)
		new /obj/item/book/manual/nt_sop(src)
		new /obj/item/book/manual/nt_tc(src)
		new /obj/item/book/manual/military_law(src)
		update_icon()
