<?php

class PluginGenerator_ActionAdmin extends PluginGenerator_Inherits_ActionAdmin
{
    /**
     * Регистрация евентов
     */
    protected function RegisterEvent()
    {
        parent::RegisterEvent();

        $this->AddEvent('generator', 'EventGenerator');
        $this->AddEventPreg('/^ajax$/i', '/^check_file$/i', 'EventAjaxCheckFile');
        $this->AddEventPreg('/^ajax$/i', '/^generate_file$/i', 'EventAjaxGenerateFile');

    }

    public function EventAjaxGenerateFile()
    {

        // * Устанавливаем формат ответа
        E::ModuleViewer()->SetResponseAjax('json');

        $sPluginLow = F::StrUnderscore($this->GetPost('plugin'));
        $sModuleLow = F::StrUnderscore($this->GetPost('module'));
        $sEntityLow = F::StrUnderscore($this->GetPost('entity'));
        $sEventLow = F::StrUnderscore($this->GetPost('event'));

        $sWhat = $this->GetPost('what');

        $sPlugin = F::StrCamelize($sPluginLow);
        $sModule = F::StrCamelize($sModuleLow);
        $sEntity = F::StrCamelize($sEntityLow);
        $sEvent = F::StrCamelize($sEventLow);

        $sModulePath = dirname(dirname(dirname(dirname(__FILE__)))) . "/" . $sPluginLow . "/classes/modules";
        $sSkinPath = dirname(dirname(dirname(dirname(__FILE__)))) . "/" . $sPluginLow . "/templates/skin";


        if ($sWhat == 'module') {
            $this->CheckModuleDirs($sModulePath, $sModuleLow);
            E::Module('PluginGenerator\Generator')->GenerateModule($sModulePath . "/" . $sModuleLow . "/" . $sModule . ".class.php", $sPlugin, $sModule);
        }

        if ($sWhat == 'mapper') {
            $this->CheckModuleDirs($sModulePath, $sModuleLow);
            E::Module('PluginGenerator\Generator')->GenerateMapper($sModulePath . "/" . $sModuleLow . "/mapper/" . $sModule . ".mapper.class.php", $sPlugin, $sModule);
        }

        if ($sWhat == 'entity') {
            $this->CheckModuleDirs($sModulePath, $sModuleLow);
            $aRelations = array(/*array(	'name'=>'user',
									'type'=>'EntityORM::RELATION_TYPE_BELONGS_TO', 
									'entity'=>'ModuleUser_EntityUser', 
									'field'=>'user_id'),*/
            );

            E::Module('PluginGenerator\Generator')->GenerateEntity($sModulePath . "/" . $sModuleLow . "/entity/" . $sEntity . ".entity.class.php", $sPlugin, $sModule, $sEntity, $aRelations);
        }

        if ($sWhat == 'event_edit' || $sWhat == 'event_list' || $sWhat == 'event_action') {
            $this->CheckSkinDirs($sSkinPath);
            $oEntity = E::GetEntity("Plugin{$sPlugin}_Module{$sModule}_Entity{$sEntity}");

            $aFields = $oEntity->_getFields();
            $aRelations = $oEntity->_getRelations();
            $sPrimary = '';

            foreach ($aFields as $key => $oField) {
                if (is_numeric($key)) {
                    $aColumns[] = array('title' => $oField,
                        'getvalue' => 'get' . F::StrCamelize($oField) . '()',
                        'setvalue' => 'set' . F::StrCamelize($oField),
                        'relation' => false
                    );
                } elseif ($key == '#primary_key') {
                    $sPrimary = F::StrCamelize($oField);
                }
            }
            foreach ($aRelations as $key => $oRelation) {

                $aColumns[] = array('title' => $key,
                    'getvalue' => 'get' . F::StrCamelize($key) . '()->get' . F::StrCamelize($oRelation[2]) . '()',
                    'relation' => 'get' . F::StrCamelize($key) . '()'
                );
            }

            if ($sWhat == 'event_list') {
                $sTemplateListText = E::Module('PluginGenerator\Generator')->GenerateTemplateList($sSkinPath . "/admin-default/tpls/actions/admin/action.admin.content/" . $sEventLow . "_list.tpl", $sEventLow, $sEntity, $aColumns, $sPrimary);
                //$this->Viewer_Assign('sTemplateListText', $sTemplateListText);
            }
            if ($sWhat == 'event_edit') {
                $sTemplateEditText = E::Module('PluginGenerator\Generator')->GenerateTemplateEdit($sSkinPath . "/admin-default/tpls/actions/admin/action.admin.content/" . $sEventLow . "_edit.tpl", $sEventLow, $sEntity, $aColumns, $sPrimary);
                //$this->Viewer_Assign('sTemplateEditText', $sTemplateEditText);
            }

            if ($sWhat == 'event_action') {
                $oViewer = E::ModuleViewer()->GetLocalViewer();

                $sActionInit = "\$this->AddEvent('{$sEventLow}', 'Event{$sEvent}');";
                $oViewer->Assign('sActionInit', $sActionInit);

                $sActionText = E::Module('PluginGenerator\Generator')->GenerateAction($sEventLow, $sEvent, $sPlugin, $sModule, $sEntity, $aColumns, $sPrimary);
                $oViewer->Assign('sActionText', $sActionText);

                if (!file_exists($sSkinPath . "/admin-default/tpls/admin_menu.tpl")) {
                    $sMenuPath = $sSkinPath . "/admin-default/tpls/admin_menu.tpl";
                } else {
                    $sMenuPath = null;
                }
                $sMenuText = E::Module('PluginGenerator\Generator')->GenerateTemplateMenu($sMenuPath, $sEventLow, $sEntity);

                $oViewer->Assign('sMenuText', $sMenuText);
                $oViewer->Assign('sMenuPath', $sMenuPath);

                $sHookText = E::Module('PluginGenerator\Generator')->GenerateHook();
                $oViewer->Assign('sHookText', $sHookText);

                $sResult = $oViewer->Fetch('actions/admin/action.admin.generator_inner.tpl');
                E::ModuleViewer()->AssignAjax('sResult', $sResult);
            }
        }


    }

