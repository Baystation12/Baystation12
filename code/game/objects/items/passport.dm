/obj/item/passport
	name = "passport"
	icon = 'icons/obj/passport.dmi'
	icon_state = "passport"
	force = 0.5
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A passport. Its origin seems unknown."
	var/info
	var/fingerprint

/obj/item/passport/proc/set_info(mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/decl/cultural_info/culture = H.get_cultural_value(TAG_HOMEWORLD)
	var/pob = culture ? culture.name : "Unset"
	if(H.dna)
		fingerprint = md5(H.dna.uni_identity)
	else
		fingerprint = "N/A"
	info = "\icon[src] [src]:\nName: [H.real_name]\nSpecies: [H.get_species()]\nGender: [gender2text(H.gender)]\nAge: [H.age]\nPlace of Birth: [pob]\nFingerprint: [fingerprint]"

/obj/item/passport/attack_self(mob/user as mob)
	user.visible_message(
		SPAN_ITALIC("[user] opens and checks [src]."),
		SPAN_ITALIC("You open [src] and check for some main information."),
		SPAN_ITALIC("You hear the faint rustle of pages."),
		5
	)
	to_chat(user, info || SPAN_WARNING("[src] is completely blank!"))

/obj/item/passport/scg
	name = "\improper SCG passport"
	icon_state = "passport_scg"
	desc = "A passport from the Sol Central Government."

/obj/item/passport/earth
	name = "\improper Earth passport"
	icon_state = "passport_scg2"
	desc = "A passport from the Earth, within Sol Central Government space."

/obj/item/passport/venus
	name = "\improper Venusian passport"
	icon_state = "passport_scg2"
	desc = "A passport from Venus, within Sol Central Government space."

/obj/item/passport/luna
	name = "\improper Luna passport"
	icon_state = "passport_scg2"
	desc = "A passport from Luna, within Sol Central Government space."

/obj/item/passport/mars
	name = "\improper Mars passport"
	icon_state = "passport_scg2"
	desc = "A passport from Mars, within Sol Central Government space."

/obj/item/passport/phobos
	name = "\improper Phobos passport"
	icon_state = "passport_scg2"
	desc = "A passport from Phobos, within Sol Central Government space."

/obj/item/passport/ceres
	name = "\improper Ceres passport"
	icon_state = "passport_scg2"
	desc = "A passport from Ceres, within Sol Central Government space."

/obj/item/passport/pluto
	name = "\improper Pluto passport"
	icon_state = "passport_scg2"
	desc = "A passport from Pluto, within Sol Central Government space."

/obj/item/passport/tiamat
	name = "\improper Tiamat passport"
	icon_state = "passport_scg2"
	desc = "A passport from Tiamat, within Sol Central Government space."

/obj/item/passport/eos
	name = "\improper Eos passport"
	icon_state = "passport_scg2"
	desc = "A passport from Eos, within Sol Central Government space."

/obj/item/passport/ceti_epsilon
	name = "\improper Ceti Epsilon passport"
	icon_state = "passport_scg2"
	desc = "A passport from Ceti Epsilon, within Sol Central Government space."

/obj/item/passport/iolaus
	name = "\improper Iolaus passport"
	icon_state = "passport_scg2"
	desc = "A passport from Iolaus, within Sol Central Government space."

/obj/item/passport/pirx
	name = "\improper Pirx passport"
	icon_state = "passport_scg2"
	desc = "A passport from Pirx, within Sol Central Government space."

/obj/item/passport/tadmor
	name = "\improper Tadmor passport"
	icon_state = "passport_scg2"
	desc = "A passport from Tadmor, within Sol Central Government space."

/obj/item/passport/brahe
	name = "\improper Brahe passport"
	icon_state = "passport_scg2"
	desc = "A passport from Brahe, within Sol Central Government space."

/obj/item/passport/saffar
	name = "\improper Saffar passport"
	icon_state = "passport_scg2"
	desc = "A passport from Yuklid V, within Sol Central Government space."

/obj/item/passport/south_gaia
	name = "\improper Southern Gaia passport"
	icon_state = "passport_scg2"
	desc = "A passport from the southern part of Gaia, under control of the Sol Central Government."

/obj/item/passport/iccg
	name = "\improper ICCG passport"
	icon_state = "passport_iccg"
	desc = "A passport from the Independent Colonial Confederation of Gilgamesh."

/obj/item/passport/north_gaia
	name = "\improper Northern Gaia passport"
	icon_state = "passport_iccg2"
	desc = "A passport from the northern part of Gaia, under control of the Independent Colonial Confederation of Gilgamesh."

/obj/item/passport/terra
	name = "\improper Terra passport"
	icon_state = "passport_iccg2"
	desc = "A passport from Terra, within ICCG space."

/obj/item/passport/novayazemlya
	name = "\improper Novaya Zemlya passport"
	icon_state = "passport_iccg2"
	desc = "A passport from Novaya Zemlya, within ICCG space."

/obj/item/passport/saveel
	name = "\improper Saveel passport"
	icon_state = "passport"
	desc = "A passport from Saveel, an isolationist frontier colony."

/obj/item/passport/magnitka
	name = "\improper Magnitka passport"
	icon_state = "passport"
	desc = "A passport from Magnitka, an independant colony."

/obj/item/passport/empiremohranda
	name = "\improper Mohranda passport"
	icon_state = "passport"
	desc = "A passport from the Empire of Mohranda, a frontier empire established on Lohrene and Mohranda, in the Luggust system."
