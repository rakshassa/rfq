function drawing_selected(selector) {	

	selector.previousElementSibling.innerHTML = selector.value.split('\\')[selector.value.split('\\').length-1];
	selector.previousElementSibling.previousElementSibling.style.visibility="hidden";

}

function part_changed(target_node, part) {
	//alert(target_node + " changing to " + part.item(part.selectedIndex).getAttribute("desc"));
	target_node.innerHTML = part.item(part.selectedIndex).getAttribute("desc");
}
