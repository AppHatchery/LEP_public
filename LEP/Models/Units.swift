//
//  Units.swift
//  LEP
//
//  Created by Yago Arconada on 4/21/24.
//

import Foundation

struct Units {
    
    let general_tasks: [[NurseCard]] = [[model.call_interpreter, model.checking_IV, model.inserting_IV, model.taking_IV_out, model.changing_IV_bag, model.flushing_IV, model.giving_medicine, model.drawing_blood,model.starting_feeding, model.assessing_by_touching, model.turning_patient_over, model.changing_bandages, model.NG_tube, model.checking_NG_tube, model.suction, model.placing_a_foley, model.checking_drain, model.giving_a_rectal_enema, model.placing_a_ventilator], [model.checking_ventilator, model.checking_temperature, model.assessing_monitor, model.checking_blood_pressure, model.listen_to_vitals], [model.are_you_in_pain, model.level_of_pain, model.have_you_drunk, model.have_you_eaten, model.question, model.have_you_gone_to_bathroom, model.hurt_when_touched, /*model.can_you_feel,*/ model.comfortable, model.cold_pack, model.heat_pack], [model.changing_diaper, model.mouthcare, model.change_bedsheet, model.get_dressed, model.time_for_a_shower, model.go_for_a_walk]]
    let day_surgery_tasks: [[NurseCard]] = [[model.take_out_to_the_car_in_wheelchair, model.medicine_will_make_you_sleep],[], [model.last_time_solid_food, model.last_time_breast_milk, model.last_time_clear_liquids],[]] //Liquids to go into questions
    let therapist_tasks: [[NurseCard]] = [[model.belt, model.playroom, model.socks],[],[model.water],[]] //socks and playroom should go in tasks
    let sibley_tasks: [[NurseCard]] = [[model.gel_on_ankle, model.ultrasound, model.do_ekg, model.leg_bp],[],[], [/*model.change_kid_diaper*/]] //Ultrasound should go into vitals
    
    //    let general_tasks: [[NurseCard]] = [
    //        [model.call_interpreter, model.checking_IV, model.inserting_IV, model.taking_IV_out, model.changing_IV_bag, model.flushing_IV, model.giving_medicine, model.drawing_blood, model.starting_feeding, model.assessing_by_touching, model.turning_patient_over, model.changing_bandages, model.NG_tube, model.checking_NG_tube, model.suction, model.placing_a_foley, model.checking_drain, model.giving_a_rectal_enema, model.placing_a_ventilator, model.checking_ventilator],
    //        [model.checking_temperature, model.assessing_monitor, model.checking_blood_pressure, model.listen_to_vitals],
    //        [model.are_you_in_pain, model.level_of_pain, model.question, model.have_you_gone_to_bathroom, model.hurt_when_touched, model.can_you_feel, model.comfortable, model.have_you_drunk, model.have_you_eaten, model.cold_pack, model.heat_pack],
    //        [model.changing_diaper, model.mouthcare, model.change_bedsheet, model.get_dressed, model.time_for_a_shower, model.go_for_a_walk]
    //    ]
    let general_phrases: [Drawer] = [
        model.let_me_call_an_interpreter,
        model.my_name_is,
        model.this_is_normal,
        model.i_am_done,
        model.how_are_you_feeling,
        model.everything_is_okay,
        model.this_shouldnt_hurt,
        model.here_is_the_menu,
        model._have_you_eaten,
        model._what_have_you_eaten,
        model.have_you_drank,
        model.how_much_have_you_drank,
        model.have_you_used_the_bathroom,
        model.do_you_understand,
        model.has_the_bedding_been_changed,
        model.you_can_only_have_ice_chips,
        model.you_cant_eat_right_now,
        model.you_cant_eat_this,
        model.you_need_to_stay_here_to_get_better,
        model.ill_get_something_for_you,
        model.ill_get_that_for_you,
        model.does_this_hurt,
        model.do_you_want_medicine,
        model.im_getting_help,
        model.im_working_to_help,
        model.doctor_is_here_today,
        model.im_calling_the_doctor_for_you,
        model.waiting_for_doctor,
        model.im_not_sure_ill_find_out,
        model.im_touching_to_check_on_you,
        model.someone_else_is_coming_in_to_help,
        model.my_number_is_on_the_board,
        model.dont_hesitate_to_call_on_me,
        model.do_you_need_anything_from_me,
        model.can_i_get_you_anything_water,
        model.ill_be_right_back,
        model.im_leaving_now,
        model.want_to_talk_to_social_worker,
        model.how_much_pee,
        model.dont_toss_pee,
        model.use_the_urinal,
        model.call_me_to_check,
        model._30_mins,
        model._1_hour,
        model._2_hours,
        model._4_hours,
        model._8_hours,
        model.after_breakfast,
        model.after_lunch,
        model.after_dinner,
        model.after_surgery,
        model.after_the_test]
    
