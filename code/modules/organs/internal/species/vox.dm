//vox got different organs within. This will also help with regular surgeons knowing the organs within an alien as alien as vox.
/obj/item/organ/internal/heart/vox
	icon_state = "vox heart"
	dead_icon = null
	parent_organ = BP_GROIN

/obj/item/organ/internal/lungs/vox
	name = "air capillary sack" //Like birds, Vox absorb gas via air capillaries.
	icon_state = "vox lung"

/obj/item/organ/internal/kidneys/vox
	name = "filtration bladder"
	icon_state = "lungs" //wow are vox kidneys fat.
	color = "#99ccff"
	parent_organ = BP_CHEST

/obj/item/organ/internal/liver/vox
	name = "waste tract"
	parent_organ = BP_CHEST
	color = "#0033cc"

/obj/item/organ/internal/stack/vox
	name = "cortical stack"
	invasive = 1

/obj/item/organ/internal/stack/vox/removed()
	var/obj/item/organ/external/head = owner.get_organ(parent_organ)
	owner.visible_message("<span class='danger'>\The [src] rips gaping holes in \the [owner]'s [head.name] as it is torn loose!</span>")
	head.take_external_damage(rand(15,20))
	for(var/obj/item/organ/internal/O in head.contents)
		O.take_internal_damage(rand(30,70))
	..()
