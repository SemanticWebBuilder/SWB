<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.model.*,java.util.*,org.semanticwb.platform.*"%>
<h2 class="titulo2">Comunidades</h2>
<h3>Las m&aacute;s recientes</h3>
<ul class="comunidades">
    <%
            //User user=(User)request.getAttribute("user");
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            //WebPage webpage = (WebPage) request.getAttribute("webpage");
            WebPage webpage = paramRequest.getWebPage();
            WebSite site = webpage.getWebSite();
            TreeSet<SemanticObject> setVals = new TreeSet<SemanticObject>(new Comparator()
            {
                public int compare(Object arg0, Object arg1)
                {
                    if (arg0 != null && arg1 != null)
                    {

                        SemanticObject obj0 = (SemanticObject) arg0;
                        SemanticObject obj1 = (SemanticObject) arg1;
                        return obj1.getProperty(MicroSite.swb_created).compareTo(obj0.getProperty(MicroSite.swb_created));
                    }
                    else
                    {
                        return 0;
                    }
                }
            });
            Iterator<SemanticObject> lista = site.getSemanticObject().getModel().listInstancesOfClass(MicroSite.sclass);
            while (lista.hasNext())
            {
                SemanticObject obj = lista.next();
                if (obj != null)
                {
                    setVals.add(obj);
                }
            }
            Iterator<SemanticObject> communities = setVals.iterator();
            if (!communities.hasNext())
            {
    %>
    <li><p>No hay comunidades recientes</p></li>
    <%            }

            int i = 0;
            //communities = SWBComparator.sortByCreated(MicroSite.ClassMgr.listMicroSites(site), false);
            while (communities.hasNext())
            {
                SemanticObject obj = communities.next();
                if (obj != null)
                {
                    try
                    {
                        MicroSite comm = (MicroSite) obj.createGenericInstance();
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
                    }
                    catch (Exception e)
                    {
                    }
                }

            }
            
    %>
</ul>