    //    let day_surgery_tasks: [[NurseCard]] = [
    //        [model.call_interpreter, model.checking_IV, model.inserting_IV, model.taking_IV_out, model.flushing_IV, model.giving_medicine, model.assessing_by_touching, model.changing_bandages, model.placing_a_ventilator, model.checking_ventilator, model.medicine_will_make_you_sleep],
    //        [model.checking_temperature, model.assessing_monitor, model.checking_blood_pressure, model.listen_to_vitals],
    //        [model.last_time_solid_food,
    //         model.last_time_breast_milk,
    //         model.last_time_clear_liquids, model.are_you_in_pain, model.question, model.can_you_feel, model.comfortable, model.have_you_drunk, model.cold_pack, model.heat_pack],
    //        [model.get_dressed, model.take_out_to_the_car_in_wheelchair]
    //    ]
    
    let day_surgery_phrases: [Drawer] = [
        model.interpreter_on_the_way,
        model.let_me_call_an_interpreter,
        model.write_last_time_ate,
        model.write_last_time_drank,
        model.this_is_normal,
        model.had_liquids,
        model.had_thickener,
        model.has_allergies,
        model.has_fever,
        model.gone_to_washroom,
        model.how_long,
        model.has_vomitted,
        model.will_tell_doctor,
        model.is_everything_okay,
        model.i_am_done,
        model.how_are_you_feeling,
        model.everything_is_okay,
        model.this_shouldnt_hurt,
        model.have_you_drank,
        model.how_much_have_you_drank,
        model.have_you_used_the_bathroom,
        model.you_cant_eat_right_now,
        model.giving_tylenol,
        model.giving_ubiprofen,
        model.stay_in_bed,
        model.ill_get_something_for_you,
        model.ill_get_that_for_you,
        model.does_this_hurt,
        model.do_you_want_medicine,
        model.im_getting_help,
        model.im_working_to_help,
        model.im_calling_the_doctor_for_you,
        model.waiting_for_doctor,
        model.im_not_sure_ill_find_out,
        model.what_time,
        model.come_this_way,
        model.im_touching_to_check_on_you,
        model.someone_else_is_coming_in_to_help,
        model.my_number_is_on_the_board,
        model.dont_hesitate_to_call_on_me,
        model.do_you_need_anything_from_me,
        model.ill_be_right_back,
        model.im_leaving_now,
        model.after_surgery,
        model.after_the_test,
        model.provide_urine_sample,
        model.seen_surgeon,
        model.seen_anesthiologist,
        model.move_toes,
        model.move_fingers,
        model.put_gown_on,
        model.no_more_walking,
        model.bring_car_to_door,
        model.where_is_car,
        model.i_will_wait,
        model.getting_operation_updates,
        model.observer_in_room_okay
    ]
    
