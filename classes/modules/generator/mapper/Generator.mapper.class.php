<?php

class PluginGenerator_ModuleGenerator_MapperGenerator extends MapperORM
{
	public function ShowColumnsFromTable($sTableName) {
		
		$sql_check = "SHOW TABLES LIKE '".$sTableName."'";
		
		if ($aRows = $this->oDb->select($sql_check)) {
		
			$sql = "SHOW COLUMNS FROM " . $sTableName;
			$aItems = array();
			if ($aRows = $this->oDb->select($sql)) {
				foreach ($aRows as $aRow) {
					$aItems[] = $aRow['Field'];
					if ($aRow['Key'] == 'PRI') {
						$aItems['#primary_key'] = $aRow['Field'];
					}
				}
			}
				
			return $aItems;
		}else{
			return array();
		}
    }

}

?>
