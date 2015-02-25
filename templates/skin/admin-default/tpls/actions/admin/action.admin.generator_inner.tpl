{if $sMenuText}
    <div class="b-wbox">
        <div class="b-wbox-header">
            <div class="b-wbox-header-title">
                Menu {if !$sMenuPath}скопируйте в файл admin_menu самостоятельно{/if}
            </div>
        </div>
        <div class="b-wbox-content">
            <div class="comment-content text">
                <pre class="prettyprint"><code><span class="pln">{$sMenuText|escape}</span></code></pre>
            </div>
        </div>
    </div>
{/if}

{if $sHookText}
    <div class="b-wbox">
        <div class="b-wbox-header">
            <div class="b-wbox-header-title">
                Hook скопируйте в файл самостоятельно
            </div>
        </div>
        <div class="b-wbox-content">
            <div class="comment-content text">
                <pre class="prettyprint"><code><span class="pln">{$sHookText|escape}</span></code></pre>
            </div>
        </div>
    </div>
{/if}

{if $sActionInit}
    <div class="b-wbox">
        <div class="b-wbox-header">
            <div class="b-wbox-header-title">
                Action Init скопируйте в файл самостоятельно
            </div>
        </div>
        <div class="b-wbox-content">
            <div class="comment-content text">
                <pre class="prettyprint"><code><span class="pln">{$sActionInit|escape}</span></code></pre>
            </div>
        </div>
    </div>
{/if}

{if $sActionText}
    <div class="b-wbox">
        <div class="b-wbox-header">
            <div class="b-wbox-header-title">
                Action Text скопируйте в файл самостоятельно
            </div>
        </div>
        <div class="b-wbox-content">
            <div class="comment-content text">
                <pre class="prettyprint"><code><span class="pln">{$sActionText}</span></code></pre>
            </div>
        </div>
    </div>
{/if}

{if $sTemplateListText}
    <div class="b-wbox">
        <div class="b-wbox-header">
            <div class="b-wbox-header-title">
                Template list.tpl
            </div>
        </div>
        <div class="b-wbox-content">
            <div class="comment-content text">
                <pre class="prettyprint"><code><span class="pln">{$sTemplateListText|escape}</span></code></pre>
            </div>
        </div>
    </div>
{/if}

{if $sTemplateEditText}
    <div class="b-wbox">
        <div class="b-wbox-header">
            <div class="b-wbox-header-title">
                Template edit.tpl
            </div>
        </div>
        <div class="b-wbox-content">
            <div class="comment-content text">
                <pre class="prettyprint"><code><span class="pln">{$sTemplateEditText|escape}</span></code></pre>
            </div>
        </div>
    </div>
{/if}