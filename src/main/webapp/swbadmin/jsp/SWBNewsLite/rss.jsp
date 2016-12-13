<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.resources.sem.newslite.*,org.w3c.dom.*,org.semanticwb.portal.community.*,java.util.*,org.semanticwb.model.WebPage,org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.model.*,org.semanticwb.SWBUtils,org.semanticwb.SWBPortal,org.semanticwb.SWBPlatform,org.semanticwb.platform.*,org.semanticwb.portal.api.SWBResourceURL"%><%!
    private Element addAtribute(Element ele, String name, String value)
    {
        Document doc = ele.getOwnerDocument();
        Element n = doc.createElement(name);
        ele.appendChild(n);
        n.appendChild(doc.createTextNode(value));
        return n;
    }
%><%
        if(request.getAttribute("paramRequest")!=null)
        {
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            List<New> news=(List)request.getAttribute("news");
            SWBResourceURL url=(SWBResourceURL) request.getAttribute("url");
            response.setContentType("application/rss+xml");
            Document doc = org.semanticwb.SWBUtils.XML.getNewDocument();
            Element rss = doc.createElement("rss");
            rss.setAttribute("version", "2.0");
            doc.appendChild(rss);

            Element channel = doc.createElement("channel");
            rss.appendChild(channel);
            addAtribute(channel, "title", "Noticias");
            addAtribute(channel, "link",paramRequest.getWebPage().getUrl());
            addAtribute(channel, "description", "Canal de noticias en formato RSS");
            for(New element : news)
            {
                Element item = doc.createElement("item");
                channel.appendChild(item);
                addAtribute(item, "title", element.getTitle());
                addAtribute(item, "link", url+"?uri="+element.getEncodedURI());
                addAtribute(item, "description", element.getDescription());
                addAtribute(item, "pubDate", element.getCreated().toGMTString());
                //addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
            }
            out.write(org.semanticwb.SWBUtils.XML.domToXml(doc));
        }
        else
        {
            WebSite site = ((WebPage) request.getAttribute("webpage")).getWebSite();
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
                            if(resourcewp.getId().equals("Noticias"))
                            {
                                SWBResourceURLImp url=new SWBResourceURLImp(request, resource, resourcewp, SWBResourceURLImp.UrlType_RENDER);
                                url.setCallMethod(url.Call_DIRECT);
                                url.setMode("rss");
                                //String url="#";

                                %>
                                | <a href="<%=url%>">RSS </a>
                                <%
                                break;
                            }
                        }
                    }
                }
            }
            
        }
%>
