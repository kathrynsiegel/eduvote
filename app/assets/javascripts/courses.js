$(document).ready(function(){

    // Set up buttons to add instructor to course and add student to class
    var addUserButton = $('#add-user');
    var addClassButton = $('#add-class');
    if (addUserButton.length > 0) {
        addUserButton.click(addUser);
        setUpUserTypeahead();
    }
    if (addClassButton.length > 0) {
        ClassAdder(addClassButton);
        setUpClassTypeahead();
    }
    
    // Highlight instructors by default in the new course page
    $('.instructors option').attr('selected', true)

    var questionPreview = $('#myModal');
    if (questionPreview.length > 0) {
        createPreview(questionPreview)
        setUpAddOptions();
    }

    // Phone number should appear on sign up form only for students
    customize_form();


    // Set up bar chart to display results
    build_bar_chart();
    poll_for_responses();

    // Set up pages
    setUpRenameLectures();
    setUpQuestionForm();
    setUpCalendar();
    setUpSignUp();
    hover();
    resizePage();


});

// Set up Add Option button to allow instructors to add options to questions
var setUpAddOptions = function() {
  var b = $('.addOption');
  var first = $('.option').first();
  var current = first.siblings(".option").last();
  var ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  var v = current.children(".choice").val();
  var count = ALPHA.indexOf(v) + 1;
  $(".addOption").click(function(e) {
    e.preventDefault();
    if (count < 26) {
      var next = first.clone();
      next.children('.value').val("");
      next.children('input').val(ALPHA[count]);
      next.attr("id", "option" + count);
      current.after(next);
      $('select').append(new Option(ALPHA[count], ALPHA[count]))
      count += 1
      current = next
    }
  });
}

// Make it so that instructors can rename lectures from within the calendar
var setUpRenameLectures = function() {
    var currentName;
    // Updating lecture names in calendar
    $('.lectureName').on('focus', function() {
        currentName = $(this).html();
    });
    $('.lectureName').on('blur', function() {
        updateLectureName($(this), currentName);
    });

    $('.lectureName').keydown(function(e) {
        if (e.keyCode == 13 && e.shiftKey){
            $(this).val(  $(this).val() + '\n');
        } else if(e.keyCode == 13){
            e.preventDefault();
            $(this).blur();
        }
    });
}

// Set up typeahead in the Add Instructor box on New Lecture page
var setUpUserTypeahead = function() {
    // Initialize typeahead.
    // First create query
    var remote_query = "/users/search_instructors?email_start=%QUERY"
    for (var i=0; i< $('#course_instructors').children().length; i++) {
        remote_query += '&instructor' + i + '=' + $('#course_instructors').children()[i].value;
    }
    
    $("#instructor-add-text").typeahead({
        name: "instructor_emails",
        remote: remote_query
    });
    
    // Add some formatting.
    $(".tt-hint").addClass("form-control");
    $(".tt-dropdown-menu").width("100%");
}

// Update the lecture name if it has been changed
var updateLectureName = function(element, currentName) {
  var name = element.html().trim();
  var date = element.siblings('.lectureDate').html();
  var url = window.location['href']
  var split = url.split('/')
  var course = split[split.length - 1]
  if (name !== currentName && name.replace(/&nbsp;|\s/gi,'') != "") {
    if (name != null) {
      name.replace('\n\t','');
      $.post('/lectures/rename', {date: date, name: name, course: course}, function(data) {
        console.log(data);
      })
    }
  } else {
    element.html(currentName);
  }
  
}

// Set up typeahead in the Add class box on student home page
var setUpClassTypeahead = function() {
    // Initialize typeahead.
    $("#class-add-text").typeahead({
        name: "course_names",
        remote: "/courses/search?name_start=%QUERY"
    });
    
    // Add some formatting.
    $(".tt-hint").addClass("form-control");
    $(".tt-dropdown-menu").width("100%");
}

// Display the question preview in the new question page
var createPreview = function(element) {
    $('#myModal').on('shown.bs.modal', function(){
        $("#preview_question_text").html($(".new_question_text_area").val());
        var preview_options = $('#preview_question_option');
        preview_options.empty();
        var answer = "(None)";
        if ($("#MCQuestion_tab").hasClass("active")) {
            $('textarea.new_option_text_area').each(function() {
                var n = '<li>' + $(this).val() + '</li>';
                preview_options.append(n);
                var val = $("#question_mc_answer").val();
                if (val !== "") {
                    answer = val;
                }
            });
        } else {
            var val = $("#question_num_answer").val();
            if (val !== "") {
                answer = val;
            }
        }
        $("#preview_question_answer").text(answer);
        MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
    });
}

// Add a student to a class
var ClassAdder = function(element){
  element.click(function(event){
    event.preventDefault();
    sendClass();
  });
  
  // Send the name of the class to the server
  var sendClass = function(){
    var name = $('#class-add-text').val();
    if(name != null){
      $.post("/courses/find", {name:name}, parseResult);
    }
  }

  // If the class exists, append it to the list of classes
  var parseResult = function(result) {
    var name = result['name']
    var number = result['number']
    var id = result['id']
    var attendance = result['attendance']
    var accuracy = result['accuracy']
    var instructors = result['instructors'][0]['name']
    console.log(result);
    if (name == null || name.length <= 1) {
        alert('Invalid entry. Please try again.');
    } else {
        $('.noClasses').remove();
        $('.courses').append('<tr class = "table_row oddrow clickable" style = "backgound-color: white;">' +
            '<td class = "color_block" style = "background-color: transparent;"></td>' +
            '<td><a class = "course_link" href="/courses/' + id + '">' + name + '</a></td>' +
            '<td>' + instructors + '</td>' +
            '<td>' + attendance + '</td>' +
            '<td>' + accuracy + '</td>' +
            '<td>' + number + '</td>' +
            '</tr>');
        $('#class-add-text').val('');
        $("#class-add-text").typeahead("setQuery", "");
        hover();
    }
  }
}

// Add an instructor to a course
var addUser = function (event) {
  event.preventDefault();
  var userList = [$("#course_creator_email").attr("data-email")]

  // Send the email of the instructor to the server
  var sendUser = function(){
    var email = $('#instructor-add-text').val().toLowerCase();
    if(email != null){
      $.post("/users/find_instructor", {email: email}, parseResult);
    }
  }
  
  // If the instructor exists, add the name to the list of possible instructors
  var parseResult = function(result) {
    var email = result['email']
    var name = result['name']
    var id = result['id']
    if(email == null || email.length <= 1){
      alert('Not an instructor email. Please check your entry.');
    } else {
      if($.inArray(email, userList) == -1){
        userList.push(email);
        var opt = new Option(name, id);
        opt.selected = true;
        $('#course_instructors').append(opt);
        $('#instructor-add-text').val('');
        $("#instructor-add-text").typeahead("setQuery", "");
      } else {
        alert("Instructor already added.");
      }
    }
  }

  sendUser();

}

// Set the table row highlighting on hovering in the table
var hover = function() {
  $(".table_row.clickable").mouseenter(function(){
    $(this).children(".color_block").css({"background-color": "#14c8e3"});
    $(this).css({"background-color": "#eeeeff"});
  });
  $(".table_row.clickable").mouseleave(function(){
    $(this).children(".color_block").css({"background-color": "transparent"});
    $(this).css({"background-color": "white"});
  });
  $(".table_row.clickable").click(function(){
    if ($(this).find("a").attr("href")){
      window.location.href = $(this).find("a").attr("href");
    }
  });
}
