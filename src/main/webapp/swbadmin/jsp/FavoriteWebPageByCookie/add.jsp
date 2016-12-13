<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%!
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
            SWBResourceURL url = paramRequest.getRenderUrl();
            url.setParameter("addthis", "true");
            String _url = url.toString();
            boolean show = true;
            String idportal = paramRequest.getWebPage().getWebSiteId();
            String id_page = paramRequest.getWebPage().getId();
            List<String> ids = null;
            if (request.getAttribute("cookie_" + idportal) != null)
            {
                ids = (List<String>) request.getAttribute("cookie_" + idportal);
            }
            else
            {
                ids = getIds(request.getCookies(), idportal);
            }
            if (ids.contains(id_page))
            {
                show = false;
            }
            if (show)
            {
%>
<a href="<%=_url%>">Agregar esta página</a>
<%
            }

%>

