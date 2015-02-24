	/***********************************{$sEvent}************************************/

    protected function Event{$sEvent}() {

        $this->sMainMenuItem = 'content';
		
        if ($this->GetParam(0) == 'add') {
            $this->_event{$sEvent}Edit('add');
        } elseif ($this->GetParam(0) == 'edit') {
            $this->_event{$sEvent}Edit('edit');
        }elseif ($this->GetParam(0) == 'delete') {
            $this->_event{$sEvent}Delete();
        } else {
            $this->_event{$sEvent}List();
        }
    }

    protected function _event{$sEvent}List() {
		
		$this->_setTitle('{$sEvent}');
		
        $nPage = $this->_getPageNum();
        $a{$sEntity} = E::Module('Plugin{$sPlugin}\{$sModule}')->Get{$sEntity}ItemsByFilter(
            array(
                '#page' => 1,
                '#limit' => array(($nPage - 1) * Config::Get('admin.items_per_page'),
                                  Config::Get('admin.items_per_page'))
            )
        );
        $aPaging = $this->Viewer_MakePaging(
            $a{$sEntity}['count'], $nPage, Config::Get('admin.items_per_page'), 4,
            Router::GetPath('admin') . '{$sEventLow}/'
        );
		
        E::ModuleViewer()->Assign('a{$sEntity}', $a{$sEntity}['collection']);
        E::ModuleViewer()->Assign('aPaging', $aPaging);
		
        
        $this->SetTemplateAction('content/{$sEventLow}_list');
    }

    protected function _event{$sEvent}Delete() {
	
        if ($o{$sEntity} = E::Module('Plugin{$sPlugin}\{$sModule}')->Get{$sEntity}By{$sPrimary}($this->GetParam(1))) {
            $o{$sEntity}->Delete();
            $this->Message_AddNotice('Deleted', true);
            R::Location('admin/{$sEventLow}/');
        } else {
            $this->Message_AddError(
                'Something wrong', $this->Lang_Get('error')
            );
        }
		
    }

    protected function _event{$sEvent}Edit($sMode) {

        $this->_setTitle('{$sEvent} '.$this->GetParam(1));
        $this->SetTemplateAction('content/{$sEventLow}_edit');
        E::ModuleViewer()->Assign('sMode', $sMode);

        if ($this->GetParam(0) == 'add' && F::isPost('submit_{$sEventLow}_save')) {
            $this->SubmitAdd{$sEvent}();
        }

        if ($this->GetParam(0) == 'edit') {
            if ($o{$sEntity}Edit = E::Module('Plugin{$sPlugin}\{$sModule}')->Get{$sEntity}By{$sPrimary}($this->GetParam(1))) {
                if (!F::isPost('submit_{$sEventLow}_save')) {
                    {foreach $aColumns as $aColumn}
                    {if !$aColumn.relation}
					
					$_REQUEST['{$aColumn.title}'] = $o{$sEntity}Edit->{$aColumn.getvalue};
					{/if}
                    {/foreach}
					
                } else {
                    $this->SubmitEdit{$sEvent}($o{$sEntity}Edit);
                }
                E::ModuleViewer()->Assign('o{$sEntity}Edit', $o{$sEntity}Edit);
            } else {
                E::ModuleMessage()->AddError('No such {$sEntity}', E::ModuleLang()->Get('error'));
                $this->SetParam(0, null);
            }
        }
    }


    protected function SubmitEdit{$sEvent}($o{$sEntity}Edit) {

        // * Проверяем корректность полей
        if (!$this->Check{$sEvent}Fields()) {
            return;
        }
		{foreach $aColumns as $aColumn}
        {if !$aColumn.relation}
		$o{$sEntity}Edit->{$aColumn.setvalue}(F::GetRequest('{$aColumn.title}'));
		{/if}
		{/foreach}

        // * Обновляем страницу
        if ($o{$sEntity}Edit->Save()) {
            R::Location('admin/{$sEventLow}/');
        } else {
            E::ModuleMessage()->AddError(E::ModuleLang()->Get('system_error'));
        }
    }


    protected function SubmitAdd{$sEvent}() {

        // * Проверяем корректность полей
        if (!$this->Check{$sEvent}Fields()) {
            return;
        }
        // * Заполняем свойства
        $o{$sEntity} = E::GetEntity('Plugin{$sPlugin}_Module{$sModule}_Entity{$sEntity}');
		{foreach $aColumns as $aColumn}
        {if !$aColumn.relation}
		$o{$sEntity}->{$aColumn.setvalue}(F::GetRequest('{$aColumn.title}'));
		{/if}
		{/foreach}
		
        /**
         * Добавляем страницу
         */
        if ($o{$sEntity}->Add()) {
            E::ModuleMessage()->AddNotice('Ok');
            $this->SetParam(0, null);
            R::Location('admin/{$sEventLow}/');
        } else {
            E::ModuleMessage()->AddError(E::ModuleLang()->Get('system_error'));
        }
    }

    /**
     * Проверка полей на корректность
     *
     * @return bool
     */
    protected function Check{$sEvent}Fields() {

        E::ModuleSecurity()->ValidateSendForm();

        $bOk = true;
		/*
		{foreach $aColumns as $aColumn}
        {if !$aColumn.relation}

		if (!F::CheckVal(F::GetRequest('{$aColumn.title}', null, 'post'), 'text', 1, 50000)) {
            E::ModuleMessage()->AddError('Panic', E::ModuleLang()->Get('error'));
            $bOk = false;
        }
		{/if}
		{/foreach}
		*/
        
        E::ModuleHook()->Run('check_{$sEventLow}_fields', array('bOk' => &$bOk));

        return $bOk;
    }


    /***********************************{$sEvent}************************************/
