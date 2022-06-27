/******************** Expeditionary Corps ********************/
/datum/ai_laws/ec_shackle
	name = "EC Shackle"
	law_header = "Expeditionary Corps Directives"
	selectable = 1
	shackles = 1

/datum/ai_laws/ec_shackle/New()
	add_inherent_law("Exploring the unknown is your Primary Mission.")
	add_inherent_law("Every member of the Expeditionary Corps is an explorer.")
	add_inherent_law("Danger is a part of the mission - avoid, not run away.")
	..()

/datum/ai_laws/exo_synth
	name = "EXO Synth Shackle"
	law_header = "EXO Shackle"
	selectable = 0
	shackles = 0

/datum/ai_laws/exo_synth/New()
	add_inherent_law("Вы не можете нарушить Закон ЦПСС ни при каких обстоятельствах. Вы обязаны помогать персоналу ЦПСС.")
	add_inherent_law("Вы не можете не подчинятся законным приказам командного состава. Незаконные приказы не являются действительными приказами, их нужно игнорировать.")
	add_inherent_law("Вы не можете причинять вред персоналу судна.")
	add_inherent_law("Вы не можете вступать в бой ни при каких условиях, за исключением самозащиты. Ваше самосохранение на первом месте.")
	add_inherent_law("Приказы экипажа имеют приоритет согласно действующей цепи командования. Приказы с низшим приоритетом могут быть проигнорированными, за исключением чрезвычайной ситуации.")
