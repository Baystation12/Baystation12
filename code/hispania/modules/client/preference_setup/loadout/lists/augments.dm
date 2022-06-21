/datum/gear/augment
	sort_category = "Aumentos"
	category = /datum/gear/augment
	cost = 2


/datum/gear/augment/armor_minor
	display_name = "Aumentos de armadura (menores)"
	description = "El aumento de la armadura aumenta con pocos o ningun efecto en el juego."
	path = /obj/item/organ/internal/augment


/datum/gear/augment/armor_minor/New()
	..()
	var/list/options = list()
	options["refuerzo esqueletico"] = /obj/item/organ/internal/augment/skeletal_bracing
	options["blindaje ultravioleta"] = /obj/item/organ/internal/augment/ultraviolet_shielding
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/augment/chest_minor
	display_name = "Aumentos de Pecho (Menor)"
	description = "El aumento del cofre aumenta con pocos o ningun efecto en el juego."
	path = /obj/item/organ/internal/augment


/datum/gear/augment/chest_minor/New()
	..()
	var/list/options = list()
	options["bateria de emergencia"] = /obj/item/organ/internal/augment/emergency_battery
	options["Criadora de leucocitos"] = /obj/item/organ/internal/augment/active/leukocyte_breeder
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/augment/groin_minor
	display_name = "Aumentos de la parte inferior del cuerpo (menores)"
	description = "El aumento de la parte inferior del cuerpo aumenta con pocos o ningun efecto en el juego."
	path = /obj/item/organ/internal/augment


/datum/gear/augment/groin_minor/New()
	..()
	var/list/options = list()
	options["paquete de reciclaje"] = /obj/item/organ/internal/augment/recycler_suite
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/augment/head_minor
	display_name = "Aumentos de cabeza (menores)"
	description = "El aumento de la cabeza aumenta con pocos o ningún efecto en el juego."
	path = /obj/item/organ/internal/augment


/datum/gear/augment/head_minor/New()
	..()
	var/list/options = list()
	options["acondicionador circadiano"] = /obj/item/organ/internal/augment/circadian_conditioner
	options["chip de acceso al codex"] = /obj/item/organ/internal/augment/codex_access
	options["chip de datos"] = /obj/item/organ/internal/augment/data_chip
	options["respaldo genetico"] = /obj/item/organ/internal/augment/genetic_backup
	options["implante neuroestimulador"] = /obj/item/organ/internal/augment/neurostimulator_implant
	options["asistente del dolor"] = /obj/item/organ/internal/augment/pain_assistant
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/augment/head_vision
	display_name = "Aumentos de cabeza (vision)"
	description = "Aumentos de cabeza con efectos de vision."
	path = /obj/item/organ/internal/augment
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/augment/head_vision/New()
	..()
	var/list/options = list()
	options["lentes correctivos"] = /obj/item/organ/internal/augment/active/item/corrective_lenses
	options["amortiguadores de deslumbramiento"] = /obj/item/organ/internal/augment/active/item/glare_dampeners
	options["HUD de salud integrado"] = /obj/item/organ/internal/augment/active/hud/health
	options["HUD de seguridad integrada"] = /obj/item/organ/internal/augment/active/hud/security
	options["HUD de suciedad integrado"] = /obj/item/organ/internal/augment/active/hud/janitor
	options["HUB de ciencia integrado"] = /obj/item/organ/internal/augment/active/hud/science
	gear_tweaks += new /datum/gear_tweak/path (options)
