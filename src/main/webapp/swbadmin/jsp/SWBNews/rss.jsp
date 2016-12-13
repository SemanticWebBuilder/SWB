<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.resources.sem.news.*,org.w3c.dom.*,java.util.*,org.semanticwb.model.WebPage,org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.model.*,org.semanticwb.SWBUtils,org.semanticwb.SWBPortal,org.semanticwb.SWBPlatform,org.semanticwb.platform.*,org.semanticwb.portal.api.SWBResourceURL"%><%!    private static String idNoticias = "Noticias";

public static String changeCharacters(String data)
    {
        if (data == null || data.trim().equals(""))
        {
            return data;
        }
        String changeCharacters = data.toLowerCase().trim();
        if (changeCharacters.indexOf("[") != -1)
        {
            changeCharacters = changeCharacters.replace('[', ' ');
        }
        if (changeCharacters.indexOf("]") != -1)
        {
            changeCharacters = changeCharacters.replace(']', ' ');
        }
        if (changeCharacters.indexOf("/") != -1)
        {
            changeCharacters = changeCharacters.replace('/', ' ');
        }
        if (changeCharacters.indexOf(";") != -1)
        {
            changeCharacters = changeCharacters.replace(';', ' ');
        }
        if (changeCharacters.indexOf(":") != -1)
        {
            changeCharacters = changeCharacters.replace(':', ' ');
        }
        if (changeCharacters.indexOf("-") != -1)
        {
            changeCharacters = changeCharacters.replace('-', ' ');
        }
        if (changeCharacters.indexOf(",") != -1)
        {
            changeCharacters = changeCharacters.replace(',', ' ');
        }
        changeCharacters = changeCharacters.replace('á', 'a');
        changeCharacters = changeCharacters.replace('é', 'e');
        changeCharacters = changeCharacters.replace('í', 'i');
        changeCharacters = changeCharacters.replace('ó', 'o');
        changeCharacters = changeCharacters.replace('ú', 'u');
        changeCharacters = changeCharacters.replace('à', 'a');
        changeCharacters = changeCharacters.replace('è', 'e');
        changeCharacters = changeCharacters.replace('ì', 'i');
        changeCharacters = changeCharacters.replace('ò', 'o');
        changeCharacters = changeCharacters.replace('ù', 'u');
        changeCharacters = changeCharacters.replace('ü', 'u');
        changeCharacters = changeCharacters.replace('ñ', 'n');
        StringBuilder sb = new StringBuilder();
        boolean addSpace = true;
        for (char schar : changeCharacters.toCharArray())
        {
            if (schar == ' ')
            {
                if (addSpace)
                {
                    sb.append(schar);
                    addSpace = false;
                }
            }
            else
            {
                sb.append(schar);
                addSpace = true;
            }

        }
        return sb.toString().trim();
    }

    public String getTitleURL(String title)
    {
        title = changeCharacters(title);

        StringBuilder sb = new StringBuilder();

        for (char s : title.toCharArray())
        {
            if (s == ' ')
            {
                sb.append('-');
            }
            else if (Character.isLetterOrDigit(s))
            {
                sb.append(s);
            }
            else
            {
                sb.append('-');
            }
        }
        return sb.toString();
    }
    /*public static class EventSortByStartDate implements Comparator<Event>
    {

        public int compare(Event event1, Event event2)
        {
            return event1.getStart().compareTo(event2.getStart());
        }
    }*/

    class SWBEventComparator implements Comparator<WebPage>
    {

        public int compare(WebPage o1, WebPage o2)
        {
            Date d1 = o1.getExpiration();
            Date d2 = o2.getExpiration();
            if (d1 == null)
            {
                d1 = o1.getCreated();
            }
            if (d2 == null)
            {
                d2 = o2.getCreated();
            }
            return d1.compareTo(d2);
        }
    }

    class SWBNewContentComparator implements Comparator<SWBNewContent>
    {

        public int compare(SWBNewContent o1, SWBNewContent o2)
        {
            Date d1 = o1.getPublishDate();
            Date d2 = o2.getPublishDate();
            if (d1 == null)
            {
                d1 = o1.getResource().getCreated();
            }
            if (d2 == null)
            {
                d2 = o2.getResource().getCreated();
            }
            if (d1 != null && d2 != null)
            {
                return d2.compareTo(d1);
            }
            else
            {
                return o1.getResourceBase().getIndex() >= o2.getResourceBase().getIndex() ? 1 : -1;
            }
        }
    }

    private Element addAtribute(Element ele, String name, String value)
    {
        Document doc = ele.getOwnerDocument();
        Element n = doc.createElement(name);
        ele.appendChild(n);
        n.appendChild(doc.createTextNode(value));
        return n;
    }

