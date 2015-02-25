{extends file='_index.tpl'}


{block name="content-body"}
    <div class="span12">


        <div class="b-wbox">

            <div class="b-wbox-content nopadding">
                <form action="" method="POST" class="form-horizontal uniform" enctype="multipart/form-data">

                    <input type="hidden" name="security_ls_key" value="{$ALTO_SECURITY_KEY}"/>

                    <div class="control-group">
                        <label class="control-label">
                            Plugin
                        </label>

                        <div class="controls">
                            <select name="plugin" id="plugin">
                                {foreach $aPlugins as $oPlugin}
                                    <option value="{$oPlugin}">
                                        {$oPlugin}
                                    </option>
                                {/foreach}
                            </select>
                            <span class="help-block">Choose plugin</span>
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label">
                            Module
                        </label>

                        <div class="controls">
                            <input type="text" name="module" id="module" class="input-text"/>
                            <span class="help-block">Module Path: <span id="module_exist" class="badge"></span> <span
                                        id="module_path"></span></span>
                            <span class="help-block">Mapper Path: <span id="mapper_exist" class="badge"></span> <span
                                        id="mapper_path"></span></span>
                            <button type="button" id="generate_module" class="btn btn-primary" disabled="disabled"
                                    name="generate_module">Generate Module
                            </button>
                            <button type="button" id="generate_mapper" class="btn btn-primary" disabled="disabled"
                                    name="generate_module">Generate Mapper
                            </button>
                        </div>

                    </div>

                    <div class="control-group">
                        <label class="control-label">
                            Entity
                        </label>

                        <div class="controls">
                            <input type="text" name="entity" id="entity" class="input-text"/>
                            <span class="help-block">Entity Path: <span id="entity_exist" class="badge"></span> <span
                                        id="entity_path"></span></span>
                            <span class="help-block">Table Name: <span id="table_exist" class="badge"></span> <span
                                        id="table_name"></span></span>
                            <button type="button" id="generate_entity" class="btn btn-primary" disabled="disabled"
                                    name="generate_entity">Generate Entity
                            </button>
                        </div>
                    </div>

                    <div class="control-group">
                        <label class="control-label">
                            Event
                        </label>

                        <div class="controls">
                            <input type="text" name="event" id="event" class="input-text"/>
                            <span class="help-block">Event</span>
                            <span class="help-block">Event edit Path: <span id="event_edit_exist" class="badge"></span> <span
                                        id="event_edit_path"></span></span>
                            <span class="help-block">Event list Path: <span id="event_list_exist" class="badge"></span> <span
                                        id="event_list_path"></span></span>

                            <button type="button" id="generate_event_edit" class="btn btn-primary" disabled="disabled"
                                    name="generate_event">Generate Edit file
                            </button>
                            <button type="button" id="generate_event_list" class="btn btn-primary" disabled="disabled"
                                    name="generate_event">Generate List file
                            </button>
                            <button type="button" id="generate_event_action" class="btn btn-primary" disabled="disabled"
                                    name="generate_event">Generate text for Action, Menu, Hook
                            </button>
                        </div>
                    </div>

                </form>
            </div>
        </div>

        <div id="event_action_code">
        </div>

    </div>
    <script>
        $('#module').on('input', function () {
            check_files();
        });

        $('#entity').on('input', function () {
            check_files();
        });

        $('#event').on('input', function () {
            check_files();
        });

        $('#plugin').on('change', function () {
            check_files();
        });

        $('#generate_module').on('click', function () {
            generate_files('module');
        });
        $('#generate_mapper').on('click', function () {
            generate_files('mapper');
        });
        $('#generate_entity').on('click', function () {
            generate_files('entity');
        });
        $('#generate_event_edit').on('click', function () {
            generate_files('event_edit');
        });
        $('#generate_event_list').on('click', function () {
            generate_files('event_list');
        });
        $('#generate_event_action').on('click', function () {
            generate_files('event_action');
        });

        function generate_files(what) {
            ls.ajax(aRouter['admin'] + 'ajax/generate_file/', {
                'what': what,
                'plugin': $('#plugin').val(),
                'module': $('#module').val(),
                'entity': $('#entity').val(),
                'event': $('#event').val()
            }, function (response) {
                if (!response.bStateError) {

                    check_files();
                    if (what == 'event_action') {
                        $('#event_action_code').html(response.sResult);
                    }
                } else {
                    ls.msg.error(response.sMsgTitle, response.sMsg);
                }
            });
        }

        function check_files() {
            ls.ajax(aRouter['admin'] + 'ajax/check_file/', {
                'plugin': $('#plugin').val(),
                'module': $('#module').val(),
                'entity': $('#entity').val(),
                'event': $('#event').val()
            }, function (response) {
                if (!response.bStateError) {

                    if ($('#module').val()) {
                        $('#generate_module').enable();
                        $('#generate_mapper').enable();

                        $('#module_path').html(response.sModulePath);
                        if (response.sModuleExist) {
                            $('#module_exist').html('EXIST!!!');
                        } else {
                            $('#module_exist').html('');
                        }

                        $('#mapper_path').html(response.sMapperPath);
                        if (response.sMapperExist) {
                            $('#mapper_exist').html('EXIST!!!');
                        } else {
                            $('#mapper_exist').html('');
                        }

                    } else {
                        $('#generate_module').enable(false);
                        $('#generate_mapper').enable(false);
                    }

                    if ($('#entity').val()) {

                        $('#generate_entity').enable();

                        $('#entity_path').html(response.sEntityPath);

                        if (response.sEntityExist) {
                            $('#entity_exist').html('EXIST!!!');
                        } else {
                            $('#entity_exist').html('');
                        }

                        $('#table_name').html(response.sTableName);
                        if (response.sTableExist) {
                            $('#table_exist').html('exist');
                        } else {
                            $('#table_exist').html('');
                        }

                    } else {
                        $('#generate_entity').enable(false);
                    }


                    if ($('#entity').val() && $('#module').val() && $('#event').val()) {
                        $('#generate_event_edit').enable();
                        $('#generate_event_list').enable();
                        $('#generate_event_action').enable();

                        $('#event_edit_path').html(response.sEventEditPath);
                        $('#event_list_path').html(response.sEventListPath);

                        if (response.sEventEditExist) {
                            $('#event_edit_exist').html('EXIST!!!');
                        } else {
                            $('#event_edit_exist').html('');
                        }
                        if (response.sEventListExist) {
                            $('#event_list_exist').html('EXIST!!!');
                        } else {
                            $('#event_list_exist').html('');
                        }

                    } else {
                        $('#generate_event_edit').enable(false);
                        $('#generate_event_list').enable(false);
                        $('#generate_event_action').enable(false);

                    }

                } else {
                    ls.msg.error(response.sMsgTitle, response.sMsg);
                }
            });
        }


    </script>
{/block}