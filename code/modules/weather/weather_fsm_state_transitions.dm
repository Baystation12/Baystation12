/decl/state_transition/weather
	abstract_type = /decl/state_transition/weather
	var/likelihood_weighting = 100

/decl/state_transition/weather/is_open(datum/holder)
	var/obj/abstract/weather_system/weather = holder
	return weather.supports_weather_state(target)

/decl/state_transition/weather/calm
	target = /decl/state/weather/calm
	likelihood_weighting = 50

/decl/state_transition/weather/snow
	target = /decl/state/weather/snow

/decl/state_transition/weather/rain
	target = /decl/state/weather/rain

/decl/state_transition/weather/snow_medium
	target = /decl/state/weather/snow/medium

/decl/state_transition/weather/snow_heavy
	target = /decl/state/weather/snow/heavy
	likelihood_weighting = 20

/decl/state_transition/weather/storm
	target = /decl/state/weather/rain/storm

/decl/state_transition/weather/hail
	target = /decl/state/weather/rain/hail
	likelihood_weighting = 20
