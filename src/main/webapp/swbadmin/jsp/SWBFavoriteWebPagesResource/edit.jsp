<%@page contentType="text/html" %>
<%@page import="org.semanticwb.model.Country"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.servlet.SWBHttpServletResponseWrapper"%>
<%@page import="org.semanticwb.portal.api.SWBResource"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="org.semanticwb.portal.resources.sem.favoriteWebPages.*"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="java.util.*"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.User"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%
    if (!paramRequest.getUser().isSigned())
    {
        return;
    }
    
    ArrayList<WebPage> pages = (ArrayList<WebPage>) request.getAttribute("pages");
    final String id = paramRequest.getWebPage().getId();
    SWBResourceURL url = paramRequest.getActionUrl().setCallMethod(SWBResourceURL.Call_DIRECT);
    
    if(!pages.contains(paramRequest.getWebPage()))
    {
        url.setAction(SWBResourceURL.Action_ADD);
%>
        <div id="fv_<%=paramRequest.getWebPage().getId()%>">
            <input type="button" value="Agregar como favoritos" class="bkmrk" onclick="postHtml('<%=url%>','fv_<%=id%>')" title="Agregr como favoritos"/>
        </div>
<%                        
    }
    else
    {
        url.setAction(SWBResourceURL.Action_REMOVE);
%>
        <div id="fv_<%=paramRequest.getWebPage().getId()%>">
            <input type="button" value="Quitar de favoritos" class="unbkmrk" onclick="postHtml('<%=url%>','fv_<%=id%>')" title="Quitar de favoritos"/>
        </div>
<%
    }
%>