<%@page import="org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<%
            WebPage webpage = (WebPage) request.getAttribute("webpage");
            if (webpage instanceof MicroSite)
            {
                String title = webpage.getTitle();
%>
<%=title%>
<%
            }
            else
            {
                webpage = webpage.getParent();
                if (webpage != null && webpage instanceof MicroSite)
                {
                    String title = webpage.getTitle();
%>
<%=title%>
<%
                }
            }
%>