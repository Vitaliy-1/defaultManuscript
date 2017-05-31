{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2016 Simon Fraser University Library
 * Copyright (c) 2003-2016 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 * Modified by Vitaliy Bezsheiko, MD, 2017 for use with jatsParser plugin
 * @brief View of an Article which displays all details about the article.
 *  Expected to be primary object on the page.
 *
 * Many journals will want to add custom data to this object, either through
 * plugins which attach to hooks on the page or by editing the template
 * themselves. In order to facilitate this, a flexible layout markup pattern has
 * been implemented. If followed, plugins and other content can provide markup
 * in a way that will render consistently with other items on the page. This
 * pattern is used in the .main_entry column and the .entry_details column. It
 * consists of the following:
 *
 * <!-- Wrapper class which provides proper spacing between components -->
 * <div class="item">
 *     <!-- Title/value combination -->
 *     <div class="label">Abstract</div>
 *     <div class="value">Value</div>
 * </div>
 *
 * All styling should be applied by class name, so that titles may use heading
 * elements (eg, <h3>) or any element required.
 *
 * <!-- Example: component with multiple title/value combinations -->
 * <div class="item">
 *     <div class="sub_item">
 *         <div class="label">DOI</div>
 *         <div class="value">12345678</div>
 *     </div>
 *     <div class="sub_item">
 *         <div class="label">Published Date</div>
 *         <div class="value">2015-01-01</div>
 *     </div>
 * </div>
 *
 * <!-- Example: component with no title -->
 * <div class="item">
 *     <div class="value">Whatever you'd like</div>
 * </div>
 *
 * Core components are produced manually below, but can also be added via
 * plugins using the hooks provided:
 *
 * Templates::Article::Main
 * Templates::Article::Details
 *
 * @uses $article Article This article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $citationPlugins Array of citation format plugins
 * @uses $copyright string Copyright notice. Only assigned if statement should
 *   be included with published articles.
 * @uses $copyrightHolder string Name of copyright holder
 * @uses $copyrightYear string Year of copyright
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published articles.
 * @uses $ccLicenseBadge string An image and text with details about the license
 *}
{**
{foreach from=$article->getAuthors() key=k item=author}
    {if $k +1 < $article->getAuthors()|@count }
		<span>
			{$author->getLastName()|strip_unsafe_html} {$author->getFirstName()|strip_unsafe_html|regex_replace:"/(?<=^\w).*/":""}.,
		</span>
    {else}
		<span>
			{$author->getLastName()|strip_unsafe_html} {$author->getFirstName()|strip_unsafe_html|regex_replace:"/(?<=^\w).*/":""}.
		</span>
    {/if}
{/foreach}
*}
<article class="obj_article_details">


	<div class="row" id="article_page_tabs">
        <ul>
            <li><a href="#article_tab">{translate key="jatsParser.navigation.article"}</a></li>
            <li><a href="#details_tab">{translate key="jatsParser.navigation.details"}</a></li>
            <li id="for_floating_right"><a href="#article_metrics">{translate key="jatsParser.navigation.metrics"}</a></li>
        </ul>
        <div class="before_title"><p>{translate key="jatsParser.openAccess.label"}</p></div>
        <h1 class="page_title">
            {$article->getLocalizedTitle()|escape}
        </h1>

        {if $article->getLocalizedSubtitle()}
            <h2 class="subtitle">
                {$article->getLocalizedSubtitle()|escape}
            </h2>
        {/if}
        {if $article->getAuthors()}
            <ul class="item authors">
                {foreach from=$article->getAuthors() item=author}
                    <li>
							<span class="name">
								{$author->getFullName()|escape}
							</span>
                        {if $author->getLocalizedAffiliation()}
                            <span class="affiliation">
									{$author->getLocalizedAffiliation()|escape}
								</span>
                        {/if}
                        {if $author->getOrcid()}
                            <span class="orcid">
									<a href="{$author->getOrcid()|escape}" target="_blank">
										{$author->getOrcid()|escape}
									</a>
								</span>
                        {/if}
                    </li>
                {/foreach}
            </ul>
        {/if}
		<div class="main_entry" id="article_tab">
			{* DOI (requires plugin) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{php}continue;{/php}
				{/if}
				{if $issue->getPublished()}
					{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{else}
					{assign var=pubId value=$pubIdPlugin->getPubId($article)}{* Preview pubId *}
				{/if}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<div class="item doi">
						<span class="label">
							{translate key="plugins.pubIds.doi.readerDisplayName"}
						</span>
						<span class="value">
							<a href="{$doiUrl}">
								{$doiUrl}
							</a>
						</span>
					</div>
				{/if}
			{/foreach}

			{* Abstract *}
			{**
			{if $article->getLocalizedAbstract()}
				<div class="item abstract">
					<h3 class="abstract-title">{translate key="article.abstract"}</h3>
					{$article->getLocalizedAbstract()|strip_unsafe_html|nl2br}
				</div>
			{/if}
			*}
			{call_hook name="Templates::Article::Main"}

		</div><!-- .main_entry -->

		<div class="entry_details" id="details_tab">

			{* Article/Issue cover image *}
			{if $article->getLocalizedCoverImage() || $issue->getLocalizedCoverImage()}
				<div class="item cover_image">
					<div class="sub_item">
						{if $article->getLocalizedCoverImage()}
							<img src="{$publicFilesDir}/{$article->getLocalizedCoverImage()|escape}"{if $article->getLocalizedCoverImageAltText()} alt="{$article->getLocalizedCoverImageAltText()|escape}"{/if}>
						{else}
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img src="{$publicFilesDir}/{$issue->getLocalizedCoverImage()|escape}"{if $issue->getLocalizedCoverImageAltText()} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
							</a>
						{/if}
					</div>
				</div>
			{/if}



			{* Citation formats *}
			{if $citationPlugins|@count}
				<div class="item citation_formats">
					{* Output the first citation format *}
					{foreach from=$citationPlugins name="citationPlugins" item="citationPlugin"}
						<div class="panel panel-default">
							<div class="panel-heading">
								{translate key="submission.howToCite"}
							</div>
							<div id="citationOutput" class="panel-body">
								{$citationPlugin->fetchCitation($article, $issue, $currentContext)}
							</div>
						</div>
						{php}break;{/php}
					{/foreach}

					{* Output list of all citation formats *}
					<div class="panel panel-default output">
						<div class="panel-heading">
							{translate key="submission.howToCite.citationFormats"}
						</div>
						<div class="panel-body">

								{foreach from=$citationPlugins name="citationPlugins" item="citationPlugin"}

										{capture assign="citationUrl"}{url page="article" op="cite" path=$article->getBestArticleId()}/{$citationPlugin->getName()|escape}{/capture}
										<a class="list-group-item" href="{$citationUrl}"{if !$citationPlugin->isDownloadable()} data-load-citation="true"{/if} target="_blank">{$citationPlugin->getCitationFormatName()|escape}</a>

								{/foreach}

						</div>
					</div>
				</div>
			{/if}



			{* Keywords *}
			{* @todo keywords not yet implemented *}

			{* Article Subject *}
			{if $article->getLocalizedSubject()}
				<div class="panel panel-default">
					<h3 class="panel-heading">
						{translate key="article.subject"}
					</h3>
					<div class="panel-body">
						{$article->getLocalizedSubject()|escape}
					</div>
				</div>
			{/if}

			{* PubIds (requires plugins) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() == 'doi'}
					{php}continue;{/php}
				{/if}
				{if $issue->getPublished()}
					{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{else}
					{assign var=pubId value=$pubIdPlugin->getPubId($article)}{* Preview pubId *}
				{/if}
				{if $pubId}
					<div class="item pubid">
						<div class="label">
							{$pubIdPlugin->getPubIdDisplayType()|escape}
						</div>
						<div class="value">
							{if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								<a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}" href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">
									{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								</a>
							{else}
								{$pubId|escape}
							{/if}
						</div>
					</div>
				{/if}
			{/foreach}

			{* Licensing info *}
			{if $copyright || $licenseUrl}
				<div class="item copyright">
					{if $licenseUrl}
						{if $ccLicenseBadge}
							{$ccLicenseBadge}
						{else}
							<a href="{$licenseUrl|escape}" class="copyright">
								{if $copyrightHolder}
									{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder copyrightYear=$copyrightYear}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					{$copyright}
				</div>
			{/if}

			{call_hook name="Templates::Article::Details"}

		</div><!-- .entry_details -->
        <div class="article_metrics" id="article_metrics">

        </div>
	</div><!-- .row -->

</article>
