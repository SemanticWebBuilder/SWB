<%@page import="java.text.*,java.net.*,org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<div class="organizacionesIzquierda">
    <%
            User user = (User) request.getAttribute("user");
            String lang = "es";
            if (user.getLanguage() != null)
            {
                lang = user.getLanguage();
            }
            WebPage webpage = (WebPage) request.getAttribute("webpage");
            WebPage clasificados = webpage.getWebSite().getWebPage("Organizaciones");
            Iterator<WebPage> nivel1 = clasificados.listVisibleChilds(lang);
            int elements = 0;
            while (nivel1.hasNext())
            {
                nivel1.next();
                elements++;
            }
            int rows = elements / 2;
            nivel1 = clasificados.listVisibleChilds(lang);
            int irow = 0;
            while (nivel1.hasNext())
            {
                WebPage child = nivel1.next();
    %>
    <ul>
        <li>
            <h3><a href="<%=child.getUrl()%>"><%=child.getTitle()%></a></h3>
        </li>

        <%
                Iterator<WebPage> subpages = child.listVisibleChilds(lang);
                int i = 0;
                while (subpages.hasNext())
                {
                    WebPage sbpage = subpages.next();
        %>
        <li><a href="<%=sbpage.getUrl()%>"><%=sbpage.getTitle()%></a></li>
        <%
                    i++;
                    if (i >= 5)
                    {
                        break;
                    }

                }
                if(subpages.hasNext())
                {
                    %>                    
                    <li><a href="<%=child.getUrl()%>">...</a></li>
                    <%
                }
        %>
    </ul>
    <%

                irow++;
                if (rows == irow)
                {
    %>
</div>
<div class="organizacionesDerecha">
    <%                }
            }

    %>
</div>
<div class="clear">&nbsp;</div>
