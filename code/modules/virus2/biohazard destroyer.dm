/obj/machinery/disease2/biodestroyer
	name = "Biohazard destroyer"
	icon = 'disposal.dmi'
	icon_state = "disposalbio"
	var/list/accepts = list(/obj/item/clothing,/obj/item/weapon/virusdish/,/obj/item/weapon/cureimplanter,/obj/item/weapon/diseasedisk,/obj/item/weapon/reagent_containers)
	density = 1
	anchored = 1

/obj/machinery/disease2/biodestroyer/attackby(var/obj/I as obj, var/mob/user as mob)
	for(var/path in accepts)
		if(I.type in typesof(path))
			user.drop_item()
			del(I)
			overlays += image('disposal.dmi', "dispover-handle")
			return
	user.drop_item()
	I.loc = src.loc

	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src] \blue The [src.name] beeps", 2)