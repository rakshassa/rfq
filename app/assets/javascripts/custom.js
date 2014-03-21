function drawing_selected(selector) {	

	selector.previousElementSibling.innerHTML = selector.value;
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


function NoQuoteChanged(target_node1, target_node2, target_node3) {
	if (target_node1.style.visibility == "hidden") {
		target_node1.style.visibility="visible";
    target_node2.style.visibility="visible";
    target_node3.style.visibility="visible";
	} else { 
		target_node1.style.visibility="hidden";
    target_node2.style.visibility="hidden";
    target_node3.style.visibility="hidden";
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

$(document).ready(function() {

  $('#build_date').daterangepicker(
      {
        ranges: {
           'Today': [moment(), moment()],
           'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
           'Last 7 Days': [moment().subtract('days', 6), moment()],
           'Last 30 Days': [moment().subtract('days', 29), moment()],
           'This Month': [moment().startOf('month'), moment().endOf('month')],
           'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
        },
        format: 'YYYY/MM/DD',
        startDate: moment().subtract('days', 29),
        endDate: moment(),
        showDropdowns: true
      }
  );

  $('#quote_date').daterangepicker(
      {
        ranges: {
           'Today': [moment(), moment()],
           'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
           'Last 7 Days': [moment().subtract('days', 6), moment()],
           'Last 30 Days': [moment().subtract('days', 29), moment()],
           'This Month': [moment().startOf('month'), moment().endOf('month')],
           'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
        },
        format: 'YYYY/MM/DD',
        startDate: moment().subtract('days', 29),
        endDate: moment(),
        showDropdowns: true
      }
  );

});
