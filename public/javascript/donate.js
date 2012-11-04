$(document).ready(function(){


  $(".donate-buttons a").click(function(){
    $(".donate-buttons a").removeClass("active");
    $(this).addClass("active");
    $("form input[name=amount]").val($(this).data("amount"));
  });
});