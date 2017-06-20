{**
 * lib/pkp/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2017 Vitaliy Bezsheiko, MD, Department of Psychosomatic Medicine and Psychotherapy, Bogomolets National Medical University, Kyiv, Ukraine
 * Distributed under the GNU GPL v3.
 *
 * for use in default Manuscript theme with jatsParser plugin
 *}
{strip}
	{* Determine whether a logo or title string is being displayed *}
	{assign var="showingLogo" value=true}
	{if $displayPageHeaderTitle && !$displayPageHeaderLogo && is_string($displayPageHeaderTitle)}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{translate|assign:"pageTitleTranslated" key=$pageTitle}{/if}
{include file="frontend/components/headerHead.tpl"}
{if $requestedPage|escape == "article"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}" data-spy="scroll" data-target="#myAffix">
{else}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}">
{/if}
	<div class="cmp_skip_to_content">
		<a href="#pkp_content_main">{translate key="navigation.skip.main"}</a>
		<a href="#pkp_content_nav">{translate key="navigation.skip.nav"}</a>
		<a href="#pkp_content_footer">{translate key="navigation.skip.footer"}</a>
	</div>
	<div class="pkp_structure_page">

		{* Header *}
		<header class="pkp_structure_head" id="headerNavigationContainer" role="banner">
			<div class="pkp_head_wrapper">

				<div class="pkp_site_name_wrapper">
					{* Logo or site title. Only use <h1> heading on the homepage.
					   Otherwise that should go to the page title. *}
					{if $requestedOp == 'index'}
						<h1 class="pkp_site_name">
					{else}
						<div class="pkp_site_name">
					{/if}
						{if $currentContext && $multipleContexts}
							{url|assign:"homeUrl" journal="index" router=$smarty.const.ROUTE_PAGE}
						{else}
							{url|assign:"homeUrl" page="index" router=$smarty.const.ROUTE_PAGE}
						{/if}
						{if $displayPageHeaderLogo && is_array($displayPageHeaderLogo)}
							<a href="{$homeUrl}" class="is_img">
								<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{else}alt="{translate key="common.pageHeaderLogo.altText"}"{/if} />
							</a>
						{elseif $displayPageHeaderTitle && !$displayPageHeaderLogo && is_string($displayPageHeaderTitle)}
							<a href="{$homeUrl}" class="is_text">{$displayPageHeaderTitle}</a>
						{elseif $displayPageHeaderTitle && !$displayPageHeaderLogo && is_array($displayPageHeaderTitle)}
							<a href="{$homeUrl}" class="is_img">
								<img src="{$publicFilesDir}/{$displayPageHeaderTitle.uploadName|escape:"url"}" alt="{$displayPageHeaderTitle.altText|escape}" width="{$displayPageHeaderTitle.width|escape}" height="{$displayPageHeaderTitle.height|escape}" />
							</a>
						{else}
							<a href="{$homeUrl}" class="is_img">
								<img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" width="180" height="90" />
							</a>
						{/if}
					{if $requestedOp == 'index'}
						</h1>
					{else}
						</div>
					{/if}
				</div>

				{* Primary site navigation *}
				{if $currentContext}
					<nav id="pkp_content_nav" class="pkp_navigation_primary_row navDropdownMenu" aria-label="{translate|escape key="common.navigation.site"}">
						<div class="pkp_navigation_primary_wrapper">

							{* Primary navigation menu for current application *}
							{include file="frontend/components/primaryNavMenu.tpl"}

							{* Search form *}
							{include file="frontend/components/searchForm_simple.tpl"}
						</div>
					</nav>
				{/if}

				<nav class="pkp_navigation_user_wrapper navDropdownMenu" id="navigationUserWrapper" aria-label="{translate|escape key="common.navigation.user"}">
					<ul id="navigationUser" class="pkp_navigation_user pkp_nav_list">
						{if $isUserLoggedIn}
							<li class="profile {if $unreadNotificationCount} has_tasks{/if}" aria-haspopup="true" aria-expanded="false">
								<a href="{url router=$smarty.const.ROUTE_PAGE page="submissions"}">
									{$loggedInUsername|escape}
									<span class="task_count">
										{$unreadNotificationCount}
									</span>
								</a>
								<ul>
									{if array_intersect(array(ROLE_ID_MANAGER, ROLE_ID_ASSISTANT, ROLE_ID_REVIEWER, ROLE_ID_AUTHOR), (array)$userRoles)}
										<li>
											<a href="{url router=$smarty.const.ROUTE_PAGE page="submissions"}">
												{translate key="navigation.dashboard"}
												<span class="task_count">
													{$unreadNotificationCount}
												</span>
											</a>
										</li>
									{/if}
									<li>
										<a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="profile"}">
											{translate key="common.viewProfile"}
										</a>
									</li>
									{if array_intersect(array(ROLE_ID_SITE_ADMIN), (array)$userRoles)}
									<li>
										<a href="{if $multipleContexts}{url router=$smarty.const.ROUTE_PAGE context="index" page="admin" op="index"}{else}{url router=$smarty.const.ROUTE_PAGE page="admin" op="index"}{/if}">
											{translate key="navigation.admin"}
										</a>
									</li>
									{/if}
									<li>
										<a href="{url router=$smarty.const.ROUTE_PAGE page="login" op="signOut"}">
											{translate key="user.logOut"}
										</a>
									</li>
									{if $isUserLoggedInAs}
										<li>
											<a href="{url router=$smarty.const.ROUTE_PAGE page="login" op="signOutAsUser"}">
												{translate key="user.logOutAs"} {$loggedInUsername|escape}
											</a>
										</li>
									{/if}
								</ul>
							</li>
						{else}
							{if !$disableUserReg}
								<li><a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="register"}">{translate key="navigation.register"}</a></li>
							{/if}
							<li><a href="{url router=$smarty.const.ROUTE_PAGE page="login"}">{translate key="navigation.login"}</a></li>
						{/if}
					</ul>
				</nav><!-- .pkp_navigation_user_wrapper -->

			</div><!-- .pkp_head_wrapper -->
		</header><!-- .pkp_structure_head -->

		{* Wrapper for page content and sidebars *}
		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			{if $requestedPage|escape == "article"}
				{if $section}
					{include file="frontend/components/breadcrumbs_article.tpl" currentTitle=$section->getLocalizedTitle()}
				{else}
					{include file="frontend/components/breadcrumbs_article.tpl" currentTitleKey="article.article"}
				{/if}
				<div class="fornav col-lg-4 col-md-4" role="complementary" id="navwrap">


					{* Article Galleys *}
					{assign var=galleys value=$article->getGalleys()}
					{if $galleys}
						<div class="item galleys">
							<div class="panel panel-default">
								<div class="panel-heading">
									{translate key="jatsParser.galleys.info"}
								</div>
								<ul class="list-group">
									{foreach from=$galleys item=galley}
										{if $galley->getFileType() != "text/html"}
											<li class="list-group-item">
												{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley}
											</li>
										{/if}
									{/foreach}
								</ul>
							</div>
						</div>
					{/if}

					{if $article->getDatePublished()}
						<div class="item published">
							<div class="panel panel-default">
								<div class="panel-heading">
									{translate key="submissions.published"}
								</div>
								<div class="panel-body">
									{$article->getDatePublished()|date_format}
								</div>
							</div>
						</div>
					{/if}

					{* Issue article appears in *}
					<div class="item issue">
						<div class="panel panel-default">
							<div class="panel-heading">
								{translate key="issue.issue"}
							</div>
							<div class="panel-body">
								<a class="title" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
									{$issue->getIssueIdentification()}
								</a>
							</div>
						</div>

						{if $section}
							<div class="panel panel-default">
								<div class="panel-heading">
									{translate key="section.section"}
								</div>
								<div class="panel-body">
									{$section->getLocalizedTitle()|escape}
								</div>
							</div>
						{/if}
					</div>

					{** navigation *}
					<nav class="bs-docs-sidebar" id="myAffix">
						<ul class="nav nav-tabs bs-docs-sidenav" id="navblock" role="tablist">
							{**autogenerated navigational menu on article detail page*}
						</ul>
					</nav>
				</div>
			{/if}
			<div id="pkp_content_main" class="pkp_structure_main{if $requestedPage|escape == "article"} col-lg-8 col-md-8 col-sm-12 col-xs-12{/if}" role="main">
