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

        return true;
    }

    // Деактивация плагина
    public function Deactivate(){

        return true;
    }


    // Инициализация плагина
    public function Init() {

    }
}
?>
