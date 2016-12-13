<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.resources.sem.newslite.*,java.util.*,java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%    
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    List<New> news=(List) request.getAttribute("news");
    Resource oresource=paramRequest.getResourceBase();
    WebSite site=paramRequest.getWebPage().getWebSite();
    Iterator<Resource> resources=Resource.ClassMgr.listResourceByResourceType(oresource.getResourceType(),site);

    while(resources.hasNext())
    {
        Resource resource=resources.next();
        if(resource.getResourceable() instanceof WebPage)
        {
            WebPage resourcewp=(WebPage)resource.getResourceable();
            if(resourcewp.getId().equals("Noticias"))
            {                
                SWBResourceURLImp url=new SWBResourceURLImp(request, resource, resourcewp, SWBResourceURLImp.UrlType_RENDER);                
                for(New onew : news)
                {                    
                    url.setCallMethod(url.Call_CONTENT);
                    url.setMode("detail");
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
                    %>
                      <div class="mainNews">
                      <p><a href="<%=url%>"><%=title%></a></p>
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
    
%>					


