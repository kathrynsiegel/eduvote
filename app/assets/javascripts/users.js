// Only prompt a student for a phone number on sign up
var customize_form = function () {
	$("input[name='user[type]']:radio").change(function () {
		if ($(this).attr("id") === "user_type_student") {
			$(".phone_input").show();
		}
		else {
			$(".phone_input").hide();
		}
	});
}

// Set up the sign up functionality
var setUpSignUp = function() {
  $("#sign_up").click(function(){
    $("#overlay").removeClass("invisible");
    $("#sign_in_overlay").removeClass("invisible");
  });
  $("#overlay").click(function(){
    $("#overlay").addClass("invisible");
    $("#sign_in_overlay").addClass("invisible");
  });
  $('[data-toggle=offcanvas]').click(function() {
    $('.row-offcanvas').toggleClass('active');
  });
}

// Sidebar height adjustment
var resizePage = function() {
  var height = $(".main").height();
  var win_height = $(window).height() - 80;
  if (height <= win_height){
    height = win_height;
  }
  $("#test_sidebar").css({'height':(height +'px')});
}