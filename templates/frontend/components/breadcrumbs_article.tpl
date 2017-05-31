{**
 * templates/frontend/components/breadcrumbs_article.tpl
 *
 * Copyright (c) 2017 Vitaliy Bezsheiko, MD, Department of Psychosomatic Medicine and Psychotherapy, Bogomolets National Medical University, Kyiv, Ukraine
 * Distributed under the GNU GPL v3.
 *
 * for use in default Manuscript theme with jatsParser plugin
 *}

<nav class="cmp_breadcrumbs col-lg-12 col-md-12 col-sm-12 col-xs-12" role="navigation" aria-label="{translate key="navigation.breadcrumbLabel"}">
	<ol>
		<li>
            <span class="glyphicon glyphicon-folder-open" aria-hidden="true"></span>
			<a href="{url page="index" router=$smarty.const.ROUTE_PAGE}">
                
				{translate key="common.homepageNavigationLabel"}
			</a>
			<span class="separator">{translate key="navigation.breadcrumbSeparator"}</span>
		</li>
		<li>
			<a href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}">
				{translate key="navigation.archives"}
			</a>
			<span class="separator">{translate key="navigation.breadcrumbSeparator"}</span>
		</li>
		<li>
			<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
				{$issue->getIssueIdentification()}
			</a>
			<span class="separator">{translate key="navigation.breadcrumbSeparator"}</span>
		</li>
		<li class="current">
				{if $currentTitleKey}
					{translate key=$currentTitleKey}
				{else}
					{$currentTitle|escape}
				{/if}
		</li>
	</ol>
</nav>
