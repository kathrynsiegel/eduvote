// Set up the calendar for the show course page
var setUpCalendar = function() {
    var sample_add_lecture = $("#add-lecture-link").html();

    $("td.no-events").each(function() {
        $(this).find(".day_number").after(sample_add_lecture);
        var date = $(this).closest("td").attr("data-date");
        var date_input = $('<input id="lecture_date" name="lecture[date]" type="hidden" value="'+date+'">');
        $(this).find("input#lecture_course").after(date_input);
    });

    $(".day").find(".calendar_options").hide();
    $(".day").mouseenter(function(){
        $(this).find(".calendar_options").show();
    });
    $(".day").mouseleave(function(){
        $(this).find(".calendar_options").hide();
    });

    $("#calendar_list").hide();
    $( ".second" ).click(function() {
        if ($(".first").hasClass("active")){
            $(".first").removeClass("active");
            $(".second").addClass("active");
            $("#calendar").hide();
            $("#calendar_list").show();
        }
    });
    $( ".first" ).click(function() {
        if ($(".second").hasClass("active")){
            $(".second").removeClass("active");
            $(".first").addClass("active");
            $("#calendar").show();
            $("#calendar_list").hide();
        }
    });
}