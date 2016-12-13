<%@page import="org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<%!
    private Member getMember(User user, MicroSite site)
    {
        if (site != null)
        {
            Iterator<Member> it = Member.ClassMgr.listMemberByUser(user, site.getWebSite());
            while (it.hasNext())
            {
                Member mem = it.next();
                if (mem.getMicroSite().equals(site))
                {
                    return mem;
                }
            }
        }
        return null;
    }
%>
<%
            WebPage community = null;
            User user = (User) request.getAttribute("user");
            WebPage currentpage = (WebPage) request.getAttribute("webpage");

            if (currentpage instanceof MicroSite)
            {
                community = currentpage;
            }
            else
            {
                community = currentpage.getParent();
            }
            if (community != null)
            {
                String urlPrincipal = community.getUrl();
                String active = "";
                if (community.getURI().equals(currentpage.getURI()))
                {
                    active = "class=\"active\"";
                }

%>
<li><a <%=active%> href="<%=urlPrincipal%>">Principal</a></li>
<%
                Iterator<WebPage> tools = community.listVisibleChilds("es");
                while (tools.hasNext())
                {
                    WebPage tool = tools.next();
                    if (tool.isVisible())
                    {
                        active = "";

                        String url = tool.getUrl();
                        if (tool.getURI().equals(currentpage.getURI()))
                        {
                            active = "class=\"active\"";
                        }
                        String title = tool.getTitle();
%>
<li><a <%=active%> href="<%=url%>"><%=title%></a></li>
<%
                    }
                }
            }


%>



