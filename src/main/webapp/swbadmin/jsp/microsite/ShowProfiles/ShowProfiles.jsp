<%@page import="org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.User,org.semanticwb.model.WebPage,java.util.*"%>
<h2 class="titulo1">Perfiles</h2>
<div id="Accordion1" class="Accordion">
    <div class="AccordionPanel">
        <div class="AccordionPanelTab"></div>
        <div class="AccordionPanelContent">
            <ul>
                <%
            User user = (User) request.getAttribute("user");
            String lang = "es";
            if (user.getLanguage() != null)
            {
                lang = user.getLanguage();
            }
            WebPage webpage = (WebPage) request.getAttribute("webpage");
            WebPage topics = webpage.getWebSite().getWebPage("Perfiles");
            Iterator<WebPage> pages = topics.listVisibleChilds(lang);
            while (pages.hasNext())
            {
                WebPage profile = pages.next();
                %>
                <li><a href="<%=profile.getUrl()%>"><%=profile.getTitle()%></a></li>
                <%
            }

                %>
            </ul>
        </div>
    </div>
</div>