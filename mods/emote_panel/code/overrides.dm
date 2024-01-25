/singleton/emote/visible
	key ="tail"
	emote_message_3p = "USER виляет своим хвостом."
	message_type = VISIBLE_MESSAGE

/singleton/emote/visible/scratch
	key = "scratch"
	check_restraints = TRUE
	emote_message_3p = "USER чешется."

/singleton/emote/visible/drool
	key ="drool"
	emote_message_3p = "USER неразборчиво бурчит."
	conscious = 0

/singleton/emote/visible/nod
	key ="nod"
	emote_message_3p = "USER кивает."

/singleton/emote/visible/sway
	key ="sway"
	emote_message_3p = "USER шатается."

/singleton/emote/visible/sulk
	key ="sulk"
	emote_message_3p = "USER грустно садится..."

/singleton/emote/visible/dance
	key ="dance"
	check_restraints = TRUE
	emote_message_3p = "USER танцует!"

/singleton/emote/visible/roll
	key ="roll"
	check_restraints = TRUE
	emote_message_3p = "USER катается."

/singleton/emote/visible/shake
	key ="shake"
	emote_message_3p = "USER трясет головой."

/singleton/emote/visible/jump
	key ="jump"
	emote_message_3p = "USER прыгает!"

/singleton/emote/visible/hiss
	key ="hiss_"
	emote_message_3p = "USER мягко шипит..."
	emote_message_3p_target = "USER мягко шипит на TARGET..."

/singleton/emote/visible/shiver
	key ="shiver"
	emote_message_3p = "USER дрожит."
	conscious = 0

/singleton/emote/visible/collapse
	key ="collapse"
	emote_message_3p = "USER падает!"

/singleton/emote/visible/collapse/do_extra(mob/user)
	if(istype(user))
		user.Paralyse(2)

// /singleton/emote/visible/flash
// 	key = "flash"
// 	emote_message_3p = "The lights on USER flash quickly."

/singleton/emote/visible/blink
	key = "blink"
	emote_message_3p = "USER моргает."

// /singleton/emote/visible/airguitar
// 	key = "airguitar"
// 	check_restraints = TRUE
// 	emote_message_3p = "USER is strumming the air and headbanging like a safari chimp."

/singleton/emote/visible/blink_r
	key = "blink_r"
	emote_message_3p = "USER быстро моргает!"

/singleton/emote/visible/bow
	key = "bow"
	emote_message_3p_target = "USER делает поклон TARGET."
	emote_message_3p = "USER делает поклон."

/singleton/emote/visible/salute
	key = "salute"
	emote_message_3p_target = "USER выполняет воинское приветствие TARGET."
	emote_message_3p = "USER выполняет воинское приветствие."
	check_restraints = TRUE

/singleton/emote/visible/flap
	key = "flap"
	check_restraints = TRUE
	emote_message_3p = "USER машет крыльями."

/singleton/emote/visible/aflap
	key = "aflap"
	check_restraints = TRUE
	emote_message_3p = "USER агрессивно машет крыльями!"

/singleton/emote/visible/eyebrow
	key = "eyebrow"
	emote_message_3p = "USER приподнимает бровь."

/singleton/emote/visible/twitch
	key = "twitch"
	emote_message_3p = "USER дергается."
	conscious = 0

/singleton/emote/visible/twitch_v
	key = "twitch_v"
	emote_message_3p = "USER сильно дергается!"
	conscious = 0

/singleton/emote/visible/faint
	key = "faint"
	emote_message_3p = "USER падает в обморок!"

/singleton/emote/visible/faint/do_extra(mob/user)
	if(istype(user) && user.sleeping <= 0)
		user.sleeping += 10

/singleton/emote/visible/frown
	key = "frown"
	emote_message_3p = "USER хмурится."

/singleton/emote/visible/blush
	key = "blush"
	emote_message_3p = "USER краснеет..."

/singleton/emote/visible/wave
	key = "wave"
	emote_message_3p = "USER машет."
	emote_message_3p_target = "USER машет TARGET."
	check_restraints = TRUE

/singleton/emote/visible/glare
	key = "glare"
	emote_message_3p = "USER недовольно смотрит на TARGET."
	emote_message_3p = "USER недовольно смотрит."

/singleton/emote/visible/stare
	key = "stare"
	emote_message_3p = "USER пялится на TARGET."
	emote_message_3p = "USER пялится."

/singleton/emote/audible/scream
	key = "scream"
	emote_message_3p = "USER кричит!"

/singleton/emote/visible/look
	key = "look"
	emote_message_3p = "USER смотрит на TARGET."
	emote_message_3p = "USER смотрит."

/singleton/emote/visible/point
	key = "point"
	check_restraints = TRUE
	emote_message_3p = "USER показывает пальцем."
	emote_message_3p_target = "USER показывает пальцем на TARGET."

/singleton/emote/visible/raise
	key = "raise"
	check_restraints = TRUE
	emote_message_3p = "USER поднимает руку."

/singleton/emote/visible/grin
	key = "grin"
	emote_message_3p = "USER скалится в улыбке."

/singleton/emote/visible/shrug
	key = "shrug"
	emote_message_3p = "USER пожимает плечами."

/singleton/emote/visible/smile
	key = "smile"
	emote_message_3p = "USER улыбается."
	emote_message_3p_target = "USER улыбается TARGET."

