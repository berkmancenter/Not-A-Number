# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def render_destroy(resource_object, source, title)
    modal_content = <<-MODAL_CONTENT
      <div class=\\'warning\\'>
          <p>Are you sure?</p>
          <table><tr><td>
          #{button_to "Yes", resource_object, :method => :delete, :onclick => 'Modalbox.hide()'}
          </td><td>
          <input type=\\'button\\' value=\\'No\\' onclick=\\'Modalbox.hide()\\' />
          </td></tr></table>
      </div>
    MODAL_CONTENT

    modal_content.gsub!("\n", "")

    output_to_view = "Modalbox.show(\'#{modal_content}\', {title: \'#{title}\', width: 300});"
    return output_to_view
  end

  def update_group_list
    page.replace_html :group_list_container, Time.now.to_s(:db)
  end
  
  if ENV['R_HOME'].nil?
    ENV['R_HOME'] = "/Library/Frameworks/R.framework/Resources"
  end

end
