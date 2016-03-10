//vox got different organs within. This will also help with regular surgeons knowing the organs within an alien as alien as vox.
/obj/item/organ/heart/vox
	name = "weird organ"
	icon_state = "vox heart"
	dead_icon = "vox heart"
	parent_organ = "groin"

/obj/item/organ/lungs/vox
	name = "strange organ"
	icon_state = "vox lung"

/obj/item/organ/kidneys/vox
	name = "odd organ"
	icon_state = "lungs" //wow are vox kidneys fat.
	color = "#99ccff"
	parent_organ = "chest"

/obj/item/organ/liver/vox
	name = "curious organ"
	parent_organ = "head"
	color = "#0033cc"


/obj/item/organ/external/groin/vox //vox have an extended ribcage for extra protection.
	encased = "lower ribcage"