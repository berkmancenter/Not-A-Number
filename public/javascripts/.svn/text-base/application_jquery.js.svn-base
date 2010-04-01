$.noConflict();

jQuery(function() {
    initBranch();

    
});

function initBranch() {
    jQuery("#branch_question_id").change(function() {
        jQuery('#branch_choice_id').load('/branches/get_choices?question_id=' + jQuery("#branch_question_id option:selected").val());

        //alert(jQuery("#branch_question_id option:selected").val());
    });
}