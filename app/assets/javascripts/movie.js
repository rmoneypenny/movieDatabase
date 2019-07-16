
$(document).on("click", ".review-button", function(){
    var divID = ($(this).parent().siblings("div").eq(1).attr("id"));
    var newDivID = "#" + divID;
    $(newDivID).slideToggle();
});


$(document).on("click", ".one-star", function(){
	score = 1;
	var divID = $(this).parent().parent().attr("id");
	html = updateStars(score);
	document.getElementById(divID).innerHTML = html;   
});	
$(document).on("click", ".two-star", function(){
	score = 2;	
	var divID = $(this).parent().parent().attr("id");
	html = updateStars(score);
	document.getElementById(divID).innerHTML = html;   
});	
$(document).on("click", ".three-star", function(){
	score = 3;	
	var divID = $(this).parent().parent().attr("id");
	html = updateStars(score);
	document.getElementById(divID).innerHTML = html;   
});	
$(document).on("click", ".four-star", function(){
	score = 4;	
	var divID = $(this).parent().parent().attr("id");
	html = updateStars(score);
	document.getElementById(divID).innerHTML = html;   
});	
$(document).on("click", ".five-star", function(){
	score = 5;	
	var divID = $(this).parent().parent().attr("id");
	html = updateStars(score);
	document.getElementById(divID).innerHTML = html;   
});	

function updateStars(score){

	var html = "<button type=\"button\" class=\"btn btn-default btn-sm\">";
    for(i=0; i<5; i++){
		if(i<score){
			html += "<span class=\"glyphicon glyphicon-star star\"></span>";
		}
		else{
			html += "<span class=\"glyphicon glyphicon-star-empty\"></span>";
		}
	};
	html += "<br></button>";
	return html;
};

// var score = $(this).parent().siblings().val();
// <%= hidden_field_tag "score", 3 %>