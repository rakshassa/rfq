function drawing_selected(selector) {	

	selector.previousElementSibling.innerHTML = selector.value.split('\\')[selector.value.split('\\').length-1];
	selector.previousElementSibling.previousElementSibling.style.visibility="hidden";

}

function part_changed(target_node, part) {
	//alert(target_node + " changing to " + part.item(part.selectedIndex).getAttribute("desc"));
	target_node.innerHTML = part.item(part.selectedIndex).getAttribute("desc");
}

function employee_changed(target_node, employee) {
	//alert(target_node + " changing to " + part.item(part.selectedIndex).getAttribute("desc"));
	target_node.innerHTML = employee.item(employee.selectedIndex).getAttribute("email");
}

function NoQuoteChanged(target_node) {
	if (target_node.style.visibility == "hidden") {
		target_node.style.visibility="visible";
	} else { 
		target_node.style.visibility="hidden";
	}
}

$(function() {
  $('#accordion').accordion({
    collapsible: true,
    heightStyle: "content",
    icons: {
      header: "ui-icon-arrowthick-1-e",
      activeHeader: "ui-icon-arrowthick-1-s"
    }
  });
  return $('#accordion #keep_link').click(function() {
    window.location = $(this).attr('href');
    return false;
  });
});
