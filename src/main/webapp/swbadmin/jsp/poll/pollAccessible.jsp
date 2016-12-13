<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<jsp:useBean id="html" scope="request" type="java.lang.String"/>
<%@page import="org.semanticwb.model.Resource"%>
<%
    Resource base = paramRequest.getResourceBase();
    out.println(html);
%>