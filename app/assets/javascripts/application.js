//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require react
//= require react_ujs
//= require components
//= require_tree .

( function( $ ) {

    var myIndex = 0;

    function carousel() {
        var i;
        var x = document.getElementsByClassName("mySlides");
        if(x != null ) {
            for (i = 0; i < x.length; i++) {
                x[i].style.display = "none";
            }
            myIndex++;
            if (myIndex > x.length) {myIndex = 1}
            if(x[myIndex-1] != null) {x[myIndex-1].style.display = "block";}
            setTimeout(carousel, 8000);
        }

    }

    $( document ).ready(function() {
        $('#cssmenu').prepend('<div id="menu-button">RoadQuest</div>');
        $('#cssmenu #menu-button').on('click', function(){
            var menu = $(this).next('ul');
            if (menu.hasClass('open')) {
                menu.removeClass('open');
            }
            else {
                menu.addClass('open');
            }
        });
        carousel();
    });
} )( jQuery );

