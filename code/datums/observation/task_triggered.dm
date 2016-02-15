//
//	Observer Pattern Implementation: Scheduled task triggered
//		Registration type: /datum/scheduled_task
//
//		Raised when: When a scheduled task reaches its trigger time.
//
//		Arguments that the called proc should expect:
//			/datum/scheduled_task/task: The task that reached its trigger time.
var/decl/observ/task_triggered/task_triggered_event = new()

/decl/observ/task_triggered
	name = "Task Triggered"
	expected_type = /datum/scheduled_task
