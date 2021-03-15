/obj/item/flame/candle/scented
	name = "scented candle"
	desc = "A candle which releases pleasant-smelling oils into the air when burned."

	var/scent //for the desc
	var/decl/scent_type/style
	var/list/scent_types = list(/decl/scent_type/rose,
								/decl/scent_type/cinnamon,
								/decl/scent_type/vanilla,
								/decl/scent_type/seabreeze,
								/decl/scent_type/lavender)

/obj/item/flame/candle/scented/Initialize()
	. = ..()
	get_scent()

/obj/item/flame/candle/scented/attack_self(mob/user as mob)
	..()
	if(!lit)
		remove_extension(src, /datum/extension/scent)

/obj/item/flame/candle/scented/extinguish(var/mob/user, var/no_message)
	..()
	remove_extension(src, /datum/extension/scent)

/obj/item/flame/candle/scented/light(mob/user)
	..()
	if(lit)
		set_extension(src, style.scent_datum)

/obj/item/flame/candle/scented/proc/get_scent()
	var/scent_type = DEFAULTPICK(scent_types, null)
	if(scent_type)
		style = decls_repository.get_decl(scent_type)
		color = style.color
		scent = style.scent
	if(scent)
		desc += " This one smells of [scent]."
	update_icon()

/obj/item/storage/candle_box/scented
	name = "scented candle box"
	desc = "An unbranded pack of scented candles, in a variety of scents."
	max_storage_space = 5

	startswith = list(/obj/item/flame/candle/scented = 5)