    // Rehab
    //    let therapist_tasks: [[NurseCard]] = [
    //        [model.call_interpreter, model.socks, model.belt, model.playroom, model.giving_medicine, model.starting_feeding, model.assessing_by_touching, model.turning_patient_over],
    //        [model.checking_temperature, model.assessing_monitor, model.checking_blood_pressure, model.listen_to_vitals],
    //        [model.are_you_in_pain, model.level_of_pain, model.question, model.have_you_gone_to_bathroom, model.have_you_drunk, model.water, model.have_you_eaten],
    //        [model.go_for_a_walk]
    //    ]
    
    let therapist_phrases: [Drawer] = [
        model.occupational_therapy,
        model.physical_therapy,
        model.speech_therapy,
        model.waiting_for_an_interpreter,
        model.good_time_for_therapy,
        model.therapy_in_the_morning,
        model.therapy_in_the_afternoon,
        model.observe_child_eating,
        model.observe_child_meal_time,
        model.thank_you,
        model.hold_your_child,
        model.dont_get_child_out_of_bed,
        model.help_get_child_out_of_bed,
        model.need_to_rest,
        model.need_the_nurse,
        model.need_help,
        model.use_mechanical_lift_to_move_child,
        model.baby_is_sleeping_ill_come_later,
        model.have_questions_about_today,
        model.write_next_time_patient_will_eat,
        model.see_how_child_plays,
    ]
    
    // Sibley
    //    let sibley_tasks: [[NurseCard]] = [
    //        [model.call_interpreter, model.gel_on_ankle, model.do_ekg, model.ultrasound, model.assessing_by_touching, model.turning_patient_over, model.changing_bandages, model.placing_a_ventilator, model.checking_ventilator],
    //        [model.checking_temperature, model.assessing_monitor, model.checking_blood_pressure, model.leg_bp, model.listen_to_vitals],
    //        [model.are_you_in_pain, model.question, model.have_you_gone_to_bathroom, model.hurt_when_touched, model.can_you_feel, model.comfortable],
    //        [model.change_kid_diaper, model.get_dressed]
    //    ]
    
    let sibley_phrases: [Drawer] = [
        model.i_am_done,
        model.you_can_go_back_to_the_room,
        model.your_childs_name_will_be_on_the_door,
        model.how_are_you_feeling,
        model.childs_name,
        model.change_diaper,
        model.please_take_off_your_shoes_and_stand_on_the_scale,
        model.i_am_going_to_put_stickers_on_your_chest,
        model.i_am_going_to_put_a_heart_monitor,
        model.please_take_off_your_shirt,
        model.these_wires_are_going_to_hold_the_stickers,
        model.does_this_hurt,
        model.nothing_will_hurt_today,
        model.we_wont_do_shots_or_blood_work,
        model.this_doesnt_hurt_but_may_feel_cold,
        model.please_lay_on_your_left_side,
        model.please_fold_your_left_arm_so_your_head_lays_on_it,
        model.i_am_going_to_put_3_stickers_on_your_chest,
        model.i_am_going_to_connect_wires_to_the_stickers,
        model.please_lay_down_on_the_table,
        //        model.please_relax_your_shoulders_and_try_to_stay_still,
        //        model.we_are_going_to_another_room_for_the_provider_to_see_you,
        model.do_you_need_anything_from_me,
        //        model.please_bring_a_pacifier_bottle_or_toys,
        //        model.we_need_your_help_to_keep_your_baby_calm,
        //        model.i_am_going_to_put_jelly_on_your_chest,
        //        model.i_will_put_my_camera_on_your_chest_to_get_the_pictures,
        //        model.the_doctor_will_review_this_exam,
        //        model.you_will_get_the_results_before_you_leave,
        model.have_you_used_the_bathroom,
        model.this_is_normal,
        model.everything_is_okay,
        model.this_shouldnt_hurt,
        model.here_is_the_menu,
        model.you_can_only_have_ice_chips,
        model.you_cant_eat_right_now,
        model.ill_get_something_for_you,
        model.ill_get_that_for_you,
        model.im_getting_help,
        model.im_working_to_help,
        model.let_me_call_an_interpreter,
        model.doctor_is_here_today,
        model.im_calling_the_doctor_for_you,
        model.waiting_for_doctor,
        model.im_not_sure_ill_find_out,
        model.im_touching_to_check_on_you,
        model.someone_else_is_coming_in_to_help,
        model.can_i_get_you_anything_water,
        model.ill_be_right_back,
        model.im_leaving_now,
        model._30_mins,
        model._1_hour,
        model._2_hours,
        model._4_hours,
        model.after_surgery,
        model.after_the_test
    ]
    //Front Desk
    let sibley_front_desk_phrases: [Drawer] = [
        model.have_appointment,
        model.patients_name,
        model.spelling_of_name,
        model.date_of_birth,
        model.any_cough,
        model.rash_with_fever,
        model.family_have_flu,
        model.recent_travel_outside_US,
        model.parent_or_guardian_name,
        model.insurance_card_photo_id,
        model.confirming_information,
        model.patients_address,
        model.primary_contact_phone,
        model.insurance_through_mom_dad,
        model.who_do_they_work_for,
        model.primary_care_provider,
        model.referred_by,
        model.which_pharmacy,
        model.consent_to_treat_form,
        model.form_for_mychart,
        model.email_in_24_hours,
        model.thank_you_waiting_room,
        model.doctor_is_running_behind,
        model.want_bottle_of_water,
        model.lets_schedule_follow_up,
        model.have_a_great_day,
        model.doctor_will_see_you_unsure_about_wait_time,
        model.im_sorry_but_reschedule,
        model.what_time_works_for_you,
        model.form_for_parent_conversation
    ]
    