/singleton/emote/visible/pale
	key = "pale"
	emote_message_3p = "USER на секунду бледнеет..."

/singleton/emote/visible/tremble
	key = "tremble"
	emote_message_3p = "USER трепещет в страхе!"

/singleton/emote/visible/wink
	key = "wink"
	emote_message_3p = "USER подмигивает."
	emote_message_3p_target = "USER подмигивает TARGET."

/singleton/emote/visible/hug
	key = "hug"
	check_restraints = TRUE
	emote_message_3p_target = "USER обнимает TARGET!"
	emote_message_3p = "USER обнимает USER_SELF!"
	check_range = 1

// /singleton/emote/visible/dap
// 	key = "dap"
// 	check_restraints = TRUE
// 	emote_message_3p_target = "USER gives daps to TARGET."
// 	emote_message_3p = "USER sadly can't find anybody to give daps to, and daps USER_SELF."

/singleton/emote/visible/bounce
	key = "bounce"
	emote_message_3p = "USER прыгает на месте!"

/singleton/emote/visible/jiggle
	key = "jiggle"
	emote_message_3p = "USER покачивается..."

/singleton/emote/visible/lightup
	key = "light"
	emote_message_3p = "USER lights up for a bit, then stops."

/singleton/emote/visible/vibrate
	key = "vibrate"
	emote_message_3p = "USER вибрирует!"

// /singleton/emote/visible/deathgasp_robot
// 	key = "deathgasp"
// 	emote_message_3p = "USER shudders violently for a moment, then becomes motionless, USER_THEIR eyes slowly darkening."

/singleton/emote/visible/handshake
	key = "handshake"
	check_restraints = TRUE
	emote_message_3p_target = "USER пожимает руку TARGET."
	emote_message_3p = "USER пожимает руку USER_SELF."
	check_range = 1

/singleton/emote/visible/handshake/get_emote_message_3p(atom/user, atom/target, extra_params)
	if(target && !user.Adjacent(target))
		return "USER протягивает руку TARGET."
	return ..()

/singleton/emote/visible/signal
	key = "signal"
	emote_message_3p_target = "USER машет TARGET."
	emote_message_3p = "USER машет."
	check_restraints = TRUE

/singleton/emote/visible/signal/check_user(atom/user)
	return ismob(user)

/singleton/emote/visible/signal/proc/get_fingers_word(number)
	switch(number)
		if (1) return "палец"
		if (2, 3, 4) return "пальца"
		if (5) return "пальцев"

/singleton/emote/visible/signal/get_emote_message_3p(mob/user, atom/target, extra_params)
	if(istype(user) && !(user.r_hand && user.l_hand))
		var/t1 = round(text2num(extra_params))
		if(isnum(t1) && t1 <= 5)
			return "USER показывает [t1] [get_fingers_word(t1)]."
	return .. ()

/singleton/emote/visible/afold
	key = "afold"
	check_restraints = TRUE
	emote_message_3p = "USER складывает руки."

/singleton/emote/visible/alook
	key = "alook"
	emote_message_3p = "USER отворачивается."

/singleton/emote/visible/hbow
	key = "hbow"
	emote_message_3p = "USER кланяет голову."

/singleton/emote/visible/hip
	key = "hip"
	check_restraints = TRUE
	emote_message_3p = "USER упирается руками в свои бёдра."

/singleton/emote/visible/holdup
	key = "holdup"
	check_restraints = TRUE
	emote_message_3p = "USER поднимает свои ладони."

/singleton/emote/visible/hshrug
	key = "hshrug"
	emote_message_3p = "USER чуть пожимает плечами."

/singleton/emote/visible/crub
	key = "crub"
	check_restraints = TRUE
	emote_message_3p = "USER потирает подбородок."

/singleton/emote/visible/eroll
	key = "eroll"
	emote_message_3p = "USER закатывает глаза."
	emote_message_3p_target = "USER закатывает глаза на TARGET."

/singleton/emote/visible/erub
	key = "erub"
	check_restraints = TRUE
	emote_message_3p = "USER протирает глаза."

/singleton/emote/visible/fslap
	key = "fslap"
	check_restraints = TRUE
	emote_message_3p = "USER шлёпает себя по лбу."

/singleton/emote/visible/ftap
	key = "ftap"
	emote_message_3p = "USER постукивает ногой."

/singleton/emote/visible/hrub
	key = "hrub"
	check_restraints = TRUE
	emote_message_3p = "USER потирает свои руки."

/singleton/emote/visible/hspread
	key = "hspread"
	check_restraints = TRUE
	emote_message_3p = "USER разводит руками."

/singleton/emote/visible/pocket
	key = "pocket"
	check_restraints = TRUE
	emote_message_3p = "USER засовывает свои руки в карманы."

// /singleton/emote/visible/rsalute
// 	key = "rsalute"
// 	check_restraints = TRUE
// 	emote_message_3p = "USER returns the salute."

/singleton/emote/visible/rshoulder
	key = "rshoulder"
	emote_message_3p = "USER закатывает свои рукава."

/singleton/emote/visible/squint
	key = "squint"
	emote_message_3p = "USER прищуривается."
	emote_message_3p_target = "USER щурится на TARGET."

/singleton/emote/visible/tfist
	key = "tfist"
	emote_message_3p = "USER сжимает руки в кулаки."

/singleton/emote/visible/tilt
	key = "tilt"
	emote_message_3p = "USER наклоняет свою голову."
