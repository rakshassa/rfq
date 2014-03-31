
pdf.text "RFQ Request", :align => :center, :size => 40, :style => :bold

pdf.text "<b>RFQ:</b>  #{@rfqform.printable_id}", :inline_format => true, :size => 20
pdf.text "<b>Date:</b>  #{@rfqform.date.to_s}", :inline_format => true, :size => 20
pdf.text "<b>RFQ Due Date:</b>  #{@rfqform.due_date.to_s}", :inline_format => true, :size => 20
pdf.text "<b>Program:</b>  #{Part.find(@rfqform.program).name.to_s}", :inline_format => true, :size => 20

pdf.move_down(20)
pdf.text "Program Detail", :style => :bold, :size => 20
pdf.text "<b>PO/Release Type:</b>  #{@rfqform.release_type}", :inline_format => true
pdf.text "<b>Expected Launch Date:</b>  #{@rfqform.launch_date}", :inline_format => true
pdf.text "<b>EAUs:</b>  #{@rfqform.eaus.map { |f| f.value }.join(', ')}", :inline_format => true

pdf.move_down(20)
pdf.text "Quality Requirements", :style => :bold, :size => 20
pdf.text "<b>PPAP or other sample quality verification:</b>", :inline_format => true
pdf.text "    #{@rfqform.ppap}"

pdf.move_down(20)
pdf.text "Contact Info", :style => :bold, :size => 20

if  !@rfqform.req_by.blank? then 
	pdf.text "<b>Requisitioned by:</b>  #{@rfqform.req_by_employee.name}", :inline_format => true
else 
	pdf.text "<b>Requisitioned by:</b>  <i>None Selected</i>", :inline_format => true
end

if !@rfqform.engineer.nil? then
    pdf.text "<b>Engineer:</b>  #{@rfqform.engineer_employee.name}", :inline_format => true
else
	pdf.text "<b>Engineer:</b>  <i>None Selected</i>", :inline_format => true
end


pdf.move_down(20)


parts = []
parts << ["Part", "Description", "Rev", "Qty", "Units", "Vendors"]


@rfqform.rfqparts.map do |part|
	parts << [
	Part.find(part.part_number).name,
	Part.find(part.part_number).description,
	part.revision,
	part.qty,
	part.units,
	part.vendor_name_list
]

end

pdf.table parts, 
	:row_colors => ["FFFFFF", "DDDDDD"], 
	:header => true,
	:column_widths => [100,110,50,50,50,180] do 

	row(0).font_style = :bold
	row(0).border_width = 2

end


pdf.move_down(20)
pdf.text "<b>Additional Information:</b>", :inline_format => true
pdf.text "#{@rfqform.info}"