    public function CheckModuleDirs($sModulePath, $sModuleLow)
    {
        if (!file_exists($sModulePath)) {
            mkdir($sModulePath);
        }
        if (!file_exists($sModulePath . "/" . $sModuleLow)) {
            mkdir($sModulePath . "/" . $sModuleLow);
        }
        if (!file_exists($sModulePath . "/" . $sModuleLow . "/entity")) {
            mkdir($sModulePath . "/" . $sModuleLow . "/entity");
        }
        if (!file_exists($sModulePath . "/" . $sModuleLow . "/mapper")) {
            mkdir($sModulePath . "/" . $sModuleLow . "/mapper");
        }
    }

    public function CheckSkinDirs($sSkinPath)
    {
        if (!file_exists($sSkinPath)) {
            mkdir($sSkinPath);
        }
        if (!file_exists($sSkinPath . "/admin-default")) {
            mkdir($sSkinPath . "/admin-default");
        }
        if (!file_exists($sSkinPath . "/admin-default/tpls")) {
            mkdir($sSkinPath . "/admin-default/tpls");
        }
        if (!file_exists($sSkinPath . "/admin-default/tpls/actions")) {
            mkdir($sSkinPath . "/admin-default/tpls/actions");
        }
        if (!file_exists($sSkinPath . "/admin-default/tpls/actions/admin")) {
            mkdir($sSkinPath . "/admin-default/tpls/actions/admin");
        }
        if (!file_exists($sSkinPath . "/admin-default/tpls/actions/admin/action.admin.content")) {
            mkdir($sSkinPath . "/admin-default/tpls/actions/admin/action.admin.content");
        }
    }

