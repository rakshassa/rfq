font_size 10

pdf.text "RFQ Request", :align => :center, :size => 40, :style => :bold

pdf.text "<b>RFQ:</b>  #{@rfqquote.whole_printable_id}", :inline_format => true, :size => 20
pdf.text "<b>Date:</b>  #{@rfqform.date.to_s}", :inline_format => true, :size => 20

pdf.move_down(10)
stroke_horizontal_rule
pdf.move_down(10)

full = 550
gap = 10
@lowest = cursor

@col_start = cursor
	
bounding_box([0, @col_start], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Vendor:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{@vendor.name}"
		pdf.text "Street Address"
		pdf.text "City, State, Zip"
		pdf.text "Phone Number"
	end	
end

pdf.move_down(gap)

bounding_box([0,cursor], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>RFQ Contact:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{@rfq_contact.name}"
		pdf.text "#{@rfq_contact.email}"
	end	
end

@lowest = cursor

bounding_box([((full+gap)/2), @col_start], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Requisitioned by:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{Employee.find(@rfqform.req_by).name}"
		pdf.text "#{Employee.find(@rfqform.req_by).email}"
	end			
end

pdf.move_down(gap)

bounding_box([((full+gap)/2), cursor], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Engineer:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{Employee.find(@rfqform.engineer).name}"
		pdf.text "#{Employee.find(@rfqform.engineer).email}"
	end			
end	

if (cursor < @lowest) then @lowest = cursor end
move_cursor_to @lowest


pdf.move_down(10)
stroke_horizontal_rule
pdf.move_down(10)

@col_start = cursor


bounding_box([0, @col_start], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Part Number:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do			
		pdf.text "#{@part.name}  <b>Revision: </b> #{@rfqpart.revision}", :inline_format => true
	end	
end	

bounding_box([0,cursor], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>PO/Release Type:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{@rfqform.release_type}"
	end	
end

bounding_box([0,cursor], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>PPAP or other sample quality verification:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{@rfqform.ppap}"
	end	
end

@lowest = cursor - 10

bounding_box([((full+gap)/2), @col_start], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Description:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{@part.description}"
	end			
end	

bounding_box([((full+gap)/2), cursor], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Expected Launch Date:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{@rfqform.launch_date}"
	end			
end	

if (cursor < @lowest) then @lowest = cursor end
move_cursor_to @lowest


pdf.move_down(10)
stroke_horizontal_rule
pdf.move_down(10)

pdf.text "<b>Additional Information:</b>", :inline_format => true
pdf.text "#{@rfqform.info}"



pdf.move_down(10)
stroke_horizontal_rule
pdf.move_down(10)


@col_start = cursor
	
bounding_box([0, @col_start], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Quotation Number:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do			
		pdf.text "#{@rfqquote.quote_number}"
	end	
end	

bounding_box([0,cursor], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Quotation Submitted by:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{@rfqquote.submitted_by}"
	end	
end

bounding_box([0,cursor], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Any Exceptions:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		if @rfqquote.exceptions? then
			pdf.text "Yes"
		else
			pdf.text "No"
		end		
	end	
end

@lowest = cursor

bounding_box([((full+gap)/2), @col_start], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Quotation Date:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{@rfqquote.quote_date.to_s}"
	end			
end	

bounding_box([((full+gap)/2), cursor], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Valid Till:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do
		pdf.text "#{@rfqquote.valid_till.to_s}"
	end			
end	


if (cursor < @lowest) then @lowest = cursor end
move_cursor_to @lowest


pdf.move_down(10)
stroke_horizontal_rule
pdf.move_down(10)

@col_start = cursor
bounding_box([0, @col_start], :width=>(full/2)) do
	bounding_box([0, 0], :width=>((full/4)-gap)) do
		pdf.text "<b>Unit of Measure:</b>", :inline_format => true
	end
	bounding_box([(full/4), bounds.top], :width=>((full/4)-gap)) do			
		pdf.text "#{@rfqpart.units}"
	end	
end	


pdf.move_down(10)


parts = []
parts << ["Quantity", "Notes", "Unit Price", "Tooling", "NRE", "Feedback"]


@rfqquote.rfqquote_eaus.map do |eau|
	qty = (@rfqpart.qty * Eau.find(eau.eau_id).value).to_s

	if (eau.no_quote) then
		parts << [
			qty,
			eau.parts_note,
			"No Quote",
			"",
			"",
			eau.feedback
		]		
	else
		parts << [
			qty,
			eau.parts_note,
			number_to_currency(eau.unit_price),
			number_to_currency(eau.tooling),
			number_to_currency(eau.nre),
			eau.feedback
		]	
	end



end

pdf.table parts, 
	:row_colors => ["FFFFFF", "DDDDDD"], 
	:header => true,
	:column_widths => [100,110,50,50,50,180] do 

	row(0).font_style = :bold
	row(0).border_width = 2

end

pdf.move_down(20)

pdf.text "<b>Quotation Notes:</b>", :inline_format => true
pdf.text "#{@rfqquote.quote_note}"

