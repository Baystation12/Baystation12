#ifdef T_BOARD_MECHA
#error T_BOARD_MECHA already defined elsewhere, we can't use it.
#endif
#define T_BOARD_MECHA(name)	"exosuit module circuit board (" + (name) + ")"

/obj/item/weapon/circuitboard/mecha
	name = "exosuit circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"


/obj/item/weapon/circuitboard/mecha/ripley
		origin_tech = "programming=3"

/obj/item/weapon/circuitboard/mecha/ripley/peripherals
		name = T_BOARD_MECHA("Ripley peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/ripley/main
		name = T_BOARD_MECHA("Ripley central control")
		icon_state = "mainboard"


/obj/item/weapon/circuitboard/mecha/gygax
		origin_tech = "programming=4"

/obj/item/weapon/circuitboard/mecha/gygax/peripherals
		name = T_BOARD_MECHA("Gygax peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/gygax/targeting
		name = T_BOARD_MECHA("Gygax weapon control and targeting")
		icon_state = "mcontroller"
		origin_tech = "programming=4;combat=4"

/obj/item/weapon/circuitboard/mecha/gygax/main
		name = T_BOARD_MECHA("Gygax central control")
		icon_state = "mainboard"


/obj/item/weapon/circuitboard/mecha/durand
		origin_tech = "programming=4"

/obj/item/weapon/circuitboard/mecha/durand/peripherals
		name = T_BOARD_MECHA("Durand peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/durand/targeting
		name = T_BOARD_MECHA("Durand weapon control and targeting")
		icon_state = "mcontroller"
		origin_tech = "programming=4;combat=4"

/obj/item/weapon/circuitboard/mecha/durand/main
		name = T_BOARD_MECHA("Durand central control")
		icon_state = "mainboard"


/obj/item/weapon/circuitboard/mecha/honker
		origin_tech = "programming=4"

/obj/item/weapon/circuitboard/mecha/honker/peripherals
		name = T_BOARD_MECHA("H.O.N.K peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/honker/targeting
		name = T_BOARD_MECHA("H.O.N.K weapon control and targeting")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/honker/main
		name = T_BOARD_MECHA("H.O.N.K central control")
		icon_state = "mainboard"


/obj/item/weapon/circuitboard/mecha/odysseus
		origin_tech = "programming=3"

/obj/item/weapon/circuitboard/mecha/odysseus/peripherals
		name = T_BOARD_MECHA("Odysseus peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/odysseus/main
		name = T_BOARD_MECHA("Odysseus central control")
		icon_state = "mainboard"

//Undef the macro, shouldn't be needed anywhere else
#undef T_BOARD_MECHA
