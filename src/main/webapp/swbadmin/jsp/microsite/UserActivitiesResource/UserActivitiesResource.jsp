<%@page import="org.semanticwb.portal.community.utilresources.CommunityActivity,java.text.*,java.net.*,org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            if (request.getParameter("user") != null)
            {
                return;
            }
            int numrec = (Integer) request.getAttribute("numrec");
            Iterator<CommunityActivity> it = (Iterator<CommunityActivity>) request.getAttribute("activities");

%>

<h2>Contenidos recientes</h2>
<ul class="listaElementos">
    <%

            CommunityActivity ca = null;
            MicroSiteElement mse = null;
            MicroSite ms = null;
            if (it.hasNext())
            {
                int num = 0;
                while (it.hasNext())
                {
                    ca = it.next();
                    user = ca.getUser();
                    mse = ca.getElement();
                    if (mse != null && ca.getCommunity() != null && ms != null)
                    {
                    num++;
                    if (num > numrec)
                    {
                        break;
                    }
                   
                    
                        ms = ca.getCommunity();
                        Date updated = new Date(ca.getModified().getTime());
                        if (mse != null && user != null && ms != null)
                        {
                            String sActualized = "actualizó";
                            if (SWBUtils.TEXT.getTimeAgo(updated, user.getLanguage()).equals(SWBUtils.TEXT.getTimeAgo(mse.getCreated(), user.getLanguage())))
                            {
                                sActualized = "registró";
                            }
    %>

    <li> <%=user.getFullName()%> <%=sActualized%> <a class="elemento" href="<%=mse.getURL()%>" ><%=mse.getDisplayTitle(user.getLanguage())%></a>
        <%=SWBUtils.TEXT.getTimeAgo(updated, user.getLanguage())%>.</li>
        <%
                        }
                    }
                }
                if (num == 0)
                {
        %>
    <li>No hay actividades que reportar.</li>
    <%                }
            }
            else
            {
    %>
    <li>No hay actividades que reportar.</li>
    <%            }
    %>
</ul>

<%

%>