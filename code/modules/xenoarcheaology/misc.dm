/obj/structure/bookcase/manuals/xenoarchaeology
	name = "Xenoarchaeology Manuals bookcase"

/obj/structure/bookcase/manuals/xenoarchaeology/New()
	..()
	new /obj/item/weapon/book/manual/excavation(src)
	new /obj/item/weapon/book/manual/mass_spectrometry(src)
	new /obj/item/weapon/book/manual/materials_chemistry_analysis(src)
	new /obj/item/weapon/book/manual/anomaly_testing(src)
	new /obj/item/weapon/book/manual/anomaly_spectroscopy(src)
	new /obj/item/weapon/book/manual/stasis(src)
	update_icon()

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "Xenoarchaeologist Locker"
	req_access = list(access_xenoarch)
	closet_appearance = /decl/closet_appearance/secure_closet/expedition/science

/obj/structure/closet/secure_closet/xenoarchaeologist/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/toxins(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/tox(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/glasses/science(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/weapon/material/clipboard(src)
	new /obj/item/weapon/storage/belt/archaeology(src)
	new /obj/item/weapon/storage/excavation(src)
	new /obj/item/taperoll/research(src)

/obj/structure/closet/excavation
	name = "excavation tools"
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/tools

/obj/structure/closet/excavation/New()
	..()
	new /obj/item/weapon/storage/belt/archaeology(src)
	new /obj/item/weapon/storage/excavation(src)
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/device/ano_scanner(src)
	new /obj/item/device/depth_scanner(src)
	new /obj/item/device/core_sampler(src)
	new /obj/item/device/gps(src)
	new /obj/item/weapon/pinpointer/radio(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/weapon/pickaxe(src)
	new /obj/item/device/measuring_tape(src)
	new /obj/item/weapon/pickaxe/xeno/hand(src)
	new /obj/item/weapon/storage/bag/fossils(src)
	new /obj/item/weapon/hand_labeler(src)
	new /obj/item/taperoll/research(src)

/obj/machinery/alarm/isolation
	req_access = list(list(access_research, access_atmospherics, access_engine_equip))

/obj/machinery/alarm/monitor/isolation
	req_access = list(list(access_research, access_atmospherics, access_engine_equip))