function drawing_selected(selector) {	

	selector.previousElementSibling.innerHTML = selector.value.split('\\')[selector.value.split('\\').length-1];
	selector.previousElementSibling.previousElementSibling.style.visibility="hidden";

}