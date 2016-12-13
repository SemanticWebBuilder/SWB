<%@page import="org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<ul id="menuInterna">
    <%
            WebPage webpage = (WebPage) request.getAttribute("webpage");
            String id = webpage.getId();
            String classPerfil = "", classamigos = "", classeventos = "", classfaviritos = "", classtwiter = "";
            if (id.equals("perfil"))
            {
                classPerfil = "class=\"active\"";
            }
            if (id.equals("Amigos"))
            {
                classamigos = "class=\"active\"";
            }
            if (id.equals("Mis_Eventos"))
            {
                classeventos = "class=\"active\"";
            }
            if (id.equals("Mis_favoritos"))
            {
                classfaviritos = "class=\"active\"";
            }
            if (id.equals("Twitter"))
            {
                classtwiter = "class=\"active\"";
            }

            String parameter = request.getParameter("user");
            if (parameter == null)
            {
                parameter = "";
            }
            else
            {
                parameter = "?user=" + java.net.URLEncoder.encode(parameter);
            }
    %>
    <li><a <%=classPerfil%> href="<%=webpage.getWebSite().getWebPage("perfil").getUrl()%><%=parameter%>" >Principal</a></li>
    <li><a <%=classamigos%> href="<%=webpage.getWebSite().getWebPage("Amigos").getUrl()%><%=parameter%>" >Amigos</a></li>
    <li><a <%=classeventos%> href="<%=webpage.getWebSite().getWebPage("Mis_Eventos").getUrl()%><%=parameter%>" >Eventos</a></li>
    <%
        if(request.getParameter("user")==null)
            {
            %>
            <li><a <%=classfaviritos%> href="<%=webpage.getWebSite().getWebPage("Mis_favoritos").getUrl()%><%=parameter%>" >Favoritos</a></li>
            <%
            }
    %>
    
    <li><a <%=classtwiter%> href="<%=webpage.getWebSite().getWebPage("Twitter").getUrl()%><%=parameter%>" >Twitter</a></li>
</ul>