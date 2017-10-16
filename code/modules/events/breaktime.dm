datum/event/breaktime/setup()
	announceWhen = rand(0, 300)
	endWhen = announceWhen + 9000

datum/event/breaktime/announce()
	command_announcement.Announce("Break time! You are given a 15 minute break, enjoy!", "Break Time")

datum/event/breaktime/start()
	return //Simplest fucking event ever.