    public function EventAjaxCheckFile()
    {

        // * Устанавливаем формат ответа
        E::ModuleViewer()->SetResponseAjax('json');

        $sPluginLow = F::StrUnderscore($this->GetPost('plugin'));
        $sModuleLow = F::StrUnderscore($this->GetPost('module'));
        $sEntityLow = F::StrUnderscore($this->GetPost('entity'));
        $sEventLow = F::StrUnderscore($this->GetPost('event'));


        $sPlugin = F::StrCamelize($sPluginLow);
        $sModule = F::StrCamelize($sModuleLow);
        $sEntity = F::StrCamelize($sEntityLow);
        $sEvent = F::StrCamelize($sEventLow);

        $sModulePath = dirname(dirname(dirname(dirname(__FILE__)))) . "/" . $sPluginLow . "/classes/modules";
        $sSkinPath = dirname(dirname(dirname(dirname(__FILE__)))) . "/" . $sPluginLow . "/templates/skin";

        $sTableName = 'prefix_' . $sModuleLow;

        if ($sModuleLow != $sEntityLow && $sEntityLow != '') {
            $sTableName .= '_' . $sEntityLow;
        }


        E::ModuleViewer()->AssignAjax('sModulePath', $sModulePath . "/" . $sModuleLow . "/" . $sModule . ".class.php");
        E::ModuleViewer()->AssignAjax('sMapperPath', $sModulePath . "/" . $sModuleLow . "/mapper/" . $sModule . ".mapper.class.php");
        E::ModuleViewer()->AssignAjax('sEntityPath', $sModulePath . "/" . $sModuleLow . "/entity/" . $sEntity . ".entity.class.php");
        E::ModuleViewer()->AssignAjax('sEventEditPath', $sSkinPath . "/admin-default/tpls/actions/admin/action.admin.content/" . $sEventLow . "_edit.tpl");
        E::ModuleViewer()->AssignAjax('sEventListPath', $sSkinPath . "/admin-default/tpls/actions/admin/action.admin.content/" . $sEventLow . "_list.tpl");
        E::ModuleViewer()->AssignAjax('sEntityPath', $sModulePath . "/" . $sModuleLow . "/entity/" . $sEntity . ".entity.class.php");
        E::ModuleViewer()->AssignAjax('sModuleExist', file_exists($sModulePath . "/" . $sModuleLow . "/" . $sModule . ".class.php"));
        E::ModuleViewer()->AssignAjax('sMapperExist', file_exists($sModulePath . "/" . $sModuleLow . "/mapper/" . $sModule . ".mapper.class.php"));
        E::ModuleViewer()->AssignAjax('sEntityExist', file_exists($sModulePath . "/" . $sModuleLow . "/entity/" . $sEntity . ".entity.class.php"));
        E::ModuleViewer()->AssignAjax('sEventEditExist', file_exists($sSkinPath . "/admin-default/tpls/actions/admin/action.admin.content/" . $sEventLow . "_edit.tpl"));
        E::ModuleViewer()->AssignAjax('sEventListExist', file_exists($sSkinPath . "/admin-default/tpls/actions/admin/action.admin.content/" . $sEventLow . "_list.tpl"));

        E::ModuleViewer()->AssignAjax('sTableName', $sTableName);
        E::ModuleViewer()->AssignAjax('sTableExist', $this->Database_IsTableExists($sTableName));

        $aFields = array();

        if ($sEntityLow && $sModuleLow) {
            $aFields = E::Module('PluginGenerator\Generator')->ShowColumnsFromTable($sTableName);
        }

        E::ModuleViewer()->AssignAjax('aFields', $aFields);
    }

    protected function EventGenerator()
    {

        $this->sMainMenuItem = 'content';
        $aPlugins = F::GetPluginsList();
        $this->Viewer_Assign('aPlugins', $aPlugins);

        $this->SetTemplateAction('generator');
    }


}
