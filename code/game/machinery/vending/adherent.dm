/obj/machinery/vending/tool/adherent
	name = "\improper Adherent Tool Dispenser"
	desc = "This looks like a heavily modified vending machine. It contains technology that doesn't appear to be human in origin."
	product_ads = "\[C#\]\[Cb\]\[Db\]. \[Ab\]\[A#\]\[Bb\]. \[E\]\[C\]\[Gb\]\[B#\]. \[C#\].;\[Cb\]\[A\]\[F\]\[Cb\]\[C\]\[E\]\[Cb\]\[E\]\[Fb\]. \[G#\]\[C\]\[Ab\]\[A\]\[C#\]\[B\]. \[Eb\]\[choral\]. \[E#\]\[C#\]\[Ab\]\[E\]\[C#\]\[Fb\]\[Cb\]\[F#\]\[C#\]\[Gb\]."
	icon_state = "adh-tool"
	icon_deny = "adh-tool-deny"
	icon_vend = "adh-tool-vend"
	vend_delay = 5
	products = list(/obj/item/weldingtool/electric/crystal = 5,
					/obj/item/wirecutters/crystal = 5,
					/obj/item/screwdriver/crystal = 5,
					/obj/item/crowbar/crystal = 5,
					/obj/item/wrench/crystal = 5,
					/obj/item/device/multitool/crystal = 5,
					/obj/item/storage/belt/utility/crystal = 5,
					/obj/item/storage/toolbox/crystal = 5)

/obj/machinery/vending/tool/adherent/vend(datum/stored_items/vending_products/R, mob/living/carbon/user)
	if((istype(user) && user.species.name == SPECIES_ADHERENT) || emagged)
		. = ..()
	else
		to_chat(user, SPAN_NOTICE("The vending machine emits a discordant note, and a small hole blinks several times. It looks like it wants something inserted."))
