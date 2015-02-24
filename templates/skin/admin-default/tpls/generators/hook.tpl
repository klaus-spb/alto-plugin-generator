$this->AddHook('template_admin_menu_content', 'hook_admin_menu'); //строка в RegisterHook()


public function hook_admin_menu() {
	return $this->Viewer_Fetch(Plugin::GetTemplateDir(__CLASS__) . 'tpls/admin_menu.tpl');
}