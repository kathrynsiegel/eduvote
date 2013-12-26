// Dynamically update the number of responses received so far.
var poll_for_responses = function () {
	var link = $("#close_link");
	if (link.length == 0) {
		return;
	}

	setInterval(function() {
		var path =  window.location.pathname + '/count_responses';
		$.get(path, "json").done(function (data) {
			$("#response_num").text(data["count"]);
		});
	}, 1000);
}

// Picks up information on data from the view and creates a bar chart.
// Bar chart functionality from Chart.js
// http://www.chartjs.org
var build_bar_chart = function () {
	var chart_area = $("#myChart");
	if (chart_area.length == 0) {
		return;
	}

	var labels = [];
	var counts = [];
	$(".response-data").each(function (index, span) {
		var span = $(span);
		labels.push(span.attr("data-choice"));
		counts.push(parseInt(span.attr("data-count")));
	});

	var ctx = chart_area.get(0).getContext("2d");
	var data = {
		labels : labels,
		datasets : [
			{
				fillColor : "rgba(0, 102, 255, 0.7)",
				strokeColor : "rgba(0, 102, 255, 1)",
				data : counts
			}
		]
	};

	var myNewChart = new Chart(ctx).Bar(data, getScaleOptions(counts));
}

// Make sure that the scale has integral steps, and starts at 0.
var getScaleOptions = function(counts) {
	var max = 0;
	counts.forEach(function(val) {
		max = Math.max(val, max);
	});
	var step_size = Math.max(Math.ceil(max/10), 1);
	return { 
		scaleOverride: true,
		scaleStartValue: 0,
		scaleStepWidth: step_size,
		scaleSteps: 10,
	}
};

// Various functions for setting up the new question form,
// and displaying questions.
var setUpQuestionForm = function () {

	// Toggle the hidden field for type when the question
	// type is changed on the new question form.
	var setQuestionType = function() {
		var type = $("input#question_type").val();
		var active_area_class = "." + type + "_area";
		$(active_area_class).addClass("active");
		$(".qtype_tab").on('shown.bs.tab', function () {
		  type = type === "MCQuestion" ? "NumericQuestion" : "MCQuestion";
		  $("input#question_type").val(type);
		});
	}

	// set default lecture.
	var setLecture = function() {
		var lec_id = $("#selected-lecture").attr("data-sel-id");
		$("select#question_lecture_id").val(lec_id);
	}

	// set up infinite scroll for 
	var infiniteScrollSetup = function () {
		$('.questions_all').infinitescroll({
		    navSelector  : ".pagination",            
		    nextSelector : "a.next_page",    
		    itemSelector : ".question_section",
		    loading: {
		        finishedMsg: "<em>No more questions to show.</em>",
		        msgText: "<em>Loading the next set of questions...</em>",
		    },    
	  	});
	}

	setQuestionType();
	setLecture();
	infiniteScrollSetup();
}


