module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Vendor Portal"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end


  def sortable(column, title = nil)
  	title ||= column.titleize
  	css_class = ""    
  	direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"  	

  	if (column == sort_column) then
  		if (sort_direction == "asc") then
  			out = capture {image_tag "up_arrow.gif"}
        css_class += "current asc"
  		else
  			out = capture {image_tag "down_arrow.gif"}
        css_class += "current desc"
  		end
  		out << capture { link_to (" " + title), { :sort => column, :direction => direction }, { :class => css_class } }
  	else 
  		out = capture { link_to title, { :sort => column, :direction => direction }, { :class => css_class } }
  	end
  	
  end

  def default_cert(cert)
    cert ? "display:block" : "display:none"
  end
end
