<?php

/**
 * Запрещаем напрямую через браузер обращение к этому файлу.
 */
if (!class_exists('Plugin')) {
    die('Hacking attemp!');
}

class PluginGenerator extends Plugin {

    // Объявление делегирований (нужны для того, чтобы назначить свои экшны и шаблоны)
    public $aDelegates = array(
            /**
             * 'action' => array('ActionIndex'=>'_ActionSomepage'),
             * Замена экшна ActionIndex на ActionSomepage из папки плагина
             *
             * 'template' => array('index.tpl'=>'_my_plugin_index.tpl'),
             * Замена index.tpl из корня скина файлом /common/plugins/abcplugin/templates/skin/default/my_plugin_index.tpl
             *
             * 'template'=>array('actions/ActionIndex/index.tpl'=>'_actions/ActionTest/index.tpl'),
             * Замена index.tpl из скина из папки actions/ActionIndex/ файлом /common/plugins/abcplugin/templates/skin/default/actions/ActionTest/index.tpl
             */


    );

    // Объявление переопределений (модули, мапперы и сущности)
    protected $aInherits
        = array(
            'action' => array(			  
                  'ActionAdmin'=>'PluginGenerator_ActionAdmin',
            ),
        );

    // Активация плагина
    public function Activate() {
        /*
        if (!$this->isTableExists('prefix_tablename')) {
            $this->ExportSQL(dirname(__FILE__).'/install.sql'); // Если нам надо изменить БД, делаем это здесь.
        }
        */
        return true;
    }

    // Деактивация плагина
    public function Deactivate(){
        /*
        $this->ExportSQL(dirname(__FILE__).'/deinstall.sql'); // Выполнить деактивационный sql, если надо.
        */
        return true;
    }


    // Инициализация плагина
    public function Init() {
        // $this->Viewer_AppendStyle(Plugin::GetTemplateDir(__CLASS__)."assets/css/style.css"); // Добавление своего CSS
        // $this->Viewer_AppendScript(Plugin::GetTemplateDir(__CLASS__)."assets/js/script.js"); // Добавление своего JS

        //$this->Viewer_AddMenu('blog',Plugin::GetTemplateDir(__CLASS__).'menu.blog.tpl'); // например, задаем свой вид меню
    }
}
?>
