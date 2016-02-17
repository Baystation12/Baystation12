/obj/structure/closet/wizard
	name = "artifact closet"
	desc = "a special lead lined closet used to hold artifacts of immense power"
	icon = 'icons/obj/storage.dmi'
	icon = 'icons/obj/closet.dmi'
	icon_state = "acloset"
	icon_closed = "acloset"
	icon_opened = "aclosetopen"

/obj/structure/closet/wizard/New()
	..()
	var/obj/structure/bigDelivery/package = new /obj/structure/bigDelivery(get_turf(src))
	package.wrapped = src
	package.examtext = "Imported straight from the Wizard Acadamy. Do not lose the contents or suffer a demerit."
	src.forceMove(package)
	package.update_icon()

/obj/structure/closet/wizard/armor/New()
	..()
	new /obj/item/clothing/shoes/sandal(src) //In case they've lost them.
	new /obj/item/clothing/gloves/purple(src)//To complete the outfit
	new /obj/item/clothing/suit/space/void/wizard(src)
	new /obj/item/clothing/head/helmet/space/void/wizard(src)

/obj/structure/closet/wizard/scrying/New()
	..()
	new /obj/item/weapon/scrying(src)
	new /obj/item/weapon/contract/wizard/xray(src)

/obj/structure/closet/wizard/souls/New()
	..()
	new /obj/item/weapon/contract/wizard/spell/artificer(src)
	new /obj/item/weapon/storage/belt/soulstone/full(src)
