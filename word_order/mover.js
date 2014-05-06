// Generated by CoffeeScript 1.7.1
(function() {
  var $;

  $ = jQuery;

  $(function() {
    var $draggable, $droppables;
    $("button").button();
    $("#sortable").sortable({
      revert: true,
      items: "> li",
      axis: "x"
    });
    $("li").disableSelection();
    $("#check").click(function() {
      var $list, solution, user_input;
      $list = $("ul#sortable");
      solution = $list.data("sol");
      user_input = "";
      $list.children("li").each(function() {
        console.log($(this).text());
        return user_input = user_input + " " + $(this).text();
      });
      user_input = user_input.trim();
      if (user_input === solution) {
        return $("#status").attr("class", "ui-icon ui-icon-circle-check");
      } else {
        return $("#status").attr("class", "ui-icon ui-icon-circle-close");
      }
    });
    $droppables = $(".droppable");
    $draggable = $("#draggable_clitic").draggable();
    $droppables.droppable({
      drop: function(e, ui) {
        $(this).css({
          backgroundColor: "red"
        }).text($draggable.text());
        return $draggable.remove();
      }
    });
    $("#reset").click(function() {
      $droppables.css({
        backgroundColor: "#CCCCCC"
      }).text("");
      return $("#task").append($draggable.draggable());
    });
    return $("#check_clit").click(function() {
      return $droppables.each(function() {
        var $drop;
        $drop = $(this);
        if ($drop.text() && $drop.data("sol")) {
          console.log("right");
          $("#status_clit").attr("class", "ui-icon ui-icon-circle-check");
          return false;
        } else {
          console.log("false");
        }
        return $("#status_clit").attr("class", "ui-icon ui-icon-circle-close");
      });
    });
  });

}).call(this);

//# sourceMappingURL=mover.map
