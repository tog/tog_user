module Admin
  module UserHelper
    
    def select_state_tag(user)
      default_state = user.new_record? ? :passive : user.aasm_current_state

      events  = user.aasm_events_for_current_state.collect do |x| 
        [ I18n.t("tog_user.model.states.actions.#{x}"), x ] 
      end

      options = events.insert(0, [ "", '' ])

      select_tag("state_event", options_for_select(options.uniq, default_state))
    end
        
    # Return link to sort column with toggled sort order
    def link_to_sortable_column_header(field, order_by, sort_order, name)
      if order_by == field.to_s
        sort_order = (sort_order || '').upcase == 'DESC' ? 'ASC' : 'DESC'
        arrow = (sort_order == 'ASC') ? 'down' : 'up' 
      else
        sort_order = 'ASC'
        arrow = nil
      end
      new_params = params.merge(:order_by => field.to_s, :sort_order => sort_order)
      html = link_to(name, new_params)
      html << image_tag("/tog_core/images/ico/arrow-#{arrow}.gif") if arrow
      html
    end
  
    # Insert a li with link to filter
    #
    # Set field to nil to clear filter
    #
    # Options:
    #   :li_on: CSS class of <li> element if item is active (default: 'on')
    #
    def filter_item(field, value, name, options={})
      on_condition = params[field].to_s == value.to_s
      li_class = on_condition ? (options[:li_on] || 'on') : nil
      content_tag(:li, :class => li_class) do
        if value 
          link_to(name, params.merge(field => value.to_s))
        else
          link_to(name, params.except(field))
        end
      end
    end  
  end
end
