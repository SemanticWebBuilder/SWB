<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.resources.sem.newslite.*,org.w3c.dom.*,org.semanticwb.portal.community.*,java.util.*,org.semanticwb.model.WebPage,org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.model.*,org.semanticwb.SWBUtils,org.semanticwb.SWBPortal,org.semanticwb.SWBPlatform,org.semanticwb.platform.*,org.semanticwb.portal.api.SWBResourceURL"%>
<div id="mainMenu">
    <ul id="MenuBar1" class="MenuBarHorizontal">
<%
    WebSite site = ((WebPage) request.getAttribute("webpage")).getWebSite();
    User user = (User) request.getAttribute("user");
    Iterator<WebPage> childs=site.getHomePage().listVisibleChilds("es");
    while(childs.hasNext())
    {
        WebPage chanel=childs.next();
        if(user.haveAccess(chanel))
        {
            String title=chanel.getTitle();
            String url=chanel.getUrl();
            Iterator<WebPage> pages=chanel.listVisibleChilds("es");
            if(pages.hasNext())
            {
                %>
                    <li><a class="MenuBarItemSubmenu" href="<%=url%>"><%=title%></a>
                    <ul>
                <%
                while(pages.hasNext())
                {
                    WebPage child=pages.next();
                    if(user.haveAccess(child))
                    {
                        %>
                        <li><a href="<%=child.getUrl()%>"><%=child.getTitle()%></a></li>
                        <%
                    }
                }
                %>
                </ul></li>
                <%
            }
            else
            {
            %>
                <li><a href="<%=url%>"><%=title%></a></li>
            <%
            }
        }
    }
%>      
    </ul>
  </div>
