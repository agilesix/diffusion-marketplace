(($) => {
    const $document = $(document);

    function displayCorePeopleResource() {
        let addCorePeopleResourceButton = $('#link_to_add_button_core_people_resource');
        if (addCorePeopleResourceButton.is(':visible')) {
            addCorePeopleResourceButton.click();
        }
    }

    function requireCorePeopleResourceInput() {
        $('.practice-input').each(function() {
            if ($(this).closest('li').hasClass('core-people-resource-li')) {
                let is_published = document.getElementById("hidden_publish").value;
                if(is_published == "true") {
                    $(this).attr('required', 'true');
                    $(this).addClass('dm-required-field');
                }
                else{
                    $(this).removeAttr('required');
                    $(this).removeClass('dm-required-field');
                }
            }
        })
    }

    function displayCorePeopleTrashContainer() {
        let corePeopleLi = $('.core-people-resource-li');
        if (corePeopleLi.length > 1) {
            corePeopleLi.not(':first').find('.trash-container').css('display', 'block');
        }
    }

    function initializeImplementationForm() {
        hideResources('core_attachment');
        hideResources('optional_attachment');
        hideResources('support_attachment');

        attachDeleteResourceListener();
        attachAddResourceListener("core_attachment_file_form", "display_core_attachment_file", "core_attachment", "file" );
        attachAddResourceListener("core_attachment_link_form", "display_core_attachment_link", "core_attachment", "link" );

        attachAddResourceListener("optional_attachment_file_form", "display_optional_attachment_file", "optional_attachment", "file" );
        attachAddResourceListener("optional_attachment_link_form", "display_optional_attachment_link", "optional_attachment", "link" );

        attachAddResourceListener("support_attachment_file_form", "display_support_attachment_file", "support_attachment", "file" );
        attachAddResourceListener("support_attachment_link_form", "display_support_attachment_link", "support_attachment", "link" );


        $document.on('click', '#cancel_core_attachment_file', function (e) {
            e.preventDefault();
            document.getElementById('core_resource_attachment_file').checked = false;
            document.getElementById('core_attachment_file_form').style.display = 'none';
        });
        $document.on('click', '#cancel_core_attachment_link', function (e) {
            e.preventDefault();
            document.getElementById('core_resource_attachment_link').checked = false;
            document.getElementById('core_attachment_link_form').style.display = 'none';
        });

        $document.on('click', '#cancel_optional_attachment_file', function (e) {
            e.preventDefault();
            document.getElementById('optional_resource_attachment_file').checked = false;
            document.getElementById('optional_attachment_file_form').style.display = 'none';
        });
        $document.on('click', '#cancel_optional_attachment_link', function (e) {
            e.preventDefault();
            document.getElementById('optional_resource_attachment_link').checked = false;
            document.getElementById('optional_attachment_link_form').style.display = 'none';
        });

        $document.on('click', '#cancel_support_attachment_file', function (e) {
            e.preventDefault();
            document.getElementById('support_resource_attachment_file').checked = false;
            document.getElementById('support_attachment_file_form').style.display = 'none';
        });
        $document.on('click', '#cancel_support_attachment_link', function (e) {
            e.preventDefault();
            document.getElementById('support_resource_attachment_link').checked = false;
            document.getElementById('support_attachment_link_form').style.display = 'none';
        });

        displayCorePeopleResource();
        requireCorePeopleResourceInput();
        displayCorePeopleTrashContainer();

    }

    function hideResources(sArea) {
        const areas = [sArea];
        areas.forEach(a => {
            $(`#display_${a}_form div[id*="_form"]`).hide();
            $(`#display_${a}_form div[id*="_file"]`).hide();
            $(`#display_${a}_form div[id*="_link"]`).hide();
        });
    }

    $document.on('turbolinks:load', initializeImplementationForm);
})(window.jQuery);
