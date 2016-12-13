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
    ArrayList<WebPage> pages = (ArrayList<WebPage>)request.getAttribute("pages");
    if(pages.isEmpty())
    {
%>
        <p>No tienes páginas registradas como favoritas</p>
<%
    }
    else
    {
        %>
        <ul>
        <%
        for (WebPage _page : pages)
        {                
            String title = SWBUtils.TEXT.encodeExtendedCharacters(_page.getDisplayTitle(paramRequest.getUser().getLanguage()));
            String url = _page.getUrl();
%>
        <li><a href="<%=url%>" ><%=title%></a></li>
<%
        }
%>
        </ul>
<%
    }
%>