/obj/item/device/integrated_electronics/analyzer
	name = "circuit analyzer"
	desc = "This tool can scan an assembly and generate code necessary to recreate it in a circuit printer."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "analyzer"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_ALUMINIUM = 1500, MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500, MATERIAL_PLASTIC = 500)

/obj/item/device/integrated_electronics/analyzer/afterattack(var/atom/A, var/mob/living/user)
	. = ..()
	if(istype(A, /obj/item/device/electronic_assembly))
		var/saved = "[A.name] analyzed! On circuit printers with cloning enabled, you may use the code below to clone the circuit:<br><br><code>[SScircuit.save_electronic_assembly(A)]</code>"
		if(saved)
			to_chat(user, "<span class='notice'>You scan [A].</span>")
			show_browser(user, saved, "window=circuit_scan;size=500x600;border=1;can_resize=1;can_close=1;can_minimize=1")
		else
			to_chat(user, "<span class='warning'>[A] is not complete enough to be encoded!</span>")
