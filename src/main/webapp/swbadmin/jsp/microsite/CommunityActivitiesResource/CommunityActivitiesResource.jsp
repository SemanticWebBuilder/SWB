<%@page import="org.semanticwb.portal.community.utilresources.CommunityActivity,java.text.*,java.net.*,org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*" %>
<div id="contactos">
    <h2>Actividades de la comunidad</h2>
    <ul class="listaElementos">
        <%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            int numrec = (Integer) request.getAttribute("numrec");
            WebPage wp = paramRequest.getWebPage();
            MicroSite ms = null;
            if (wp instanceof MicroSite)
            {
                ms = (MicroSite) wp;
            }
            Iterator<CommunityActivity> it = (Iterator<CommunityActivity>) request.getAttribute("activities");
            CommunityActivity ca = null;
            User user = null;
            MicroSiteElement mse = null;
            if (it.hasNext())
            {
                int num = 0;
                while (it.hasNext())
                {
                    num++;
                    if (num > numrec)
                    {
                        break;
                    }

                    ca = it.next();
                    user = ca.getUser();
                    mse = ca.getElement();
                    Date updated=new Date(ca.getModified().getTime());
                    if (mse != null && user != null && ms != null)
                    {
                        String sActualized="actualizó";
                        if(SWBUtils.TEXT.getTimeAgo(updated, user.getLanguage()).equals(SWBUtils.TEXT.getTimeAgo(mse.getCreated(), user.getLanguage())))
                        {
                        sActualized="registró";
                        }
        %>        
        <li> <%=user.getFullName()%> <%=sActualized%> <a class="elemento" href="<%=mse.getURL()%>" ><%=mse.getDisplayTitle(user.getLanguage())%></a>
            <%=SWBUtils.TEXT.getTimeAgo(updated, user.getLanguage())%>.</li>
            <%
                    }
                }
            }
            else
            {
            %>
        <li>No hay actividades.</li>
        <%            }


        %>
    </ul>
</div>