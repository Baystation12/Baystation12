/obj/machinery/vending/tool/adherent
	name = "\improper Adherent Tools"
	desc = "This looks like a heavily modified vending machine. It contains technology that doesn't appear to be human in origin."
	icon_state = "adh-tool"
	icon_deny = "adh-tool-deny"
	icon_vend = "adh-tool-vend"
	product_ads = {"\
		\[C#\]\[Cb\]\[Db\]. \[Ab\]\[A#\]\[Bb\]. \[E\]\[C\]\[Gb\]\[B#\]. \[C#\].;\
		\[Cb\]\[A\]\[F\]\[Cb\]\[C\]\[E\]\[Cb\]\[E\]\[Fb\]. \[G#\]\[C\]\[Ab\]\[A\]\[C#\]\[B\]. \[Eb\]\[choral\]. \[E#\]\[C#\]\[Ab\]\[E\]\[C#\]\[Fb\]\[Cb\]\[F#\]\[C#\]\[Gb\].\
	"}
	products = list(
		/obj/item/weldingtool/electric/crystal = 5,
		/obj/item/wirecutters/crystal = 5,
		/obj/item/screwdriver/crystal = 5,
		/obj/item/crowbar/crystal = 5,
		/obj/item/wrench/crystal = 5,
		/obj/item/device/multitool/crystal = 5,
		/obj/item/storage/belt/utility/crystal = 5,
		/obj/item/storage/toolbox/crystal = 5
	)


/obj/machinery/vending/tool/adherent/vend(datum/stored_items/vending_products/products, mob/living/carbon/user)
	if (emagged || istype(user) && user.species.name == SPECIES_ADHERENT)
		return ..()
	to_chat(user, SPAN_WARNING("\The [src] emits a discordant chime."))
