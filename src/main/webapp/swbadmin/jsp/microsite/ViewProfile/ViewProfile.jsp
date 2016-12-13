<%@page import="org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.User,org.semanticwb.model.WebPage,java.util.*"%><%
    User user=(User)request.getAttribute("user");
    WebPage webpage=(WebPage)request.getAttribute("webpage");
    if(webpage!=null && user!=null && user.isSigned() && webpage.getWebSite().getWebPage("perfil")!=null)
    {
       WebPage perfil=webpage.getWebSite().getWebPage("perfil");
       String path=perfil.getUrl();%><li><a>Hola &nbsp;<%=user.getFullName()%></a></li>
        <li><a href="<%=path%>">Ver perfil</a></li><%
    }
    else
        {
        // puesto por razones de validación w3c
        %><li><p>&nbsp;</p></li><%
        }%>