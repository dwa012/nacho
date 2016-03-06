require File.expand_path("../common", __FILE__)

# module Nacho
#   class FormBuilder < ActionView::Helpers::FormBuilder
module ActionView
  module Helpers
    module FormHelper
      include Nacho::Common

      # The helper for a FormBuilder class. Will create the select and the needed modal that contains the given
      # form for the target model to create.
      #
      # A multiple select will generate a button to trigger the modal.
      #
      # @param [Object] object_name The form object that the select helper is being called for
      # @param [Symbol] method See http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-select
      # @param [Array] choices The list of choices for the select, shoudl be in [[val, display],...] format
      # @param [Hash] options the options to create a message with.
      # @option options [Boolean] :include_blank Include a blank option (Forced to <tt>true</tt> when <tt>choices.count</tt> == 0)
      # @option options [String] :new_option_text Text to display as the <tt>option</tt> that will trigger the new modal (Default "-- Add new --", will be ignored if <tt>html_options[:multiple]</tt> is set to <tt>true</tt>)
      # @option options [Symbol] :value_key The attribute of the model that will be used as the <tt>option</tt> value from the JSON return when a new record is created
      # @option options [Symbol] :text_key The attribute of the model that will be used as the <tt>option</tt> display content from the JSON return when a new record is created
      # @option options [Symbol] :new_key The JSON key that will contain the value of the record that was created with the modal
      # @option options [String] :modal_title The title of the modal (Default to "Add new <model.class.name>")
      # @option options [String] :partial The form partial for the modal body
      # @param [Hash] html_options See http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-select
      def nacho_select(object_name, method, choices = nil, options = {}, html_options = {})
        nacho_options = build_options(method, choices, options, html_options)
        select_element = select(object_name, method, nacho_options[:choices], nacho_options[:options], nacho_options[:html_options])
        select_element += nacho_options[:button] if nacho_options[:html_options][:multiple]

        select_element
      end
    end
  end
end

class ActionView::Helpers::FormBuilder

  # The helper for a FormBuilder class. Will create the select and the needed modal that contains the given
  # form for the target model to create.
  #
  # A multiple select will generate a button to trigger the modal.
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
  def nacho_select(method, choices = nil, options = {}, html_options = {})
    @template.nacho_select(@object_name, method, choices, objectify_options(options), objectify_options(html_options))
  end
end