    let sibley_medical_assistant_phrases: [Drawer] = [
        model.stand_on_scale_for_height_weight,
        model.baby_on_scale,
        model.remove_top_and_put_on_vest,
        model.checking_pulse,
        model.doing_ekg,
        model.please_lie_still,
        model.breathe_normally_and_dont_move,
        model.nurse_will_be_in_shortly,
        model.doctor_will_be_in_shortly,
        model.taking_you_to_room_for_echo,
        model.want_to_watch_movie_during_echo,
        model.back_to_room_after_echo,
        model.doctor_coming_to_discuss_echo
    ]
    
    let sibley_sonographer_phrases: [Drawer] = [
        model.taking_pictures_of_heart,
        model.lay_down_on_left,
        model.lie_flat_on_back,
        model.breathe_and_hold,
        model.you_can_breathe_now,
        model.bend_your_knees,
        model.help_me_if_baby_is_fussy,
        model.can_have_pacifier,
        model.this_will_not_hurt,
        model.lift_chin_up,
        model.lift_under_shoulders_and_tilt_head_back,
        model.lift_your_arm_up_high,
        model.roll_on_your_side,
        model.feed_baby_I_will_scan,
        model.hold_baby_i_will_scan,
        model.doctor_soon
    ]
    
    let nicu_phrases: [Drawer] = [
        model.do_you_need_interpreter,
        model.would_you_like_an_interpreter,
        model.has_doctor_called_with_updates,
        model.do_you_have_questions,
        model.speak_to_lactation_consultant,
        model.help_with_oral_care,
        model.want_to_change_diaper,
        model.want_to_take_babys_temperature,
        model.want_to_hold_baby,
        model.hold_baby_skin_to_skin,
        model.need_more_milk_bottles
    ]
    
    let socialwork_phrases: [Drawer] = [
        model.do_you_have_ride_home,
        model.will_call_medicaid_transportation,
        model.medicaid_transportation_on_the_way,
        model.do_you_have_money_for_food,
        model.please_fill_out_this_form,
        model.are_you_able_to_obtain_medication,
        model.we_are_here_to_help_you,
        model.resources_to_assist_with_care,
        model.list_of_lowcost_clinics,
        model.do_you_have_insurance,
        model.does_the_patient_have_insurance,
        model.hospital_financial_counselor
    ]
}