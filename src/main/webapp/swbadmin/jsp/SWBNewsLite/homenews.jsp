<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.resources.sem.newslite.*,java.util.*,org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%!

class ComparatorNews implements Comparator<New>
{

    public int compare(New o1, New o2)
    {
        return o2.getCreated().compareTo(o1.getCreated());
    }
}
%>

<%
    WebSite site = ((WebPage) request.getAttribute("webpage")).getWebSite();
    HashMap params=(HashMap)request.getAttribute("params");
    String newid=null;
    if(params.containsKey("idtopic"))
    {
        newid=params.get("idtopic").toString();
    }
    if(newid==null)
    {
        newid="Noticias";
    }
    
    Iterator<ResourceType> resourceTypes=ResourceType.ClassMgr.listResourceTypes(site);
    while(resourceTypes.hasNext())
    {
        ResourceType resourceType=resourceTypes.next();
        if(resourceType.getResourceClassName().equals("org.semanticwb.portal.resources.sem.newslite.SWBNewsLite"))
        {
            Iterator<Resource> resources=Resource.ClassMgr.listResourceByResourceType(resourceType,site);
            while(resources.hasNext())
            {
                Resource resource=resources.next();
                if(resource.getResourceable() instanceof WebPage)
                {
                    WebPage resourcewp=(WebPage)resource.getResourceable();
                    if(resourcewp.getId().equals(newid))
                    {                        
                        List<New> news = new ArrayList<New>();
                        SWBResourceURLImp url=new SWBResourceURLImp(request, resource, resourcewp, SWBResourceURLImp.UrlType_RENDER);
                        url.setCallMethod(url.Call_CONTENT);
                        url.setMode("detail");
                        Iterator<New> itNews = New.ClassMgr.listNews(site);
                        while (itNews.hasNext())
                        {
                            New onew = itNews.next();
                            if (onew.getExpiration().after(new Date(System.currentTimeMillis())))
                            {
                                news.add(onew);
                            }
                        }
                        New[] elements = news.toArray(new New[news.size()]);
                        Arrays.sort(elements, new ComparatorNews());
                        int max = 3;
                        news = new ArrayList<New>();
                        if (elements.length <= max || max == -1)
                        {

                            for (New onew : elements)
                            {
                                news.add(onew);
                            }
                        }
                        else
                        {
                            for (int i = 0; i < max; i++)
                            {
                                news.add(elements[i]);
                            }
                        }
                        for(New onew : news)
                        {
                            
                            String title=onew.getTitle();
                            String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/SWBNewsLite/sinfoto.png";
                            String path = onew.getWorkPath();
                            if (onew.getNewsThumbnail() != null)
                            {
                                int pos = onew.getNewsThumbnail().lastIndexOf("/");
                                if (pos != -1)
                                {
                                    String sphoto = onew.getNewsThumbnail().substring(pos + 1);
                                    onew.setNewsThumbnail(sphoto);
                                }
                                pathPhoto = SWBPortal.getWebWorkPath() + path + "/" + onew.getNewsThumbnail();
                            }
                            String href=url+"?uri="+onew.getEncodedURI();

                            %>
                              <div class="mainNews">
                              <p><a href="<%=href%>"><%=title%></a></p>
                              <img width="92" height="60" src="<%=pathPhoto%>" alt="Imagen noticia" />
                              <div class="clear">&nbsp;</div>
                              <ul class="underline">
                                  <li>&nbsp;</li>
                              </ul>
                              <p>&nbsp;</p>
                            </div>
                            <%
                        }
                        break;
                    }
                }
            }
        }
    }
%>