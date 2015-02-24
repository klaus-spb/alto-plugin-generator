{literal}
{extends file='_index.tpl'}

{block name="content-bar"}
    <div class="btn-group">
        <a href="{router page='admin'}{/literal}{$sEventLow}{literal}/" class="btn btn-primary"><i class="icon icon-chevron-left"></i></a>
    </div>
{/block}

{block name="content-body"}

<div class="span12">

    <div class="b-wbox">
        <div class="b-wbox-header">
            <div class="b-wbox-header-title"> 
                {if $sMode=='edit'}
                    Edit
                {else}
					Add                 
                {/if}
            </div>
        </div>
        <div class="b-wbox-content nopadding">
            <form action="" method="POST" class="form-horizontal uniform" enctype="multipart/form-data">
                {hook run='plugin_{/literal}{$sEventLow}{literal}_form_add_begin'}
                <input type="hidden" name="security_ls_key" value="{$ALTO_SECURITY_KEY}"/>
				{/literal}
				{foreach $aColumns as $aColumn}
				{if !$aColumn.relation}
				
				<div class="control-group">
					<label for="{$aColumn.title}" class="control-label">{$aColumn.title}</label>
					{literal}
					<div class="controls">
						<input type="text" id="{/literal}{$aColumn.title}{literal}" class="input-text" name="{/literal}{$aColumn.title}{literal}"
                               value="{if $_aRequest.{/literal}{$aColumn.title}{literal}}{$_aRequest.{/literal}{$aColumn.title}{literal}|strip_tags|escape:'html'}{/if}" />
					{/literal} 
					</div>
				</div>
				{/if}
				{/foreach}
				{literal}
                {hook run='plugin_{/literal}{$sEventLow}{literal}_form_add_end'}
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary"
                            name="submit_{/literal}{$sEventLow}{literal}_save">Save</button>
                </div>

            </form>
        </div>
    </div>

</div>

{/block}
{/literal}