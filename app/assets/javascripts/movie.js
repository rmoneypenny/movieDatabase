
$(document).on("click", ".review-button", function(){
    var divID = ($(this).parent().attr("id"));
    var newDivID = "#" + "review-" + divID;
    $(newDivID).slideToggle();
});


$(document).on("click", ".one-star", function(){
	score = 1;
	var divID = $(this).parent().parent().attr("id");
	updateStars(divID, score);
	updateScoreField(divID, score);
});	
$(document).on("click", ".two-star", function(){
	score = 2;	
	var divID = $(this).parent().parent().attr("id");
	updateStars(divID, score);
	updateScoreField(divID, score);
});	
$(document).on("click", ".three-star", function(){
	score = 3;	
	var divID = $(this).parent().parent().attr("id");
	updateStars(divID, score);
	updateScoreField(divID, score); 
});	
$(document).on("click", ".four-star", function(){
	score = 4;	
	var divID = $(this).parent().parent().attr("id");
	updateStars(divID, score);
	updateScoreField(divID, score);
});	
$(document).on("click", ".five-star", function(){
	score = 5;	
	var divID = $(this).parent().parent().attr("id");
	updateStars(divID, score);
	updateScoreField(divID, score);  
});	

$(document).on("click", "#moreReviews", function(){
	var moviedbid = $(this).parent().attr("id");
	$(location).attr('href', "/reviews/" + moviedbid);

});	



function updateStars(divID, score){

	var html = "<button type=\"button\" class=\"btn btn-default btn-default\">";
	var starNumbers = ["one-star", "two-star", "three-star", "four-star", "five-star"];
    for(i=0; i<5; i++){
		if(i<score){
			html += "<span class=\"glyphicon glyphicon-star star star-hover " + starNumbers[i] + "\"></span>";
		}
		else{
			html += "<span class=\"glyphicon glyphicon-star-empty star-hover " + starNumbers[i] + "\"></span>";
		}
	};
	html += "<br></button>";
	document.getElementById(divID).innerHTML = html;   
};

function updateScoreField(divID, score){
	
	var moviedbid = "score-" + divID.slice(6, divID.length);
	document.getElementById(moviedbid).value = score;
	
};

