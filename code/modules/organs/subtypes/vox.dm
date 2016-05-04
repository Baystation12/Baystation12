//vox got different organs within. This will also help with regular surgeons knowing the organs within an alien as alien as vox.
/obj/item/organ/heart/vox
	icon_state = "vox heart"
	dead_icon = "vox heart"
	parent_organ = "groin"

/obj/item/organ/lungs/vox
	name = "air capillary sack" //Like birds, Vox absorb gas via air capillaries.
	icon_state = "vox lung"

/obj/item/organ/kidneys/vox
	name = "filtration bladder"
	icon_state = "lungs" //wow are vox kidneys fat.
	color = "#99ccff"
	parent_organ = "chest"

/obj/item/organ/liver/vox
	name = "waste tract"
	parent_organ = "chest"
	color = "#0033cc"


/obj/item/organ/external/groin/vox //vox have an extended ribcage for extra protection.
	encased = "lower ribcage"