<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.model.*,java.util.*"%>
<h3>Las m&aacute;s activas</h3>
<ul class="comunidades">
    
    <%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            //WebPage webpage = (WebPage) request.getAttribute("webpage");
            WebPage webpage = paramRequest.getWebPage();
            WebSite site = webpage.getWebSite();
            //Iterator communities = sortByViews(MicroSite.ClassMgr.listMicroSites(site), false);
            Iterator communities = SWBComparator.sortByDisplayName(MicroSite.ClassMgr.listMicroSites(site),paramRequest.getUser().getLanguage());
            if (!communities.hasNext())
            {
    %>
    <li><p>No hay comunidades activas</p></li>
    <%      }
            int i = 0;
            while (communities.hasNext())
            {
                Object obj=null;
                try
                {
                    obj = communities.next();
                }catch(Exception e){e.printStackTrace();}
                if (obj != null && obj instanceof MicroSite)
                {
                    try
                            {
                    MicroSite comm = (MicroSite) communities.next();
                    if (comm != null && comm.getUrl() != null && comm.getTitle() != null && comm.isActive())
                    {
                        i++;
    %>
    <li><a href="<%=comm.getUrl()%>"><%=comm.getTitle()%></a></li>
    <%
                        if (i == 5)
                        {
                            break;
                        }
                    }
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                }
            }
                        
            if(i==0)
                {
                %>
                <li><p>No hay comunidades activas</p></li>
                <%
                }

    %>
</ul>
