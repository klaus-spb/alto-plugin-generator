{literal}
{extends file='_index.tpl'}

{block name="content-bar"}
    <div class="btn-group">
        <a href="{router page='admin'}{/literal}{$sEventLow}{literal}/add/" class="btn btn-primary"><i class="icon icon-plus"></i></a>
    </div>
{/block}

{block name="content-body"}

<div class="span12">

    <div class="b-wbox">
        <div class="b-wbox-content nopadding">

            <table class="table table-striped table-condensed pages-list">
                <thead>
                <tr>
				{/literal}
				{foreach $aColumns as $aColumn}
                    <th>{$aColumn.title}</th>
				{/foreach}
				{literal}
                </tr>
                </thead>

                <tbody>
					{foreach {/literal}$a{$sEntity} as $o{$sEntity}{literal}}
                    <tr>
						{/literal}
						{foreach $aColumns as $aColumn}
                        <td>{*check for relation*}{if $aColumn.relation}{literal}{if {/literal}$o{$sEntity}->{$aColumn.relation}{literal}}{/literal}{/if}{*end check*}
                        {literal}{{/literal}$o{$sEntity}->{$aColumn.getvalue}{literal}}{/literal}
                        {*check for relation*}{if $aColumn.relation}{literal}{/if}{/literal}{/if}{*end check*}
                        </td>
                        {/foreach}
						{literal}
						<td class="center">
                            <a href="{router page='admin'}{/literal}{$sEventLow}{literal}/edit/{{/literal}$o{$sEntity}->get{$sPrimary}{literal}()}/"
                               title="Edit" class="tip-top i-block">
                                <i class="icon icon-note"></i>
                            </a>
                            <a href="#" title="Delete" class="tip-top i-block"
                                  onclick="return admin.confirmDelete('{{/literal}$o{$sEntity}->get{$sPrimary}{literal}()}'); return false;">
                                <i class="icon icon-trash"></i>
                            </a>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>

    {include file="inc.paging.tpl"}

</div>

<script>
    var admin = admin || { };

    admin.confirmDelete = function(id) {
		ls.modal.confirm({
			title: 'Delete',
			message: 'Are you realy wonna delete {/literal}{$sEntity}{literal} "' + id + '"<br/>Please confirm',
			onConfirm: function () {
				document.location = "{router page='admin'}{/literal}{$sEventLow}{literal}/delete/" + id + "/?security_ls_key={$ALTO_SECURITY_KEY}";
			}
		});				
    }
</script>

{/block}
{/literal}