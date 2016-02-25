(function ( $ ) {
    $.nacho = function(element, options) {

        const HTML5_OPTION_VALUE_KEY    = "data-nacho-option-value-key";
        const HTML5_OPTION_TEXT_KEY     = "data-nacho-option-text-key";
        const HTML5_NEW_ITEM_VALUE_KEY  = "data-nacho-new-value-key";
        const HTML5_MODAL_ID_KEY        = "data-nacho-modal-id";
        const HTML5_MODAL_HTML_KEY      = "data-nacho-modal";
        const HTML5_ADD_NEW_VALUE_KEY   = "data-nacho-add-new-value";
        const HTML5_PREVIOUS_VALUE_KEY  = "data-nacho-previous-value";

        /*
            These defautls will be overwritten if the HTML5 attributes are present
         */
        var defaults = {
            optionValueKey: 'value',
            optionTextKey:  'text',
            newItemValueKey:  'id',
            formElementsToRemove: ['input[type=submit]']
        };

        var plugin = this;

        plugin.settings = {};

        var $element = $(element);

        var modalId, $modal;

        /*
            Initialize the plugin
         */
        plugin.init = function() {
            plugin.settings = $.extend({}, defaults, options);

            /*
                Set the settings if the specified HTML5 attributes are present
             */
            if ($element.attr(HTML5_OPTION_VALUE_KEY)) {
                plugin.settings.optionValueKey = $element.attr(HTML5_OPTION_VALUE_KEY);
            }

            if ($element.attr(HTML5_OPTION_TEXT_KEY)) {
                plugin.settings.optionTextKey = $element.attr(HTML5_OPTION_TEXT_KEY);
            }

            if ($element.attr(HTML5_NEW_ITEM_VALUE_KEY)) {
                plugin.settings.newItemValueKey = $element.attr(HTML5_NEW_ITEM_VALUE_KEY);
            }

            $element.attr(HTML5_PREVIOUS_VALUE_KEY, $element.val());

            modalId = $element.attr(HTML5_MODAL_ID_KEY);
            $modal = $($element.attr(HTML5_MODAL_HTML_KEY));

            insertModal();
            initListeners();
        };

        var initListeners = function() {
            /*
                When the add new item is selected, then show the modal
             */
            $element.on('change', function () {
                if ($(this).attr(HTML5_ADD_NEW_VALUE_KEY) == $(this).val()) {
                    $modal.modal('show');
                }
            });

            /*
                Store the currently selected value when the select is focused on
             */
            $element.on('focus', function(){
                $(this).attr(HTML5_PREVIOUS_VALUE_KEY, $(this).val());
            });

            /*
                 When the referenced dialog is closed, we need to see if the select
                 box needs to be reset.
             */
            $modal.on('hidden.bs.modal', function (e) {
                /*
                     If the value of the box is still the the 'add new' option, then
                     set to the first value.
                 */
                if ($element.attr(HTML5_ADD_NEW_VALUE_KEY) == $element.val()) {
                    $element.val($element.attr(HTML5_PREVIOUS_VALUE_KEY));
                }
            });

            /*
                Add the listener for the modal submit button to create the new record
             */
            $modal.find('.modal-footer button').on('click', function () {
                var form = $modal.find('form');

                /*
                    Create the ajax request with type JSON create the new record
                 */
                $.ajax({
                    type: "POST",
                    dataType: 'json',
                    url: form.attr('action'),
                    data: form.serializeJSON(),
                    success: function (data) {

                        var selected = $element.val() || [];

                        /*
                            When the select is a multiple selection, then we can add the new item id to the selected
                            array and clear out all the current options.

                            If the select is a single select, then we need to delete all the options
                            except for the last one, which is the option to add a new record
                         */
                        if ($element.attr('multiple') == 'multiple') {
                            selected.push('' + data[plugin.settings.newItemValueKey]);
                            $element.find("option").remove()

                        } else {
                            $element.find("option:lt(-1)").remove();

                        }

                        /*
                            Add the new options from the data set we recieved from the server
                         */
                        $.each(data.options, function (index, item) {
                            $element.prepend($('<option />').attr('value', item[plugin.settings.optionValueKey]).text(item[plugin.settings.optionTextKey]));
                        });

                        /*
                            When the select is set to multiple, then we set the val with the updated array.
                            Taking a unique in case there is an issue with repeated values.

                            For single select we need to add the blank option back to the top.
                            Set the value to the returned key.
                         */
                        if ($element.attr('multiple') == 'multiple') {
                            $element.val($.unique(selected));

                        } else {
                            $element.prepend($('<option />').attr('value', '').text(''));
                            $element.val('' + data[plugin.settings.newItemValueKey]);

                        }

                        /*
                            Hide the modal
                         */
                        $modal.modal('hide');

                        // trigger the updated event.
                        $element.trigger(jQuery.Event("nacho-select:updated"))
                    },
                    error: function (e) {
                        alert(e);
                    }
                });
            });
        };

        /*
            Append the modal to the body, making it the last item in the DOM.
            This is due to the HTML spec that prevents nested forms.
         */
        var insertModal = function() {
            // configure the modal.
            var selector = plugin.settings.formElementsToRemove;

            if (plugin.settings.formElementsToRemove instanceof Array) {
                selector = plugin.settings.formElementsToRemove.join(',');
            }

            $modal.find('form').find(selector).remove();
            $modal.appendTo('body');
        };

        plugin.init();

    };

    /**
     * Add the nacho function to the jQuery namespace
     *
     * @param options The options for the plugin
     * @returns {*}
     */
    $.fn.nacho = function(options) {
        return this.each(function() {
            if (undefined == $(this).data('nacho') && $(this)[0].tagName.toLowerCase() == 'select') {
                var plugin = new $.nacho(this, options);
                $(this).data('nacho', plugin);
            }
        });
    }
}( jQuery ));