%><%    int limit = 15;
            if (request.getAttribute("paramRequest") != null)
            {
                String port = "";
                if (request.getServerPort() != 80)
                {
                    port = ":" + request.getServerPort();
                }
                String host = request.getServerName();
                String baserequest = request.getScheme() + "://" + host + port;
                SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
                List<SWBNewContent> news = (List<SWBNewContent>) request.getAttribute("news");
                Collections.sort(news, new SWBNewContentComparator());
                //SWBResourceURL url=(SWBResourceURL) request.getAttribute("url");
                String url = (String) request.getAttribute("url");
                response.setContentType("application/rss+xml;charset=UTF-8");
                Document doc = org.semanticwb.SWBUtils.XML.getNewDocument();
                Element rss = doc.createElement("rss");
                rss.setAttribute("version", "2.0");

                rss.setAttribute("xmlns:atom", "http://www.w3.org/2005/Atom");

                doc.appendChild(rss);

                Element channel = doc.createElement("channel");

                
                Element atom_link=doc.createElement("atom:link");
                channel.appendChild(atom_link);
                atom_link.setAttribute("href", baserequest + request.getRequestURI());
                atom_link.setAttribute("rel", "self");
                atom_link.setAttribute("type", "application/rss+xml");


                rss.appendChild(channel);
                addAtribute(channel, "title", "Noticias y Eventos");
                addAtribute(channel, "link", baserequest + paramRequest.getWebPage().getUrl());
                addAtribute(channel, "description", "Canal de noticias y eventos en formato RSS");
                int inew = 0;
                for (SWBNewContent element : news)
                {
                    inew++;
                    Element item = doc.createElement("item");
                    Element guid = doc.createElement("guid");
                    item.appendChild(guid);
                    guid.appendChild(doc.createTextNode(element.getResourceBase().getURI()));
                    channel.appendChild(item);
                    
                    String title = element.getResourceBase().getTitle(paramRequest.getUser().getLanguage());
                    if (title == null || title.trim().equals(""))
                    {
                        title = element.getResourceBase().getTitle();

                    }
                    if (title != null)
                    {
                        title = title.replace('"', '\'');
                    }
                    addAtribute(item, "title", title);
                    String titleURL = getTitleURL(element.getResourceBase().getDisplayTitle(paramRequest.getUser().getLanguage()));
                    //addAtribute(item, "link",  baserequest+url + "?uri=" + element.getResourceBase().getEncodedURI());
                    addAtribute(item, "link", baserequest + url + "/" + element.getResourceBase().getId()+"/"+titleURL);
                    Element category = doc.createElement("category");
                    item.appendChild(category);
                    category.appendChild(doc.createTextNode("Noticias"));
                    addAtribute(item, "description", element.getResourceBase().getDescription());
                    if (element.getPublishDate() != null)
                    {
                        addAtribute(item, "pubDate", element.getPublishDate().toGMTString());
                    }
                    else
                    {
                        addAtribute(item, "pubDate", new Date().toGMTString());
                    }
                    //addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                    if (inew >= limit)
                    {
                        break;
                    }
                }

                String id = "Eventos_relevantes";
                WebPage eventoWebPage = paramRequest.getWebPage().getWebSite().getWebPage(id);
                if (eventoWebPage != null)
                {


                    /*Iterator<WebPage> eventos = eventoWebPage.listChilds(paramRequest.getUser().getLanguage(), true, false, false, true);

                    ArrayList<WebPage> pages = new ArrayList<WebPage>();
                    while (eventos.hasNext())
                    {
                    WebPage event = eventos.next();
                    pages.add(event);
                    }
                    Collections.sort(pages, new SWBEventComparator());*/


                    int currentYear = java.util.Calendar.getInstance().getTime().getYear();
                    int currentMonth = java.util.Calendar.getInstance().getTime().getMonth();
                    int currentDay = java.util.Calendar.getInstance().getTime().getDay();
                    /*Iterator<Event> itevents = Event.ClassMgr.listEvents(paramRequest.getWebPage().getWebSite());
                    
                    List<Event> events = new ArrayList<Event>();
                    while (itevents.hasNext())
                    {
                        Event event = itevents.next();


                        if (event.getParent().equals(eventoWebPage) && event.isActive() && event.isValid() && event.getStart() != null && event.getStart().getYear() == currentYear && event.getStart().getMonth() >= currentMonth && event.getStart().getDay() >= currentDay)
                        {
                            events.add(event);
                        }

                    }*/
                    
                    /*Collections.sort(events, new EventSortByStartDate());

                    for (Event event : events)
                    {

                        Element item = doc.createElement("item");
                        Element guid = doc.createElement("guid");
                        item.appendChild(guid);
                        guid.appendChild(doc.createTextNode(event.getURI()));
                        channel.appendChild(item);
                        String title = event.getTitle(paramRequest.getUser().getLanguage());
                        if (title == null || title.trim().equals(""))
                        {
                            title = event.getTitle();

                        }
                        if (title != null)
                        {
                            title = title.replace('"', '\'');
                            title = SWBUtils.TEXT.decodeExtendedCharacters(title);

                        }

                        String description = "";
                        if (event.getDescription() != null)
                        {
                            description = event.getDescription();
                        }
                        Element category = doc.createElement("category");
                        item.appendChild(category);
                        category.appendChild(doc.createTextNode("Eventos"));
                        addAtribute(item, "title", title);
                        String titleURL = getTitleURL(event.getDisplayTitle(paramRequest.getUser().getLanguage()));
                        addAtribute(item, "link", baserequest + event.getUrl()+"/"+titleURL);
                        addAtribute(item, "description", description);

                        java.util.Calendar cal= java.util.Calendar.getInstance();
                        cal.setTime(event.getUpdated());
                        cal.set(cal.HOUR_OF_DAY, 0);
                        cal.set(cal.MINUTE, 0);
                        cal.set(cal.SECOND, 1);
                        addAtribute(item, "pubDate", cal.getTime().toGMTString());

                    }*/
                }
                String xml=org.semanticwb.SWBUtils.TEXT.decode(org.semanticwb.SWBUtils.XML.domToXml(doc),"UTF-8");
                out.write(xml);
            }
            else
            {
                WebSite site = ((WebPage) request.getAttribute("webpage")).getWebSite();
                Iterator<ResourceType> resourceTypes = ResourceType.ClassMgr.listResourceTypes(site);
                while (resourceTypes.hasNext())
                {
                    ResourceType resourceType = resourceTypes.next();
                    if (resourceType.getResourceClassName().equals(SWBNews.class.getCanonicalName()))
                    {
                        Iterator<Resource> resources = Resource.ClassMgr.listResourceByResourceType(resourceType, site);
                        while (resources.hasNext())
                        {
                            Resource resource = resources.next();
                            if (resource.getResourceable() instanceof WebPage)
                            {
                                WebPage resourcewp = (WebPage) resource.getResourceable();
                                if (resourcewp.getId().equals(idNoticias))
                                {
                                    SWBResourceURLImp url = new SWBResourceURLImp(request, resource, resourcewp, SWBResourceURLImp.UrlType_RENDER);
                                    url.setCallMethod(url.Call_DIRECT);
                                    url.setMode("rss");

                                    HashMap params = (HashMap) request.getAttribute("params");
                                    if ("link".equals(params.get("view")))
                                    {
%>
<link rel="alternate" type="application/rss+xml" title="Fondo de Información y Documentacion para la industria (INFOTEC)" href="<%=url%>" />
<%
                                    }
                                    else
                                    {
%>
<a id="rss" href="<%=url%>" >RSS</a>
<%
                                    }


                                    break;
                                }
                            }
                        }
                    }
                }

            }
%>
