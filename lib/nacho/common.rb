# The common code module for the FormBuilder helper and the form tag helper.
#
# @author Daniel Ward
module Nacho::Common
  include ActionView::Context

  HTML5_OPTION_VALUE_KEY    = "data-nacho-option-value-key"
  HTML5_OPTION_TEXT_KEY     = "data-nacho-option-text-key"
  HTML5_NEW_ITEM_VALUE_KEY  = "data-nacho-new-value-key"
  HTML5_MODAL_ID_KEY        = "data-nacho-modal-id"
  HTML5_MODAL_HTML_KEY      = "data-nacho-modal"
  HTML5_ADD_NEW_VALUE_KEY   = "data-nacho-add-new-value"

  private

  # The helper to build the options for the form element, based on the given options.
  #
  # @param [Symbol] method See http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-select.
  # @param [Array] choices The list of choices for the select, shoudl be in [[val, display],...] format
  # @param [Hash] options the options to create a message with.
  # @option options [Boolean] :include_blank Include a blank option (Forced to <tt>true</tt> when <tt>choices.count</tt> == 0)
  # @option options [String] :new_option_text Text to display as the <tt>option</tt> that will trigger the new modal (Default "-- Add new --", will be ignored if <tt>html_options[:multiple]</tt> is set to <tt>true</tt>)
  # @option options [Symbol] :value_key The attribute of the model that will be used as the <tt>option</tt> value from the JSON return when a new record is created
  # @option options [Symbol] :text_key The attribute of the model that will be used as the <tt>option</tt> display content from the JSON return when a new record is created
  # @option options [Symbol] :new_key The JSON key that will contain the value of the record that was created with the modal
  # @option options [String] :modal_title The title of the modal (Default to "Add new <model.class.name>")
  # @option options [String] :partial The form partial for the modal body
  # @param [Hash] html_options See http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-select.
  def build_options(method, choices = nil, options = {}, html_options = {})

    new_option_value = Random.new.rand(-10000...-100)
    modal_id_suffix = Random.new.rand(100...10000)

    choices ||= []
    choices << [(options[:new_option_text] || '-- Add new --'), new_option_value] unless html_options[:multiple]

    options[:include_blank] = (choices.count == 1)
    html_options[:include_blank] = options[:include_blank]

    html_options[HTML5_ADD_NEW_VALUE_KEY]   = new_option_value
    html_options[HTML5_MODAL_ID_KEY]        = "##{method.to_s}_nacho_modal_#{modal_id_suffix}"
    html_options[HTML5_OPTION_VALUE_KEY]    = options[:value_key] if options[:value_key].present?
    html_options[HTML5_OPTION_TEXT_KEY]     = options[:text_key]  if options[:text_key].present?
    html_options[HTML5_NEW_ITEM_VALUE_KEY]  = options[:new_key]   if options[:new_key].present?

    modal_options = {
        id: html_options[HTML5_MODAL_ID_KEY].gsub(/^#/, ''),
        title: options[:modal_title] || "Add new #{method.to_s.humanize}",
        body: options[:partial].html_safe
    }

    html_options[HTML5_MODAL_HTML_KEY] = escape_once nacho_form_modal(modal_options)

    {
        choices: choices,
        html_options: html_options,
        options: options,
        button: button_tag((options[:new_option_text] || 'Add new'), type: :button, data: { toggle: 'modal', target: html_options[HTML5_MODAL_ID_KEY] })
    }
  end

  def nacho_form_modal(options = {})
    content_tag :div, id: options[:id], class: "modal fade #{options[:class]}", role: 'dialog', tabindex: '-1' do
      content_tag :div, class: 'modal-dialog' do
        content_tag :div, class: 'modal-content' do

          head = content_tag :div, class: 'modal-header' do
            [
                content_tag(:button, content_tag(:span, '&times;', aria: {hideen: true} ), class: 'close', type: :button, data: {dismiss: :modal}, aria: {label: 'Close'}),
                content_tag(:h4, options[:title], class: 'modal-title')
            ].join(' ')
          end

          body = content_tag :div, class: 'modal-body' do
            options[:body]
          end

          footer = content_tag :div, class: 'modal-footer' do
            [
                content_tag(:button, 'Close', class: 'btn btn-default', type: :button, data: {dismiss: :modal}),
                content_tag(:button, 'Save', class: 'btn btn-default', type: :button)
            ].join(' ')
          end

          head + body + footer
        end
      end
    end
  end
end