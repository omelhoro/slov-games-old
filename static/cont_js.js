$(document).ready(function(){   

    function control_input(event){
            var right=false;
            $event=$(event);
            $event.siblings("input").each(
            function(){
            user_input=$(this).val().trim().replace(" ","_");
            solution=$(this).data("sol");
            console.log(user_input,solution,right);
            if(user_input==solution)
                right=true;
            });
            if(right==true){
            $event.addClass("right").text('✓');
            }
            else{
            $event.addClass("false").text("X");
            }};
            
    $("span#au").click(function(){
        track=$(this).children("audio").each(function(){
            console.log("name",this)
            this.play() 
        });
    });
    
    $("button.corrector").click(function(){
        console.log("id",this.id);
        if(this.id==""){
            control_input(this);
        }
        else{
            $p=$(this).parent().prevAll().children("button");
            console.log("all",this.id,$p);
            $p.each(function(){control_input(this);});
        };
    });
    
    $("h2").siblings().hide();
    $("h2").click(function(){
        $clickedElement=$(this);
        console.log($clickedElement);
        $clickedElement.siblings().slideToggle("slow");
    });
    $('tr:nth-child(odd)').addClass("even");
    $("img").click(function(){
        lang=this.id;
        window.location.href="lek7_"+lang+".html";
    });
    function doOpen() {
        console.log(this)
        $(this).addClass("hover");
        $(this).children().css('visibility', 'visible');
    }
 
    function doClose() {
        $(this).removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
    }
    $("ul.dropdown li").hover(doOpen,doClose)
    

});
