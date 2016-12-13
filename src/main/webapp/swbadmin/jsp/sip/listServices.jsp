<%-- 
    Document   : listServices
    Created on : 18/05/2010, 11:04:23 AM
    Author     : Hasdai Pacheco {haxdai@gmail.com}
--%>
<%@page import="org.semanticwb.SWBPortal" %>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.portal.api.*"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>

<%
WebSite site = ((WebPage) request.getAttribute("webpage")).getWebSite();
HashMap params = (HashMap)request.getAttribute("params");
int maxServices = 6;

String parentWp = "Tramites_y_Servicios";
if (params.containsKey("sParent")) {
    parentWp = (String)params.get("sParent");
}

String defcss = "icon_6";
if (params.containsKey("defIcon")) {
    defcss = (String)params.get("defIcon");
}

if (params.containsKey("maxServices")) {
    maxServices = Integer.parseInt((String)params.get("maxServices"));
}

WebPage servWp = site.getWebPage(parentWp);
%>
<div class="bloqueNotas">
    <h2 class="tituloBloque">Consulta<span class="span_tituloBloque">&nbsp;Tr&aacute;mites y servicios</span></h2>
    <%
    if (servWp != null) {
        Iterator<WebPage> childs = servWp.listChilds("es", true, false, false, false, true);
        //if (callMethod == paramRequest.Call_STRATEGY) {
            %>
            <ul class="listaTramites">
                <%
                int c = 0;
                while(childs.hasNext() && c < maxServices) {
                    c++;
                    WebPage child = childs.next();
                    String iconClass = child.getIconClass();
                    if (iconClass == null || iconClass.trim().equals("") || iconClass.equals("null")) {
                        iconClass = "icono_6";
                    }
                    %>
                    <li><a href="<%=child.getUrl()%>"><span class="<%=iconClass%>">&nbsp;</span><%=child.getTitle()%></a></li>
                    <%
                }
                %>
            </ul>
            <p class="vermas"><a href="<%=servWp.getUrl()%>">Ver m&aacute;s tr&aacute;mites y servicios</a></p>
            <%
        //}
    }
    %>
</div>
