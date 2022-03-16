//////////////////////////////////////////////
//                                          //
//          ASSAULT OPERATIVES              //
//                                          //
//////////////////////////////////////////////

/datum/dynamic_ruleset/roundstart/assault_operatives
	name = "Assault Operatives"
	antag_flag = ROLE_ASSAULT_OPERATIVE
	antag_datum = /datum/antagonist/assault_operative
	minimum_required_age = 14
	restricted_roles = list(
		JOB_CAPTAIN,
		JOB_HEAD_OF_SECURITY,
	)
	required_candidates = 5
	weight = 3
	cost = 20
	requirements = list(90,90,90,80,60,40,30,20,10,10)
	flags = HIGH_IMPACT_RULESET
	antag_cap = list("denominator" = 18, "offset" = 1)
	var/datum/team/assault_operatives/assault_operatives_team

/datum/dynamic_ruleset/roundstart/assault_operatives/ready(population, forced = FALSE)
	required_candidates = 2
	. = ..()

/datum/dynamic_ruleset/roundstart/assault_operatives/pre_execute(population)
	. = ..()
	// If ready() did its job, candidates should have 5 or more members in it
	var/operatives = 2
	for(var/operatives_number = 1 to operatives)
		if(candidates.len <= 0)
			break
		var/mob/mob = pick_n_take(candidates)
		assigned += mob.mind
		mob.mind.set_assigned_role(SSjob.GetJobType(/datum/job/assault_operative))
		mob.mind.special_role = ROLE_ASSAULT_OPERATIVE
		GLOB.pre_setup_antags += mob.mind
	return TRUE

/datum/dynamic_ruleset/roundstart/assault_operatives/execute()
	assault_operatives_team = new()
	for(var/datum/mind/mind in assigned)
		GLOB.pre_setup_antags -= mind
		var/datum/antagonist/assault_operative/new_op = new antag_datum()
		mind.add_antag_datum(new_op, assault_operatives_team)
	if(assault_operatives_team.members.len)
		assault_operatives_team.update_objectives()
		return TRUE
	log_game("DYNAMIC: [ruletype] [name] failed to get any eligible assault operatives. Refunding [cost] threat.")
	return FALSE
/*
/datum/dynamic_ruleset/roundstart/assault_operatives/round_result()
	var/result = assault_operatives_team.get_result()
	switch(result)
		if(ASSAULT_RESULT_WIN)
			SSticker.mode_result = "win - assault operatives extracted data"




		if(NUKE_RESULT_FLUKE)
			SSticker.mode_result = "loss - syndicate nuked - disk secured"
			SSticker.news_report = NUKE_SYNDICATE_BASE
		if(NUKE_RESULT_NUKE_WIN)
			SSticker.mode_result = "win - syndicate nuke"
			SSticker.news_report = STATION_NUKED
		if(NUKE_RESULT_NOSURVIVORS)
			SSticker.mode_result = "halfwin - syndicate nuke - did not evacuate in time"
			SSticker.news_report = STATION_NUKED
		if(NUKE_RESULT_WRONG_STATION)
			SSticker.mode_result = "halfwin - blew wrong station"
			SSticker.news_report = NUKE_MISS
		if(NUKE_RESULT_WRONG_STATION_DEAD)
			SSticker.mode_result = "halfwin - blew wrong station - did not evacuate in time"
			SSticker.news_report = NUKE_MISS
		if(NUKE_RESULT_CREW_WIN_SYNDIES_DEAD)
			SSticker.mode_result = "loss - evacuation - disk secured - syndi team dead"
			SSticker.news_report = OPERATIVES_KILLED
		if(NUKE_RESULT_CREW_WIN)
			SSticker.mode_result = "loss - evacuation - disk secured"
			SSticker.news_report = OPERATIVES_KILLED
		if(NUKE_RESULT_DISK_LOST)
			SSticker.mode_result = "halfwin - evacuation - disk not secured"
			SSticker.news_report = OPERATIVE_SKIRMISH
		if(NUKE_RESULT_DISK_STOLEN)
			SSticker.mode_result = "halfwin - detonation averted"
			SSticker.news_report = OPERATIVE_SKIRMISH
		else
			SSticker.mode_result = "halfwin - interrupted"
			SSticker.news_report = OPERATIVE_SKIRMISH
*/
