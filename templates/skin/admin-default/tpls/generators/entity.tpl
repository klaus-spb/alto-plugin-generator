<?php

class Plugin{$sPlugin}_Module{$sModule}_Entity{$sEntity} extends EntityORM
{	
	{if $aRelations}
	protected $aRelations=array(
		{foreach $aRelations as $aRelation}
		'{$aRelation.name}' => array({$aRelation.type}, '{$aRelation.entity}', '{$aRelation.field}'),
		{/foreach}
	);
	{/if}
}

?>
