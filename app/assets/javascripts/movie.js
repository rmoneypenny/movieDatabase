$(document).on("click", ".review-button", function(){
    var divID = ($(this).parent().siblings("div").eq(1).attr("id"));
    var newDivID = "#" + divID;
    $(newDivID).slideToggle();
});