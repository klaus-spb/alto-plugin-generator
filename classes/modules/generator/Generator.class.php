<?php

class PluginGenerator_ModuleGenerator extends ModuleORM {
	
	protected $oMapper;

    public function Init() {
        $this->oMapper = Engine::GetMapper(__CLASS__);
    }
	
	public function ShowColumnsFromTable($sTableName) {
		
        $data = $this->oMapper->ShowColumnsFromTable($sTableName);

        return $data;
    }
	
	public function GenerateModule( $sTargetPath, $sPlugin, $sModule) {
		$oViewer = E::ModuleViewer()->GetLocalViewer();
        $oViewer->Assign('sPlugin', $sPlugin);
        $oViewer->Assign('sModule', $sModule);
		$sCodeResult = $oViewer->Fetch('generators/model.tpl');
		
		file_put_contents($sTargetPath, $sCodeResult);
	}
	public function GenerateMapper($sTargetPath, $sPlugin, $sModule) {
		$oViewer = E::ModuleViewer()->GetLocalViewer();
        $oViewer->Assign('sPlugin', $sPlugin);
        $oViewer->Assign('sModule', $sModule);
		$sCodeResult = $oViewer->Fetch('generators/mapper.tpl');
		
		file_put_contents($sTargetPath, $sCodeResult);
	}
	
	public function GenerateEntity($sTargetPath, $sPlugin, $sModule, $sEntity, $aRelations) {
		$oViewer = E::ModuleViewer()->GetLocalViewer();
        $oViewer->Assign('sPlugin', $sPlugin);
        $oViewer->Assign('sModule', $sModule);
        $oViewer->Assign('sEntity', $sEntity);
        $oViewer->Assign('aRelations', $aRelations);
		
		$sCodeResult = $oViewer->Fetch('generators/entity.tpl');
		
		file_put_contents($sTargetPath, $sCodeResult);
	}
	
	public function GenerateTemplateList($sTargetPath, $sEventLow, $sEntity, $aColumns, $sPrimary) {
		$oViewer = E::ModuleViewer()->GetLocalViewer();
        $oViewer->Assign('aColumns', $aColumns);
        $oViewer->Assign('sEventLow', $sEventLow);
        $oViewer->Assign('sEntity', $sEntity);
        $oViewer->Assign('sPrimary', $sPrimary);
		
		$sCodeResult = $oViewer->Fetch('generators/list.tpl');
		file_put_contents($sTargetPath, $sCodeResult);
		return $sCodeResult;
	}
	
	public function GenerateTemplateEdit($sTargetPath, $sEventLow, $sEntity, $aColumns, $sPrimary) {
		$oViewer = E::ModuleViewer()->GetLocalViewer();
        $oViewer->Assign('aColumns', $aColumns);
        $oViewer->Assign('sEventLow', $sEventLow);
        $oViewer->Assign('sEntity', $sEntity);
        $oViewer->Assign('sPrimary', $sPrimary);
		
		$sCodeResult = $oViewer->Fetch('generators/edit.tpl');
		file_put_contents($sTargetPath, $sCodeResult);
		return $sCodeResult;
	}
	
	public function GenerateTemplateMenu($sTargetPath, $sEventLow, $sEntity) {
		$oViewer = E::ModuleViewer()->GetLocalViewer();
        $oViewer->Assign('sEventLow', $sEventLow);
        $oViewer->Assign('sEntity', $sEntity);
		
		$sCodeResult = $oViewer->Fetch('generators/menu.tpl');
		if($sTargetPath){
			file_put_contents($sTargetPath, $sCodeResult);
		}
		return $sCodeResult;
	}
	
	public function GenerateHook() {
		$oViewer = E::ModuleViewer()->GetLocalViewer();		
		$sCodeResult = $oViewer->Fetch('generators/hook.tpl');

		return $sCodeResult;
	}
	
	public function GenerateAction($sEventLow, $sEvent, $sPlugin, $sModule, $sEntity, $aColumns, $sPrimary) {
		$oViewer = E::ModuleViewer()->GetLocalViewer();
		
        $oViewer->Assign('aColumns', $aColumns);
        $oViewer->Assign('sPrimary', $sPrimary);
		
        $oViewer->Assign('sEventLow', $sEventLow);
        $oViewer->Assign('sEvent', $sEvent);
		
        $oViewer->Assign('sPlugin', $sPlugin);
        $oViewer->Assign('sModule', $sModule);
        $oViewer->Assign('sEntity', $sEntity);
		
		
		$sCodeResult = $oViewer->Fetch('generators/action.tpl');
		
		return $sCodeResult;
	}
}
?>
