<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="java.util.List"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%!
    public class PageComparator implements Comparator<WebPage>
    {

        public int compare(WebPage o1, WebPage o2)
        {
            return o1.getTitle().compareTo(o2.getTitle());
        }
    }

    public List<String> getIds(Cookie[] cookies, String idportal)
    {
        ArrayList<String> values = new ArrayList<String>();
        if (cookies != null && cookies.length > 0)
        {
            for (Cookie cookie : cookies)
            {
                if (cookie.getName() != null && cookie.getName().equals(idportal))
                {
                    String s_value = cookie.getValue();
                    StringTokenizer st = new StringTokenizer(s_value, "|");
                    while (st.hasMoreTokens())
                    {
                        String id = st.nextToken();
                        if (isValid(id, idportal))
                        {
                            values.add(id);
                        }
                    }
                }
            }
        }
        return values;
    }

    public boolean isValid(String id, String idportal)
    {
        WebSite site = WebSite.ClassMgr.getWebSite(idportal);
        if (site != null)
        {
            WebPage page = site.getWebPage(id);
            if (page != null && page.isValid())
            {
                return true;
            }
        }
        return false;
    }


%>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            String idportal = paramRequest.getWebPage().getWebSiteId();
            List<String> ids = null;
            if (request.getAttribute("cookie_" + idportal) != null)
            {
                ids = (List<String>) request.getAttribute("cookie_" + idportal);
            }
            else
            {
                ids = getIds(request.getCookies(), idportal);
            }
            WebSite site = WebSite.ClassMgr.getWebSite(idportal);
            if (site != null)
            {
                ArrayList<WebPage> pages = new ArrayList<WebPage>();
                for (String id : ids)
                {
                    WebPage shorcut = site.getWebPage(id);
                    pages.add(shorcut);
                }
                Collections.sort(pages, new PageComparator());
%>
<ul>
    <%
                    for (WebPage shorcut : pages)
                    {
                        //WebPage shorcut = site.getWebPage(id);
                        String url = shorcut.getUrl();
                        String title = shorcut.getDisplayTitle(user.getLanguage());
    %>
    <li><a href="<%=url%>"><%=title%></a></li>
    <%
                    }

    %>
</ul>
<%
            }
%>
