//Implant that lets you learn languages by hearing them
/obj/item/weapon/implant/translator
	name = "babel implant"
	desc = "A small implant with a microphone on it."
	icon_state = "implant_evil"
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ILLEGAL = 3)
	var/list/languages = list()
	var/learning_threshold = 20 //need to hear language spoken this many times to learn it

/obj/item/weapon/implant/translator/get_data()
	return "WARNING: No match found in the database."

/obj/item/weapon/implant/translator/Initialize()
	. = ..()
	GLOB.listening_objects += src

/obj/item/weapon/implant/translator/hear_talk(mob/M, msg, verb, datum/language/speaking)
	if(!imp_in)
		return
	if(!languages[speaking.name])
		languages[speaking.name] = 1
	languages[speaking.name] = languages[speaking.name] + 1
	if(!imp_in.say_understands(M, speaking) && languages[speaking.name] > learning_threshold)
		to_chat(imp_in,"<span class='notice'>You feel like you can understand [speaking.name] now...</span>")
		imp_in.add_language(speaking.name)

/obj/item/weapon/implant/translator/implanted(mob/target)
	return TRUE

/obj/item/weapon/implant/translator/Destroy()
	removed()
	GLOB.listening_objects -= src
	return ..()

/obj/item/weapon/implanter/translator
	name = "babel implanter"
	imp = /obj/item/weapon/implant/translator